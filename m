Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbaGCNZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:25:33 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:61159 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760AbaGCNXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:23:07 -0400
From: Manuel Lauss <manuel.lauss@gmail.com>
To: Linux-MIPS <linux-mips@linux-mips.org>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, Manuel Lauss <manuel.lauss@gmail.com>
Subject: [RFC PATCH v2 04/11] MIPS: Alchemy: usb: use clk framework
Date: Thu,  3 Jul 2014 15:22:35 +0200
Message-Id: <1404393762-858019-5-git-send-email-manuel.lauss@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404393762-858019-1-git-send-email-manuel.lauss@gmail.com>
References: <1404393762-858019-1-git-send-email-manuel.lauss@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add use of the common clock framework to set and enable the 48MHz
clock source for the onchip OHCI and UDC blocks.

Tested on a DB1500.  (Au1200 and Au1300 use an external 48MHz crystal).

Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
---
v2: taken from initial patch #2

 arch/mips/alchemy/common/usb.c | 47 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 7 deletions(-)

diff --git a/arch/mips/alchemy/common/usb.c b/arch/mips/alchemy/common/usb.c
index d193dbe..297805a 100644
--- a/arch/mips/alchemy/common/usb.c
+++ b/arch/mips/alchemy/common/usb.c
@@ -9,6 +9,7 @@
  *
  */
 
+#include <linux/clk.h>
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/module.h>
@@ -387,10 +388,25 @@ static inline void au1200_usb_init(void)
 	udelay(1000);
 }
 
-static inline void au1000_usb_init(unsigned long rb, int reg)
+static inline int au1000_usb_init(unsigned long rb, int reg)
 {
 	void __iomem *base = (void __iomem *)KSEG1ADDR(rb + reg);
 	unsigned long r = __raw_readl(base);
+	struct clk *c;
+
+	/* 48MHz check. Don't init if no one can provide it */
+	c = clk_get(NULL, "usbh_clk");
+	if (IS_ERR(c))
+		return -ENODEV;
+	if (clk_round_rate(c, 48000000) != 48000000) {
+		clk_put(c);
+		return -ENODEV;
+	}
+	if (clk_set_rate(c, 48000000)) {
+		clk_put(c);
+		return -ENODEV;
+	}
+	clk_put(c);
 
 #if defined(__BIG_ENDIAN)
 	r |= USBHEN_BE;
@@ -400,6 +416,8 @@ static inline void au1000_usb_init(unsigned long rb, int reg)
 	__raw_writel(r, base);
 	wmb();
 	udelay(1000);
+
+	return 0;
 }
 
 
@@ -407,8 +425,15 @@ static inline void __au1xx0_ohci_control(int enable, unsigned long rb, int creg)
 {
 	void __iomem *base = (void __iomem *)KSEG1ADDR(rb);
 	unsigned long r = __raw_readl(base + creg);
+	struct clk *c = clk_get(NULL, "usbh_clk");
+
+	if (IS_ERR(c))
+		return;
 
 	if (enable) {
+		if (clk_prepare_enable(c))
+			goto out;
+
 		__raw_writel(r | USBHEN_CE, base + creg);
 		wmb();
 		udelay(1000);
@@ -423,7 +448,10 @@ static inline void __au1xx0_ohci_control(int enable, unsigned long rb, int creg)
 	} else {
 		__raw_writel(r & ~(USBHEN_CE | USBHEN_E), base + creg);
 		wmb();
+		clk_disable_unprepare(c);
 	}
+out:
+	clk_put(c);
 }
 
 static inline int au1000_usb_control(int block, int enable, unsigned long rb,
@@ -457,11 +485,11 @@ int alchemy_usb_control(int block, int enable)
 	case ALCHEMY_CPU_AU1500:
 	case ALCHEMY_CPU_AU1100:
 		ret = au1000_usb_control(block, enable,
-				AU1000_USB_OHCI_PHYS_ADDR, AU1000_OHCICFG);
+			AU1000_USB_OHCI_PHYS_ADDR, AU1000_OHCICFG);
 		break;
 	case ALCHEMY_CPU_AU1550:
 		ret = au1000_usb_control(block, enable,
-				AU1550_USB_OHCI_PHYS_ADDR, AU1550_OHCICFG);
+			AU1550_USB_OHCI_PHYS_ADDR, AU1550_OHCICFG);
 		break;
 	case ALCHEMY_CPU_AU1200:
 		ret = au1200_usb_control(block, enable);
@@ -569,14 +597,18 @@ static struct syscore_ops alchemy_usb_pm_ops = {
 
 static int __init alchemy_usb_init(void)
 {
+	int ret = 0;
+
 	switch (alchemy_get_cputype()) {
 	case ALCHEMY_CPU_AU1000:
 	case ALCHEMY_CPU_AU1500:
 	case ALCHEMY_CPU_AU1100:
-		au1000_usb_init(AU1000_USB_OHCI_PHYS_ADDR, AU1000_OHCICFG);
+		ret = au1000_usb_init(AU1000_USB_OHCI_PHYS_ADDR,
+				      AU1000_OHCICFG);
 		break;
 	case ALCHEMY_CPU_AU1550:
-		au1000_usb_init(AU1550_USB_OHCI_PHYS_ADDR, AU1550_OHCICFG);
+		ret = au1000_usb_init(AU1550_USB_OHCI_PHYS_ADDR,
+				      AU1550_OHCICFG);
 		break;
 	case ALCHEMY_CPU_AU1200:
 		au1200_usb_init();
@@ -586,8 +618,9 @@ static int __init alchemy_usb_init(void)
 		break;
 	}
 
-	register_syscore_ops(&alchemy_usb_pm_ops);
+	if (!ret)
+		register_syscore_ops(&alchemy_usb_pm_ops);
 
-	return 0;
+	return ret;
 }
 arch_initcall(alchemy_usb_init);
-- 
2.0.0

