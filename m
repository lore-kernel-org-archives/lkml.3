Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161902Ab3BOM6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:58:31 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59369 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161853Ab3BOM6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:58:17 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Yang QU <yang.qu@stericsson.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 28/35] mfd: ab8500-debug: Add ADC input channel usb_id in debugfs
Date: Fri, 15 Feb 2013 12:56:59 +0000
Message-Id: <1360933026-30325-29-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang QU <yang.qu@stericsson.com>

Signed-off-by: Yang QU <yang.qu@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Alexandre BOURDIOL <alexandre.bourdiol@stericsson.com>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
---
 drivers/mfd/ab8500-debugfs.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index a301f10..ae8660a 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -1705,6 +1705,35 @@ static const struct file_operations ab8500_gpadc_die_temp_fops = {
 	.owner = THIS_MODULE,
 };
 
+static int ab8500_gpadc_usb_id_print(struct seq_file *s, void *p)
+{
+	int usb_id_raw;
+	int usb_id_convert;
+	struct ab8500_gpadc *gpadc;
+
+	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
+	usb_id_raw = ab8500_gpadc_read_raw(gpadc, USB_ID,
+		avg_sample, trig_edge, trig_timer, conv_type);
+	usb_id_convert = ab8500_gpadc_ad_to_voltage(gpadc, USB_ID,
+		usb_id_raw);
+
+	return seq_printf(s, "%d,0x%X\n",
+			usb_id_convert, usb_id_raw);
+}
+
+static int ab8500_gpadc_usb_id_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab8500_gpadc_usb_id_print, inode->i_private);
+}
+
+static const struct file_operations ab8500_gpadc_usb_id_fops = {
+	.open = ab8500_gpadc_usb_id_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 static int ab8540_gpadc_xtal_temp_print(struct seq_file *s, void *p)
 {
 	int xtal_temp_raw;
@@ -2711,6 +2740,12 @@ static int ab8500_debug_probe(struct platform_device *plf)
 	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_die_temp_fops);
 	if (!file)
 		goto err;
+
+	file = debugfs_create_file("usb_id", (S_IRUGO | S_IWUGO),
+	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_usb_id_fops);
+	if (!file)
+		goto err;
+
 	if (is_ab8540(ab8500)) {
 		file = debugfs_create_file("xtal_temp", (S_IRUGO | S_IWUGO),
 		    ab8500_gpadc_dir, &plf->dev, &ab8540_gpadc_xtal_temp_fops);
-- 
1.7.10.4

