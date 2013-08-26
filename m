Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab3HZC54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 22:57:56 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:52544 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab3HZC5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 22:57:54 -0400
From: navin patidar <navinp@cdac.in>
To: gregkh@linuxfoundation.org
Cc: wfp5p@virginia.edu, viro@zeniv.linux.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navinp@cdac.in>
Subject: [PATCH] staging: rtl8192e: Remove pt_regs * irq handler parameter
Date: Mon, 26 Aug 2013 08:25:50 +0530
Message-Id: <1377485750-25515-1-git-send-email-navinp@cdac.in>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct pt_regs pointer is no longer passed as a irq handler
argument. and also remove unnecessary macros.

Signed-off-by: navin patidar <navinp@cdac.in>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c |    5 +++--
 drivers/staging/rtl8192e/rtl8192e/rtl_core.h |    6 ------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index 2b6c61c..d952a34 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -94,6 +94,7 @@ MODULE_DEVICE_TABLE(pci, rtl8192_pci_id_tbl);
 static int rtl8192_pci_probe(struct pci_dev *pdev,
 			const struct pci_device_id *id);
 static void rtl8192_pci_disconnect(struct pci_dev *pdev);
+static irqreturn_t rtl8192_interrupt(int irq, void *netdev);
 
 static struct pci_driver rtl8192_pci_driver = {
 	.name = DRV_NAME,	/* Driver name   */
@@ -1324,7 +1325,7 @@ static short rtl8192_init(struct net_device *dev)
 		    (unsigned long)dev);
 
 	rtl8192_irq_disable(dev);
-	if (request_irq(dev->irq, (void *)rtl8192_interrupt_rsl, IRQF_SHARED,
+	if (request_irq(dev->irq, rtl8192_interrupt, IRQF_SHARED,
 	    dev->name, dev)) {
 		printk(KERN_ERR "Error allocating IRQ %d", dev->irq);
 		return -1;
@@ -2704,7 +2705,7 @@ out:
 }
 
 
-irqreturn_type rtl8192_interrupt(int irq, void *netdev, struct pt_regs *regs)
+irqreturn_t rtl8192_interrupt(int irq, void *netdev)
 {
 	struct net_device *dev = (struct net_device *) netdev;
 	struct r8192_priv *priv = (struct r8192_priv *)rtllib_priv(dev);
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.h b/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
index 87d4d34..9d7cb0e 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
@@ -88,10 +88,6 @@
 	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID , \
 	.driver_data = (kernel_ulong_t)&(cfg)
 
-#define irqreturn_type irqreturn_t
-
-#define rtl8192_interrupt(x, y, z) rtl8192_interrupt_rsl(x, y)
-
 #define RTL_MAX_SCAN_SIZE 128
 
 #define RTL_RATE_MAX		30
@@ -1044,8 +1040,6 @@ void rtl8192_set_chan(struct net_device *dev, short ch);
 void check_rfctrl_gpio_timer(unsigned long data);
 
 void rtl8192_hw_wakeup_wq(void *data);
-irqreturn_type rtl8192_interrupt(int irq, void *netdev, struct pt_regs *regs);
-
 short rtl8192_pci_initdescring(struct net_device *dev);
 
 void rtl8192_cancel_deferred_work(struct r8192_priv *priv);
-- 
1.7.10.4

