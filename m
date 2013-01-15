Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab3AOM7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:59:50 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:47488 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab3AOM4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:56:53 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        John Beckett <john.beckett@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 15/26] mfd: ab8500-debugfs: Export all AB8500 ADCs as debugfs nodes
Date: Tue, 15 Jan 2013 12:55:55 +0000
Message-Id: <1358254566-12419-16-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Beckett <john.beckett@stericsson.com>

Allow a user to take a glimpse into the inner workings of the
AB8500 Analogue-to-Digital Converters, via debugfs.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: John Beckett <john.beckett@stericsson.com>
Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
---
 drivers/mfd/ab8500-debugfs.c |  486 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 465 insertions(+), 21 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 7698d30..aedbcb0 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -82,7 +82,7 @@
 #include <linux/slab.h>
 
 #include <linux/mfd/abx500.h>
-#include <linux/mfd/abx500/ab8500.h>
+#include <linux/mfd/abx500/ab8500-gpadc.h>
 
 #ifdef CONFIG_DEBUG_FS
 #include <linux/string.h>
@@ -143,6 +143,7 @@ static struct hwreg_cfg hwreg_cfg = {
 };
 
 #define AB8500_NAME_STRING "ab8500"
+#define AB8500_ADC_NAME_STRING "gpadc"
 #define AB8500_NUM_BANKS 22
 
 #define AB8500_REV_REG 0x80
@@ -672,6 +673,382 @@ static int ab8500_hwreg_open(struct inode *inode, struct file *file)
 	return single_open(file, ab8500_hwreg_print, inode->i_private);
 }
 
