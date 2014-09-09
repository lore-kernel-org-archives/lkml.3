Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbaIIJfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:35:12 -0400
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:41080 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbaIIJfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:35:10 -0400
Date: Tue, 9 Sep 2014 13:38:40 +0300
From: Matti Vaittinen <matti.vaittinen@nsn.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux@roeck-us.net" <linux@roeck-us.net>
Cc: a.zummo@towertech.it, "jic23@kernel.org" <jic23@kernel.org>,
        "arno@natisbad.org" <arno@natisbad.org>,
        jgunthorpe@obsidianresearch.com, san@rosetechnology.dk, hs@denx.de,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Sverdlin Alexander <alexander.sverdlin@nsn.com>
Subject: [PATCH v4 2/2] rtc: ds1307: add trickle charger device tree binding.
Message-ID: <20140909103832.GA338@fi-ourus-dhcp00977.emea.nsn-net.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 4393
X-purgate-ID: 151667::1410255263-00002A30-68E82DA5/0/0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtc: ds1307: add trickle charger device tree binding.

Some DS13XX devices have "trickle chargers". Introduce a device tree
binding for specifying the trickle charger configuration for ds1339.

Only ds1339 dt binding is supported because this is the only chip I have.
I _assume_ the code would have worked on other allready supported chips.
However I cannot check the resistor values for the other chips or test them.
For other chips the driver code works as earlier Eg. it does not check the
dt bindings at all.

Signed-off-by: Matti Vaittinen <matti.vaittinen@nsn.com>
---
 drivers/rtc/rtc-ds1307.c | 66 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 62 insertions(+), 4 deletions(-)

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

