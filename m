Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab3HPW01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:26:27 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:40278 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab3HPW0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:26:24 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [RFC v1 3/5] ARM: mvebu: add Armada 150 uart to lowlevel debug
Date: Fri, 16 Aug 2013 21:41:36 +0200
Message-Id: <1376682098-10580-4-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds UART0 as found on the Armada 1500 to the lowlevel debug of
mach-mvebu. Unfortunately, default register base addresses for Armada
370/XP switched from 0xd000000 to 0xf100000. So, we finally end up
in three different lowlevel setups:

 (a) Armada 1500 (possibly also Armada 1000, or MV88DE3xxx in general)
 (b) Armada 370/XP with new bootloader mapping at 0xf1000000 and
     the other Orion SoCs (Dove, Kirkwood, Orion5x, MV78xx0)
 (c) Armada 370/XP with old bootloader mapping at 0xd0000000

Now, mach-mvebu has been a Armada 370/XP-only playground for a while
but with great work of Thomas, Gregory, and the others we have moved
almost all drivers to DT. I suggest to clean-up a little and find
some meaningful names for the DEBUG_ Kconfigs.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/include/debug/mvebu.S |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/debug/mvebu.S b/arch/arm/include/debug/mvebu.S
index 6517311..ca41c02 100644
--- a/arch/arm/include/debug/mvebu.S
+++ b/arch/arm/include/debug/mvebu.S
@@ -11,19 +11,25 @@
  * published by the Free Software Foundation.
 */
 
-#ifdef CONFIG_DEBUG_MVEBU_UART_ALTERNATE
-#define ARMADA_370_XP_REGS_PHYS_BASE	0xf1000000
-#else
-#define ARMADA_370_XP_REGS_PHYS_BASE	0xd0000000
+#if defined(CONFIG_MACH_ARMADA_1500)
+#define MVEBU_REGS_PHYS_BASE	0xf7f80000
+#define MVEBU_REGS_VIRT_BASE	0xf7f80000
+#define MVEBU_UART0_OFFSET	0x00049000
+#elif defined(CONFIG_DEBUG_MVEBU_UART)
+#define MVEBU_REGS_PHYS_BASE	0xd0000000
+#define MVEBU_REGS_VIRT_BASE	0xfec00000
+#define MVEBU_UART0_OFFSET	0x00012000
+#else /* CONFIG_DEBUG_MVEBU_UART_ALTERNATE */
+#define MVEBU_REGS_PHYS_BASE	0xf1000000
+#define MVEBU_REGS_VIRT_BASE	0xfec00000
+#define MVEBU_UART0_OFFSET	0x00012000
 #endif
 
-#define ARMADA_370_XP_REGS_VIRT_BASE	0xfec00000
-
 	.macro	addruart, rp, rv, tmp
-	ldr	\rp, =ARMADA_370_XP_REGS_PHYS_BASE
-	ldr	\rv, =ARMADA_370_XP_REGS_VIRT_BASE
-	orr	\rp, \rp, #0x00012000
-	orr	\rv, \rv, #0x00012000
+	ldr	\rp, =MVEBU_REGS_PHYS_BASE
+	ldr	\rv, =MVEBU_REGS_VIRT_BASE
+	orr	\rp, \rp, #MVEBU_UART0_OFFSET
+	orr	\rv, \rv, #MVEBU_UART0_OFFSET
 	.endm
 
 #define UART_SHIFT	2
-- 
1.7.10.4