+static int ab8500_gpadc_bat_ctrl_print(struct seq_file *s, void *p)
+{
+	int bat_ctrl_raw;
+	int bat_ctrl_convert;
+	struct ab8500_gpadc *gpadc;
+
+	gpadc = ab8500_gpadc_get();
+	bat_ctrl_raw = ab8500_gpadc_read_raw(gpadc, BAT_CTRL);
+	bat_ctrl_convert = ab8500_gpadc_ad_to_voltage(gpadc,
+			BAT_CTRL, bat_ctrl_raw);
+
+	return seq_printf(s, "%d,0x%X\n",
+			bat_ctrl_convert, bat_ctrl_raw);
+}
+
+static int ab8500_gpadc_bat_ctrl_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab8500_gpadc_bat_ctrl_print, inode->i_private);
+}
+
+static const struct file_operations ab8500_gpadc_bat_ctrl_fops = {
+	.open = ab8500_gpadc_bat_ctrl_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_gpadc_btemp_ball_print(struct seq_file *s, void *p)
+{
+	int btemp_ball_raw;
+	int btemp_ball_convert;
+	struct ab8500_gpadc *gpadc;
+
+	gpadc = ab8500_gpadc_get();
+	btemp_ball_raw = ab8500_gpadc_read_raw(gpadc, BTEMP_BALL);
+	btemp_ball_convert = ab8500_gpadc_ad_to_voltage(gpadc, BTEMP_BALL,
+			btemp_ball_raw);
+
+	return seq_printf(s,
+			"%d,0x%X\n", btemp_ball_convert, btemp_ball_raw);
+}
+
+static int ab8500_gpadc_btemp_ball_open(struct inode *inode,
+		struct file *file)
+{
+	return single_open(file, ab8500_gpadc_btemp_ball_print, inode->i_private);
+}
+
+static const struct file_operations ab8500_gpadc_btemp_ball_fops = {
+	.open = ab8500_gpadc_btemp_ball_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_gpadc_main_charger_v_print(struct seq_file *s, void *p)
+{
+	int main_charger_v_raw;
+	int main_charger_v_convert;
+	struct ab8500_gpadc *gpadc;
+
+	gpadc = ab8500_gpadc_get();
+	main_charger_v_raw = ab8500_gpadc_read_raw(gpadc, MAIN_CHARGER_V);
+	main_charger_v_convert = ab8500_gpadc_ad_to_voltage(gpadc,
+			MAIN_CHARGER_V, main_charger_v_raw);
+
+	return seq_printf(s, "%d,0x%X\n",
+			main_charger_v_convert, main_charger_v_raw);
+}
+
+static int ab8500_gpadc_main_charger_v_open(struct inode *inode,
+		struct file *file)
+{
+	return single_open(file, ab8500_gpadc_main_charger_v_print,
+			inode->i_private);
+}
+
+static const struct file_operations ab8500_gpadc_main_charger_v_fops = {
+	.open = ab8500_gpadc_main_charger_v_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_gpadc_acc_detect1_print(struct seq_file *s, void *p)
+{
+	int acc_detect1_raw;
+	int acc_detect1_convert;
+	struct ab8500_gpadc *gpadc;
+
+	gpadc = ab8500_gpadc_get();
+	acc_detect1_raw = ab8500_gpadc_read_raw(gpadc, ACC_DETECT1);
+	acc_detect1_convert = ab8500_gpadc_ad_to_voltage(gpadc, ACC_DETECT1,
+			acc_detect1_raw);
+
+	return seq_printf(s, "%d,0x%X\n",
+			acc_detect1_convert, acc_detect1_raw);
+}
+
+static int ab8500_gpadc_acc_detect1_open(struct inode *inode,
+		struct file *file)
+{
+	return single_open(file, ab8500_gpadc_acc_detect1_print,
+			inode->i_private);
+}
+
+static const struct file_operations ab8500_gpadc_acc_detect1_fops = {
+	.open = ab8500_gpadc_acc_detect1_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_gpadc_acc_detect2_print(struct seq_file *s, void *p)
+{
+	int acc_detect2_raw;
+	int acc_detect2_convert;
+	struct ab8500_gpadc *gpadc;
+
+	gpadc = ab8500_gpadc_get();
+	acc_detect2_raw = ab8500_gpadc_read_raw(gpadc, ACC_DETECT2);
+	acc_detect2_convert = ab8500_gpadc_ad_to_voltage(gpadc,
+	    ACC_DETECT2, acc_detect2_raw);
+
+	return seq_printf(s, "%d,0x%X\n",
+			acc_detect2_convert, acc_detect2_raw);
+}
+
+static int ab8500_gpadc_acc_detect2_open(struct inode *inode,
+		struct file *file)
+{
+	return single_open(file, ab8500_gpadc_acc_detect2_print,
+	    inode->i_private);
+}
+
+static const struct file_operations ab8500_gpadc_acc_detect2_fops = {
+	.open = ab8500_gpadc_acc_detect2_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_gpadc_aux1_print(struct seq_file *s, void *p)
+{
+	int aux1_raw;
+	int aux1_convert;
+	struct ab8500_gpadc *gpadc;
+
+	gpadc = ab8500_gpadc_get();
+	aux1_raw = ab8500_gpadc_read_raw(gpadc, ADC_AUX1);
+	aux1_convert = ab8500_gpadc_ad_to_voltage(gpadc, ADC_AUX1,
+			aux1_raw);
+
+	return seq_printf(s, "%d,0x%X\n",
+			aux1_convert, aux1_raw);
+}
+
+static int ab8500_gpadc_aux1_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab8500_gpadc_aux1_print, inode->i_private);
+}
+
+static const struct file_operations ab8500_gpadc_aux1_fops = {
+	.open = ab8500_gpadc_aux1_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_gpadc_aux2_print(struct seq_file *s, void *p)
+{
+	int aux2_raw;
+	int aux2_convert;
+	struct ab8500_gpadc *gpadc;
+
+	gpadc = ab8500_gpadc_get();
+	aux2_raw = ab8500_gpadc_read_raw(gpadc, ADC_AUX2);
+	aux2_convert = ab8500_gpadc_ad_to_voltage(gpadc, ADC_AUX2,
+			aux2_raw);
+
+	return seq_printf(s, "%d,0x%X\n",
+			aux2_convert, aux2_raw);
+}
+
+static int ab8500_gpadc_aux2_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab8500_gpadc_aux2_print, inode->i_private);
+}
+
+static const struct file_operations ab8500_gpadc_aux2_fops = {
+	.open = ab8500_gpadc_aux2_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_gpadc_main_bat_v_print(struct seq_file *s, void *p)
+{
+	int main_bat_v_raw;
+	int main_bat_v_convert;
+	struct ab8500_gpadc *gpadc;
+
+	gpadc = ab8500_gpadc_get();
+	main_bat_v_raw = ab8500_gpadc_read_raw(gpadc, MAIN_BAT_V);
+	main_bat_v_convert = ab8500_gpadc_ad_to_voltage(gpadc, MAIN_BAT_V,
+			main_bat_v_raw);
+
+	return seq_printf(s, "%d,0x%X\n",
+			main_bat_v_convert, main_bat_v_raw);
+}
+
+static int ab8500_gpadc_main_bat_v_open(struct inode *inode,
+		struct file *file)
+{
+	return single_open(file, ab8500_gpadc_main_bat_v_print, inode->i_private);
+}
+
+static const struct file_operations ab8500_gpadc_main_bat_v_fops = {
+	.open = ab8500_gpadc_main_bat_v_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_gpadc_vbus_v_print(struct seq_file *s, void *p)
+{
+	int vbus_v_raw;
+	int vbus_v_convert;
+	struct ab8500_gpadc *gpadc;
+
+	gpadc = ab8500_gpadc_get();
+	vbus_v_raw = ab8500_gpadc_read_raw(gpadc, VBUS_V);
+	vbus_v_convert = ab8500_gpadc_ad_to_voltage(gpadc, VBUS_V,
+			vbus_v_raw);
+
+	return seq_printf(s, "%d,0x%X\n",
+			vbus_v_convert, vbus_v_raw);
+}
+
+static int ab8500_gpadc_vbus_v_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab8500_gpadc_vbus_v_print, inode->i_private);
+}
+
+static const struct file_operations ab8500_gpadc_vbus_v_fops = {
+	.open = ab8500_gpadc_vbus_v_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_gpadc_main_charger_c_print(struct seq_file *s, void *p)
+{
+	int main_charger_c_raw;
+	int main_charger_c_convert;
+	struct ab8500_gpadc *gpadc;
+
+	gpadc = ab8500_gpadc_get();
+	main_charger_c_raw = ab8500_gpadc_read_raw(gpadc, MAIN_CHARGER_C);
+	main_charger_c_convert = ab8500_gpadc_ad_to_voltage(gpadc,
+			MAIN_CHARGER_C, main_charger_c_raw);
+
+	return seq_printf(s, "%d,0x%X\n",
+			main_charger_c_convert, main_charger_c_raw);
+}
+
+static int ab8500_gpadc_main_charger_c_open(struct inode *inode,
+		struct file *file)
+{
+	return single_open(file, ab8500_gpadc_main_charger_c_print,
+			inode->i_private);
+}
+
+static const struct file_operations ab8500_gpadc_main_charger_c_fops = {
+	.open = ab8500_gpadc_main_charger_c_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_gpadc_usb_charger_c_print(struct seq_file *s, void *p)
+{
+	int usb_charger_c_raw;
+	int usb_charger_c_convert;
+	struct ab8500_gpadc *gpadc;
+
+	gpadc = ab8500_gpadc_get();
+	usb_charger_c_raw = ab8500_gpadc_read_raw(gpadc, USB_CHARGER_C);
+	usb_charger_c_convert = ab8500_gpadc_ad_to_voltage(gpadc,
+	    USB_CHARGER_C, usb_charger_c_raw);
+
+	return seq_printf(s, "%d,0x%X\n",
+			usb_charger_c_convert, usb_charger_c_raw);
+}
+
+static int ab8500_gpadc_usb_charger_c_open(struct inode *inode,
+		struct file *file)
+{
+	return single_open(file, ab8500_gpadc_usb_charger_c_print,
+	    inode->i_private);
+}
+
+static const struct file_operations ab8500_gpadc_usb_charger_c_fops = {
+	.open = ab8500_gpadc_usb_charger_c_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_gpadc_bk_bat_v_print(struct seq_file *s, void *p)
+{
+	int bk_bat_v_raw;
+	int bk_bat_v_convert;
+	struct ab8500_gpadc *gpadc;
+
+	gpadc = ab8500_gpadc_get();
+	bk_bat_v_raw = ab8500_gpadc_read_raw(gpadc, BK_BAT_V);
+	bk_bat_v_convert = ab8500_gpadc_ad_to_voltage(gpadc,
+			BK_BAT_V, bk_bat_v_raw);
+
+	return seq_printf(s, "%d,0x%X\n",
+			bk_bat_v_convert, bk_bat_v_raw);
+}
+
+static int ab8500_gpadc_bk_bat_v_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab8500_gpadc_bk_bat_v_print, inode->i_private);
+}
+
+static const struct file_operations ab8500_gpadc_bk_bat_v_fops = {
+	.open = ab8500_gpadc_bk_bat_v_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_gpadc_die_temp_print(struct seq_file *s, void *p)
+{
+	int die_temp_raw;
+	int die_temp_convert;
+	struct ab8500_gpadc *gpadc;
+
+	gpadc = ab8500_gpadc_get();
+	die_temp_raw = ab8500_gpadc_read_raw(gpadc, DIE_TEMP);
+	die_temp_convert = ab8500_gpadc_ad_to_voltage(gpadc, DIE_TEMP,
+			die_temp_raw);
+
+	return seq_printf(s, "%d,0x%X\n",
+			die_temp_convert, die_temp_raw);
+}
+
+static int ab8500_gpadc_die_temp_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab8500_gpadc_die_temp_print, inode->i_private);
+}
+
+static const struct file_operations ab8500_gpadc_die_temp_fops = {
+	.open = ab8500_gpadc_die_temp_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 /*
  * return length of an ASCII numerical value, 0 is string is not a
  * numerical value.
@@ -1040,6 +1417,7 @@ static const struct file_operations ab8500_hwreg_fops = {
 };
 
 static struct dentry *ab8500_dir;
+static struct dentry *ab8500_gpadc_dir;
 
 static int __devinit ab8500_debug_probe(struct platform_device *plf)
 {
@@ -1050,14 +1428,14 @@ static int __devinit ab8500_debug_probe(struct platform_device *plf)
 	irq_first = platform_get_irq_byname(plf, "IRQ_FIRST");
 	if (irq_first < 0) {
 		dev_err(&plf->dev, "First irq not found, err %d\n",
-			irq_first);
+				irq_first);
 		return irq_first;
 	}
 
 	irq_last = platform_get_irq_byname(plf, "IRQ_LAST");
 	if (irq_last < 0) {
 		dev_err(&plf->dev, "Last irq not found, err %d\n",
-			irq_last);
+				irq_last);
 		return irq_last;
 	}
 
@@ -1065,42 +1443,108 @@ static int __devinit ab8500_debug_probe(struct platform_device *plf)
 	if (!ab8500_dir)
 		goto err;
 
-	file = debugfs_create_file("all-bank-registers",
-		S_IRUGO, ab8500_dir, &plf->dev, &ab8500_registers_fops);
+	ab8500_gpadc_dir = debugfs_create_dir(AB8500_ADC_NAME_STRING,
+	    ab8500_dir);
+	if (!ab8500_gpadc_dir)
+		goto err;
+
+	file = debugfs_create_file("all-bank-registers", S_IRUGO,
+	    ab8500_dir, &plf->dev, &ab8500_registers_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("register-bank", (S_IRUGO | S_IWUSR),
+	    ab8500_dir, &plf->dev, &ab8500_bank_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("register-address", (S_IRUGO | S_IWUSR),
+	    ab8500_dir, &plf->dev, &ab8500_address_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("register-value", (S_IRUGO | S_IWUSR),
+	    ab8500_dir, &plf->dev, &ab8500_val_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("irq-subscribe", (S_IRUGO | S_IWUSR),
+	    ab8500_dir, &plf->dev, &ab8500_subscribe_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("irq-unsubscribe", (S_IRUGO | S_IWUSR),
+	    ab8500_dir, &plf->dev, &ab8500_unsubscribe_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("hwreg", (S_IRUGO | S_IWUSR),
+	    ab8500_dir, &plf->dev, &ab8500_hwreg_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("bat_ctrl", (S_IRUGO | S_IWUSR),
+	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_bat_ctrl_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("btemp_ball", (S_IRUGO | S_IWUSR),
+	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_btemp_ball_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("main_charger_v", (S_IRUGO | S_IWUSR),
+	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_main_charger_v_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("acc_detect1", (S_IRUGO | S_IWUSR),
+	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_acc_detect1_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("acc_detect2", (S_IRUGO | S_IWUSR),
+	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_acc_detect2_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("adc_aux1", (S_IRUGO | S_IWUSR),
+	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_aux1_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("adc_aux2", (S_IRUGO | S_IWUSR),
+	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_aux2_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("register-bank",
-		(S_IRUGO | S_IWUSR), ab8500_dir, &plf->dev, &ab8500_bank_fops);
+	file = debugfs_create_file("main_bat_v", (S_IRUGO | S_IWUSR),
+	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_main_bat_v_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("register-address",
-		(S_IRUGO | S_IWUSR), ab8500_dir, &plf->dev,
-		&ab8500_address_fops);
+	file = debugfs_create_file("vbus_v", (S_IRUGO | S_IWUSR),
+	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_vbus_v_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("register-value",
-		(S_IRUGO | S_IWUSR), ab8500_dir, &plf->dev, &ab8500_val_fops);
+	file = debugfs_create_file("main_charger_c", (S_IRUGO | S_IWUSR),
+	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_main_charger_c_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("irq-subscribe",
-		(S_IRUGO | S_IWUSR), ab8500_dir, &plf->dev,
-		&ab8500_subscribe_fops);
+	file = debugfs_create_file("usb_charger_c", (S_IRUGO | S_IWUSR),
+	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_usb_charger_c_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("irq-unsubscribe",
-		(S_IRUGO | S_IWUSR), ab8500_dir, &plf->dev,
-		&ab8500_unsubscribe_fops);
+	file = debugfs_create_file("bk_bat_v", (S_IRUGO | S_IWUSR),
+	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_bk_bat_v_fops);
 	if (!file)
 		goto err;
 
-	file = debugfs_create_file("hwreg",
-		(S_IRUGO | S_IWUSR), ab8500_dir, &plf->dev,
-		&ab8500_hwreg_fops);
+	file = debugfs_create_file("die_temp", (S_IRUGO | S_IWUSR),
+	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_die_temp_fops);
 	if (!file)
 		goto err;
 
-- 
1.7.9.5

