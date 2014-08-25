Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494AbaHYUnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 16:43:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48229 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564AbaHYUm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 16:42:59 -0400
Date: Mon, 25 Aug 2014 13:42:32 -0700
From: tip-bot for Andy Shevchenko <tipbot@zytor.com>
Message-ID: <tip-a90b858cfe27a576f7e44a456af2ee432404ee8f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, jiang.liu@linux.intel.com, hpa@zytor.com,
        mingo@kernel.org, david.a.cohen@linux.intel.com, tglx@linutronix.de,
        andriy.shevchenko@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, jiang.liu@linux.intel.com,
        linux-kernel@vger.kernel.org, david.a.cohen@linux.intel.com,
        tglx@linutronix.de, andriy.shevchenko@linux.intel.com
In-Reply-To: <1405931920-12871-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1405931920-12871-1-git-send-email-andriy.shevchenko@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86:
  Fix non-PC platform kernel crash on boot due to NULL dereference
Git-Commit-ID: a90b858cfe27a576f7e44a456af2ee432404ee8f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a90b858cfe27a576f7e44a456af2ee432404ee8f
Gitweb:     http://git.kernel.org/tip/a90b858cfe27a576f7e44a456af2ee432404ee8f
Author:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
AuthorDate: Mon, 21 Jul 2014 11:38:40 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 25 Aug 2014 22:36:57 +0200

x86: Fix non-PC platform kernel crash on boot due to NULL dereference

Upstream commit:

  95d76acc7518d5 ("x86, irq: Count legacy IRQs by legacy_pic->nr_legacy_irqs instead of NR_IRQS_LEGACY")

removed reserved interrupts for the platforms that do not have a legacy IOAPIC.

Which breaks the boot on Intel MID platforms such as Medfield:

  BUG: unable to handle kernel NULL pointer dereference at 0000003a
  IP: [<c107079a>] setup_irq+0xf/0x4d [    0.000000] *pdpt = 0000000000000000 *pde = 9bbf32453167e510

The culprit is an uncoditional setting of IRQ2 which is used
as cascade IRQ on legacy platforms. It seems we have to check
if we have enough legacy IRQs reserved before we can call
setup_irq().

The fix adds such check in native_init_IRQ() and in setup_default_timer_irq().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Jiang Liu <jiang.liu@linux.intel.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Cohen <david.a.cohen@linux.intel.com>
Link: http://lkml.kernel.org/r/1405931920-12871-1-git-send-email-andriy.shevchenko@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/irqinit.c | 2 +-
 arch/x86/kernel/time.c    | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

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
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index bf7ef5c..0fa2960 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -68,6 +68,8 @@ static struct irqaction irq0  = {
 
 void __init setup_default_timer_irq(void)
 {
+	if (!nr_legacy_irqs())
+		return;
 	setup_irq(0, &irq0);
 }
 
