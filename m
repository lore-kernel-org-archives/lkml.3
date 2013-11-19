Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab3KSP3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 10:29:17 -0500
Received: from mail.efficios.com ([78.47.125.74]:56466 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab3KSP3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 10:29:13 -0500
Date: Tue, 19 Nov 2013 15:29:12 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: lttng-dev@lists.lttng.org, Nathan Lynch <Nathan_Lynch@mentor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <1691607547.70809.1384874952002.JavaMail.zimbra@efficios.com>
In-Reply-To: <67652521.68027.1384482849638.JavaMail.zimbra@efficios.com>
References: <52803E5D.3050109@mentor.com> <52851395.3010306@mentor.com> <67652521.68027.1384482849638.JavaMail.zimbra@efficios.com>
Subject: current_thread_info() not respecting program order with gcc 4.8.x
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF25 (Linux)/8.0.5_GA_5839)
Thread-Topic: might_sleep warnings in overwrite mode
Thread-Index: 66Ruq3ioHgsRXWBaI/uLm77KGCLwEcCJv9Yj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got a bug report on ARM which appears to be caused by an aggressive gcc optimisation starting from gcc 4.8.x due to lack of constraints on the current_thread_info() inline assembly. The only logical explanation for his issue I see so far is that read of the preempt_count within might_sleep() is reordered with preempt_enable() or preempt_disable(). AFAIU, this kind of issue also applies to other architectures.

First thing, preempt enable/disable only contains barrier() between the inc/dec and the inside of the critical section, not the outside. Therefore, we are relying on program order to ensure that the preempt_count() read in might_sleep() is not reordered with the preempt count inc/dec.

However, looking at ARM arch/arm/include/asm/thread_info.h:

static inline struct thread_info *current_thread_info(void)
{
        register unsigned long sp asm ("sp");
        return (struct thread_info *)(sp & ~(THREAD_SIZE - 1));
}

The inline assembly has no clobber and is not volatile. (this is also true for all other architectures I've looked at so far, which includes x86 and powerpc)

As long as someone does:

struct thread_info *myinfo = current_thread_info();

load from myinfo->preempt_count;
store to myinfo->preempt_count;

The program order should be preserved, because the read and the write are done wrt same base. However, what we have here in the case of might_sleep() followed by preempt_enable() is:

load from current_thread_info()->preempt_count;
store to current_thread_info()->preempt_count;

Since each current_thread_info() is a different asm ("sp") without clobber nor volatile, AFAIU, the compiler is within its right to reorder them.

One possible solution to this might be to add "memory" clobber and volatile to this inline asm, but I fear it would put way too much constraints on the compiler optimizations (too heavyweight).

Have any of you experienced this issue ? Any thoughts on the matter ?

I'm providing the original bug report email exchange below. I had confirmation that adding barrier() outside preempt_enable()/preempt_disable() does indeed work-around the issue, but I fear that this work-around would be leaving the current_thread_info() semantic gap in place: people expect program order to be respected.

Thanks,

Mathieu


----- Original Message -----
> From: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> To: "Nathan Lynch" <Nathan_Lynch@mentor.com>
> Cc: lttng-dev@lists.lttng.org
> Sent: Thursday, November 14, 2013 9:34:09 PM
> Subject: Re: [lttng-dev] might_sleep warnings in overwrite mode
> 
> ----- Original Message -----
> > From: "Nathan Lynch" <Nathan_Lynch@mentor.com>
> > To: lttng-dev@lists.lttng.org
> > Sent: Thursday, November 14, 2013 1:16:53 PM
> > Subject: Re: [lttng-dev] might_sleep warnings in overwrite mode
> > 
> > On 11/10/2013 08:18 PM, Nathan Lynch wrote:
> > > At this point I cannot trigger the issue without overwrite mode on
> > > 3.11.6, but on a 3.8-based vendor kernel I can recreate it regardless of
> > > the mode.
> > 
> > Some updates on this:
> > - It's not specific to overwrite mode; I was able to provoke it on
> > 3.11.6 without --overwrite.  Overwrite mode does seem to recreate the
> > issue more readily.
> > - It seems to be GCC version-dependent.  4.8.1 and 4.8.2 produce code
> > which warns/bugs; 4.7.3 does not.
> 
> Allright! This info is really useful. Sorry for taking time to look into
> this, I was busy with preparation for 2.4-rc1.
> 
> Looking at:
> 
> fs/ext3/incode.c:
> 
> __ext3_get_inode_loc()
> 
> we can see that a use of the inlined sb_getblk() appears close to a
> tracepoint.
> 
> The tracepoint includes preempt disable/enable, exactly those:
> 
> include/linux/preempt.h:
> 
> #define preempt_disable_notrace() \
> do { \
>         inc_preempt_count_notrace(); \
>         barrier(); \
> } while (0)
> 
> #define preempt_enable_notrace() \
> do { \
>         preempt_enable_no_resched_notrace(); \
>         barrier(); \
>         preempt_check_resched_context(); \
> } while (0)
> 
> 
> Can you try wrapping the _outside_ of those macros with barrier(), e.g.
> 
> 
> #define preempt_disable_notrace() \
> do { \
>         barrier(); \
>         inc_preempt_count_notrace(); \
>         barrier(); \
> } while (0)
> 
> #define preempt_enable_notrace() \
> do { \
>         preempt_enable_no_resched_notrace(); \
>         barrier(); \
>         preempt_check_resched_context(); \
>         barrier(); \
> } while (0)
> 
> and try it out with the apparently buggy compiler to see if it helps ? It
> does look like the preempt inc or dec is slipping out and somehow triggers
> the might_sleep() warning. I don't see clearly how this could happen yet,
> since each of the inc/dec and the test are touching preempt_count(), but
> it's worth a try.
> 
> Maybe on ARM the current_thread_info() macro somehow hides important info
> from the compiler and it mistakenly reorders inc/dec vs the test. Another
> thing to try out (in addition to the first one) would be to try changing
> current_thread_info(), e.g., by turning asm ("sp") into a volatile inline
> assembly, and by adding "memory" clobbers to it.
> 
> Thoughts ?
> 
> Thanks,
> 
> Mathieu
> 
> 
> > 
> > 
> > 
> > _______________________________________________
> > lttng-dev mailing list
> > lttng-dev@lists.lttng.org
> > http://lists.lttng.org/cgi-bin/mailman/listinfo/lttng-dev
> > 
> 
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com
> 
> _______________________________________________
> lttng-dev mailing list
> lttng-dev@lists.lttng.org
> http://lists.lttng.org/cgi-bin/mailman/listinfo/lttng-dev
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
