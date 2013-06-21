Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945956Ab3FUS2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 14:28:05 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:56858 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945942Ab3FUS2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 14:28:02 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: linux-fbdev@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: jimwall@q.com, brian@crystalfontz.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 2/2] fb: backlight: HX8357: Add HX8369 support
Date: Fri, 21 Jun 2013 20:27:39 +0200
Message-Id: <1371839259-543-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371839259-543-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1371839259-543-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/video/backlight/hx8357.c | 183 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 175 insertions(+), 8 deletions(-)

diff --git a/drivers/video/backlight/hx8357.c b/drivers/video/backlight/hx8357.c
index 69f5672..b1c4042 100644
--- a/drivers/video/backlight/hx8357.c
+++ b/drivers/video/backlight/hx8357.c
@@ -71,6 +71,18 @@
 #define HX8357_SET_POWER_NORMAL		0xd2
 #define HX8357_SET_PANEL_RELATED	0xe9
 
+#define HX8369_SET_DISPLAY_BRIGHTNESS		0x51
+#define HX8369_WRITE_CABC_DISPLAY_VALUE		0x53
+#define HX8369_WRITE_CABC_BRIGHT_CTRL		0x55
+#define HX8369_WRITE_CABC_MIN_BRIGHTNESS	0x5e
+#define HX8369_SET_POWER			0xb1
+#define HX8369_SET_DISPLAY_MODE			0xb2
+#define HX8369_SET_DISPLAY_WAVEFORM_CYC		0xb4
+#define HX8369_SET_VCOM				0xb6
+#define HX8369_SET_EXTENSION_COMMAND		0xb9
+#define HX8369_SET_GIP				0xd5
+#define HX8369_SET_GAMMA_CURVE_RELATED		0xe0
+
 struct hx8357_data {
 	unsigned		im_pins[HX8357_NUM_IM_PINS];
 	unsigned		reset;
@@ -144,6 +156,61 @@ static u8 hx8357_seq_display_mode[] = {
 	HX8357_SET_DISPLAY_MODE_RGB_INTERFACE,
 };
 
+static u8 hx8369_seq_write_CABC_min_brightness[] = {
+	HX8369_WRITE_CABC_MIN_BRIGHTNESS, 0x00,
+};
+
+static u8 hx8369_seq_write_CABC_control[] = {
+	HX8369_WRITE_CABC_DISPLAY_VALUE, 0x24,
+};
+
+static u8 hx8369_seq_set_display_brightness[] = {
+	HX8369_SET_DISPLAY_BRIGHTNESS, 0xFF,
+};
+
+static u8 hx8369_seq_write_CABC_control_setting[] = {
+	HX8369_WRITE_CABC_BRIGHT_CTRL, 0x02,
+};
+
+static u8 hx8369_seq_extension_command[] = {
+	HX8369_SET_EXTENSION_COMMAND, 0xff, 0x83, 0x69,
+};
+
+static u8 hx8369_seq_display_related[] = {
+	HX8369_SET_DISPLAY_MODE, 0x00, 0x2b, 0x03, 0x03, 0x70, 0x00,
+	0xff, 0x00, 0x00, 0x00, 0x00, 0x03, 0x03, 0x00,	0x01,
+};
+
+static u8 hx8369_seq_panel_waveform_cycle[] = {
+	HX8369_SET_DISPLAY_WAVEFORM_CYC, 0x0a, 0x1d, 0x80, 0x06, 0x02,
+};
+
+static u8 hx8369_seq_set_address_mode[] = {
+	HX8357_SET_ADDRESS_MODE, 0x00,
+};
+
+static u8 hx8369_seq_vcom[] = {
+	HX8369_SET_VCOM, 0x3e, 0x3e,
+};
+
+static u8 hx8369_seq_gip[] = {
+	HX8369_SET_GIP, 0x00, 0x01, 0x03, 0x25, 0x01, 0x02, 0x28, 0x70,
+	0x11, 0x13, 0x00, 0x00, 0x40, 0x26, 0x51, 0x37, 0x00, 0x00, 0x71,
+	0x35, 0x60, 0x24, 0x07, 0x0f, 0x04, 0x04,
+};
+
+static u8 hx8369_seq_power[] = {
+	HX8369_SET_POWER, 0x01, 0x00, 0x34, 0x03, 0x00, 0x11, 0x11, 0x32,
+	0x2f, 0x3f, 0x3f, 0x01, 0x3a, 0x01, 0xe6, 0xe6, 0xe6, 0xe6, 0xe6,
+};
+
+static u8 hx8369_seq_gamma_curve_related[] = {
+	HX8369_SET_GAMMA_CURVE_RELATED, 0x00, 0x0d, 0x19, 0x2f, 0x3b, 0x3d,
+	0x2e, 0x4a, 0x08, 0x0e, 0x0f, 0x14, 0x16, 0x14, 0x14, 0x14, 0x1e,
+	0x00, 0x0d, 0x19, 0x2f, 0x3b, 0x3d, 0x2e, 0x4a, 0x08, 0x0e, 0x0f,
+	0x14, 0x16, 0x14, 0x14, 0x14, 0x1e,
+};
+
 static int hx8357_spi_write_then_read(struct lcd_device *lcdev,
 				u8 *txbuf, u16 txlen,
 				u8 *rxbuf, u16 rxlen)
@@ -242,6 +309,16 @@ static int hx8357_exit_standby(struct lcd_device *lcdev)
 	return 0;
 }
 
