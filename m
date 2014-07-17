Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680AbaGQO7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:59:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:39142 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908AbaGQO7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:59:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,678,1400050800"; 
   d="scan'208";a="458171991"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] x86: fix kernel crash on boot due to NULL dereference
Date: Thu, 17 Jul 2014 17:59:41 +0300
Message-Id: <1405609181-12831-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch "x86, irq: Count legacy IRQs by legacy_pic->nr_legacy_irqs instead of
NR_IRQS_LEGACY" (linux-next commit 95d76acc7518d566df18d67c1343bb375b78d1f3)
removed reserved interrupts for the platforms that do not have a legacy IOAPIC.
Meanwhile it breks a boot on Intel MID platforms such as Medfield.

[    0.000000] BUG: unable to handle kernel NULL pointer dereference at 0000003a
[    0.000000] IP: [<c107079a>] setup_irq+0xf/0x4d
[    0.000000] *pdpt = 0000000000000000 *pde = 9bbf32453167e510
[    0.000000] Oops: 0000 [#1] PREEMPT SMP
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc5-next-20140717-00043-g6ab7e8d-dirty #497
[    0.000000] task: c184bc80 ti: c183e000 task.ti: c183e000
[    0.000000] EIP: 0060:[<c107079a>] EFLAGS: 00210046 CPU: 0
[    0.000000] EIP is at setup_irq+0xf/0x4d
[    0.000000] EAX: 00000000 EBX: 00000002 ECX: 00000000 EDX: 00000002
[    0.000000] ESI: 000000d5 EDI: c184e280 EBP: c183ffc0 ESP: c183ffb4
[    0.000000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.000000] CR0: 8005003b CR2: 0000003a CR3: 0195b000 CR4: 000006b0
[    0.000000] Stack:
[    0.000000]  00000100 000000d5 c195c800 c183ffd0 c18eff07 c1935100 00010800 c183ffd8
[    0.000000]  c18efca0 c183ffe8 c18ec92e c1935100 00020800 c183fff8 c18ec2b4 00020800
[    0.000000]  c195c800 025e5003 00000000
[    0.000000] Call Trace:
[    0.000000]  [<c18eff07>] native_init_IRQ+0x265/0x273
[    0.000000]  [<c18efca0>] init_IRQ+0x2c/0x2e
[    0.000000]  [<c18ec92e>] start_kernel+0x1e4/0x32a
[    0.000000]  [<c18ec2b4>] i386_start_kernel+0x82/0x86
[    0.000000] Code: eb 05 bf ea ff ff ff 8b 83 c4 00 00 00 e8 f6 a3 01 00 8d 65 f4 89 f8 5b 5e 5f 5d c3 55 89 e5 57 89 d7 56 53 89 c3 e8 4b e4 ff ff <f6> 40 3a 02 89 c6 74 16 b8 2b 3e 77 c1 ba 0a 05 00 00 e8 83 60
[    0.000000] EIP: [<c107079a>] setup_irq+0xf/0x4d SS:ESP 0068:c183ffb4
[    0.000000] CR2: 000000000000003a
[    0.000000] ---[ end trace cb88537fdc8fa200 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.000000] ---[ end Kernel panic - not syncing: Attempted to kill the idle task!

The culprit is an uncoditional setting of the IRQ2 which is used as cascade IRQ
on legacy platforms. It seems we have to check if we have enough legacy IRQs
reserved before we can call setup_irq().

The proposed patch adds such check.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/x86/kernel/irqinit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 1e6cff5..44f1ed4 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -203,7 +203,7 @@ void __init native_init_IRQ(void)
 		set_intr_gate(i, interrupt[i - FIRST_EXTERNAL_VECTOR]);
 	}
 
-	if (!acpi_ioapic && !of_ioapic)
+	if (!acpi_ioapic && !of_ioapic && nr_legacy_irqs())
 		setup_irq(2, &irq2);
 
 #ifdef CONFIG_X86_32
-- 
2.0.1

