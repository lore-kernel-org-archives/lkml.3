Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbaLAPe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 10:34:57 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44144 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbaLAPey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 10:34:54 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Wolfram Sang <wsa@the-dreams.de>, Sekhar Nori <nsekhar@ti.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: <linux-i2c@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Mike Looijmans <info@milosoftware.com>, <devicetree@vger.kernel.org>
Subject: [PATCH 5/5] i2c: davinci: use ICPFUNC to toggle I2C as gpio for bus recovery
Date: Mon, 1 Dec 2014 17:34:07 +0200
Message-ID: <1417448047-15236-6-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417448047-15236-1-git-send-email-grygorii.strashko@ti.com>
References: <1417448047-15236-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having a board where the I2C bus locks up occasionally made it clear
that the bus recovery in the i2c-davinci driver will only work on
some boards, because on regular boards, this will only toggle GPIO
lines that aren't muxed to the actual pins.

The I2C controller on SoCs like da850 (and da830), Keystone 2 has the
built-in capability to bit-bang its lines by using the ICPFUNC registers
of the i2c controller.
Implement the suggested procedure by toggling SCL and checking SDA using
the ICPFUNC registers of the I2C controller when present. Allow platforms
to indicate the presence of the ICPFUNC registers with a has_pfunc platform
data flag and add optional DT property "ti,has-pfunc" to indicate
the same in DT.

CC: Sekhar Nori <nsekhar@ti.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>
CC: Santosh Shilimkar <ssantosh@kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>
CC: Mike Looijmans <info@milosoftware.com>
CC: <devicetree@vger.kernel.org>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
Signed-off-by: Mike Looijmans <milo-software@users.sourceforge.net>
[grygorii.strashko@ti.com: combined patches from Ben Gardiner and
Mike Looijmans and reimplemented ICPFUNC bus recovery using I2C
bus recovery infrastructure]
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 .../devicetree/bindings/i2c/i2c-davinci.txt        |   3 +
 drivers/i2c/busses/i2c-davinci.c                   | 102 ++++++++++++++++++++-
 include/linux/platform_data/i2c-davinci.h          |   1 +
 3 files changed, 105 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-davinci.txt b/Documentation/devicetree/bindings/i2c/i2c-davinci.txt
index 2dc935b..a4e1cbc 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-davinci.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-davinci.txt
@@ -10,6 +10,9 @@ Required properties:
 Recommended properties :
 - interrupts : standard interrupt property.
 - clock-frequency : desired I2C bus clock frequency in Hz.