+static void hx8357_lcd_reset(struct hx8357_data *lcd)
+{
+	gpio_set_value(lcd->reset, 1);
+	usleep_range(10000, 12000);
+	gpio_set_value(lcd->reset, 0);
+	usleep_range(10000, 12000);
+	gpio_set_value(lcd->reset, 1);
+	msleep(120);
+}
+
 static int hx8357_lcd_init(struct lcd_device *lcdev)
 {
 	struct hx8357_data *lcd = lcd_get_data(lcdev);
@@ -257,13 +334,7 @@ static int hx8357_lcd_init(struct lcd_device *lcdev)
 		gpio_set_value_cansleep(lcd->im_pins[2], 1);
 	}
 
-	/* Reset the screen */
-	gpio_set_value(lcd->reset, 1);
-	usleep_range(10000, 12000);
-	gpio_set_value(lcd->reset, 0);
-	usleep_range(10000, 12000);
-	gpio_set_value(lcd->reset, 1);
-	msleep(120);
+	hx8357_lcd_reset(lcd);
 
 	ret = hx8357_spi_write_array(lcdev, hx8357_seq_power,
 				ARRAY_SIZE(hx8357_seq_power));
@@ -359,6 +430,97 @@ static int hx8357_lcd_init(struct lcd_device *lcdev)
 	return 0;
 }
 
