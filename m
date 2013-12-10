Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab3LJVKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:10:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab3LJVKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:10:22 -0500
Date: Tue, 10 Dec 2013 16:09:56 -0500
From: Dave Jones <davej@redhat.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131210210956.GD27373@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Darren Hart <dvhart@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20131210154724.GA30020@redhat.com>
 <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
 <1386709077.3685.73.camel@dvhart-mobl4.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386709077.3685.73.camel@dvhart-mobl4.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 12:57:57PM -0800, Darren Hart wrote:


 > > > Call Trace:
 > > >  [<ffffffff817587a0>] ? retint_restore_args+0xe/0xe
 > > >  [<ffffffff8132af0e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 > > >  [<ffffffff8100b184>] ? native_sched_clock+0x24/0x80
 > > >  [<ffffffff8109624f>] ? local_clock+0xf/0x50
 > > >  [<ffffffff810aa27e>] ? put_lock_stats.isra.28+0xe/0x30
 > > >  [<ffffffff8103edd0>] ? gup_pud_range+0x170/0x190
 > > >  [<ffffffff8103f0d5>] ? get_user_pages_fast+0x1a5/0x1c0
 > > >  [<ffffffff810ad1f5>] ? trace_hardirqs_on_caller+0x115/0x1e0
 > > >  [<ffffffff810a8a2f>] ? up_read+0x1f/0x40
 > > >  [<ffffffff8103f0d5>] ? get_user_pages_fast+0x1a5/0x1c0
 > > >  [<ffffffff8115f76c>] ? put_page+0x3c/0x50
 > > >  [<ffffffff810dd525>] ? get_futex_key+0xd5/0x2c0
 > > >  [<ffffffff810df18a>] ? futex_requeue+0xfa/0x9c0
 > > >  [<ffffffff810e019e>] ? do_futex+0xae/0xc80
 > > >  [<ffffffff810aa27e>] ? put_lock_stats.isra.28+0xe/0x30
 > > >  [<ffffffff810aa7de>] ? lock_release_holdtime.part.29+0xee/0x170
 > > >  [<ffffffff8114f16e>] ? context_tracking_user_exit+0x4e/0x190
 > > >  [<ffffffff810ad1f5>] ? trace_hardirqs_on_caller+0x115/0x1e0
 > > >  [<ffffffff810e0de1>] ? SyS_futex+0x71/0x150
 > > >  [<ffffffff81010a45>] ? syscall_trace_enter+0x145/0x2a0
 > > >  [<ffffffff81760be4>] ? tracesys+0xdd/0xe2
 > > >
 > 
 > Can you get us an idea of the arguments trinity is tossing into
 > SYS_futex?
 > 
 > Op code? Would help to know if this was requeue_pi for example.
 > Type of memory being used for the uaddr?

As is always the case, the interesting bugs only seem to happen
when I have logging disabled. So other than what I can glean from what's
left in the shm, no idea.

One of the other child processes (which exited already) did do a sys_futex.
the params it passed were..

1cb5000, -1, c57, 1cb5004, ffffffffffd8f420, 90000000091a6311

The result of this syscall was -1

 > I see futex_requeue in the stack, which means the opcode is one of:
 > 
 > FUTEX_REQUEUE
 > FUTEX_CMP_REQUEUE
 > FUTEX_CMP_REQUEUE_PI
 > 
 > FUTEX_REQUEUE has a known issue and was replaced with FUTEX_CMP_REQUEUE,
 > for details, test cases, and an analysis see the historic tree:
 > 
 > commit 9b91d73bde9d68800f9e5c338c0cf9d0fe3bc862
 > Author: Andrew Morton <akpm@osdl.org>
 > Date:   2004-05-31
 > 
 >     [PATCH] Add FUTEX_CMP_REQUEUE futex op
 > 
 > Specifically:
 > http://listman.redhat.com/archives/phil-list/2004-May/msg00023.html
 > 
 > 
 > Trinity is going to trigger hangs in futexes just by it's very nature,
 > but I believe you have watchdogs in place to kill such malformed tests
 > after a timeout?

It should. Though that pid is happily ignoring the SIGKILL's the watchdog
is continuing to send, because it's never getting around to processing the
signals apparently.

	Dave

