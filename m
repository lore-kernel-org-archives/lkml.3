Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286Ab3EXKAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 06:00:40 -0400
Received: from mail-wi0-f196.google.com ([209.85.212.196]:48964 "EHLO
	mail-wi0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab3EXKAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 06:00:16 -0400
From: Alexandre Torgue <alexandre.torgue.st@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>,
        <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Julien Delacou <julien.delacou@stericsson.com>
Subject: [PATCH 1/2] mfd: ab8540: add device for new rtc version on ab8540 cut2
Date: Fri, 24 May 2013 11:59:47 +0200
Message-Id: <1369389588-27568-2-git-send-email-alexandre.torgue.st@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1369389588-27568-1-git-send-email-alexandre.torgue.st@gmail.com>
References: <1369389588-27568-1-git-send-email-alexandre.torgue.st@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Torgue <alexandre.torgue@st.com>

AB8540 rtc have changed between AB8540_cut1 and AB8540_cut2.Different
ressources to define for those two version.

Signed-off-by: Julien Delacou <julien.delacou@stericsson.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>

Acked-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 42abd3a..6f22527 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -650,6 +650,21 @@ static struct resource ab8500_rtc_resources[] = {
 	},
 };
 
+static struct resource ab8540_rtc_resources[] = {
+	{
+		.name	= "1S",
+		.start	= AB8540_INT_RTC_1S,
+		.end	= AB8540_INT_RTC_1S,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.name	= "ALARM",
+		.start	= AB8500_INT_RTC_ALARM,
+		.end	= AB8500_INT_RTC_ALARM,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
 static struct resource ab8500_poweronkey_db_resources[] = {
 	{
 		.name	= "ONKEY_DBF",
@@ -1284,11 +1299,6 @@ static struct mfd_cell ab8540_devs[] = {
 		.resources = ab8505_gpadc_resources,
 	},
 	{
-		.name = "ab8500-rtc",
-		.num_resources = ARRAY_SIZE(ab8500_rtc_resources),
-		.resources = ab8500_rtc_resources,
-	},
-	{
 		.name = "ab8500-acc-det",
 		.num_resources = ARRAY_SIZE(ab8500_av_acc_detect_resources),
 		.resources = ab8500_av_acc_detect_resources,
@@ -1328,6 +1338,24 @@ static struct mfd_cell ab8540_devs[] = {
 	},
 };
 
+static struct mfd_cell ab8540_cut1_devs[] = {
+	{
+		.name = "ab8500-rtc",
+		.of_compatible = "stericsson,ab8500-rtc",
+		.num_resources = ARRAY_SIZE(ab8500_rtc_resources),
+		.resources = ab8500_rtc_resources,
+	},
+};
+
+static struct mfd_cell ab8540_cut2_devs[] = {
+	{
+		.name = "ab8540-rtc",
+		.of_compatible = "stericsson,ab8540-rtc",
+		.num_resources = ARRAY_SIZE(ab8540_rtc_resources),
+		.resources = ab8540_rtc_resources,
+	},
+};
+
 static ssize_t show_chip_id(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -1731,11 +1759,22 @@ static int ab8500_probe(struct platform_device *pdev)
 		ret = mfd_add_devices(ab8500->dev, 0, ab9540_devs,
 				ARRAY_SIZE(ab9540_devs), NULL,
 				ab8500->irq_base, ab8500->domain);
-	else if (is_ab8540(ab8500))
+	else if (is_ab8540(ab8500)) {
 		ret = mfd_add_devices(ab8500->dev, 0, ab8540_devs,
 			      ARRAY_SIZE(ab8540_devs), NULL,
-			      ab8500->irq_base, ab8500->domain);
-	else if (is_ab8505(ab8500))
+			      ab8500->irq_base, NULL);
+		if (ret)
+			return ret;
+
+		if (is_ab8540_1p2_or_earlier(ab8500))
+			ret = mfd_add_devices(ab8500->dev, 0, ab8540_cut1_devs,
+			      ARRAY_SIZE(ab8540_cut1_devs), NULL,
+			      ab8500->irq_base, NULL);
+		else /* ab8540 >= cut2 */
+			ret = mfd_add_devices(ab8500->dev, 0, ab8540_cut2_devs,
+			      ARRAY_SIZE(ab8540_cut2_devs), NULL,
+			      ab8500->irq_base, NULL);
+	} else if (is_ab8505(ab8500))
 		ret = mfd_add_devices(ab8500->dev, 0, ab8505_devs,
 			      ARRAY_SIZE(ab8505_devs), NULL,
 			      ab8500->irq_base, ab8500->domain);
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index fb1bf7d..e330ad3 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -291,6 +291,8 @@ enum ab8500_version {
 #define AB8540_INT_FSYNC2R		213
 #define AB8540_INT_BITCLK2F		214
 #define AB8540_INT_BITCLK2R		215
+/* ab8540_irq_regoffset[27] -> IT[Source|Latch|Mask]33 */
+#define AB8540_INT_RTC_1S		216
 
 /*
  * AB8500_AB9540_NR_IRQS is used when configuring the IRQ numbers for the
-- 
1.8.2.1

