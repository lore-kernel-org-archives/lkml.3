Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbaIKVSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 17:18:09 -0400
Received: from mga14.intel.com ([192.55.52.115]:24708 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbaIKVSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 17:18:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,507,1406617200"; 
   d="scan'208";a="590081058"
Date: Fri, 12 Sep 2014 05:18:02 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [nohz] WARNING: CPU: 0 PID: 0 at
 arch/x86/kernel/cpu/common.c:1430 warn_pre_alternatives()
Message-ID: <20140911211802.GA18626@localhost>
References: <20140911071704.GA4026@localhost>
 <20140911155316.GA2524@lerouge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911155316.GA2524@lerouge>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On Thu, Sep 11, 2014 at 05:53:19PM +0200, Frederic Weisbecker wrote:
> Hi,
> 
> On Thu, Sep 11, 2014 at 03:17:04PM +0800, Fengguang Wu wrote:
> > Greetings,
> > 
> > 0day kernel testing robot got the below dmesg and the first bad commit is
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git nohz/fixes-v2
> > 
> > commit 664c05b9ab2dd92aad807bd7f9aa273955949abe
> > Author:     Frederic Weisbecker <fweisbec@gmail.com>
> > AuthorDate: Sun Aug 17 22:02:55 2014 +0200
> > Commit:     Frederic Weisbecker <fweisbec@gmail.com>
> > CommitDate: Wed Sep 10 18:52:45 2014 +0200
> > 
> >     nohz: Consolidate nohz full init code
> >     
> >     The supports for CONFIG_NO_HZ_FULL_ALL=y and the nohz_full= kernel
> >     parameter both have their own way to do the same thing: allocate
> >     full dynticks cpumasks, fill them and initialize some state variables.
> >     
> >     Lets consolidate that all in the same place.
> >     
> >     While at it, convert some regular printk message to warnings when
> >     fundamental allocations fail.
> >     
> >     Cc: Ingo Molnar <mingo@kernel.org>
> >     Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >     Cc: Peter Zijlstra <peterz@infradead.org>
> >     Cc: Thomas Gleixner <tglx@linutronix.de>
> >     Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > +-----------------------------------------------------------------+------------+------------+------------+
> > |                                                                 | ed1fb75de3 | 664c05b9ab | dd99eb9cdf |
> > +-----------------------------------------------------------------+------------+------------+------------+
> > | boot_successes                                                  | 60         | 0          | 0          |
> > | boot_failures                                                   | 0          | 20         | 23         |
> 
> So you tested ed1fb75de3 and 664c05b9ab with the same config that is in attachement, right?

Yes.

> I can't find what dd99eb9cdf refers to though.

It's an internal merge-and-test branch head.

> One more thing below:
> 
> > | WARNING:at_arch/x86/kernel/cpu/common.c:warn_pre_alternatives() | 0          | 20         | 22         |
> > | BUG:kernel_boot_hang                                            | 0          | 20         | 22         |
> > | backtrace:setup_default_timer_irq                               | 0          | 20         | 22         |
> > | backtrace:hpet_time_init                                        | 0          | 20         | 22         |
> > | backtrace:x86_late_time_init                                    | 0          | 20         | 22         |
> > | WARNING:CPU:PID:at/kbuild/                                      | 0          | 1          |            |
> > | WARNING:CPU:PID:at_arch/x86/k                                   | 0          | 1          |            |
> > | WARNING:CPU:PID:at_arch/x86/kernel/cpu/common.c:warn_pre_al     | 0          | 0          | 1          |
> > | BUG:kernel_boot_crashed                                         | 0          | 0          | 1          |
> > +-----------------------------------------------------------------+------------+------------+------------+
> > 
> > [    0.000000] ----------------------------------------------------
> > [    0.000000] hpet clockevent registered
> > [    0.000000] ------------[ cut here ]------------
> > [    0.000000] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/cpu/common.c:1430 warn_pre_alternatives+0x1e/0x20()
> > [    0.000000] You're using static_cpu_has before alternatives have run!
> > [    0.000000] Modules linked in:
> > [    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.17.0-rc3-00007-g664c05b #840
> > [    0.000000]  0000000000000009 ffff880012603d80 ffffffff89dfe8c6 ffff880012603dc8
> > [    0.000000]  ffff880012603db8 ffffffff89a81df3 ffffffff8a414580 0000000000000000
> > [    0.000000]  0000000000000000 0000000000000000 0000000000000000 ffff880012603e18
> > [    0.000000] Call Trace:
> > [    0.000000]  <IRQ>  [<ffffffff89dfe8c6>] dump_stack+0x4d/0x66
> > [    0.000000]  [<ffffffff89a81df3>] warn_slowpath_common+0x73/0x90
> > [    0.000000]  [<ffffffff89a81e57>] warn_slowpath_fmt+0x47/0x50
> > [    0.000000]  [<ffffffff89acaadf>] ? rcu_check_callbacks+0x30f/0x7c0
> > [    0.000000]  [<ffffffff89a1396e>] warn_pre_alternatives+0x1e/0x20
> > [    0.000000]  [<ffffffff89aeddd5>] irq_work_tick+0x15/0x50
> > [    0.000000]  [<ffffffff89acfae6>] update_process_times+0x56/0x70
> > [    0.000000]  [<ffffffff89adae2b>] tick_periodic+0x2b/0xc0
> > [    0.000000]  [<ffffffff89adb0d1>] ? tick_handle_periodic+0x21/0x60
> > [    0.000000]  [<ffffffff89adb0d1>] tick_handle_periodic+0x21/0x60
> > [    0.000000]  [<ffffffff89a05500>] timer_interrupt+0x10/0x20
> > [    0.000000]  [<ffffffff89ac1ef4>] handle_irq_event_percpu+0x64/0x110
> > [    0.000000]  [<ffffffff89ac1fd8>] handle_irq_event+0x38/0x60
> > [    0.000000]  [<ffffffff89ac4c24>] handle_level_irq+0x74/0x110
> > [    0.000000]  [<ffffffff89a04cf8>] handle_irq+0x58/0x150
> > [    0.000000]  [<ffffffff89aa8e89>] ? vtime_account_idle+0x9/0x50
> > [    0.000000]  [<ffffffff89aa8f0d>] ? vtime_common_account_irq_enter+0x3d/0x50
> > [    0.000000]  [<ffffffff89a04598>] do_IRQ+0x48/0xe0
> > [    0.000000]  [<ffffffff89e063ed>] common_interrupt+0x6d/0x6d
> > [    0.000000]  <EOI>  [<ffffffff89a2f0a6>] ? native_restore_fl+0x6/0x10
> > [    0.000000]  [<ffffffff89e04ea1>] _raw_spin_unlock_irqrestore+0x31/0x40
> > [    0.000000]  [<ffffffff89ac3845>] __setup_irq+0x255/0x580
> > [    0.000000]  [<ffffffff89ac3bac>] setup_irq+0x3c/0xa0
> > [    0.000000]  [<ffffffff8a529998>] ? hpet_enable+0x29a/0x2cb
> > [    0.000000]  [<ffffffff8a51cb9b>] setup_default_timer_irq+0x1e/0x20
> > [    0.000000]  [<ffffffff8a51cbb4>] hpet_time_init+0x17/0x19
> > [    0.000000]  [<ffffffff8a51cb76>] x86_late_time_init+0xa/0x11
> > [    0.000000]  [<ffffffff8a51ad8c>] start_kernel+0x383/0x3f8
> > [    0.000000]  [<ffffffff8a51a120>] ? early_idt_handlers+0x120/0x120
> > [    0.000000]  [<ffffffff8a51a432>] x86_64_start_reservations+0x2a/0x2c
> > [    0.000000]  [<ffffffff8a51a50b>] x86_64_start_kernel+0xd7/0xe4
> 
> So the issue here seems to be that something enabled irqs on boot way too early.
> But I tried hard to reproduce that crash without success. So I wanted to ask you,
> do you mind if I send you a patch to debug this?

Never mind. Feel free to send me the patch.

Thanks,
Fengguang
