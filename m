Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaH2KZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 06:25:20 -0400
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:50401 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbaH2KZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 06:25:18 -0400
Date: Fri, 29 Aug 2014 14:29:09 +0300
From: Matti Vaittinen <matti.vaittinen@nsn.com>
To: mark.rutland@arm.com
Cc: "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "arno@natisbad.org" <arno@natisbad.org>,
        "jgunthorpe@obsidianresearch.com" <jgunthorpe@obsidianresearch.com>,
        "san@rosetechnology.dk" <san@rosetechnology.dk>,
        "hs@denx.de" <hs@denx.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Sverdlin Alexander <alexander.sverdlin@nsn.com>
Subject: [PATCH v2] rtc: ds1307: add trickle charger device tree binding
Message-ID: <20140829112902.GA14650@fi-ourus-dhcp00977.emea.nsn-net.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 4870
X-purgate-ID: 151667::1409307875-0000061C-7B132483/0/0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second version of the patch delta to previous:
 - fixed the property fetching 
 - removed the trickle register property
 - removed underscore from setup value property name
 - added higher level meaning of setup value for ds1339 in documentation.



    Some DS13XX devices have "trickle chargers". Introduce a device tree binding
    for specifying the trickle charger setup value.

Signed-off-by: Matti Vaittinen <matti.vaittinen@nsn.com>
---
 .../devicetree/bindings/i2c/trivial-devices.txt    |  1 -
 .../devicetree/bindings/rtc/dallas,ds1339.txt      | 24 ++++++++++++++++++++++
 drivers/rtc/rtc-ds1307.c                           | 23 +++++++++++++++++----
 3 files changed, 43 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rtc/dallas,ds1339.txt

diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
index 6af570e..e9206a4 100644
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
+++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -35,7 +35,6 @@ catalyst,24c32		i2c serial eeprom
 cirrus,cs42l51		Cirrus Logic CS42L51 audio codec
 dallas,ds1307		64 x 8, Serial, I2C Real-Time Clock
 dallas,ds1338		I2C RTC with 56-Byte NV RAM
-dallas,ds1339		I2C Serial Real-Time Clock
 dallas,ds1340		I2C RTC with Trickle Charger
 dallas,ds1374		I2C, 32-Bit Binary Counter Watchdog RTC with Trickle Charger and Reset Input/Output
 dallas,ds1631		High-Precision Digital Thermometer
diff --git a/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt b/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt
new file mode 100644
index 0000000..07214d0
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt
@@ -0,0 +1,24 @@
+* Dallas DS1339		I2C Serial Real-Time Clock
+
+Required properties:
+- compatible: Should contain "dallas,ds1339".
+- reg: I2C address for chip
+
+Optional properties:
+- trickle : Used Trickle Charger configuration,
+	corresponding to 4 lowest bits in trickle charger register.
+	Following values are specified:
+		0x5 => No diode, 250 ohm
+		0x9 => Diode, 250 ohm
+		0x6 => No diode, 2k ohm
+		0xa => Diode, 2k ohm
+		0x7 => No diode, 4k ohm
+		0xb => Diode, 4k ohm
+Example:
+	ds1339: rtc@68 {
+		compatible = "dallas,ds1339";
+		trickle = <0x5>;
+		reg = <0x68>;
+	};
+
+
diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index f03d5ba..cb2364e 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -126,9 +126,10 @@ struct chip_desc {
 	u16			nvram_offset;
 	u16			nvram_size;
 	u16			trickle_charger_reg;
+	u8			trickle_charger_setup;
 };
 
-static const struct chip_desc chips[last_ds_type] = {
+static struct chip_desc chips[last_ds_type] = {
 	[ds_1307] = {
 		.nvram_offset	= 8,
 		.nvram_size	= 56,
@@ -833,15 +834,17 @@ ds1307_nvram_write(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
+
 /*----------------------------------------------------------------------*/
 
+
 static int ds1307_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct ds1307		*ds1307;
 	int			err = -ENODEV;
 	int			tmp;
-	const struct chip_desc	*chip = &chips[id->driver_data];
+	struct chip_desc	*chip = &chips[id->driver_data];
 	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
 	bool			want_irq = false;
 	unsigned char		*buf;
@@ -852,6 +855,7 @@ static int ds1307_probe(struct i2c_client *client,
 		[ds_3231] = DS3231_BIT_BBSQW,
 	};
 	const struct rtc_class_ops *rtc_ops = &ds13xx_rtc_ops;
+	uint32_t setup = 0;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)
 	    && !i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
@@ -866,9 +870,20 @@ static int ds1307_probe(struct i2c_client *client,
 	ds1307->client	= client;
 	ds1307->type	= id->driver_data;
 
-	if (pdata && pdata->trickle_charger_setup && chip->trickle_charger_reg)
+	if (!pdata && client->dev.of_node) {
+		of_property_read_u32(client->dev.of_node, "trickle" , &setup);
+		chip->trickle_charger_setup = setup;
+	} else if (pdata && pdata->trickle_charger_setup)
+		chip->trickle_charger_setup = pdata->trickle_charger_setup;
+
+	if (chip->trickle_charger_setup && chip->trickle_charger_reg) {
+		dev_dbg(&client->dev, "writing trickle charger info 0x%x to 0x%x\n",
+		    DS13XX_TRICKLE_CHARGER_MAGIC | chip->trickle_charger_setup,
+		    chip->trickle_charger_reg);
 		i2c_smbus_write_byte_data(client, chip->trickle_charger_reg,
-			DS13XX_TRICKLE_CHARGER_MAGIC | pdata->trickle_charger_setup);
+		    DS13XX_TRICKLE_CHARGER_MAGIC |
+		    chip->trickle_charger_setup);
+	}
 
 	buf = ds1307->regs;
 	if (i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK)) {
-- 
1.8.3.1
