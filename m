Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161744Ab3BOM5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:57:37 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:35123 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161715Ab3BOM5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:57:30 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Michel JAOUEN <michel.jaouen@stericsson.com>,
        "M'boumba Cedric Madianga" <cedric.madianga@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/35] mfd: ab8500-gpadc: Add gpadc hw conversion
Date: Fri, 15 Feb 2013 12:56:35 +0000
Message-Id: <1360933026-30325-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel JAOUEN <michel.jaouen@stericsson.com>

Add the support of gpacd hw conversion and make the number of
sample configurable.

Signed-off-by: M'boumba Cedric Madianga <cedric.madianga@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
Tested-by: Michel JAOUEN <michel.jaouen@stericsson.com>
---
 drivers/mfd/ab8500-debugfs.c            |  292 ++++++++++++++++++++++++++++---
 drivers/mfd/ab8500-gpadc.c              |  282 +++++++++++++++++++++--------
 include/linux/mfd/abx500/ab8500-gpadc.h |   30 +++-
 3 files changed, 500 insertions(+), 104 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index ba25f95..8078a93 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -100,6 +100,11 @@ static int num_irqs;
 static struct device_attribute **dev_attr;
 static char **event_name;
 
+static u8 avg_sample = SAMPLE_16;
+static u8 trig_edge = RISING_EDGE;
+static u8 conv_type = ADC_SW;
+static u8 trig_timer;
+
 /**
  * struct ab8500_reg_range
  * @first: the first address of the range
@@ -807,9 +812,10 @@ static int ab8500_gpadc_bat_ctrl_print(struct seq_file *s, void *p)
 	struct ab8500_gpadc *gpadc;
 
 	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
-	bat_ctrl_raw = ab8500_gpadc_read_raw(gpadc, BAT_CTRL);
+	bat_ctrl_raw = ab8500_gpadc_read_raw(gpadc, BAT_CTRL,
+		avg_sample, trig_edge, trig_timer, conv_type);
 	bat_ctrl_convert = ab8500_gpadc_ad_to_voltage(gpadc,
-			BAT_CTRL, bat_ctrl_raw);
+		BAT_CTRL, bat_ctrl_raw);
 
 	return seq_printf(s, "%d,0x%X\n",
 			bat_ctrl_convert, bat_ctrl_raw);
@@ -835,9 +841,10 @@ static int ab8500_gpadc_btemp_ball_print(struct seq_file *s, void *p)
 	struct ab8500_gpadc *gpadc;
 
 	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
-	btemp_ball_raw = ab8500_gpadc_read_raw(gpadc, BTEMP_BALL);
+	btemp_ball_raw = ab8500_gpadc_read_raw(gpadc, BTEMP_BALL,
+		avg_sample, trig_edge, trig_timer, conv_type);
 	btemp_ball_convert = ab8500_gpadc_ad_to_voltage(gpadc, BTEMP_BALL,
-			btemp_ball_raw);
+		btemp_ball_raw);
 
 	return seq_printf(s,
 			"%d,0x%X\n", btemp_ball_convert, btemp_ball_raw);
@@ -864,9 +871,10 @@ static int ab8500_gpadc_main_charger_v_print(struct seq_file *s, void *p)
 	struct ab8500_gpadc *gpadc;
 
 	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
-	main_charger_v_raw = ab8500_gpadc_read_raw(gpadc, MAIN_CHARGER_V);
+	main_charger_v_raw = ab8500_gpadc_read_raw(gpadc, MAIN_CHARGER_V,
+		avg_sample, trig_edge, trig_timer, conv_type);
 	main_charger_v_convert = ab8500_gpadc_ad_to_voltage(gpadc,
-			MAIN_CHARGER_V, main_charger_v_raw);
+		MAIN_CHARGER_V, main_charger_v_raw);
 
 	return seq_printf(s, "%d,0x%X\n",
 			main_charger_v_convert, main_charger_v_raw);
@@ -894,9 +902,10 @@ static int ab8500_gpadc_acc_detect1_print(struct seq_file *s, void *p)
 	struct ab8500_gpadc *gpadc;
 
 	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
-	acc_detect1_raw = ab8500_gpadc_read_raw(gpadc, ACC_DETECT1);
+	acc_detect1_raw = ab8500_gpadc_read_raw(gpadc, ACC_DETECT1,
+		avg_sample, trig_edge, trig_timer, conv_type);
 	acc_detect1_convert = ab8500_gpadc_ad_to_voltage(gpadc, ACC_DETECT1,
-			acc_detect1_raw);
+		acc_detect1_raw);
 
 	return seq_printf(s, "%d,0x%X\n",
 			acc_detect1_convert, acc_detect1_raw);
@@ -924,9 +933,10 @@ static int ab8500_gpadc_acc_detect2_print(struct seq_file *s, void *p)
 	struct ab8500_gpadc *gpadc;
 
 	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
-	acc_detect2_raw = ab8500_gpadc_read_raw(gpadc, ACC_DETECT2);
+	acc_detect2_raw = ab8500_gpadc_read_raw(gpadc, ACC_DETECT2,
+		avg_sample, trig_edge, trig_timer, conv_type);
 	acc_detect2_convert = ab8500_gpadc_ad_to_voltage(gpadc,
-	    ACC_DETECT2, acc_detect2_raw);
+		ACC_DETECT2, acc_detect2_raw);
 
 	return seq_printf(s, "%d,0x%X\n",
 			acc_detect2_convert, acc_detect2_raw);
@@ -954,9 +964,10 @@ static int ab8500_gpadc_aux1_print(struct seq_file *s, void *p)
 	struct ab8500_gpadc *gpadc;
 
 	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
-	aux1_raw = ab8500_gpadc_read_raw(gpadc, ADC_AUX1);
+	aux1_raw = ab8500_gpadc_read_raw(gpadc, ADC_AUX1,
+		avg_sample, trig_edge, trig_timer, conv_type);
 	aux1_convert = ab8500_gpadc_ad_to_voltage(gpadc, ADC_AUX1,
-			aux1_raw);
+		aux1_raw);
 
 	return seq_printf(s, "%d,0x%X\n",
 			aux1_convert, aux1_raw);
@@ -982,9 +993,10 @@ static int ab8500_gpadc_aux2_print(struct seq_file *s, void *p)
 	struct ab8500_gpadc *gpadc;
 
 	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
-	aux2_raw = ab8500_gpadc_read_raw(gpadc, ADC_AUX2);
+	aux2_raw = ab8500_gpadc_read_raw(gpadc, ADC_AUX2,
+		avg_sample, trig_edge, trig_timer, conv_type);
 	aux2_convert = ab8500_gpadc_ad_to_voltage(gpadc, ADC_AUX2,
-			aux2_raw);
+		aux2_raw);
 
 	return seq_printf(s, "%d,0x%X\n",
 			aux2_convert, aux2_raw);
@@ -1010,9 +1022,10 @@ static int ab8500_gpadc_main_bat_v_print(struct seq_file *s, void *p)
 	struct ab8500_gpadc *gpadc;
 
 	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
-	main_bat_v_raw = ab8500_gpadc_read_raw(gpadc, MAIN_BAT_V);
+	main_bat_v_raw = ab8500_gpadc_read_raw(gpadc, MAIN_BAT_V,
+		avg_sample, trig_edge, trig_timer, conv_type);
 	main_bat_v_convert = ab8500_gpadc_ad_to_voltage(gpadc, MAIN_BAT_V,
-			main_bat_v_raw);
+		main_bat_v_raw);
 
 	return seq_printf(s, "%d,0x%X\n",
 			main_bat_v_convert, main_bat_v_raw);
@@ -1039,9 +1052,10 @@ static int ab8500_gpadc_vbus_v_print(struct seq_file *s, void *p)
 	struct ab8500_gpadc *gpadc;
 
 	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
-	vbus_v_raw = ab8500_gpadc_read_raw(gpadc, VBUS_V);
+	vbus_v_raw =  ab8500_gpadc_read_raw(gpadc, VBUS_V,
+		avg_sample, trig_edge, trig_timer, conv_type);
 	vbus_v_convert = ab8500_gpadc_ad_to_voltage(gpadc, VBUS_V,
-			vbus_v_raw);
+		vbus_v_raw);
 
 	return seq_printf(s, "%d,0x%X\n",
 			vbus_v_convert, vbus_v_raw);
@@ -1067,9 +1081,10 @@ static int ab8500_gpadc_main_charger_c_print(struct seq_file *s, void *p)
 	struct ab8500_gpadc *gpadc;
 
 	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
-	main_charger_c_raw = ab8500_gpadc_read_raw(gpadc, MAIN_CHARGER_C);
+	main_charger_c_raw = ab8500_gpadc_read_raw(gpadc, MAIN_CHARGER_C,
+		avg_sample, trig_edge, trig_timer, conv_type);
 	main_charger_c_convert = ab8500_gpadc_ad_to_voltage(gpadc,
-			MAIN_CHARGER_C, main_charger_c_raw);
+		MAIN_CHARGER_C, main_charger_c_raw);
 
 	return seq_printf(s, "%d,0x%X\n",
 			main_charger_c_convert, main_charger_c_raw);
@@ -1097,9 +1112,10 @@ static int ab8500_gpadc_usb_charger_c_print(struct seq_file *s, void *p)
 	struct ab8500_gpadc *gpadc;
 
 	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
-	usb_charger_c_raw = ab8500_gpadc_read_raw(gpadc, USB_CHARGER_C);
+	usb_charger_c_raw = ab8500_gpadc_read_raw(gpadc, USB_CHARGER_C,
+		avg_sample, trig_edge, trig_timer, conv_type);
 	usb_charger_c_convert = ab8500_gpadc_ad_to_voltage(gpadc,
-	    USB_CHARGER_C, usb_charger_c_raw);
+		USB_CHARGER_C, usb_charger_c_raw);
 
 	return seq_printf(s, "%d,0x%X\n",
 			usb_charger_c_convert, usb_charger_c_raw);
@@ -1127,9 +1143,10 @@ static int ab8500_gpadc_bk_bat_v_print(struct seq_file *s, void *p)
 	struct ab8500_gpadc *gpadc;
 
 	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
-	bk_bat_v_raw = ab8500_gpadc_read_raw(gpadc, BK_BAT_V);
+	bk_bat_v_raw = ab8500_gpadc_read_raw(gpadc, BK_BAT_V,
+		avg_sample, trig_edge, trig_timer, conv_type);
 	bk_bat_v_convert = ab8500_gpadc_ad_to_voltage(gpadc,
-			BK_BAT_V, bk_bat_v_raw);
+		BK_BAT_V, bk_bat_v_raw);
 
 	return seq_printf(s, "%d,0x%X\n",
 			bk_bat_v_convert, bk_bat_v_raw);
@@ -1155,9 +1172,10 @@ static int ab8500_gpadc_die_temp_print(struct seq_file *s, void *p)
 	struct ab8500_gpadc *gpadc;
 
 	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
-	die_temp_raw = ab8500_gpadc_read_raw(gpadc, DIE_TEMP);
+	die_temp_raw = ab8500_gpadc_read_raw(gpadc, DIE_TEMP,
+		avg_sample, trig_edge, trig_timer, conv_type);
 	die_temp_convert = ab8500_gpadc_ad_to_voltage(gpadc, DIE_TEMP,
-			die_temp_raw);
+		die_temp_raw);
 
 	return seq_printf(s, "%d,0x%X\n",
 			die_temp_convert, die_temp_raw);
@@ -1176,6 +1194,208 @@ static const struct file_operations ab8500_gpadc_die_temp_fops = {
 	.owner = THIS_MODULE,
 };
 
+static int ab8500_gpadc_avg_sample_print(struct seq_file *s, void *p)
+{
+	return seq_printf(s, "%d\n", avg_sample);
+}
+
+static int ab8500_gpadc_avg_sample_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab8500_gpadc_avg_sample_print,
+			inode->i_private);
+}
+
+static ssize_t ab8500_gpadc_avg_sample_write(struct file *file,
+	const char __user *user_buf,
+	size_t count, loff_t *ppos)
+{
+	struct device *dev = ((struct seq_file *)(file->private_data))->private;
+	char buf[32];
+	int buf_size;
+	unsigned long user_avg_sample;
+	int err;
+
+	/* Get userspace string and assure termination */
+	buf_size = min(count, (sizeof(buf) - 1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	buf[buf_size] = 0;
+
+	err = strict_strtoul(buf, 0, &user_avg_sample);
+	if (err)
+		return -EINVAL;
+	if ((user_avg_sample == SAMPLE_1) || (user_avg_sample == SAMPLE_4)
+			|| (user_avg_sample == SAMPLE_8)
+			|| (user_avg_sample == SAMPLE_16)) {
+		avg_sample = (u8) user_avg_sample;
+	} else {
+		dev_err(dev, "debugfs error input: "
+			"should be egal to 1, 4, 8 or 16\n");
+		return -EINVAL;
+	}
+	return buf_size;
+}
+
+static const struct file_operations ab8500_gpadc_avg_sample_fops = {
+	.open = ab8500_gpadc_avg_sample_open,
+	.read = seq_read,
+	.write = ab8500_gpadc_avg_sample_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_gpadc_trig_edge_print(struct seq_file *s, void *p)
+{
+	return seq_printf(s, "%d\n", trig_edge);
+}
+
+static int ab8500_gpadc_trig_edge_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab8500_gpadc_trig_edge_print,
+			inode->i_private);
+}
+
+static ssize_t ab8500_gpadc_trig_edge_write(struct file *file,
+	const char __user *user_buf,
+	size_t count, loff_t *ppos)
+{
+	struct device *dev = ((struct seq_file *)(file->private_data))->private;
+	char buf[32];
+	int buf_size;
+	unsigned long user_trig_edge;
+	int err;
+
+	/* Get userspace string and assure termination */
+	buf_size = min(count, (sizeof(buf) - 1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	buf[buf_size] = 0;
+
+	err = strict_strtoul(buf, 0, &user_trig_edge);
+	if (err)
+		return -EINVAL;
+	if ((user_trig_edge == RISING_EDGE)
+			|| (user_trig_edge == FALLING_EDGE)) {
+		trig_edge = (u8) user_trig_edge;
+	} else {
+		dev_err(dev, "Wrong input:\n"
+			"Enter 0. Rising edge\n"
+			"Enter 1. Falling edge\n");
+		return -EINVAL;
+	}
+	return buf_size;
+}
+
+static const struct file_operations ab8500_gpadc_trig_edge_fops = {
+	.open = ab8500_gpadc_trig_edge_open,
+	.read = seq_read,
+	.write = ab8500_gpadc_trig_edge_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_gpadc_trig_timer_print(struct seq_file *s, void *p)
+{
+	return seq_printf(s, "%d\n", trig_timer);
+}
+
+static int ab8500_gpadc_trig_timer_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab8500_gpadc_trig_timer_print,
+			inode->i_private);
+}
+
+static ssize_t ab8500_gpadc_trig_timer_write(struct file *file,
+	const char __user *user_buf,
+	size_t count, loff_t *ppos)
+{
+	struct device *dev = ((struct seq_file *)(file->private_data))->private;
+	char buf[32];
+	int buf_size;
+	unsigned long user_trig_timer;
+	int err;
+
+	/* Get userspace string and assure termination */
+	buf_size = min(count, (sizeof(buf) - 1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	buf[buf_size] = 0;
+
+	err = strict_strtoul(buf, 0, &user_trig_timer);
+	if (err)
+		return -EINVAL;
+	if ((user_trig_timer >= 0) && (user_trig_timer <= 255)) {
+		trig_timer = (u8) user_trig_timer;
+	} else {
+		dev_err(dev, "debugfs error input: "
+			"should be beetween 0 to 255\n");
+		return -EINVAL;
+	}
+	return buf_size;
+}
+
+static const struct file_operations ab8500_gpadc_trig_timer_fops = {
+	.open = ab8500_gpadc_trig_timer_open,
+	.read = seq_read,
+	.write = ab8500_gpadc_trig_timer_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int ab8500_gpadc_conv_type_print(struct seq_file *s, void *p)
+{
+	return seq_printf(s, "%d\n", conv_type);
+}
+
+static int ab8500_gpadc_conv_type_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab8500_gpadc_conv_type_print,
+			inode->i_private);
+}
+
+static ssize_t ab8500_gpadc_conv_type_write(struct file *file,
+	const char __user *user_buf,
+	size_t count, loff_t *ppos)
+{
+	struct device *dev = ((struct seq_file *)(file->private_data))->private;
+	char buf[32];
+	int buf_size;
+	unsigned long user_conv_type;
+	int err;
+
+	/* Get userspace string and assure termination */
+	buf_size = min(count, (sizeof(buf) - 1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	buf[buf_size] = 0;
+
+	err = strict_strtoul(buf, 0, &user_conv_type);
+	if (err)
+		return -EINVAL;
+	if ((user_conv_type == ADC_SW)
+			|| (user_conv_type == ADC_HW)) {
+		conv_type = (u8) user_conv_type;
+	} else {
+		dev_err(dev, "Wrong input:\n"
+			"Enter 0. ADC SW conversion\n"
+			"Enter 1. ADC HW conversion\n");
+		return -EINVAL;
+	}
+	return buf_size;
+}
+
+static const struct file_operations ab8500_gpadc_conv_type_fops = {
+	.open = ab8500_gpadc_conv_type_open,
+	.read = seq_read,
+	.write = ab8500_gpadc_conv_type_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 /*
  * return length of an ASCII numerical value, 0 is string is not a
  * numerical value.
@@ -1721,6 +1941,26 @@ static int ab8500_debug_probe(struct platform_device *plf)
 	if (!file)
 		goto err;
 
+	file = debugfs_create_file("avg_sample", (S_IRUGO | S_IWUGO),
+		ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_avg_sample_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("trig_edge", (S_IRUGO | S_IWUGO),
+		ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_trig_edge_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("trig_timer", (S_IRUGO | S_IWUGO),
+		ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_trig_timer_fops);
+	if (!file)
+		goto err;
+
+	file = debugfs_create_file("conv_type", (S_IRUGO | S_IWUGO),
+		ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_conv_type_fops);
+	if (!file)
+		goto err;
+
 	return 0;
 
 err:
diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index 1b48ac1..5942f2f 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -55,13 +55,18 @@
 #define EN_VTVOUT			0x02
 #define EN_GPADC			0x01
 #define DIS_GPADC			0x00
-#define SW_AVG_16			0x60
+#define AVG_1				0x00
+#define AVG_4				0x20
+#define AVG_8				0x40
+#define AVG_16				0x60
 #define ADC_SW_CONV			0x04
 #define EN_ICHAR			0x80
 #define BTEMP_PULL_UP			0x08
 #define EN_BUF				0x40
 #define DIS_ZERO			0x00
 #define GPADC_BUSY			0x01
+#define EN_FALLING			0x10
+#define EN_TRIG_EDGE			0x02
 
 /* GPADC constants from AB8500 spec, UM0836 */
 #define ADC_RESOLUTION			1024
@@ -116,7 +121,10 @@ struct adc_cal_data {
  *				the completion of gpadc conversion
  * @ab8500_gpadc_lock:		structure of type mutex
  * @regu:			pointer to the struct regulator
- * @irq:			interrupt number that is used by gpadc
+ * @irq_sw:			interrupt number that is used by gpadc for Sw
+ *				conversion
+ * @irq_hw:			interrupt number that is used by gpadc for Hw
+ *				conversion
  * @cal_data			array of ADC calibration data structs
  */
 struct ab8500_gpadc {
@@ -126,7 +134,8 @@ struct ab8500_gpadc {
 	struct completion ab8500_gpadc_complete;
 	struct mutex ab8500_gpadc_lock;
 	struct regulator *regu;
-	int irq;
+	int irq_sw;
+	int irq_hw;
 	struct adc_cal_data cal_data[NBR_CAL_INPUTS];
 };
 
@@ -247,30 +256,35 @@ int ab8500_gpadc_ad_to_voltage(struct ab8500_gpadc *gpadc, u8 channel,
 EXPORT_SYMBOL(ab8500_gpadc_ad_to_voltage);
 
 /**
- * ab8500_gpadc_convert() - gpadc conversion
+ * ab8500_gpadc_sw_hw_convert() - gpadc conversion
  * @channel:	analog channel to be converted to digital data
+ * @avg_sample:  number of ADC sample to average
+ * @trig_egde:  selected ADC trig edge
+ * @trig_timer: selected ADC trigger delay timer
+ * @conv_type: selected conversion type (HW or SW conversion)
  *
  * This function converts the selected analog i/p to digital
  * data.
  */
-int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 channel)
+int ab8500_gpadc_sw_hw_convert(struct ab8500_gpadc *gpadc, u8 channel,
+		u8 avg_sample, u8 trig_edge, u8 trig_timer, u8 conv_type)
 {
 	int ad_value;
 	int voltage;
 
-	ad_value = ab8500_gpadc_read_raw(gpadc, channel);
-
-	/* On failure retry a second time */
+	ad_value = ab8500_gpadc_read_raw(gpadc, channel, avg_sample,
+			trig_edge, trig_timer, conv_type);
+/* On failure retry a second time */
 	if (ad_value < 0)
-		ad_value = ab8500_gpadc_read_raw(gpadc, channel);
-
-	if (ad_value < 0) {
-		dev_err(gpadc->dev, "GPADC raw value failed ch: %d\n", channel);
+		ad_value = ab8500_gpadc_read_raw(gpadc, channel, avg_sample,
+			trig_edge, trig_timer, conv_type);
+if (ad_value < 0) {
+		dev_err(gpadc->dev, "GPADC raw value failed ch: %d\n",
+				channel);
 		return ad_value;
 	}
 
 	voltage = ab8500_gpadc_ad_to_voltage(gpadc, channel, ad_value);
-
 	if (voltage < 0)
 		dev_err(gpadc->dev, "GPADC to voltage conversion failed ch:"
 			" %d AD: 0x%x\n", channel, ad_value);
@@ -282,11 +296,16 @@ EXPORT_SYMBOL(ab8500_gpadc_convert);
 /**
  * ab8500_gpadc_read_raw() - gpadc read
  * @channel:	analog channel to be read
+ * @avg_sample:  number of ADC sample to average
+ * @trig_edge:  selected trig edge
+ * @trig_timer: selected ADC trigger delay timer
+ * @conv_type: selected conversion type (HW or SW conversion)
  *
- * This function obtains the raw ADC value, this then needs
- * to be converted by calling ab8500_gpadc_ad_to_voltage()
+ * This function obtains the raw ADC value for an hardware conversion,
+ * this then needs to be converted by calling ab8500_gpadc_ad_to_voltage()
  */
-int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel)
+int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel,
+		u8 avg_sample, u8 trig_edge, u8 trig_timer, u8 conv_type)
 {
 	int ret;
 	int looplimit = 0;
@@ -296,7 +315,6 @@ int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel)
 		return -ENODEV;
 
 	mutex_lock(&gpadc->ab8500_gpadc_lock);
-
 	/* Enable VTVout LDO this is required for GPADC */
 	pm_runtime_get_sync(gpadc->dev);
 
@@ -324,9 +342,29 @@ int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel)
 		goto out;
 	}
 
-	/* Select the channel source and set average samples to 16 */
-	ret = abx500_set_register_interruptible(gpadc->dev, AB8500_GPADC,
-		AB8500_GPADC_CTRL2_REG, (channel | SW_AVG_16));
+	/* Select the channel source and set average samples */
+	switch (avg_sample) {
+	case SAMPLE_1:
+		val = channel | AVG_1;
+		break;
+	case SAMPLE_4:
+		val = channel | AVG_4;
+		break;
+	case SAMPLE_8:
+		val = channel | AVG_8;
+		break;
+	default:
+		val = channel | AVG_16;
+		break;
+
+	}
+
+	if (conv_type == ADC_HW)
+		ret = abx500_set_register_interruptible(gpadc->dev,
+				AB8500_GPADC, AB8500_GPADC_CTRL3_REG, val);
+	else
+		ret = abx500_set_register_interruptible(gpadc->dev,
+				AB8500_GPADC, AB8500_GPADC_CTRL2_REG, val);
 	if (ret < 0) {
 		dev_err(gpadc->dev,
 			"gpadc_conversion: set avg samples failed\n");
@@ -338,22 +376,43 @@ int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel)
 	 * charging current sense if it needed, ABB 3.0 needs some special
 	 * treatment too.
 	 */
+	if ((conv_type == ADC_HW) && (trig_edge)) {
+		ret = abx500_mask_and_set_register_interruptible(gpadc->dev,
+			AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
+			EN_FALLING, EN_FALLING);
+
+	}
 	switch (channel) {
 	case MAIN_CHARGER_C:
 	case USB_CHARGER_C:
-		ret = abx500_mask_and_set_register_interruptible(gpadc->dev,
-			AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
-			EN_BUF | EN_ICHAR,
-			EN_BUF | EN_ICHAR);
-		break;
-	case BTEMP_BALL:
-		if (!is_ab8500_2p0_or_earlier(gpadc->parent)) {
-			/* Turn on btemp pull-up on ABB 3.0 */
+		if (conv_type == ADC_HW)
 			ret = abx500_mask_and_set_register_interruptible(
 				gpadc->dev,
 				AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
-				EN_BUF | BTEMP_PULL_UP,
-				EN_BUF | BTEMP_PULL_UP);
+				EN_BUF | EN_ICHAR | EN_TRIG_EDGE,
+				EN_BUF | EN_ICHAR | EN_TRIG_EDGE);
+		else
+			ret = abx500_mask_and_set_register_interruptible(
+				gpadc->dev,
+				AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
+				EN_BUF | EN_ICHAR,
+				EN_BUF | EN_ICHAR);
+		break;
+	case BTEMP_BALL:
+		if (!is_ab8500_2p0_or_earlier(gpadc->parent)) {
+			if (conv_type == ADC_HW)
+				/* Turn on btemp pull-up on ABB 3.0 */
+				ret = abx500_mask_and_set_register_interruptible
+					(gpadc->dev,
+					AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
+					EN_BUF | BTEMP_PULL_UP | EN_TRIG_EDGE,
+					EN_BUF | BTEMP_PULL_UP | EN_TRIG_EDGE);
+			else
+				ret = abx500_mask_and_set_register_interruptible
+					(gpadc->dev,
+					AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
+					EN_BUF | BTEMP_PULL_UP,
+					EN_BUF | BTEMP_PULL_UP);
 
 		 /*
 		  * Delay might be needed for ABB8500 cut 3.0, if not, remove
@@ -364,8 +423,17 @@ int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel)
 		}
 		/* Intentional fallthrough */
 	default:
-		ret = abx500_mask_and_set_register_interruptible(gpadc->dev,
-			AB8500_GPADC, AB8500_GPADC_CTRL1_REG, EN_BUF, EN_BUF);
+		if (conv_type == ADC_HW)
+			ret = abx500_mask_and_set_register_interruptible(
+				gpadc->dev,
+				AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
+				EN_BUF | EN_TRIG_EDGE,
+				EN_BUF | EN_TRIG_EDGE);
+		else
+			ret = abx500_mask_and_set_register_interruptible(
+				gpadc->dev,
+				AB8500_GPADC,
+				AB8500_GPADC_CTRL1_REG, EN_BUF, EN_BUF);
 		break;
 	}
 	if (ret < 0) {
@@ -374,36 +442,83 @@ int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel)
 		goto out;
 	}
 
-	ret = abx500_mask_and_set_register_interruptible(gpadc->dev,
-		AB8500_GPADC, AB8500_GPADC_CTRL1_REG, ADC_SW_CONV, ADC_SW_CONV);
-	if (ret < 0) {
-		dev_err(gpadc->dev,
-			"gpadc_conversion: start s/w conversion failed\n");
-		goto out;
+	/* Set trigger delay timer */
+	if (conv_type == ADC_HW) {
+		ret = abx500_set_register_interruptible(gpadc->dev,
+			AB8500_GPADC, AB8500_GPADC_AUTO_TIMER_REG, trig_timer);
+		if (ret < 0) {
+			dev_err(gpadc->dev,
+				"gpadc_conversion: trig timer failed\n");
+			goto out;
+		}
+	}
+
+	/* Start SW conversion */
+	if (conv_type == ADC_SW) {
+		ret = abx500_mask_and_set_register_interruptible(gpadc->dev,
+			AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
+			ADC_SW_CONV, ADC_SW_CONV);
+		if (ret < 0) {
+			dev_err(gpadc->dev,
+				"gpadc_conversion: start s/w conv failed\n");
+			goto out;
+		}
 	}
+
 	/* wait for completion of conversion */
-	if (!wait_for_completion_timeout(&gpadc->ab8500_gpadc_complete,
-					 msecs_to_jiffies(CONVERSION_TIME))) {
-		dev_err(gpadc->dev,
-			"timeout: didn't receive GPADC conversion interrupt\n");
-		ret = -EINVAL;
-		goto out;
+	if (conv_type == ADC_HW) {
+		if (!wait_for_completion_timeout(&gpadc->ab8500_gpadc_complete,
+			2*HZ)) {
+				dev_err(gpadc->dev,
+					"timeout didn't receive"
+					" hw GPADC conv interrupt\n");
+				ret = -EINVAL;
+				goto out;
+		}
+	} else {
+		if (!wait_for_completion_timeout(&gpadc->ab8500_gpadc_complete,
+			msecs_to_jiffies(CONVERSION_TIME))) {
+				dev_err(gpadc->dev,
+					"timeout didn't receive"
+					" sw GPADC conv interrupt\n");
+				ret = -EINVAL;
+				goto out;
+		}
 	}
 
 	/* Read the converted RAW data */
-	ret = abx500_get_register_interruptible(gpadc->dev, AB8500_GPADC,
-		AB8500_GPADC_MANDATAL_REG, &low_data);
-	if (ret < 0) {
-		dev_err(gpadc->dev, "gpadc_conversion: read low data failed\n");
-		goto out;
-	}
+	if (conv_type == ADC_HW) {
+		ret = abx500_get_register_interruptible(gpadc->dev,
+			AB8500_GPADC, AB8500_GPADC_AUTODATAL_REG, &low_data);
+		if (ret < 0) {
+			dev_err(gpadc->dev,
+				"gpadc_conversion: read hw low data failed\n");
+			goto out;
+		}
 
-	ret = abx500_get_register_interruptible(gpadc->dev, AB8500_GPADC,
-		AB8500_GPADC_MANDATAH_REG, &high_data);
-	if (ret < 0) {
-		dev_err(gpadc->dev,
-			"gpadc_conversion: read high data failed\n");
-		goto out;
+		ret = abx500_get_register_interruptible(gpadc->dev,
+			AB8500_GPADC, AB8500_GPADC_AUTODATAH_REG, &high_data);
+		if (ret < 0) {
+			dev_err(gpadc->dev,
+				"gpadc_conversion: read hw high data failed\n");
+			goto out;
+		}
+	} else {
+		ret = abx500_get_register_interruptible(gpadc->dev,
+			AB8500_GPADC, AB8500_GPADC_MANDATAL_REG, &low_data);
+		if (ret < 0) {
+			dev_err(gpadc->dev,
+				"gpadc_conversion: read sw low data failed\n");
+			goto out;
+		}
+
+		ret = abx500_get_register_interruptible(gpadc->dev,
+			AB8500_GPADC, AB8500_GPADC_MANDATAH_REG, &high_data);
+		if (ret < 0) {
+			dev_err(gpadc->dev,
+				"gpadc_conversion: read sw high data failed\n");
+			goto out;
+		}
 	}
 
 	/* Disable GPADC */
@@ -414,6 +529,7 @@ int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel)
 		goto out;
 	}
 
+	/* Disable VTVout LDO this is required for GPADC */
 	pm_runtime_mark_last_busy(gpadc->dev);
 	pm_runtime_put_autosuspend(gpadc->dev);
 
@@ -430,9 +546,7 @@ out:
 	 */
 	(void) abx500_set_register_interruptible(gpadc->dev, AB8500_GPADC,
 		AB8500_GPADC_CTRL1_REG, DIS_GPADC);
-
 	pm_runtime_put(gpadc->dev);
-
 	mutex_unlock(&gpadc->ab8500_gpadc_lock);
 	dev_err(gpadc->dev,
 		"gpadc_conversion: Failed to AD convert channel %d\n", channel);
@@ -441,16 +555,16 @@ out:
 EXPORT_SYMBOL(ab8500_gpadc_read_raw);
 
 /**
- * ab8500_bm_gpswadcconvend_handler() - isr for s/w gpadc conversion completion
+ * ab8500_bm_gpadcconvend_handler() - isr for gpadc conversion completion
  * @irq:	irq number
  * @data:	pointer to the data passed during request irq
  *
- * This is a interrupt service routine for s/w gpadc conversion completion.
+ * This is a interrupt service routine for gpadc conversion completion.
  * Notifies the gpadc completion is completed and the converted raw value
  * can be read from the registers.
  * Returns IRQ status(IRQ_HANDLED)
  */
-static irqreturn_t ab8500_bm_gpswadcconvend_handler(int irq, void *_gpadc)
+static irqreturn_t ab8500_bm_gpadcconvend_handler(int irq, void *_gpadc)
 {
 	struct ab8500_gpadc *gpadc = _gpadc;
 
@@ -651,11 +765,19 @@ static int ab8500_gpadc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	gpadc->irq = platform_get_irq_byname(pdev, "SW_CONV_END");
-	if (gpadc->irq < 0) {
-		dev_err(&pdev->dev, "failed to get platform irq-%d\n",
-			gpadc->irq);
-		ret = gpadc->irq;
+	gpadc->irq_sw = platform_get_irq_byname(pdev, "SW_CONV_END");
+	if (gpadc->irq_sw < 0) {
+		dev_err(gpadc->dev, "failed to get platform irq-%d\n",
+			gpadc->irq_sw);
+		ret = gpadc->irq_sw;
+		goto fail;
+	}
+
+	gpadc->irq_hw = platform_get_irq_byname(pdev, "HW_CONV_END");
+	if (gpadc->irq_hw < 0) {
+		dev_err(gpadc->dev, "failed to get platform irq-%d\n",
+			gpadc->irq_hw);
+		ret = gpadc->irq_hw;
 		goto fail;
 	}
 
@@ -666,14 +788,21 @@ static int ab8500_gpadc_probe(struct platform_device *pdev)
 	/* Initialize completion used to notify completion of conversion */
 	init_completion(&gpadc->ab8500_gpadc_complete);
 
-	/* Register interrupt  - SwAdcComplete */
-	ret = request_threaded_irq(gpadc->irq, NULL,
-		ab8500_bm_gpswadcconvend_handler,
-		IRQF_ONESHOT | IRQF_NO_SUSPEND | IRQF_SHARED,
-				"ab8500-gpadc", gpadc);
+	/* Register interrupts */
+	ret = request_threaded_irq(gpadc->irq_sw, NULL,
+		ab8500_bm_gpadcconvend_handler,
+		IRQF_NO_SUSPEND | IRQF_SHARED, "ab8500-gpadc-sw", gpadc);
+	if (ret < 0) {
+		dev_err(gpadc->dev, "Failed to register interrupt, irq: %d\n",
+			gpadc->irq_sw);
+		goto fail;
+	}
+	ret = request_threaded_irq(gpadc->irq_hw, NULL,
+		ab8500_bm_gpadcconvend_handler,
+		IRQF_NO_SUSPEND | IRQF_SHARED, "ab8500-gpadc-hw", gpadc);
 	if (ret < 0) {
 		dev_err(gpadc->dev, "Failed to register interrupt, irq: %d\n",
-			gpadc->irq);
+			gpadc->irq_hw);
 		goto fail;
 	}
 
@@ -697,6 +826,9 @@ static int ab8500_gpadc_probe(struct platform_device *pdev)
 	list_add_tail(&gpadc->node, &ab8500_gpadc_list);
 	dev_dbg(gpadc->dev, "probe success\n");
 	return 0;
+fail_irq:
+	free_irq(gpadc->irq_sw, gpadc);
+	free_irq(gpadc->irq_hw, gpadc);
 fail:
 	kfree(gpadc);
 	gpadc = NULL;
@@ -710,7 +842,8 @@ static int ab8500_gpadc_remove(struct platform_device *pdev)
 	/* remove this gpadc entry from the list */
 	list_del(&gpadc->node);
 	/* remove interrupt  - completion of Sw ADC conversion */
-	free_irq(gpadc->irq, gpadc);
+	free_irq(gpadc->irq_sw, gpadc);
+	free_irq(gpadc->irq_hw, gpadc);
 
 	pm_runtime_get_sync(gpadc->dev);
 	pm_runtime_disable(gpadc->dev);
@@ -760,6 +893,7 @@ subsys_initcall_sync(ab8500_gpadc_init);
 module_exit(ab8500_gpadc_exit);
 
 MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Arun R Murthy, Daniel Willerud, Johan Palsson");
+MODULE_AUTHOR("Arun R Murthy, Daniel Willerud, Johan Palsson,"
+		"M'boumba Cedric Madianga");
 MODULE_ALIAS("platform:ab8500_gpadc");
 MODULE_DESCRIPTION("AB8500 GPADC driver");
diff --git a/include/linux/mfd/abx500/ab8500-gpadc.h b/include/linux/mfd/abx500/ab8500-gpadc.h
index 2529667..7694e7a 100644
--- a/include/linux/mfd/abx500/ab8500-gpadc.h
+++ b/include/linux/mfd/abx500/ab8500-gpadc.h
@@ -4,12 +4,14 @@
  *
  * Author: Arun R Murthy <arun.murthy@stericsson.com>
  * Author: Daniel Willerud <daniel.willerud@stericsson.com>
+ * Author: M'boumba Cedric Madianga <cedric.madianga@stericsson.com>
  */
 
 #ifndef	_AB8500_GPADC_H
 #define _AB8500_GPADC_H
 
-/* GPADC source: From datasheet(ADCSwSel[4:0] in GPADCCtrl2) */
+/* GPADC source: From datasheet(ADCSwSel[4:0] in GPADCCtrl2
+ * and ADCHwSel[4:0] in GPADCCtrl3 ) */
 #define BAT_CTRL	0x01
 #define BTEMP_BALL	0x02
 #define MAIN_CHARGER_V	0x03
@@ -24,12 +26,32 @@
 #define BK_BAT_V	0x0C
 #define DIE_TEMP	0x0D
 
+#define SAMPLE_1        1
+#define SAMPLE_4        4
+#define SAMPLE_8        8
+#define SAMPLE_16       16
+#define RISING_EDGE     0
+#define FALLING_EDGE    1
+
+/* Arbitrary ADC conversion type constants */
+#define ADC_SW				0
+#define ADC_HW				1
+
+
 struct ab8500_gpadc;
 
 struct ab8500_gpadc *ab8500_gpadc_get(char *name);
-int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 channel);
-int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel);
+int ab8500_gpadc_sw_hw_convert(struct ab8500_gpadc *gpadc, u8 channel,
+		u8 avg_sample, u8 trig_edge, u8 trig_timer, u8 conv_type);
+static inline int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 channel)
+{
+	return ab8500_gpadc_sw_hw_convert(gpadc, channel,
+			SAMPLE_16, 0, 0, ADC_SW);
+}
+
+int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel,
+		u8 avg_sample, u8 trig_edge, u8 trig_timer, u8 conv_type);
 int ab8500_gpadc_ad_to_voltage(struct ab8500_gpadc *gpadc,
-    u8 channel, int ad_value);
+		u8 channel, int ad_value);
 
 #endif /* _AB8500_GPADC_H */
-- 
1.7.10.4

