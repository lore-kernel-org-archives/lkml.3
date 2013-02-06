Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab3BFBy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 20:54:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14232 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab3BFBy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 20:54:57 -0500
X-Authority-Analysis: v=2.0 cv=f8jK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=_Bp3_fu7e2UA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=wIfm1DkAj9kA:10 a=uYVGJH5IAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=pX40m-wT-vWIu6yO510A:9 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=SSO-Y9H-le0A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Tue, 5 Feb 2013 20:54:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: Question on lockdep and MAX_LOCK_DEPTH
Message-ID: <20130206015430.GA9161@home.goodmis.org>
References: <5111AD8D.1080005@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5111AD8D.1080005@candelatech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 05:10:37PM -0800, Ben Greear wrote:
> I'm debugging something that could be my own bug in my wanlink module (but then
> again, haven't seen this on 3.5 kernels, and my module is
> basically un-changed since then).
> 
> I'm using lockdep, and keep seeing "BUG: MAX_LOCK_DEPTH too low".
> I tried changing the depth to 96 from 48, but it still hits.
> 
> I also added debug_show_all_locks(); when this error
> case hits.  I was assuming that if lockdep depth is large,
> there would be lots of locks held..but that does not
> seem to be the case??
> 
> 
> 
> ===============================
> [ INFO: suspicious RCU usage. ]
> 3.7.6+ #4 Tainted: G         C O
> -------------------------------
> /home/greearb/git/linux-3.7.dev.y/kernel/rcutree.c:360 Illegal idle entry in RCU read-side critical section.!
> 
> other info that might help us debug this:
> 
> 
> RCU used illegally from idle CPU!
> rcu_scheduler_active = 1, debug_locks = 1
> RCU used illegally from extended quiescent state!
> 1 lock held by swapper/1/0:
>  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff81489632>] rcu_read_lock+0x0/0x6f
> 
> stack backtrace:
> Pid: 0, comm: swapper/1 Tainted: G         C O 3.7.6+ #4

current is the swapper task.

> Call Trace:
>  <IRQ>  [<ffffffff810cecbd>] lockdep_rcu_suspicious+0xfc/0x105
>  [<ffffffff810fe146>] rcu_eqs_enter_common+0xef/0x178
>  [<ffffffff810fe24e>] rcu_irq_exit+0x7f/0xb0
>  [<ffffffff8108edf5>] irq_exit+0xc0/0xcc
>  [<ffffffff8100b635>] do_IRQ+0x97/0xae
>  [<ffffffff815543b2>] common_interrupt+0x72/0x72
>  <EOI>  [<ffffffff81011082>] ? mwait_idle+0x77/0x9f
>  [<ffffffff81011079>] ? mwait_idle+0x6e/0x9f
>  [<ffffffff81011379>] cpu_idle+0x68/0xbc
>  [<ffffffff8154ce84>] start_secondary+0x1fc/0x203
> 
> Showing all locks held in the system:
> 1 lock held by bash/2481:
>  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff813400a3>] n_tty_read+0x28d/0x785
> 1 lock held by mingetty/2853:
>  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff813400a3>] n_tty_read+0x28d/0x785
> 1 lock held by mingetty/2857:
>  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff813400a3>] n_tty_read+0x28d/0x785
> 1 lock held by mingetty/2862:
>  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff813400a3>] n_tty_read+0x28d/0x785
> 1 lock held by mingetty/2865:
>  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff813400a3>] n_tty_read+0x28d/0x785
> 1 lock held by mingetty/2867:
>  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff813400a3>] n_tty_read+0x28d/0x785
> 1 lock held by mingetty/2869:
>  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff813400a3>] n_tty_read+0x28d/0x785
> 1 lock held by bash/3017:
>  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff813400a3>] n_tty_read+0x28d/0x785

I'm not sure the swapper task is part of the 'do_each_thread()' loop.

Perhaps what you want to do is add a:

	lockdep_print_held_locks(current);

> 
> =============================================
> 
> BUG: MAX_LOCK_DEPTH too low, depth: 96  max: 96!
> turning off the locking correctness validator.
> Pid: 0, comm: swapper/1 Tainted: G         C O 3.7.6+ #4
> Call Trace:
>  <IRQ>  [<ffffffff810d1e31>] __lock_acquire+0xe80/0xf06
>  [<ffffffff810cfbbe>] ? check_irq_usage+0xad/0xbe
>  [<ffffffff810d1f1b>] lock_acquire+0x64/0x81
>  [<ffffffff810acbf3>] ? cpu_cgroup_can_attach+0x66/0x66
>  [<ffffffff810acc26>] rcu_read_lock+0x33/0x6f
>  [<ffffffff810acbf3>] ? cpu_cgroup_can_attach+0x66/0x66
>  [<ffffffff810ad1a8>] ttwu_stat+0x60/0x11c
>  [<ffffffff810b1cbb>] try_to_wake_up+0x1e6/0x20b
>  [<ffffffff810b1ced>] default_wake_function+0xd/0xf
>  [<ffffffff810ab4c1>] __wake_up_common+0x49/0x7f
>  [<ffffffff810ac4e5>] __wake_up+0x34/0x48
>  [<ffffffffa05fce11>] handleRcvWlp+0xf4d/0xfd5 [wanlink]
>  [<ffffffff810d133a>] ? __lock_acquire+0x389/0xf06

