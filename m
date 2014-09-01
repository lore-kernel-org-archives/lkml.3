Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaIAIDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:03:31 -0400
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:41100 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaIAID2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:03:28 -0400
Date: Mon, 1 Sep 2014 12:07:01 +0300
From: Matti Vaittinen <matti.vaittinen@nsn.com>
To: "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "arno@natisbad.org" <arno@natisbad.org>,
        "jgunthorpe@obsidianresearch.com" <jgunthorpe@obsidianresearch.com>,
        "san@rosetechnology.dk" <san@rosetechnology.dk>,
        "hs@denx.de" <hs@denx.de>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Sverdlin Alexander <alexander.sverdlin@nsn.com>
Subject: [PATCH v3]     rtc: ds1307: add trickle charger device tree binding
Message-ID: <20140901090653.GA26182@fi-ourus-dhcp00977.emea.nsn-net.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 6563
X-purgate-ID: 151667::1409558557-000023E0-DD1E4D23/0/0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Third attempt. Delta to patch V2:
    - Separated diode and resistor setup properties
    - Updated documentation accordingly
    - Explicitly told when to use optional 'trickle' properties.

Worth noting: Only ds1339 dt binding is supported because this is the
only chip I have. I _assume_ the code would have worked on other
allready supported chips. However I cannot check the resistor values for
the other chips or test them. For other chips the driver code works as
earlier Eg. it does not check the dt bindings at all. Also the dt
binding is only documented for ds1339.






    Some DS13XX devices have "trickle chargers". Introduce a device tree binding
    for specifying the trickle charger configuration for ds1339.
    Note that the patch _only_ iplements device tree bindings to ds1339
    chip because I only had access to that specific chip.

Signed-off-by: Matti Vaittinen <matti.vaittinen@nsn.com>
---
 .../devicetree/bindings/i2c/trivial-devices.txt    |  1 -
 .../devicetree/bindings/rtc/dallas,ds1339.txt      | 18 ++++++
 drivers/rtc/rtc-ds1307.c                           | 66 ++++++++++++++++++++--
 3 files changed, 80 insertions(+), 5 deletions(-)
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
index 0000000..fba65b2
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt
@@ -0,0 +1,18 @@
+* Dallas DS1339		I2C Serial Real-Time Clock
+
+Required properties:
+- compatible: Should contain "dallas,ds1339".
+- reg: I2C address for chip
+
+Optional properties:
+- trickle-resistor-ohms : Selected resistor for trickle charger
+	Values usable for ds1339 are 250, 2000, 4000
+	Should be given if trickle charger should be enabled
+- trickle-diode-enable : Use internal trickle charger diode
+	Should be given if internal trickle charger diode should be enabled
+Example:
+	ds1339: rtc@68 {
+		compatible = "dallas,ds1339";
+		trickle-resistor-ohms = <250>;
+		reg = <0x68>;
+	};
diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index f03d5ba..b297c2c 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -126,9 +126,14 @@ struct chip_desc {
 	u16			nvram_offset;
 	u16			nvram_size;
 	u16			trickle_charger_reg;
+	u8			trickle_charger_setup;
+	u8			(*do_trickle_setup)(struct i2c_client *, uint32_t, bool);
 };
 
-static const struct chip_desc chips[last_ds_type] = {
+static u8 do_trickle_setup_ds1339(struct i2c_client *,
+				  uint32_t ohms, bool diode);
+
+static struct chip_desc chips[last_ds_type] = {
 	[ds_1307] = {
 		.nvram_offset	= 8,
 		.nvram_size	= 56,
@@ -143,6 +148,7 @@ static const struct chip_desc chips[last_ds_type] = {
 	[ds_1339] = {
 		.alarm		= 1,
 		.trickle_charger_reg = 0x10,
+		.do_trickle_setup = &do_trickle_setup_ds1339,
 	},
 	[ds_1340] = {
 		.trickle_charger_reg = 0x08,
@@ -833,15 +839,57 @@ ds1307_nvram_write(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
+
 /*----------------------------------------------------------------------*/
 
+static u8 do_trickle_setup_ds1339(struct i2c_client *client,
+				  uint32_t ohms, bool diode)
+{
+	u8 setup = (diode) ? DS1307_TRICKLE_CHARGER_DIODE :
+		DS1307_TRICKLE_CHARGER_NO_DIODE;
+
+	switch (ohms) {
+	case 250:
+		setup |= DS1307_TRICKLE_CHARGER_250_OHM;
+		break;
+	case 2000:
+		setup |= DS1307_TRICKLE_CHARGER_2K_OHM;
+		break;
+	case 4000:
+		setup |= DS1307_TRICKLE_CHARGER_4K_OHM;
+		break;
+	default:
+		dev_warn(&client->dev,
+			 "Unsupported ohm value %u in dt\n", ohms);
+		return 0;
+	}
+	return setup;
+}
+
+static void ds1307_trickle_of_init(struct i2c_client *client,
+				   struct chip_desc *chip)
+{
+	uint32_t ohms = 0;
+	bool diode = false;
+
+	if (!chip->do_trickle_setup)
+		goto out;
+	if (of_property_read_u32(client->dev.of_node, "trickle-resistor-ohms" , &ohms))
+		goto out;
+	diode = of_property_read_bool(client->dev.of_node, "diode-connected");
+	chip->trickle_charger_setup = chip->do_trickle_setup(client,
+							     ohms, diode);
+out:
+	return;
+}
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
@@ -866,9 +914,19 @@ static int ds1307_probe(struct i2c_client *client,
 	ds1307->client	= client;
 	ds1307->type	= id->driver_data;
 
-	if (pdata && pdata->trickle_charger_setup && chip->trickle_charger_reg)
+	if (!pdata && client->dev.of_node)
+		ds1307_trickle_of_init(client, chip);
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