+static int hx8369_lcd_init(struct lcd_device *lcdev)
+{
+	struct hx8357_data *lcd = lcd_get_data(lcdev);
+	int ret;
+
+	hx8357_lcd_reset(lcd);
+
+	ret = hx8357_spi_write_array(lcdev, hx8369_seq_extension_command,
+				ARRAY_SIZE(hx8369_seq_extension_command));
+	if (ret < 0)
+		return ret;
+	usleep_range(10000, 12000);
+
+	ret = hx8357_spi_write_array(lcdev, hx8369_seq_display_related,
+				ARRAY_SIZE(hx8369_seq_display_related));
+	if (ret < 0)
+		return ret;
+
+	ret = hx8357_spi_write_array(lcdev, hx8369_seq_panel_waveform_cycle,
+				ARRAY_SIZE(hx8369_seq_panel_waveform_cycle));
+	if (ret < 0)
+		return ret;
+
+	ret = hx8357_spi_write_array(lcdev, hx8369_seq_set_address_mode,
+				ARRAY_SIZE(hx8369_seq_set_address_mode));
+	if (ret < 0)
+		return ret;
+
+	ret = hx8357_spi_write_array(lcdev, hx8369_seq_vcom,
+				ARRAY_SIZE(hx8369_seq_vcom));
+	if (ret < 0)
+		return ret;
+
+	ret = hx8357_spi_write_array(lcdev, hx8369_seq_gip,
+				ARRAY_SIZE(hx8369_seq_gip));
+	if (ret < 0)
+		return ret;
+
+	ret = hx8357_spi_write_array(lcdev, hx8369_seq_power,
+				ARRAY_SIZE(hx8369_seq_power));
+	if (ret < 0)
+		return ret;
+
+	ret = hx8357_spi_write_byte(lcdev, HX8357_EXIT_SLEEP_MODE);
+	if (ret < 0)
+		return ret;
+
+	msleep(120);
+
+	ret = hx8357_spi_write_array(lcdev, hx8369_seq_gamma_curve_related,
+				ARRAY_SIZE(hx8369_seq_gamma_curve_related));
+	if (ret < 0)
+		return ret;
+
+	ret = hx8357_spi_write_byte(lcdev, HX8357_EXIT_SLEEP_MODE);
+	if (ret < 0)
+		return ret;
+	usleep_range(1000, 1200);
+
+	ret = hx8357_spi_write_array(lcdev, hx8369_seq_write_CABC_control,
+				ARRAY_SIZE(hx8369_seq_write_CABC_control));
+	if (ret < 0)
+		return ret;
+	usleep_range(10000, 12000);
+
+	ret = hx8357_spi_write_array(lcdev,
+			hx8369_seq_write_CABC_control_setting,
+			ARRAY_SIZE(hx8369_seq_write_CABC_control_setting));
+	if (ret < 0)
+		return ret;
+
+	ret = hx8357_spi_write_array(lcdev,
+			hx8369_seq_write_CABC_min_brightness,
+			ARRAY_SIZE(hx8369_seq_write_CABC_min_brightness));
+	if (ret < 0)
+		return ret;
+	usleep_range(10000, 12000);
+
+	ret = hx8357_spi_write_array(lcdev, hx8369_seq_set_display_brightness,
+				ARRAY_SIZE(hx8369_seq_set_display_brightness));
+	if (ret < 0)
+		return ret;
+
+	ret = hx8357_spi_write_byte(lcdev, HX8357_SET_DISPLAY_ON);
+	if (ret < 0)
+		return ret;
+	msleep(100);
+
+	return 0;
+}
+
 #define POWER_IS_ON(pwr)	((pwr) <= FB_BLANK_NORMAL)
 
 static int hx8357_set_power(struct lcd_device *lcdev, int power)
@@ -461,7 +623,11 @@ static int hx8357_probe(struct spi_device *spi)
 	}
 	spi_set_drvdata(spi, lcdev);
 
-	ret = hx8357_lcd_init(lcdev);
+	ret = -ENODEV;
+	if (of_device_is_compatible(spi->dev.of_node, "himax,hx8357"))
+		ret = hx8357_lcd_init(lcdev);
+	else if (of_device_is_compatible(spi->dev.of_node, "himax,hx8369"))
+		ret = hx8369_lcd_init(lcdev);
 	if (ret) {
 		dev_err(&spi->dev, "Couldn't initialize panel\n");
 		goto init_error;
@@ -486,6 +652,7 @@ static int hx8357_remove(struct spi_device *spi)
 
 static const struct of_device_id hx8357_dt_ids[] = {
 	{ .compatible = "himax,hx8357" },
+	{ .compatible = "himax,hx8369" },
 	{},
 };
 MODULE_DEVICE_TABLE(of, hx8357_dt_ids);
-- 
1.8.1.2