I'm curious. Does your code grab a read lock? If you grab the same read
lock multiple times it adds to the list each time. Thus if you have
anything like:

	for (i = 0; i < 100; i++ ) {
		read_lock(&lock);
	}

	for (i = 0; i < 100; i++) {
		read_unlock(&lock);
	}

That will fill up the held locks quite a bit.

The above code I showed is ridiculous and I doubt you have it, but if
you have something that does lots of recursive reads for some reason,
that could be an issue.

-- Steve


>  [<ffffffffa05fd325>] wp_handle_rcv_pkt+0x1f5/0x243 [wanlink]
>  [<ffffffffa05fd51c>] handle_rcv+0x1a9/0x1dd [wanlink]
>  [<ffffffff8148a5f1>] deliver_skb+0x58/0x60
>  [<ffffffff8148ab00>] __netif_receive_skb+0x507/0x63c
>  [<ffffffff810100b6>] ? read_tsc+0x9/0x1b
>  [<ffffffff8148c939>] netif_receive_skb+0x56/0x8b
>  [<ffffffff8148cf64>] ? __napi_gro_receive+0xf3/0x102
>  [<ffffffff8148ca51>] napi_skb_finish+0x24/0x57
>  [<ffffffff8148d199>] napi_gro_receive+0x91/0x96
>  [<ffffffffa0231d31>] e1000_receive_skb+0x50/0x5b [e1000e]
>  [<ffffffffa023500c>] e1000_clean_rx_irq+0x29f/0x341 [e1000e]
>  [<ffffffffa02355c6>] e1000e_poll+0x7d/0x239 [e1000e]
>  [<ffffffff8148d31f>] net_rx_action+0xb2/0x1e2
>  [<ffffffff8108eeea>] ? __do_softirq+0x6d/0x17b
>  [<ffffffff8108ef28>] __do_softirq+0xab/0x17b
>  [<ffffffff810a6ed6>] ? hrtimer_interrupt+0x127/0x1e2
>  [<ffffffff8155a7fc>] call_softirq+0x1c/0x30
>  [<ffffffff8100bd46>] do_softirq+0x46/0x9e
>  [<ffffffff8108ed83>] irq_exit+0x4e/0xcc
>  [<ffffffff81027f73>] smp_apic_timer_interrupt+0x85/0x93
>  [<ffffffff8155a0b2>] apic_timer_interrupt+0x72/0x80
>  <EOI>  [<ffffffff81554477>] ? retint_restore_args+0x13/0x13
>  [<ffffffff81011082>] ? mwait_idle+0x77/0x9f
>  [<ffffffff81011079>] ? mwait_idle+0x6e/0x9f
>  [<ffffffff81011379>] cpu_idle+0x68/0xbc
>  [<ffffffff8154ce84>] start_secondary+0x1fc/0x203
> BUG: sleeping function called from invalid context at /home/greearb/git/linux-3.7.dev.y/kernel/mutex.c:269
> in_atomic(): 0, irqs_disabled(): 0, pid: 1375, name: rs:main Q:Reg
> INFO: lockdep is turned off.
> Pid: 1375, comm: rs:main Q:Reg Tainted: G         C O 3.7.6+ #4
> Call Trace:
>  [<ffffffff810adc9d>] __might_sleep+0x1a2/0x1ab
>  [<ffffffff81551969>] mutex_lock_nested+0x20/0x3b
>  [<ffffffff8133e243>] process_output+0x24/0x52
>  [<ffffffff8133fba3>] n_tty_write+0x273/0x356
>  [<ffffffff810b1ce0>] ? try_to_wake_up+0x20b/0x20b
>  [<ffffffff8133db38>] tty_write+0x19b/0x23a
>  [<ffffffff8133f930>] ? n_tty_ioctl+0xc6/0xc6
>  [<ffffffff8133dc61>] redirected_tty_write+0x8a/0x95
>  [<ffffffff81158d6c>] vfs_write+0xa9/0x105
>  [<ffffffff81158ead>] sys_write+0x54/0x89
>  [<ffffffff81559569>] system_call_fastpath+0x16/0x1b
> 
> -- 
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