+- ti,has-pfunc: boolean; if defined, it indicates that SoC supports PFUNC
+	registers. PFUNC registers allow to switch I2C pins to function as
+	GPIOs, so they can by toggled manually.
 
 Example (enbw_cmc board):
 	i2c@1c22000 {
diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 00aed63..a1bb587 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -64,6 +64,12 @@
 #define DAVINCI_I2C_IVR_REG	0x28
 #define DAVINCI_I2C_EMDR_REG	0x2c
 #define DAVINCI_I2C_PSC_REG	0x30
+#define DAVINCI_I2C_FUNC_REG	0x48
+#define DAVINCI_I2C_DIR_REG	0x4c
+#define DAVINCI_I2C_DIN_REG	0x50
+#define DAVINCI_I2C_DOUT_REG	0x54
+#define DAVINCI_I2C_DSET_REG	0x58
+#define DAVINCI_I2C_DCLR_REG	0x5c
 
 #define DAVINCI_I2C_IVR_AAS	0x07
 #define DAVINCI_I2C_IVR_SCD	0x06
@@ -97,6 +103,29 @@
 #define DAVINCI_I2C_IMR_NACK	BIT(1)
 #define DAVINCI_I2C_IMR_AL	BIT(0)
 
+/* set SDA and SCL as GPIO */
+#define DAVINCI_I2C_FUNC_PFUNC0	BIT(0)
+
+/* set SCL as output when used as GPIO*/
+#define DAVINCI_I2C_DIR_PDIR0	BIT(0)
+/* set SDA as output when used as GPIO*/
+#define DAVINCI_I2C_DIR_PDIR1	BIT(1)
+
+/* read SCL GPIO level */
+#define DAVINCI_I2C_DIN_PDIN0 BIT(0)
+/* read SDA GPIO level */
+#define DAVINCI_I2C_DIN_PDIN1 BIT(1)
+
+/*set the SCL GPIO high */
+#define DAVINCI_I2C_DSET_PDSET0	BIT(0)
+/*set the SDA GPIO high */
+#define DAVINCI_I2C_DSET_PDSET1	BIT(1)
+
+/* set the SCL GPIO low */
+#define DAVINCI_I2C_DCLR_PDCLR0	BIT(0)
+/* set the SDA GPIO low */
+#define DAVINCI_I2C_DCLR_PDCLR1	BIT(1)
+
 struct davinci_i2c_dev {
 	struct device           *dev;
 	void __iomem		*base;
@@ -257,6 +286,71 @@ static struct i2c_bus_recovery_info davinci_i2c_gpio_recovery_info = {
 	.unprepare_recovery = davinci_i2c_unprepare_recovery,
 };
 
+static void davinci_i2c_set_scl(struct i2c_adapter *adap, int val)
+{
+	struct davinci_i2c_dev *dev = i2c_get_adapdata(adap);
+
+	if (val)
+		davinci_i2c_write_reg(dev, DAVINCI_I2C_DSET_REG,
+				      DAVINCI_I2C_DSET_PDSET0);
+	else
+		davinci_i2c_write_reg(dev, DAVINCI_I2C_DCLR_REG,
+				      DAVINCI_I2C_DCLR_PDCLR0);
+}
+
+static int davinci_i2c_get_scl(struct i2c_adapter *adap)
+{
+	struct davinci_i2c_dev *dev = i2c_get_adapdata(adap);
+	int val;
+
+	/* read the state of SCL */
+	val = davinci_i2c_read_reg(dev, DAVINCI_I2C_DIN_REG);
+	return val & DAVINCI_I2C_DIN_PDIN0;
+}
+
+static int davinci_i2c_get_sda(struct i2c_adapter *adap)
+{
+	struct davinci_i2c_dev *dev = i2c_get_adapdata(adap);
+	int val;
+
+	/* read the state of SDA */
+	val = davinci_i2c_read_reg(dev, DAVINCI_I2C_DIN_REG);
+	return val & DAVINCI_I2C_DIN_PDIN1;
+}
+
+static void davinci_i2c_scl_prepare_recovery(struct i2c_adapter *adap)
+{
+	struct davinci_i2c_dev *dev = i2c_get_adapdata(adap);
+
+	davinci_i2c_prepare_recovery(adap);
+
+	/* SCL output, SDA input */
+	davinci_i2c_write_reg(dev, DAVINCI_I2C_DIR_REG, DAVINCI_I2C_DIR_PDIR0);
+
+	/* change to GPIO mode */
+	davinci_i2c_write_reg(dev, DAVINCI_I2C_FUNC_REG,
+			      DAVINCI_I2C_FUNC_PFUNC0);
+}
+
+static void davinci_i2c_scl_unprepare_recovery(struct i2c_adapter *adap)
+{
+	struct davinci_i2c_dev *dev = i2c_get_adapdata(adap);
+
+	/* change back to I2C mode */
+	davinci_i2c_write_reg(dev, DAVINCI_I2C_FUNC_REG, 0);
+
+	davinci_i2c_unprepare_recovery(adap);
+}
+
+static struct i2c_bus_recovery_info davinci_i2c_scl_recovery_info = {
+	.recover_bus = i2c_generic_scl_recovery,
+	.set_scl = davinci_i2c_set_scl,
+	.get_scl = davinci_i2c_get_scl,
+	.get_sda = davinci_i2c_get_sda,
+	.prepare_recovery = davinci_i2c_scl_prepare_recovery,
+	.unprepare_recovery = davinci_i2c_scl_unprepare_recovery,
+};
+
 /*
  * Waiting for bus not busy
  */
@@ -669,6 +763,10 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 		if (!of_property_read_u32(pdev->dev.of_node, "clock-frequency",
 			&prop))
 			dev->pdata->bus_freq = prop / 1000;
+
+		dev->pdata->has_pfunc =
+			of_property_read_bool(pdev->dev.of_node,
+					      "ti,has-pfunc");
 	} else if (!dev->pdata) {
 		dev->pdata = &davinci_i2c_platform_data_default;
 	}
@@ -710,7 +808,9 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 	adap->timeout = DAVINCI_I2C_TIMEOUT;
 	adap->dev.of_node = pdev->dev.of_node;
 
-	if (dev->pdata->scl_pin) {
+	if (dev->pdata->has_pfunc)
+		adap->bus_recovery_info = &davinci_i2c_scl_recovery_info;
+	else if (dev->pdata->scl_pin) {
 		adap->bus_recovery_info = &davinci_i2c_gpio_recovery_info;
 		adap->bus_recovery_info->scl_gpio = dev->pdata->scl_pin;
 		adap->bus_recovery_info->sda_gpio = dev->pdata->sda_pin;
diff --git a/include/linux/platform_data/i2c-davinci.h b/include/linux/platform_data/i2c-davinci.h
index 2312d19..89fd347 100644
--- a/include/linux/platform_data/i2c-davinci.h
+++ b/include/linux/platform_data/i2c-davinci.h
@@ -18,6 +18,7 @@ struct davinci_i2c_platform_data {
 	unsigned int	bus_delay;	/* post-transaction delay (usec) */
 	unsigned int    sda_pin;        /* GPIO pin ID to use for SDA */
 	unsigned int    scl_pin;        /* GPIO pin ID to use for SCL */
+	bool		has_pfunc;	/*chip has a ICPFUNC register */
 };
 
 /* for board setup code */
-- 
1.9.1

