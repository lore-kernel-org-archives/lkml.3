Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaH1LkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 07:40:13 -0400
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:44817 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaH1LkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 07:40:11 -0400
Date: Thu, 28 Aug 2014 15:42:44 +0300
From: Matti Vaittinen <matti.vaittinen@nsn.com>
To: a.zummo@towertech.it
Cc: jason@lakedaemon.net, linux@roeck-us.net, jic23@kernel.org,
        arno@natisbad.org, jgunthorpe@obsidianresearch.com,
        san@rosetechnology.dk, hs@denx.de, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Sverdlin Alexander <alexander.sverdlin@nsn.com>,
        matti.vaittinen@nsn.com
Subject: [PATCH] rtc: ds1307: add trickle charger device tree binding
Message-ID: <20140828124237.GA29102@fi-ourus-dhcp00977.emea.nsn-net.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 5084
X-purgate-ID: 151667::1409225888-000023E0-E623B0E7/0/0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch adding support for specifying trickle charger setup from device
tree. Patch is based on linux-next tree.


Some DS13XX devices have "trickle chargers". Introduce a device tree binding
for specifying the setup and register values.

Signed-off-by: Matti Vaittinen <matti.vaittinen@nsn.com>
---
 .../devicetree/bindings/i2c/trivial-devices.txt    |  1 -
 .../devicetree/bindings/rtc/dallas,ds1339.txt      | 19 ++++++++++
 drivers/rtc/rtc-ds1307.c                           | 44 ++++++++++++++++++++--
 3 files changed, 59 insertions(+), 5 deletions(-)
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
index 0000000..9faf40e
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt
@@ -0,0 +1,19 @@
+* Dallas DS1339		I2C Serial Real-Time Clock
+
+Required properties:
+- compatible: Should contain "dallas,ds1339".
+- reg: I2C address for chip
+
+Optional properties:
+- trickle_setup : Used Trickle Charger configuration,
+        corresponding to 5 lowest bits in trickle charger register.
+- trickle_reg   : Trickle charger register address. Defaults to 0x10 for ds1339.
+
+Example:
+	ds1339: rtc@68 {
+		compatible = "dallas,ds1339";
+        trickle_setup= <0x5>;
+		reg = <0x68>;
+	};
+
+
diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index f03d5ba..f9b1244 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -126,9 +126,10 @@ struct chip_desc {
 	u16			nvram_offset;
 	u16			nvram_size;
 	u16			trickle_charger_reg;
+	u8		  trickle_charger_setup;
 };
 
-static const struct chip_desc chips[last_ds_type] = {
+static struct chip_desc chips[last_ds_type] = {
 	[ds_1307] = {
 		.nvram_offset	= 8,
 		.nvram_size	= 56,
@@ -835,13 +836,37 @@ ds1307_nvram_write(struct file *filp, struct kobject *kobj,
 
 /*----------------------------------------------------------------------*/
 
+static void trickle_charger_of_init(struct chip_desc *chip,
+			struct device_node *node)
+{
+	int plen = 0;
+	const uint32_t *setup;
+	const uint32_t *reg;
+
+	setup = of_get_property(node, "trickle_setup" , &plen);
+	if (plen != 4)
+		goto out;
+	chip->trickle_charger_setup = (u8)*setup;
+	plen = 0;
+	reg = of_get_property(node, "trickle_reg" , &plen);
+	if (plen == 4)
+		chip->trickle_charger_reg = (u16)*reg;
+	return;
+out:
+	pr_debug("%s: No trickle charger data in dt for %s rtc chip\n",
+	    __func__, (node && node->name)?node->name:"ds13XX");
+}
+
+/*----------------------------------------------------------------------*/
+
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
@@ -866,9 +891,20 @@ static int ds1307_probe(struct i2c_client *client,
 	ds1307->client	= client;
 	ds1307->type	= id->driver_data;
 
-	if (pdata && pdata->trickle_charger_setup && chip->trickle_charger_reg)
+	if (!pdata && client->dev.of_node)
+		trickle_charger_of_init(chip, client->dev.of_node);
+		/* Get trickle property */
+	else if (pdata && pdata->trickle_charger_setup)
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


-- 
=============================================

Matti Vaittinen
Senile SW Specialist
FINLAND 

~~ When things go utterly wrong vim users can always type :help! ~~

