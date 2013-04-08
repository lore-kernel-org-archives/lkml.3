Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934486Ab3DHJEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:04:10 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:55715 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932898Ab3DHJEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:04:06 -0400
Message-ID: <1365411814.2753.74.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [RFC PATCH v2 2/6] powerpc: Exception hooks for context
 tracking subsystem
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
        benh@kernel.crashing.org
Date: Mon, 08 Apr 2013 17:03:34 +0800
In-Reply-To: <20130405025025.GB22465@drongo>
References: <1364551221-23177-1-git-send-email-zhong@linux.vnet.ibm.com>
	 <1364551221-23177-3-git-send-email-zhong@linux.vnet.ibm.com>
	 <20130405025025.GB22465@drongo>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040808-8878-0000-0000-0000069D73D6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-05 at 13:50 +1100, Paul Mackerras wrote:
> On Fri, Mar 29, 2013 at 06:00:17PM +0800, Li Zhong wrote:
> > This is the exception hooks for context tracking subsystem, including
> > data access, program check, single step, instruction breakpoint, machine check,
> > alignment, fp unavailable, altivec assist, unknown exception, whose handlers
> > might use RCU.
> > 
> > This patch corresponds to
> > [PATCH] x86: Exception hooks for userspace RCU extended QS
> >   commit 6ba3c97a38803883c2eee489505796cb0a727122
> > 
> > Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>


Hi Paul, 

Thanks for your review! Please check my answers below, and correct me if
any errors.

> Is there a reason why you didn't put the exception_exit() call in
> ret_from_except_lite in entry_64.S, and the exception_entry() call in
> EXCEPTION_PROLOG_COMMON?  That would seem to catch all these cases in
> a more centralized place.

It seems to me that ret_from_except_lite and EXCEPTION_PROLOG_COMMON are
also used by interrupts, where I think we don't need the hooks. So using
this way could help to avoid adding overhead to these code path
(interrupts, and some exit path of syscall). 

And I think adding the hook on higher level code seems a little easier
for reading and checking. It seems that some exceptions don't use
EXCEPTION_PROLOG_COMMON, and some don't go ret_from_except_lite exit
path (like fp unavailable might go directly to fast_exception_return ).
Maybe fast_exception_return is a centralized place for us to return to
user space? But it still adds some overheads which is not necessarily
needed. 

And I think it also makes the implementation here consistent with the
style that x86 uses. 

> Also, I notice that with the exception_exit calls where they are, we
> can still deliver signals (thus possibly taking a page fault) or call
> schedule() for preemption after the exception_exit() call.  Is that
> OK, or is it a potential problem?

If I understand correctly, I guess you are talking about the cases where
we might return to user space without context state correctly being set
as in user?

There is user_enter() called in do_notify_resume() in patch #3, so after
handling the signals we always call user_enter(). 

There are also some changes of the context_tracking code from Frederic,
which might be related: ( they are now in tip tree, and url of the
patches for your convenience https://lkml.org/lkml/2013/3/1/266 )

6c1e0256fad84a843d915414e4b5973b7443d48d
context_tracking: Restore correct previous context state on exception
exit. 

With this patch, if a later exception happened after user_enter(),
before the CPU actually returns to user space, the correct context
state(in user) is saved and restored when handling the later exception. 

Patch #6 converts the code to use these new APIs, which is currently not
available in powerpc tree. 

b22366cd54c6fe05db426f20adb10f461c19ec06
context_tracking: Restore preempted context state after
preempt_schedule_irq

With this patch, the user context state could be correctly restored
after schedule returns. 

Thanks, Zhong

> Paul.
> 


