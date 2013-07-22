Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303Ab3GVTyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 15:54:54 -0400
Received: from smtp1.uu.se ([130.238.7.54]:37349 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933208Ab3GVTyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 15:54:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20973.36152.517407.702239@pilspetsen.it.uu.se>
Date: Mon, 22 Jul 2013 21:51:20 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org
Subject: CONFIG_X86_PKG_TEMP_THERMAL causes #GP fault on Core i7-740QM breaking boot
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-rc1 and -rc2 refuse to boot on my Dell Latitude E6510 
(Intel Core i7-740QM processor) due to __rdmsr_on_cpu throwing
a #GP fault.

Being a laptop it doesn't have a good way to log early boot
messages, so the following was typed in by hand:

serio...
mousedev...
rtc_cmos...
general protection fault: 0000 [#1] SMP
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.11.0-rc2 #1
Hardware name: Dell Inc. Latitude E6510/0N5KHN, BIOS A09 05/26/2011
task: ffffffff814d1440 ti: ffffffff814c0000 task.ti: ffffffff814c0000
RIP: 0010:[<ffffffff81206f05>]  [<ffffffff81206f05>] __rdmsr_on_cpu+0x25/0x40
RSP: 0000:ffff88012fc03f70  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff88012b083c80 RCX: 00000000000001b1
RDX: 0000000000000000 RSI: ffff88012b083ce0 RDI: ffff88012b083cd8
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88012fc03f78
R13: ffffffff814c1fd8 R14: 0000000000000000 R15: ffffffff814c1fd8
FS:  0000000000000000(0000) GS:ffff88012fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff88012ffff000 CR3: 00000000014cc000 CR4: 00000000000007f0
Stack:
 ffffffff8108b5fd ffff88012fc03f78 ffff88012fc03f78 ffffffff814c1fd8
 0000000000000000 ffffffff814c1fd8 ffffffff81027272 0000000000000000
 ffffffff81382677 ffffffff814c1ea8 <EOI>  0000000000000000 0000000000000202
Call Trace:
 <IRQ>
 [<ffffffff8108b5fd>] ? generic_sml_call_function_single_interrupt+0xad/0x120
 [<ffffffff81027272>] ? smp_call_function_single_interrupt+0x22/0x40
 [<ffffffff81382677>] ? call_function_single_interrupt+0x67/0x70
 <EOI>
 [<ffffffff8100bc10>] ? idle_notifier_register+0x10/0x10
 [<ffffffff8100bc25>] ? default_idle+0x15/0xb0
 [<ffffffff8107c69d>] ? cpu_startup_entry+0x7d/0x200
 [<ffffffff8153bd80>] ? start_kernel+0x346/0x351
 [<ffffffff8153b851>] ? repair_env_strings+0x59/0x59
Code: 90 90 90 90 90 90 48 8b 47 10 48 8d 77 08 65 8b 14 25 1c b0 00 00 48 85 c0
 74 0e 48 63 d2 48 89 c6 48 03 34 d5 a0 11 52 81 8b 0f <0f> 32 48 c1 e2 20 89 c0
 48 09 c2 89 16 48 c1 ea 20 89 56 04 c3
RIP  [<ffffffff81206f05>] __rdmsr_on_cpu+0x25/0x40
 RSP <ffff88012fc03f70>
---[ end trace ... ]---
Kernel panic - not syncing: Fatal exception in interrupt

Looks like it's trying to read MSR 0x1B1, IA32_PACKAGE_THERM_STATUS,
and my i7-740QM doesn't like that.

Disabling CONFIG_X86_PKG_TEMP_THERMAL allows the kernel to boot again.

/Mikael
