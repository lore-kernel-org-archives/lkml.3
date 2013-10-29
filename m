Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab3J2WsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 18:48:20 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:51905 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3J2WsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 18:48:18 -0400
From: Robert Richter <rric@kernel.org>
To: linux-edac@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH] edac, highbank: Moving error injection to sysfs for edac
Date: Tue, 29 Oct 2013 23:47:53 +0100
Message-Id: <1383086873-13357-1-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

Always have the error injection i/f available, even if there is no
debugfs or EDAC_DEBUG enabled. We need this for testing production
kernels and environments.

Thus, the entry moves from:

 /sys/kernel/debug/edac/mc0/inject_ctrl

to:

 /sys/devices/system/edac/mc/mc0/inject_ctrl

No other changes of the interface.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 drivers/edac/highbank_mc_edac.c | 55 +++++++++++++++--------------------------
 1 file changed, 20 insertions(+), 35 deletions(-)

diff --git a/drivers/edac/highbank_mc_edac.c b/drivers/edac/highbank_mc_edac.c
index 8221191..f784de1 100644
--- a/drivers/edac/highbank_mc_edac.c
+++ b/drivers/edac/highbank_mc_edac.c
@@ -95,50 +95,34 @@ static irqreturn_t highbank_mc_err_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-#ifdef CONFIG_EDAC_DEBUG
-static ssize_t highbank_mc_err_inject_write(struct file *file,
-				      const char __user *data,
-				      size_t count, loff_t *ppos)
+static void highbank_mc_err_inject(struct mem_ctl_info *mci, u8 synd)
 {
-	struct mem_ctl_info *mci = file->private_data;
 	struct hb_mc_drvdata *pdata = mci->pvt_info;
-	char buf[32];
-	size_t buf_size;
 	u32 reg;
+
+	reg = readl(pdata->mc_err_base + HB_DDR_ECC_OPT);
+	reg &= HB_DDR_ECC_OPT_MODE_MASK;
+	reg |= (synd << HB_DDR_ECC_OPT_XOR_SHIFT) | HB_DDR_ECC_OPT_FWC;
+	writel(reg, pdata->mc_err_base + HB_DDR_ECC_OPT);
+}
+
+#define to_mci(k) container_of(k, struct mem_ctl_info, dev)
+
+static ssize_t highbank_mc_inject_ctrl(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct mem_ctl_info *mci = to_mci(dev);
 	u8 synd;
 
-	buf_size = min(count, (sizeof(buf)-1));
-	if (copy_from_user(buf, data, buf_size))
-		return -EFAULT;
-	buf[buf_size] = 0;
+	if (kstrtou8(buf, 16, &synd))
+		return -EINVAL;
 
-	if (!kstrtou8(buf, 16, &synd)) {
-		reg = readl(pdata->mc_err_base + HB_DDR_ECC_OPT);
-		reg &= HB_DDR_ECC_OPT_MODE_MASK;
-		reg |= (synd << HB_DDR_ECC_OPT_XOR_SHIFT) | HB_DDR_ECC_OPT_FWC;
-		writel(reg, pdata->mc_err_base + HB_DDR_ECC_OPT);
-	}
+	highbank_mc_err_inject(mci, synd);
 
 	return count;
 }
 
-static const struct file_operations highbank_mc_debug_inject_fops = {
-	.open = simple_open,
-	.write = highbank_mc_err_inject_write,
-	.llseek = generic_file_llseek,
-};
-
-static void highbank_mc_create_debugfs_nodes(struct mem_ctl_info *mci)
-{
-	if (mci->debugfs)
-		debugfs_create_file("inject_ctrl", S_IWUSR, mci->debugfs, mci,
-				    &highbank_mc_debug_inject_fops);
-;
-}
-#else
-static void highbank_mc_create_debugfs_nodes(struct mem_ctl_info *mci)
-{}
-#endif
+static DEVICE_ATTR(inject_ctrl, S_IWUSR, NULL, highbank_mc_inject_ctrl);
 
 struct hb_mc_settings {
 	int	err_offset;
@@ -259,7 +243,7 @@ static int highbank_mc_probe(struct platform_device *pdev)
 		goto err2;
 	}
 
-	highbank_mc_create_debugfs_nodes(mci);
+	device_create_file(&mci->dev, &dev_attr_inject_ctrl);
 
 	devres_close_group(&pdev->dev, NULL);
 	return 0;
@@ -275,6 +259,7 @@ static int highbank_mc_remove(struct platform_device *pdev)
 {
 	struct mem_ctl_info *mci = platform_get_drvdata(pdev);
 
+	device_remove_file(&mci->dev, &dev_attr_inject_ctrl);
 	edac_mc_del_mc(&pdev->dev);
 	edac_mc_free(mci);
 	return 0;
-- 
1.8.4.rc3

