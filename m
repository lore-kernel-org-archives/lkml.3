Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab3CYLBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 07:01:51 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.105]:62849 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755535Ab3CYLBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 07:01:49 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-4.tower-201.messagelabs.com!1364209306!6488515!1
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <51502C87.8050902@digi.com>
Date: Mon, 25 Mar 2013 11:52:55 +0100
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Fabio Estevam <festevam@gmail.com>, Marek Vasut <marex@denx.de>
Subject: BUG: soft lockup when recording audio on MX28EVK with ASoC sgtl5000
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I just tried recording audio on Freescale's MX28EVK that uses ASoC sgtl5000 (kernel 
v3.8) with:

	arecord -M -f cd sound.wav --duration 10

and got a scheduler message:

[  789.041847] [sched_delayed] sched: RT throttling activated

The system then becomes nearly unresponsive and after some seconds the kernel 
complains of a soft lockup.

[  904.211821] BUG: soft lockup - CPU#0 stuck for 22s! [mdev:279]
[  904.217693] Modules linked in:
[  904.220776] irq event stamp: 1576636
[  904.224363] hardirqs last  enabled at (1576635): [<c000ee28>] __irq_svc+0x48/0x54
[  904.231903] hardirqs last disabled at (1576636): [<c000ee14>] __irq_svc+0x34/0x54
[  904.239422] softirqs last  enabled at (1575782): [<c0026138>] __do_softirq+0x13c/0x220
[  904.247388] softirqs last disabled at (1575771): [<c002630c>] irq_exit+0x8c/0x94
[  904.254821]
[  904.256328] Pid: 279, comm:                 mdev
[  904.260967] CPU: 0    Not tainted  (3.8.0-00041-gbdf34c0-dirty #49)
[  904.267272] PC is at cpu_arm926_switch_mm+0x8/0x20
[  904.272089] LR is at flush_old_exec+0x340/0x5c0
[  904.276644] pc : [<c001a5c8>]    lr : [<c00da6a0>]    psr: 00000013
[  904.276644] sp : c6f73e60  ip : 00000000  fp : c0634c10
[  904.288138] r10: c779dd20  r9 : c77ac654  r8 : c779d5a0
[  904.293378] r7 : c6f0ac00  r6 : c77ac400  r5 : c6f72000  r4 : c779dd20
[  904.299918] r3 : 60000013  r2 : 00000000  r1 : c779d5a0  r0 : 46f7c000
[  904.306461] Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[  904.313613] Control: 0005317f  Table: 46f78000  DAC: 00000015
[  904.319427] [<c001510c>] (unwind_backtrace+0x0/0xf4) from [<c006c4a8>] 
(watchdog_timer_fn+0x124/0x160)
[  904.328795] [<c006c4a8>] (watchdog_timer_fn+0x124/0x160) from [<c0042784>] 
(__run_hrtimer+0x7c/0x1e8)
[  904.338061] [<c0042784>] (__run_hrtimer+0x7c/0x1e8) from [<c0042c9c>] 
(hrtimer_interrupt+0x110/0x310)
[  904.347329] [<c0042c9c>] (hrtimer_interrupt+0x110/0x310) from [<c001ab80>] 
(mxs_timer_interrupt+0x1c/0x2
8)
[  904.357033] [<c001ab80>] (mxs_timer_interrupt+0x1c/0x28) from [<c006cb38>] 
(handle_irq_event_percpu+0x5c
/0x26c)
[  904.367169] [<c006cb38>] (handle_irq_event_percpu+0x5c/0x26c) from [<c006cd84>] 
(handle_irq_event+0x3c/0
x5c)
[  904.377039] [<c006cd84>] (handle_irq_event+0x3c/0x5c) from [<c006f3b0>] 
(handle_level_irq+0x8c/0x118)
[  904.386300] [<c006f3b0>] (handle_level_irq+0x8c/0x118) from [<c006cacc>] 
(generic_handle_irq+0x28/0x30)
[  904.395741] [<c006cacc>] (generic_handle_irq+0x28/0x30) from [<c001009c>] 
(handle_IRQ+0x30/0x84)
[  904.404568] [<c001009c>] (handle_IRQ+0x30/0x84) from [<c00086ec>] 
(icoll_handle_irq+0x30/0x44)
[  904.413220] [<c00086ec>] (icoll_handle_irq+0x30/0x44) from [<c000ee24>] 
(__irq_svc+0x44/0x54)
[  904.421761] Exception stack(0xc6f73e18 to 0xc6f73e60)
[  904.426834] 3e00:                                                       46f7c000 
c779d5a0
[  904.435043] 3e20: 00000000 60000013 c779dd20 c6f72000 c77ac400 c6f0ac00 c779d5a0 
c77ac654
[  904.443250] 3e40: c779dd20 c0634c10 00000000 c6f73e60 c00da6a0 c001a5c8 00000013 
ffffffff
[  904.451472] [<c000ee24>] (__irq_svc+0x44/0x54) from [<c001a5c8>] 
(cpu_arm926_switch_mm+0x8/0x20)
[  904.460298] [<c001a5c8>] (cpu_arm926_switch_mm+0x8/0x20) from [<c6e740c0>] (0xc6e740c0)
[  936.211821] BUG: soft lockup - CPU#0 stuck for 21s! [arecord:264]
[  936.217952] Modules linked in:
[  936.221038] irq event stamp: 6749868
[  936.224624] hardirqs last  enabled at (6749867): [<c000ee28>] __irq_svc+0x48/0x54
[  936.232163] hardirqs last disabled at (6749868): [<c000ee14>] __irq_svc+0x34/0x54
[  936.239681] softirqs last  enabled at (6749012): [<c0026138>] __do_softirq+0x13c/0x220
[  936.247644] softirqs last disabled at (6748999): [<c002630c>] irq_exit+0x8c/0x94
[  936.255077]
[  936.256586] Pid: 264, comm:              arecord
[  936.261223] CPU: 0    Not tainted  (3.8.0-00041-gbdf34c0-dirty #49)
[  936.267528] PC is at cpu_arm926_switch_mm+0x8/0x20
[  936.272352] LR is at T.1273+0xf4/0x150
[  936.276125] pc : [<c001a5c8>]    lr : [<c004c9d4>]    psr: 00000013
[  936.276125] sp : c6ed1d98  ip : 00000000  fp : c6ed1dc4
[  936.287618] r10: c0455e0c  r9 : c6ec91e0  r8 : 00000001
[  936.292857] r7 : c7430000  r6 : 00000000  r5 : c062e870  r4 : c6ed0000
[  936.299398] r3 : c6ec91e0  r2 : 20000013  r1 : c6ec91e0  r0 : 46ec4000
[  936.305942] Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[  936.313092] Control: 0005317f  Table: 4776c000  DAC: 00000015
[  936.318906] [<c001510c>] (unwind_backtrace+0x0/0xf4) from [<c006c4a8>] 
(watchdog_timer_fn+0x124/0x160)
[  936.328273] [<c006c4a8>] (watchdog_timer_fn+0x124/0x160) from [<c0042784>] 
(__run_hrtimer+0x7c/0x1e8)
[  936.337539] [<c0042784>] (__run_hrtimer+0x7c/0x1e8) from [<c0042c9c>] 
(hrtimer_interrupt+0x110/0x310)
[  936.346806] [<c0042c9c>] (hrtimer_interrupt+0x110/0x310) from [<c001ab80>] 
(mxs_timer_interrupt+0x1c/0x2
8)
[  936.356509] [<c001ab80>] (mxs_timer_interrupt+0x1c/0x28) from [<c006cb38>] 
(handle_irq_event_percpu+0x5c
/0x26c)
[  936.366647] [<c006cb38>] (handle_irq_event_percpu+0x5c/0x26c) from [<c006cd84>] 
(handle_irq_event+0x3c/0
x5c)
[  936.376519] [<c006cd84>] (handle_irq_event+0x3c/0x5c) from [<c006f3b0>] 
(handle_level_irq+0x8c/0x118)
[  936.385781] [<c006f3b0>] (handle_level_irq+0x8c/0x118) from [<c006cacc>] 
(generic_handle_irq+0x28/0x30)
[  936.395222] [<c006cacc>] (generic_handle_irq+0x28/0x30) from [<c001009c>] 
(handle_IRQ+0x30/0x84)
[  936.404050] [<c001009c>] (handle_IRQ+0x30/0x84) from [<c00086ec>] 
(icoll_handle_irq+0x30/0x44)
[  936.412701] [<c00086ec>] (icoll_handle_irq+0x30/0x44) from [<c000ee24>] 
(__irq_svc+0x44/0x54)
[  936.421243] Exception stack(0xc6ed1d50 to 0xc6ed1d98)
[  936.426320] 1d40:                                     46ec4000 c6ec91e0 20000013 
c6ec91e0
[  936.434527] 1d60: c6ed0000 c062e870 00000000 c7430000 00000001 c6ec91e0 c0455e0c 
c6ed1dc4
[  936.442727] 1d80: 00000000 c6ed1d98 c004c9d4 c001a5c8 00000013 ffffffff
[  936.449389] [<c000ee24>] (__irq_svc+0x44/0x54) from [<c001a5c8>] 
(cpu_arm926_switch_mm+0x8/0x20)
[  936.458217] [<c001a5c8>] (cpu_arm926_switch_mm+0x8/0x20) from [<c6e303c0>] (0xc6e303c0)

The system does not completely die but it is extremely slow and almost unusable,
I checked that the mxs-saif interrupt (184) counter suddenly increased very quickly 
(from 288 to 45427 in one second, 94471 the next second, and so on).
I was wondering if this happens in other platforms using this codec or if it is an MXS 
issue only.

Best regards,
-- 
Héctor Palacios
