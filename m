Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaLDIn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 03:43:26 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36182 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbaLDInX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 03:43:23 -0500
Message-ID: <54801ea9.0ca5e00a.3c72.08ce@mx.google.com>
Date: Thu, 4 Dec 2014 06:43:16 -0200
From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Rorvick <chris@rorvick.com>, Tejun Heo <tj@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <CA+55aFyBgyRS0zeE+LuHAvc=54v0de2KX=hRnr3imXwFFbftXw@mail.gmail.com>
References: <20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<20141201230813.GE25340@linux.vnet.ibm.com>
	<547dec29.c71f8c0a.33d1.11d9@mx.google.com>
	<20141202170407.GK25340@linux.vnet.ibm.com>
	<547df364.236a8c0a.7b2d.ffffac67@mx.google.com>
	<20141202184202.GM25340@linux.vnet.ibm.com>
	<547e0947.c332e00a.23bf.ffffa8bd@mx.google.com>
	<20141202191143.GN25340@linux.vnet.ibm.com>
	<547e11fa.8778e00a.3439.ffffa88c@mx.google.com>
	<20141202205636.GQ25340@linux.vnet.ibm.com>
	<547e36d1.c54ae00a.2571.fffffd13@mx.google.com>
	<CA+55aFxdZjJprk8t9NxcZmewAAQ5Gf1XQWV=5i+Vfc5uTSfWFg@mail.gmail.com>
	<547e81ce.a1628c0a.4985.ffffb12a@mx.google.com>
	<CA+55aFxumSXif01LigHBgZeXFTWT-7knX=a8LJZeaZZDPoHCBg@mail.gmail.com>
	<CAEUsAPYthwHxopuiBcGg4_nnBDDsS2jrTw4pDFiov38awsFodA@mail.gmail.com>
	<CA+55aFyBgyRS0zeE+LuHAvc=54v0de2KX=hRnr3imXwFFbftXw@mail.gmail.com>
