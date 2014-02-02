Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaBBUKr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 15:10:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:36219 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbaBBUKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 15:10:45 -0500
Message-ID: <52EEA643.1010200@linutronix.de>
Date: Sun, 02 Feb 2014 21:10:43 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.2.0
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de
Subject: Re: [PATCH 1/2] irq_work: allow certain work in hard irq context
References: <1391178845-15837-1-git-send-email-bigeasy@linutronix.de> <1391314950.5444.18.camel@marge.simpson.net>
In-Reply-To: <1391314950.5444.18.camel@marge.simpson.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2014 05:22 AM, Mike Galbraith wrote:
> This patch (w. too noisy to live pr_err whacked) reliable kills my 64
> core test box, but only in _virgin_ 3.12-rt11.  Add my local patches,
> and it runs and runs, happy as a clam.  Odd.  But whatever, box with
> virgin source running says it's busted.

Sorry for that, I removed that line from the patch in my queue but the
sent version still had it…

> Killing what was killable in this run before box had a chance to turn
> into a brick, the two tasks below were left, burning 100% CPU until 5
> minute RCU deadline expired.  All other cores were idle.
> 
> [  705.466006] NMI backtrace for cpu 5
> [  705.466009] CPU: 5 PID: 21792 Comm: cc1 Tainted: GF            3.12.9-rt11 #376
> [  705.466015] RIP: 0010:[<ffffffff815d5450>]  [<ffffffff815d5450>] _raw_spin_unlock_irq+0x40/0x40
> [  705.466030]  <IRQ> 
> [  705.466033]  [<ffffffff81085074>] ? hrtimer_try_to_cancel+0x44/0x110
> [  705.466035]  [<ffffffff81085160>] hrtimer_cancel+0x20/0x30
> [  705.466037]  [<ffffffff810c52b2>] tick_nohz_restart+0x12/0x90
> [  705.466039]  [<ffffffff810c56da>] tick_nohz_restart_sched_tick+0x4a/0x60
> [  705.466041]  [<ffffffff810c5e99>] __tick_nohz_full_check+0x89/0x90
> [  705.466043]  [<ffffffff810c5ea9>] nohz_full_kick_work_func+0x9/0x10
> [  705.466047]  [<ffffffff81129e89>] __irq_work_run+0x79/0xb0
> [  705.466049]  [<ffffffff81129ec9>] irq_work_run+0x9/0x10
> [  705.466051]  [<ffffffff81068362>] update_process_times+0x62/0x80
> [  705.466053]  [<ffffffff810c4f02>] tick_sched_handle+0x32/0x70
> [  705.466055]  [<ffffffff810c51d0>] tick_sched_timer+0x40/0x70
> [  705.466057]  [<ffffffff81084b8d>] __run_hrtimer+0x14d/0x280
> [  705.466059]  [<ffffffff810c5190>] ? tick_nohz_handler+0xa0/0xa0
> [  705.466060]  [<ffffffff81084dea>] hrtimer_interrupt+0x12a/0x310
> [  705.466065]  [<ffffffff81096e4c>] ? vtime_account_user+0x6c/0x100
> [  705.466067]  [<ffffffff81034af6>] local_apic_timer_interrupt+0x36/0x60
> [  705.466069]  [<ffffffff8103a8c4>] ? native_apic_msr_eoi_write+0x14/0x20
> [  705.466071]  [<ffffffff810359fe>] smp_apic_timer_interrupt+0x3e/0x60
> [  705.466074]  [<ffffffff815ddcdd>] apic_timer_interrupt+0x6d/0x80
> [  705.466075]  <EOI> 
> [  705.468619] NMI backtrace for cpu 52
> [  705.468622] CPU: 52 PID: 23285 Comm: objdump Tainted: GF            3.12.9-rt11 #376
> [  705.468634] RIP: 0010:[<ffffffff81085083>]  [<ffffffff81085083>] hrtimer_try_to_cancel+0x53/0x110
> [  705.468650] Call Trace:
> [  705.468651]  <IRQ> 
> [  705.468653]  [<ffffffff81085160>] ? hrtimer_cancel+0x20/0x30
> [  705.468660]  [<ffffffff810c52b2>] tick_nohz_restart+0x12/0x90
> [  705.468662]  [<ffffffff810c56da>] tick_nohz_restart_sched_tick+0x4a/0x60
> [  705.468665]  [<ffffffff810c5e99>] __tick_nohz_full_check+0x89/0x90
> [  705.468667]  [<ffffffff810c5ea9>] nohz_full_kick_work_func+0x9/0x10
> [  705.468674]  [<ffffffff81129e89>] __irq_work_run+0x79/0xb0
> [  705.468676]  [<ffffffff81129ec9>] irq_work_run+0x9/0x10
> [  705.468681]  [<ffffffff81068362>] update_process_times+0x62/0x80
> [  705.468683]  [<ffffffff810c4f02>] tick_sched_handle+0x32/0x70
> [  705.468685]  [<ffffffff810c51d0>] tick_sched_timer+0x40/0x70
> [  705.468687]  [<ffffffff81084b8d>] __run_hrtimer+0x14d/0x280
> [  705.468689]  [<ffffffff810c5190>] ? tick_nohz_handler+0xa0/0xa0
> [  705.468691]  [<ffffffff81084dea>] hrtimer_interrupt+0x12a/0x310
> [  705.468700]  [<ffffffff81096c22>] ? vtime_account_system+0x52/0xe0
> [  705.468703]  [<ffffffff81034af6>] local_apic_timer_interrupt+0x36/0x60
> [  705.468708]  [<ffffffff8103a8c4>] ? native_apic_msr_eoi_write+0x14/0x20
> [  705.468710]  [<ffffffff810359fe>] smp_apic_timer_interrupt+0x3e/0x60
> [  705.468721]  [<ffffffff815ddcdd>] apic_timer_interrupt+0x6d/0x80
> [  705.468722]  <EOI> 
> [  705.468733]  [<ffffffff8105ae13>] ? pin_current_cpu+0x63/0x180
> [  705.468742]  [<ffffffff81090505>] migrate_disable+0x95/0x100
> [  705.468746]  [<ffffffff81168d21>] __do_fault+0x181/0x590
> [  705.468748]  [<ffffffff811691c3>] handle_pte_fault+0x93/0x250
> [  705.468750]  [<ffffffff811694b7>] __handle_mm_fault+0x137/0x1e0
> [  705.468752]  [<ffffffff81169653>] handle_mm_fault+0xf3/0x1a0
> [  705.468755]  [<ffffffff815d90f1>] __do_page_fault+0x291/0x550
> [  705.468758]  [<ffffffff8100a8d0>] ? native_sched_clock+0x20/0xa0
> [  705.468766]  [<ffffffff81108547>] ? acct_account_cputime+0x17/0x20
> [  705.468768]  [<ffffffff81096dc2>] ? account_user_time+0xd2/0xf0
> [  705.468770]  [<ffffffff81096e4c>] ? vtime_account_user+0x6c/0x100
> [  705.468772]  [<ffffffff815d93f0>] do_page_fault+0x40/0x70
> [  705.468774]  [<ffffffff815d5d48>] page_fault+0x28/0x30

So CPU5 & CPU52 were eating 100% CPU doing "nothing" instead of running
cc1 & objdump right?
According to the backtrace both of them are trying to access the
per-cpu hrtimer (sched_timer) in order to cancel but they seem to fail
to get the timer lock here. They shouldn't spin there for minutes, I
have no idea why they did so…
I guess this problem does not occur without -RT and before that patch
you saw only that one warning from can_stop_full_tick()?

Sebastian
