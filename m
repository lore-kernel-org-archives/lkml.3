Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaLISIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 13:08:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51451 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbaLISIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 13:08:40 -0500
Date: Tue, 9 Dec 2014 19:08:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: Calvin Owens <calvinowens@fb.com>, Tony Luck <tony.luck@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] x86: mce: Avoid timer double-add during CMCI interrupt
 storms.
Message-ID: <20141209180835.GF3990@pd.tnic>
References: <1417746575-23299-1-git-send-email-calvinowens@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1417746575-23299-1-git-send-email-calvinowens@fb.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 06:29:35PM -0800, Calvin Owens wrote:
> The Intel CMCI interrupt handler calls mce_timer_kick() to force more
> frequent polling for MCE events when a CMCI storm occurs and CMCI
> interrupts are subsequently disabled.
> 
> If a CMCI interrupt storm happens to be detected while the timer
> interrupt is executing timer functions, mce_timer_kick() can race with
> mce_timer_fn(), which results in a double-add and the following BUG:
> 
> 	#0 [ffff88047fda3ad0] machine_kexec at ffffffff8102bdf5
> 	#1 [ffff88047fda3b20] crash_kexec at ffffffff8109e788
> 	#2 [ffff88047fda3bf0] oops_end at ffffffff815f20e8
> 	#3 [ffff88047fda3c20] die at ffffffff81005c08
> 	#4 [ffff88047fda3c50] do_trap at ffffffff815f192b
> 	#5 [ffff88047fda3cb0] do_invalid_op at ffffffff81002f42
> 	#6 [ffff88047fda3d60] invalid_op at ffffffff815fa668
> 	[exception RIP: add_timer_on+234]

Do I understand this correctly?

This is

	BUG_ON(timer_pending(timer) || !timer->function);

in add_timer_on() and the first check, at that, the timer_pending()?

> 	RIP: ffffffff8104d05a RSP: ffff88047fda3e18 RFLAGS: 00010286
> 	RAX: 0000000000000000 RBX: ffff88047fdacbc0 RCX: 000000001fbee3ff
> 	RDX: ffff88047fda0000 RSI: 000000000000001d RDI: ffff88047fdacbc0
> 	RBP: ffff88047fda3e58 R8: 0000000000000000 R9: ffffffff81aa0940
> 	R10: 0720072007200720 R11: 0720072007200765 R12: ffff880474a6c000
> 	R13: 0000000000000101 R14: 000000000000001d R15: ffff88047fdacbc0
> 	ORIG_RAX: ffffffffffffffff CS: 0010 SS: 0018
> 	#7 [ffff88047fda3e60] mce_timer_fn at ffffffff8101f524
> 	#8 [ffff88047fda3e80] call_timer_fn at ffffffff8104b4fa
> 	#9 [ffff88047fda3ec0] run_timer_softirq at ffffffff8104ce70
> 
> The timer_add() in mce_timer_kick() is actually unnecessary: since the
> timer is re-added by its handler function,

What about the case where iv can become 0?

        /* Might have become 0 after CMCI storm subsided */
        if (iv) {
                t->expires = jiffies + iv;
                add_timer_on(t, smp_processor_id());
        }

I have to say that whole story of iv becoming 0 doesn't sound all too
sane to me, though. This interval either decreases when polling - but up
to HZ/100 jiffies and not below. So I don't see how that would become 0
ever!

Regardless, you need to readd the timer because you won't be able to
poll the MCE banks in a storm mode.

> the only case in which the
> timer doesn't exist is when the CMCI interrupt calls mce_timer_kick() in
> the interval between the timer firing and mce_timer_fn() actually being
> executed. Thus, the timer work will be performed by mce_timer_fn() just
> after the interrupt exits.
> 
> This patch removes the add_timer() from mce_timer_kick(), and disables
> local interrupts during mce_timer_fn() so that mce_timer_fn() will
> always pick up the timer interval value that mce_timer_kick() drops
> in the PERCPU variable.
> 
> This means that the CMCI interrupt that hits the storm threshold will
> call mce_timer_kick() either:
> 
> 	1) In the interval between the mce_timer firing and mce_timer_fn()
> 	   disabling local IRQs. In this case, mce_timer_fn() will
> 	   immediately execute after the CMCI handler exits, and will
> 	   use the interval loaded in the PERCPU variable from
> 	   mce_timer_kick() to calculate its next timer interval.
> 
> 	2) Happen after mce_timer_fn() has done its work, in which case
> 	   the existing timer will be updated with the new interval if
> 	   it is before the existing one.

Right, so this polling thing once again proves its fragility to me - we
have had problems with it in the past so maybe we should think about
replacing it with something simpler and and much more robust instead of
this flaky dynamically adjustable polling thing.

So I'm thinking of leaving the detection code as it is, when we detect
a storm on a CPU, we set CMCI_STORM_ACTIVE and start a kernel thread at
max freq HZ/100 and polling the MCA banks. No adjustable frequency, no
timers, no nothing. A stupid per-cpu thread which polls.

Then, once we haven't seen any more CMCI errors - cmc_error_seen() - we
park that thread and switch back to interrupt mode.

I think this should be a lot simpler and hopefully more robust.

Downsides? I don't see any. We will normally poll for only short periods
of time. On boxes where we have to poll for much longer, the current
mechanism will bring us to max frequency polling anyway. But I might be
missing some nasty use cases...

Tony, what do you think?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