Organization: http://www.youtube.com/DanielFragaBR
X-Mailer: Claws Mail 3.11.1-9-g1f531c (GTK+ 2.24.25; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014 07:22:44 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Anyway, Dâniel, if you restart the bisection today, start it one
> kernel earlier: re-test the last 'bad' kernel too. So start with
> reconfirming that the c9b88e958182 kernel was bad (that *might* be as
> easy as just checking your old kernel boot logs, and verifying that
> "yes, I really booted it, and yes, it clearly hung and I had to
> hard-reboot into it")

	Linus, today it's your lucky day, because I think I found the
real bad commit (if it isn't, then it's some very close to it). I 
managed to narrow the bisect and here's the result:

fd2ac4f4a65a7f34b0bc6433fcca1192d7ba8b8e is the first bad commit
commit fd2ac4f4a65a7f34b0bc6433fcca1192d7ba8b8e
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Tue Mar 18 21:12:53 2014 +0100

    nohz: Use nohz own full kick on 2nd task enqueue
    
    Now that we have a nohz full remote kick based on irq work, lets use
    it to notify a CPU that it's exiting single task mode.
    
    This unbloats a bit the scheduler IPI that the nohz code was abusing
    for its cool "callable anywhere/anytime" properties.
    
    Acked-by: Peter Zijlstra <peterz@infradead.org>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Ingo Molnar <mingo@kernel.org>
    Cc: Kevin Hilman <khilman@linaro.org>
    Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Viresh Kumar <viresh.kumar@linaro.org>
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

:040000 040000 5aa326eb5686b9343b56ab5d5e6779a0b988759d
3422b684c6d9121b888360789405050d0cf3cfdf M      kernel

****************************************************************

	And there's a nice Call Trace too:

Dec  4 06:03:33 tux kernel: [  737.180406] INFO: rcu_preempt detected stalls on CPUs/tasks: { 3} (detected by 4, t=240007 jiffies, g=36360, c=36359, q=0)
Dec  4 06:03:33 tux kernel: [  737.180412] sending NMI to all CPUs:
Dec  4 06:03:33 tux kernel: [  737.180416] NMI backtrace for cpu 4
Dec  4 06:03:34 tux kernel: [  737.180419] CPU: 4 PID: 785 Comm: kwin Not tainted 3.16.0-rc1-00005-gfd2ac4f #11
Dec  4 06:03:34 tux kernel: [  737.180420] Hardware name: System manufacturer System Product Name/P8Z68-V PRO GEN3, BIOS 3603 11/09/2012
Dec  4 06:03:34 tux kernel: [  737.180422] task: ffff880215360780 ti: ffff88020630c000 task.ti: ffff88020630c000
Dec  4 06:03:34 tux kernel: [  737.180423] RIP: 0010:[<ffffffff811fec10>]  [<ffffffff811fec10>] __const_udelay+0x0/0x30
Dec  4 06:03:34 tux kernel: [  737.180429] RSP: 0000:ffff88021f303e08  EFLAGS: 00000086
Dec  4 06:03:34 tux kernel: [  737.180430] RAX: 0000000000000c00 RBX: 0000000000002710 RCX: 0000000000000006
Dec  4 06:03:34 tux kernel: [  737.180431] RDX: 0000000000000007 RSI: 0000000000000046 RDI: 0000000000418958
Dec  4 06:03:34 tux kernel: [  737.180433] RBP: ffff88021f303e18 R08: 00000000000005cb R09: 00000000000005cb
Dec  4 06:03:34 tux kernel: [  737.180434] R10: 00000268d4b0862d R11: 00000000000005ca R12: ffffffff814f9680
Dec  4 06:03:34 tux kernel: [  737.180435] R13: ffffffff81521bd8 R14: ffffffff814f9680 R15: 0000000000000004
Dec  4 06:03:34 tux kernel: [  737.180437] FS:  00007fe9f003a900(0000) GS:ffff88021f300000(0000) knlGS:0000000000000000
Dec  4 06:03:34 tux kernel: [  737.180438] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec  4 06:03:34 tux kernel: [  737.180439] CR2: 00007fe93ba00000 CR3: 000000020635f000 CR4: 00000000000407e0
Dec  4 06:03:34 tux kernel: [  737.180440] Stack:
Dec  4 06:03:34 tux kernel: [  737.180441]  ffffffff8102f759 ffff88021f30d240 ffff88021f303e70 ffffffff8108dd41
Dec  4 06:03:34 tux kernel: [  737.180444]  ffffffff814f9680 ffffffff00000003 0000000000000000 0000000000000001
Dec  4 06:03:34 tux kernel: [  737.180445]  ffff880215360780 0000000000000000 0000000000000004 ffffffff81097730
Dec  4 06:03:34 tux kernel: [  737.180447] Call Trace:
Dec  4 06:03:34 tux kernel: [  737.180449]  <IRQ> 
Dec  4 06:03:34 tux kernel: [  737.180450]  [<ffffffff8102f759>] ? arch_trigger_all_cpu_backtrace+0x59/0x80
Dec  4 06:03:34 tux kernel: [  737.180457]  [<ffffffff8108dd41>] rcu_check_callbacks+0x6d1/0x740
Dec  4 06:03:35 tux kernel: [  737.180460]  [<ffffffff81097730>] ? tick_sched_handle.isra.20+0x40/0x40
Dec  4 06:03:35 tux kernel: [  737.180462]  [<ffffffff8104dea2>] update_process_times+0x42/0x70
Dec  4 06:03:35 tux kernel: [  737.180464]  [<ffffffff81097721>] tick_sched_handle.isra.20+0x31/0x40
Dec  4 06:03:35 tux kernel: [  737.180467]  [<ffffffff81097769>] tick_sched_timer+0x39/0x60
Dec  4 06:03:35 tux kernel: [  737.180469]  [<ffffffff810636a1>] __run_hrtimer.isra.33+0x41/0xd0
Dec  4 06:03:35 tux kernel: [  737.180472]  [<ffffffff81063a4f>] hrtimer_interrupt+0xef/0x250
Dec  4 06:03:35 tux kernel: [  737.180475]  [<ffffffff8102db65>] local_apic_timer_interrupt+0x35/0x60
Dec  4 06:03:35 tux kernel: [  737.180476]  [<ffffffff8102e12a>] smp_apic_timer_interrupt+0x3a/0x50
Dec  4 06:03:35 tux kernel: [  737.180480]  [<ffffffff81391a3a>] apic_timer_interrupt+0x6a/0x70
Dec  4 06:03:35 tux kernel: [  737.180481]  <EOI> 
Dec  4 06:03:35 tux kernel: [  737.180482]  [<ffffffff8109c4c6>] ? smp_call_function_many+0x256/0x270
Dec  4 06:03:35 tux kernel: [  737.180487]  [<ffffffff810c3290>] ? drain_pages+0x90/0x90
Dec  4 06:03:35 tux kernel: [  737.180489]  [<ffffffff810c3290>] ? drain_pages+0x90/0x90
Dec  4 06:03:35 tux kernel: [  737.180491]  [<ffffffff8109c5dc>] on_each_cpu_mask+0x2c/0x70
Dec  4 06:03:35 tux kernel: [  737.180493]  [<ffffffff810c0978>] drain_all_pages+0xb8/0xd0
Dec  4 06:03:35 tux kernel: [  737.180495]  [<ffffffff810c48a9>] __alloc_pages_nodemask+0x699/0x9f0
Dec  4 06:03:35 tux kernel: [  737.180498]  [<ffffffff810f84a2>] alloc_pages_vma+0x72/0x130
Dec  4 06:03:35 tux kernel: [  737.180501]  [<ffffffff8110579d>] do_huge_pmd_anonymous_page+0xed/0x3b0
Dec  4 06:03:35 tux kernel: [  737.180503]  [<ffffffff810e1721>] handle_mm_fault+0x141/0xae0
Dec  4 06:03:35 tux kernel: [  737.180506]  [<ffffffff810e6149>] ? vma_merge+0xf9/0x370
Dec  4 06:03:36 tux kernel: [  737.180508]  [<ffffffff81037f37>] __do_page_fault+0x167/0x4c0
Dec  4 06:03:36 tux kernel: [  737.180510]  [<ffffffff810e7e24>] ? do_mmap_pgoff+0x2e4/0x3d0
Dec  4 06:03:36 tux kernel: [  737.180513]  [<ffffffff8106f205>] ? local_clock+0x25/0x30
Dec  4 06:03:36 tux kernel: [  737.180516]  [<ffffffff8106fa5f>] ? vtime_account_user+0x4f/0x60
Dec  4 06:03:36 tux kernel: [  737.180517]  [<ffffffff810382ce>] do_page_fault+0x1e/0x70
Dec  4 06:03:36 tux kernel: [  737.180520]  [<ffffffff813921c2>] page_fault+0x22/0x30
Dec  4 06:03:36 tux kernel: [  737.180521] Code: 66 66 2e 0f 1f 84 00 00 00 00 00 48 ff c8 75 fb 48 ff c8 5d c3 66 0f 1f 44 00 00 55 48 89 e5 ff 15 2e 61 30 00 5d c3 0f 1f 40 00 <55> 48 8d 04 bd 00 00 00 00 48 89 e5 65 48 8b 14 25 20 12 01 00 
Dec  4 06:03:36 tux kernel: [  737.180542] NMI backtrace for cpu 6
Dec  4 06:03:36 tux kernel: [  737.180545] CPU: 6 PID: 8441 Comm: sh Not tainted 3.16.0-rc1-00005-gfd2ac4f #11
Dec  4 06:03:36 tux kernel: [  737.180547] Hardware name: System manufacturer System Product Name/P8Z68-V PRO GEN3, BIOS 3603 11/09/2012
Dec  4 06:03:36 tux kernel: [  737.180548] task: ffff8800c93d7800 ti: ffff880202094000 task.ti: ffff880202094000
Dec  4 06:03:36 tux kernel: [  737.180550] RIP: 0033:[<00007fcbfadb200f>]  [<00007fcbfadb200f>] 0x7fcbfadb200f
Dec  4 06:03:36 tux kernel: [  737.180563] RSP: 002b:00007fffa287e200  EFLAGS: 00000206
Dec  4 06:03:36 tux kernel: [  737.180564] RAX: 00007fffa287e2f0 RBX: 00007fffa287e2d0 RCX: 000000000095200f
Dec  4 06:03:36 tux kernel: [  737.180565] RDX: 0000000000000001 RSI: 00007fffa287e2f0 RDI: 00007fcbfb12f8a0
Dec  4 06:03:36 tux kernel: [  737.180567] RBP: 000000000095200e R08: 0000000000000000 R09: 00007fffa287e2e0
Dec  4 06:03:36 tux kernel: [  737.180568] R10: 000000000095200d R11: 0000000000000000 R12: 000000000095200f
Dec  4 06:03:36 tux kernel: [  737.180569] R13: 00007fffa287e2e8 R14: 000000000095200f R15: 0000000000000006
Dec  4 06:03:36 tux kernel: [  737.180571] FS:  00007fcbfb728700(0000) GS:ffff88021f380000(0000) knlGS:0000000000000000
Dec  4 06:03:36 tux kernel: [  737.180572] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec  4 06:03:36 tux kernel: [  737.180573] CR2: 0000000000a91000 CR3: 00000001fdfbe000 CR4: 00000000000407e0
Dec  4 06:03:37 tux kernel: [  737.180574] 
Dec  4 06:03:37 tux kernel: [  737.180576] NMI backtrace for cpu 7
Dec  4 06:03:37 tux kernel: [  737.180579] CPU: 7 PID: 8427 Comm: cc1 Not tainted 3.16.0-rc1-00005-gfd2ac4f #11
Dec  4 06:03:37 tux kernel: [  737.180580] Hardware name: System manufacturer System Product Name/P8Z68-V PRO GEN3, BIOS 3603 11/09/2012
Dec  4 06:03:37 tux kernel: [  737.180582] task: ffff8802048ec380 ti: ffff880204b48000 task.ti: ffff880204b48000
Dec  4 06:03:37 tux kernel: [  737.180583] RIP: 0033:[<0000000000ad9689>]  [<0000000000ad9689>] 0xad9689
Dec  4 06:03:37 tux kernel: [  737.180589] RSP: 002b:00007fffd63b4180  EFLAGS: 00000297
Dec  4 06:03:37 tux kernel: [  737.180590] RAX: 0000000000000059 RBX: 00007f78fe6811b0 RCX: 0000000000000000
Dec  4 06:03:37 tux kernel: [  737.180591] RDX: 0000000000000003 RSI: 0000000000000072 RDI: 00007f78fe6811b0
Dec  4 06:03:37 tux kernel: [  737.180593] RBP: 00007f78fe6811b0 R08: 0000000000000001 R09: 0000000000000000
Dec  4 06:03:37 tux kernel: [  737.180594] R10: 0000000000000000 R11: 0000000000000003 R12: 00000000015f50fa
Dec  4 06:03:37 tux kernel: [  737.180595] R13: 0000000000000000 R14: 0000000000000ba4 R15: 00007f78fe680a20
Dec  4 06:03:37 tux kernel: [  737.180597] FS:  00007f79008f8880(0000) GS:ffff88021f3c0000(0000) knlGS:0000000000000000
Dec  4 06:03:37 tux kernel: [  737.180598] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec  4 06:03:37 tux kernel: [  737.180599] CR2: 00007f78fe693000 CR3: 0000000204924000 CR4: 00000000000407e0
Dec  4 06:03:37 tux kernel: [  737.180600] 
Dec  4 06:03:37 tux kernel: [  737.180601] NMI backtrace for cpu 0
Dec  4 06:03:37 tux kernel: [  737.180604] CPU: 0 PID: 29099 Comm: cc1 Not tainted 3.16.0-rc1-00005-gfd2ac4f #11
Dec  4 06:03:37 tux kernel: [  737.180605] Hardware name: System manufacturer System Product Name/P8Z68-V PRO GEN3, BIOS 3603 11/09/2012
Dec  4 06:03:37 tux kernel: [  737.180606] task: ffff8800035e0780 ti: ffff8800035ec000 task.ti: ffff8800035ec000
Dec  4 06:03:37 tux kernel: [  737.180607] RIP: 0033:[<00000000006b1df2>]  [<00000000006b1df2>] 0x6b1df2
Dec  4 06:03:38 tux kernel: [  737.180611] RSP: 002b:00007fffbbb506f0  EFLAGS: 00000202
Dec  4 06:03:38 tux kernel: [  737.180613] RAX: 000000000329e508 RBX: 0000000002f1d888 RCX: 0000000002f1d8e8
Dec  4 06:03:38 tux kernel: [  737.180614] RDX: 000000000329e538 RSI: 0000000000000000 RDI: 0000000002f1d888
Dec  4 06:03:38 tux kernel: [  737.180615] RBP: 0000000003088008 R08: 000000000329e568 R09: 0000000000000000
Dec  4 06:03:38 tux kernel: [  737.180616] R10: 00000000ffffffff R11: 00000000ffffffff R12: 0000000002f1d2b8
Dec  4 06:03:38 tux kernel: [  737.180617] R13: 0000000003266ba8 R14: 0000000000000001 R15: 00007f72248ac3b8
Dec  4 06:03:38 tux kernel: [  737.180619] FS:  00007f72297ee880(0000) GS:ffff88021f200000(0000) knlGS:0000000000000000
Dec  4 06:03:38 tux kernel: [  737.180620] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec  4 06:03:38 tux kernel: [  737.180621] CR2: 00007f72215d5e28 CR3: 0000000012d96000 CR4: 00000000000407f0
Dec  4 06:03:38 tux kernel: [  737.180622] 
Dec  4 06:03:38 tux kernel: [  737.180623] NMI backtrace for cpu 1
Dec  4 06:03:38 tux kernel: [  737.180626] CPU: 1 PID: 7864 Comm: cc1 Not tainted 3.16.0-rc1-00005-gfd2ac4f #11
Dec  4 06:03:38 tux kernel: [  737.180631] Hardware name: System manufacturer System Product Name/P8Z68-V PRO GEN3, BIOS 3603 11/09/2012
Dec  4 06:03:38 tux kernel: [  737.180635] task: ffff88020443e900 ti: ffff880203f80000 task.ti: ffff880203f80000
Dec  4 06:03:38 tux kernel: [  737.180638] RIP: 0033:[<00007f90422909df>]  [<00007f90422909df>] 0x7f90422909df
Dec  4 06:03:38 tux kernel: [  737.180648] RSP: 002b:00007fff76432930  EFLAGS: 00000246
Dec  4 06:03:38 tux kernel: [  737.180652] RAX: 00007f90425bb678 RBX: 000000000185f6e0 RCX: 0000000000000440
Dec  4 06:03:38 tux kernel: [  737.180655] RDX: 00007f90425bb678 RSI: 0000000000000000 RDI: 00007f90425bb620
Dec  4 06:03:38 tux kernel: [  737.180660] RBP: 0000000000000400 R08: 00007f904201bae0 R09: 000000000189f130
Dec  4 06:03:38 tux kernel: [  737.180663] R10: 0000000000000000 R11: 0000000000000001 R12: 00007f90425bb620
Dec  4 06:03:38 tux kernel: [  737.180665] R13: 000000000185f7b0 R14: 0000000000000330 R15: 0000000000000000
Dec  4 06:03:38 tux kernel: [  737.180667] FS:  00007f9043b24880(0000) GS:ffff88021f240000(0000) knlGS:0000000000000000
Dec  4 06:03:38 tux kernel: [  737.180668] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec  4 06:03:39 tux kernel: [  737.180669] CR2: 00007f903faec000 CR3: 000000010499d000 CR4: 00000000000407e0
Dec  4 06:03:39 tux kernel: [  737.180670] 
Dec  4 06:03:39 tux kernel: [  737.180672] NMI backtrace for cpu 2
Dec  4 06:03:39 tux kernel: [  737.180674] CPU: 2 PID: 587 Comm: X Not tainted 3.16.0-rc1-00005-gfd2ac4f #11
Dec  4 06:03:39 tux kernel: [  737.180679] Hardware name: System manufacturer System Product Name/P8Z68-V PRO GEN3, BIOS 3603 11/09/2012
Dec  4 06:03:39 tux kernel: [  737.180683] task: ffff880215367080 ti: ffff88021391c000 task.ti: ffff88021391c000
Dec  4 06:03:39 tux kernel: [  737.180685] RIP: 0033:[<00007f93727697c2>]  [<00007f93727697c2>] 0x7f93727697c2
Dec  4 06:03:39 tux kernel: [  737.180694] RSP: 002b:00007fff5cb41b80  EFLAGS: 00003246
Dec  4 06:03:39 tux kernel: [  737.180696] RAX: 0000000000000021 RBX: 0000000000000001 RCX: 00007f9372a94620
Dec  4 06:03:39 tux kernel: [  737.180697] RDX: 0000000000000000 RSI: 00000000021abd90 RDI: 00007f9372a94620
Dec  4 06:03:39 tux kernel: [  737.180698] RBP: 00000000021abda0 R08: 0000000000000000 R09: 0000000000000000
Dec  4 06:03:39 tux kernel: [  737.180700] R10: 0000000000864d80 R11: 0000000000000000 R12: 000000000183a440
Dec  4 06:03:39 tux kernel: [  737.180701] R13: 0000000001b83b10 R14: 000000000086daf0 R15: 000000000085f078
Dec  4 06:03:39 tux kernel: [  737.180702] FS:  00007f93760ec880(0000) GS:ffff88021f280000(0000) knlGS:0000000000000000
Dec  4 06:03:39 tux kernel: [  737.180704] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec  4 06:03:39 tux kernel: [  737.180705] CR2: 00007f46a794c000 CR3: 0000000214aeb000 CR4: 00000000000407e0
Dec  4 06:03:39 tux kernel: [  737.180706] 
Dec  4 06:03:39 tux kernel: [  737.180708] NMI backtrace for cpu 5
Dec  4 06:03:39 tux kernel: [  737.180710] CPU: 5 PID: 8163 Comm: cc1 Not tainted 3.16.0-rc1-00005-gfd2ac4f #11
Dec  4 06:03:39 tux kernel: [  737.180711] Hardware name: System manufacturer System Product Name/P8Z68-V PRO GEN3, BIOS 3603 11/09/2012
Dec  4 06:03:39 tux kernel: [  737.180713] task: ffff8801afd8d280 ti: ffff8801aff20000 task.ti: ffff8801aff20000
Dec  4 06:03:39 tux kernel: [  737.180714] RIP: 0033:[<00000000006b1ce8>]  [<00000000006b1ce8>] 0x6b1ce8
Dec  4 06:03:39 tux kernel: [  737.180718] RSP: 002b:00007fff3e67c270  EFLAGS: 00000246
Dec  4 06:03:40 tux kernel: [  737.180719] RAX: 00000000032530f8 RBX: 00000000032be448 RCX: 0000000000000000
Dec  4 06:03:40 tux kernel: [  737.180720] RDX: 00000000000000c7 RSI: 0000000003253128 RDI: 00000000032e7ec0
Dec  4 06:03:40 tux kernel: [  737.180722] RBP: 00000000032be488 R08: 00000000ffffffff R09: 0000000000000000
Dec  4 06:03:40 tux kernel: [  737.180723] R10: 0000000000000000 R11: 00000000fffffffe R12: 0000000000000001
Dec  4 06:03:40 tux kernel: [  737.180724] R13: 0000000000000000 R14: 00000000032be448 R15: 0000000003227358
Dec  4 06:03:40 tux kernel: [  737.180725] FS:  00007f3b1ed4b880(0000) GS:ffff88021f340000(0000) knlGS:0000000000000000
Dec  4 06:03:40 tux kernel: [  737.180727] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec  4 06:03:40 tux kernel: [  737.180728] CR2: 00007f3b1bd32000 CR3: 0000000137da8000 CR4: 00000000000407e0
Dec  4 06:03:40 tux kernel: [  737.180729] 
Dec  4 06:03:40 tux kernel: [  737.180730] NMI backtrace for cpu 3
Dec  4 06:03:40 tux kernel: [  737.180733] CPU: 3 PID: 18986 Comm: cc1 Not tainted 3.16.0-rc1-00005-gfd2ac4f #11
Dec  4 06:03:40 tux kernel: [  737.180734] Hardware name: System manufacturer System Product Name/P8Z68-V PRO GEN3, BIOS 3603 11/09/2012
Dec  4 06:03:40 tux kernel: [  737.180736] task: ffff8801af0fad00 ti: ffff88019d734000 task.ti: ffff88019d734000
Dec  4 06:03:40 tux kernel: [  737.180737] RIP: 0010:[<ffffffff8106378c>]  [<ffffffff8106378c>] hrtimer_try_to_cancel+0x5c/0x80
Dec  4 06:03:40 tux kernel: [  737.180740] RSP: 0000:ffff88021f2c3da0  EFLAGS: 00000002
Dec  4 06:03:40 tux kernel: [  737.180741] RAX: ffff88021f2ccf80 RBX: ffff88021f2cda80 RCX: 0000000000000058
Dec  4 06:03:40 tux kernel: [  737.180742] RDX: 0000000000000002 RSI: 000000000000006a RDI: ffff88021f2ccf40
Dec  4 06:03:40 tux kernel: [  737.180744] RBP: ffff88021f2c3db8 R08: 0000000000000df2 R09: 00000000000000ee
Dec  4 06:03:41 tux kernel: [  737.180745] R10: 0000000000000003 R11: 0000000000000020 R12: 00000000ffffffff
Dec  4 06:03:41 tux kernel: [  737.180746] R13: 0000000000000000 R14: 0000000000000003 R15: ffff88021f2ccf40
Dec  4 06:03:41 tux kernel: [  737.180748] FS:  00007ff8b2464880(0000) GS:ffff88021f2c0000(0000) knlGS:0000000000000000
Dec  4 06:03:41 tux kernel: [  737.180749] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec  4 06:03:41 tux kernel: [  737.180750] CR2: 00007f9151c00000 CR3: 00000001e70f7000 CR4: 00000000000407e0
Dec  4 06:03:41 tux kernel: [  737.180751] Stack:
Dec  4 06:03:41 tux kernel: [  737.180752]  0000000000000082 ffff88021f2cda80 000000738285228a ffff88021f2c3dd0
Dec  4 06:03:41 tux kernel: [  737.180755]  ffffffff810637ca ffff88021f2cda80 ffff88021f2c3df0 ffffffff81097842
Dec  4 06:03:41 tux kernel: [  737.180757]  ffff88021f2cda80 000000738285228a ffff88021f2c3e10 ffffffff81097c4f
Dec  4 06:03:41 tux kernel: [  737.180759] Call Trace:
Dec  4 06:03:41 tux kernel: [  737.180760]  <IRQ> 
Dec  4 06:03:41 tux kernel: [  737.180761]  [<ffffffff810637ca>] hrtimer_cancel+0x1a/0x30
Dec  4 06:03:41 tux kernel: [  737.180766]  [<ffffffff81097842>] tick_nohz_restart+0x12/0x80
Dec  4 06:03:41 tux kernel: [  737.180769]  [<ffffffff81097c4f>] __tick_nohz_full_check+0x9f/0xb0
Dec  4 06:03:41 tux kernel: [  737.180771]  [<ffffffff81097c69>] nohz_full_kick_work_func+0x9/0x10
Dec  4 06:03:41 tux kernel: [  737.180774]  [<ffffffff810aecd4>] irq_work_run_list+0x44/0x70
Dec  4 06:03:41 tux kernel: [  737.180777]  [<ffffffff81097730>] ? tick_sched_handle.isra.20+0x40/0x40
Dec  4 06:03:41 tux kernel: [  737.180779]  [<ffffffff810aed19>] __irq_work_run+0x19/0x30
Dec  4 06:03:41 tux kernel: [  737.180782]  [<ffffffff810aed98>] irq_work_run+0x18/0x40
Dec  4 06:03:41 tux kernel: [  737.180784]  [<ffffffff8104deb6>] update_process_times+0x56/0x70
Dec  4 06:03:41 tux kernel: [  737.180786]  [<ffffffff81097721>] tick_sched_handle.isra.20+0x31/0x40
Dec  4 06:03:42 tux kernel: [  737.180788]  [<ffffffff81097769>] tick_sched_timer+0x39/0x60
Dec  4 06:03:42 tux kernel: [  737.180790]  [<ffffffff810636a1>] __run_hrtimer.isra.33+0x41/0xd0
Dec  4 06:03:42 tux kernel: [  737.180792]  [<ffffffff81063a4f>] hrtimer_interrupt+0xef/0x250
Dec  4 06:03:42 tux kernel: [  737.180795]  [<ffffffff8102db65>] local_apic_timer_interrupt+0x35/0x60
Dec  4 06:03:42 tux kernel: [  737.180797]  [<ffffffff8102e12a>] smp_apic_timer_interrupt+0x3a/0x50
Dec  4 06:03:42 tux kernel: [  737.180799]  [<ffffffff81391a3a>] apic_timer_interrupt+0x6a/0x70
Dec  4 06:03:42 tux kernel: [  737.180800]  <EOI> 
Dec  4 06:03:42 tux kernel: [  737.180802] Code: 2a 48 c7 c1 40 cf 00
00 65 48 03 0c 25 c8 cd 00 00 48 39 08 48 89 c6 48 89 df 41 b4 01 0f 94
c1 83 e2 02 0f b6 c9 e8 84 f8 ff ff <48> 8b 43 30 48 8b 75 e8 48 8b 38
e8 34 cb 32 00 48 83 c4 08 44 

***************************************************

	And here it's the bisect log:

git bisect start
# good: [19583ca584d6f574384e17fe7613dfaeadcdc4a6] Linux 3.16
git bisect good 19583ca584d6f574384e17fe7613dfaeadcdc4a6
# bad: [e9c9eecabaa898ff3fedd98813ee4ac1a00d006a] Merge branch 'x86-cpufeature-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad e9c9eecabaa898ff3fedd98813ee4ac1a00d006a
# good: [c9b88e9581828bb8bba06c5e7ee8ed1761172b6e] Merge tag 'trace-3.17-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
git bisect good c9b88e9581828bb8bba06c5e7ee8ed1761172b6e
# good: [5bda4f638f36ef4c4e3b1397b02affc3db94356e] Merge branch 'core-rcu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 5bda4f638f36ef4c4e3b1397b02affc3db94356e
# good: [288be943b5024729cd6809b61b62f727960178f3] perf tools: Add dso__data_status_seen()
git bisect good 288be943b5024729cd6809b61b62f727960178f3
# good: [ef35ad26f8ff44d2c93e29952cdb336bda729d9d] Merge branch 'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good ef35ad26f8ff44d2c93e29952cdb336bda729d9d
# bad: [b728ca06029d085a1585c1926610f26de93b9146] sched: Rework check_for_tasks()
git bisect bad b728ca06029d085a1585c1926610f26de93b9146
# bad: [541b82644d72c1ef4a0587515a619712c1c19bd3] sched/core: Fix formatting issues in sched_can_stop_tick()
git bisect bad 541b82644d72c1ef4a0587515a619712c1c19bd3
# bad: [3882ec643997757824cd5f25180cd8a787b9dbe1] nohz: Use IPI implicit full barrier against rq->nr_running r/w
git bisect bad 3882ec643997757824cd5f25180cd8a787b9dbe1
# good: [3d36aebc2e78923095575df954f3f3b430ac0a30] nohz: Support nohz full remote kick
git bisect good 3d36aebc2e78923095575df954f3f3b430ac0a30
# bad: [fd2ac4f4a65a7f34b0bc6433fcca1192d7ba8b8e] nohz: Use nohz own full kick on 2nd task enqueue
git bisect bad fd2ac4f4a65a7f34b0bc6433fcca1192d7ba8b8e
# good: [53c5fa16b4c843f1df91f7498e3c7bf95e0eaefa] nohz: Switch to nohz full remote kick on timer enqueue
git bisect good 53c5fa16b4c843f1df91f7498e3c7bf95e0eaefa
# first bad commit: [fd2ac4f4a65a7f34b0bc6433fcca1192d7ba8b8e] nohz:
Use nohz own full kick on 2nd task enqueue

	**************

	I hope it's correct now! If you need more testing don't 
hesitate to ask ;)

	Ps: I have the Call traces for the other bad commits, if it's needed.

-- 
Linux 3.16.0-rc1-00004-g53c5fa1: Shuffling Zombie Juror
http://www.youtube.com/DanielFragaBR
http://exchangewar.info
Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL
