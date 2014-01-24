Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaAXUCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 15:02:25 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:61777 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbaAXUCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 15:02:23 -0500
From: minyard@acm.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 4/4] ipmi: Cleanup error return
Date: Fri, 24 Jan 2014 14:00:53 -0600
Message-Id: <1390593653-5408-5-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1390593653-5408-1-git-send-email-minyard@acm.org>
References: <1390593653-5408-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

Return proper errors for a lot of IPMI failure cases.  Also call
pci_disable_device when IPMI PCI devices are removed.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_si_intf.c | 44 ++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index a5e048f..671c385 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1849,11 +1849,15 @@ static int hotmod_handler(const char *val, struct kernel_param *kp)
 				info->irq_setup = std_irq_setup;
 			info->slave_addr = ipmb;
 
-			if (!add_smi(info)) {
-				if (try_smi_init(info))
-					cleanup_one_si(info);
-			} else {
+			rv = add_smi(info);
+			if (rv) {
 				kfree(info);
+				goto out;
+			}
+			rv = try_smi_init(info);
+			if (rv) {
+				cleanup_one_si(info);
+				goto out;
 			}
 		} else {
 			/* remove */
@@ -2067,6 +2071,7 @@ struct SPMITable {
 static int try_init_spmi(struct SPMITable *spmi)
 {
 	struct smi_info  *info;
+	int rv;
 
 	if (spmi->IPMIlegacy != 1) {
 		printk(KERN_INFO PFX "Bad SPMI legacy %d\n", spmi->IPMIlegacy);
@@ -2141,10 +2146,11 @@ static int try_init_spmi(struct SPMITable *spmi)
 		 info->io.addr_data, info->io.regsize, info->io.regspacing,
 		 info->irq);
 
-	if (add_smi(info))
+	rv = add_smi(info);
+	if (rv)
 		kfree(info);
 
-	return 0;
+	return rv;
 }
 
 static void spmi_find_bmc(void)
@@ -2178,6 +2184,7 @@ static int ipmi_pnp_probe(struct pnp_dev *dev,
 	acpi_handle handle;
 	acpi_status status;
 	unsigned long long tmp;
+	int rv;
 
 	acpi_dev = pnp_acpi_device(dev);
 	if (!acpi_dev)
@@ -2259,10 +2266,11 @@ static int ipmi_pnp_probe(struct pnp_dev *dev,
 		 res, info->io.regsize, info->io.regspacing,
 		 info->irq);
 
-	if (add_smi(info))
-		goto err_free;
+	rv = add_smi(info);
+	if (rv)
+		kfree(info);
 
-	return 0;
+	return rv;
 
 err_free:
 	kfree(info);
@@ -2566,16 +2574,20 @@ static int ipmi_pci_probe(struct pci_dev *pdev,
 		&pdev->resource[0], info->io.regsize, info->io.regspacing,
 		info->irq);
 
-	if (add_smi(info))
+	rv = add_smi(info);
+	if (rv) {
 		kfree(info);
+		pci_disable_device(pdev);
+	}
 
-	return 0;
+	return rv;
 }
 
 static void ipmi_pci_remove(struct pci_dev *pdev)
 {
 	struct smi_info *info = pci_get_drvdata(pdev);
 	cleanup_one_si(info);
+	pci_disable_device(pdev);
 }
 
 static struct pci_device_id ipmi_pci_devices[] = {
@@ -2670,9 +2682,10 @@ static int ipmi_probe(struct platform_device *dev)
 
 	dev_set_drvdata(&dev->dev, info);
 
-	if (add_smi(info)) {
+	ret = add_smi(info);
+	if (ret) {
 		kfree(info);
-		return -EBUSY;
+		return ret;
 	}
 #endif
 	return 0;
@@ -2736,9 +2749,10 @@ static int ipmi_parisc_probe(struct parisc_device *dev)
 
 	dev_set_drvdata(&dev->dev, info);
 
-	if (add_smi(info)) {
+	rv = add_smi(info);
+	if (rv) {
 		kfree(info);
-		return -EBUSY;
+		return rv;
 	}
 
 	return 0;
-- 
1.8.3.1

