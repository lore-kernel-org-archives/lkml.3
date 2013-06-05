Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab3FEWbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:31:55 -0400
Received: from smtp121.ord1c.emailsrvr.com ([108.166.43.121]:51433 "EHLO
	smtp121.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757840Ab3FEWbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 18:31:53 -0400
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: tj@kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: [PATCH 2/2] sata highbank: add bit-banged SGPIO driver support
Date: Wed,  5 Jun 2013 17:31:48 -0500
Message-Id: <1370471508-30806-1-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369945051-2582-2-git-send-email-mark.langsdorf@calxeda.com>
References: <1369945051-2582-2-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Highbank supports SGPIO by bit-banging out the SGPIO signals over
three GPIO pins defined in the DTB. Add support for this SGPIO
functionality.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
---
Changes from v2:
	Added plat_data to ahci_host_priv
	Moved driver specific data to plat_data and got rid of ecx_host_priv
	Corrected order of operations in ecx_transmit_led_message
	Standardized bit operations in ecx_parse_sgpio
Changes from v1:
	Moved all global variables to a private structure
	Replaced all magic numbers with defined symbols
	Added some comments
	Removed the default ordering of ports to LEDs
	Fixed several bugs in the code to read led-order
	Made highbank_set_em_messages static

 .../devicetree/bindings/ata/ahci-platform.txt      |   5 +
 arch/arm/boot/dts/ecx-common.dtsi                  |   2 +
 drivers/ata/ahci.h                                 |   1 +
 drivers/ata/sata_highbank.c                        | 161 ++++++++++++++++++++-
 4 files changed, 163 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt b/Documentation/devicetree/bindings/ata/ahci-platform.txt
index b519f9b..3ec0c5c 100644
--- a/Documentation/devicetree/bindings/ata/ahci-platform.txt
+++ b/Documentation/devicetree/bindings/ata/ahci-platform.txt
@@ -12,6 +12,11 @@ Optional properties:
 - calxeda,port-phys: phandle-combophy and lane assignment, which maps each
 			SATA port to a combophy and a lane within that
 			combophy
+- calxeda,sgpio-gpio: phandle-gpio bank, bit offset, and default on or off,
+			which indicates that the driver supports SGPIO
+			indicator lights using the indicated GPIOs
+- calxeda,led-order : a u32 array that map port numbers to offsets within the
+			SGPIO bitstream.
 - dma-coherent      : Present if dma operations are coherent
 
 Example:
diff --git a/arch/arm/boot/dts/ecx-common.dtsi b/arch/arm/boot/dts/ecx-common.dtsi
index d61b535..e8559b7 100644
--- a/arch/arm/boot/dts/ecx-common.dtsi
+++ b/arch/arm/boot/dts/ecx-common.dtsi
@@ -33,6 +33,8 @@
 			calxeda,port-phys = <&combophy5 0 &combophy0 0
 					     &combophy0 1 &combophy0 2
 					     &combophy0 3>;
+			calxeda,sgpio-gpio =<&gpioh 5 1 &gpioh 6 1 &gpioh 7 1>;
+			calxeda,led-order = <4 0 1 2 3>;
 		};
 
 		sdhci@ffe0e000 {
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 10b14d4..6144b93 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -321,6 +321,7 @@ struct ahci_host_priv {
 	u32			em_buf_sz;	/* EM buffer size in byte */
 	u32			em_msg_type;	/* EM message type */
 	struct clk		*clk;		/* Only for platforms supporting clk */
+	void			*plat_data;	/* Other platform data */
 };
 
 extern int ahci_ignore_sss;
diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
index b20aa96..5b13f12 100644
--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -33,6 +33,9 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/export.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
+
 #include "ahci.h"
 
 #define CPHY_MAP(dev, addr) ((((dev) & 0x1f) << 7) | (((addr) >> 9) & 0x7f))
@@ -66,6 +69,146 @@ struct phy_lane_info {
 };
 static struct phy_lane_info port_data[CPHY_PORT_COUNT];
 
+static DEFINE_SPINLOCK(sgpio_lock);
+#define SCLOCK				0
+#define SLOAD				1
+#define SDATA				2
+#define SGPIO_PINS			3
+#define SGPIO_PORTS			8
+
+/* can be cast as an ahci_host_priv for compatibility with most functions */
+struct ecx_plat_data {
+	u32		n_ports;
+	unsigned	sgpio_gpio[SGPIO_PINS];
+	u32		sgpio_pattern;
+	u32		port_to_sgpio[SGPIO_PORTS];
+};
+
+#define SGPIO_SIGNALS			3
+#define ECX_ACTIVITY_BITS		0x300000
+#define ECX_ACTIVITY_SHIFT		2
+#define ECX_LOCATE_BITS			0x80000
+#define ECX_LOCATE_SHIFT		1
+#define ECX_FAULT_BITS			0x400000
+#define ECX_FAULT_SHIFT			0
+static inline int sgpio_bit_shift(struct ecx_plat_data *pdata, u32 port,
+				u32 shift)
+{
+	return 1 << (3 * pdata->port_to_sgpio[port] + shift);
+}
+
+static void ecx_parse_sgpio(struct ecx_plat_data *pdata, u32 port, u32 state)
+{
+	if (state & ECX_ACTIVITY_BITS)
+		pdata->sgpio_pattern |= sgpio_bit_shift(pdata, port,
+						ECX_ACTIVITY_SHIFT);
+	else
+		pdata->sgpio_pattern &= sgpio_bit_shift(pdata, port,
+						ECX_ACTIVITY_SHIFT);
+	if (state & ECX_LOCATE_BITS)
+		pdata->sgpio_pattern |= sgpio_bit_shift(pdata, port,
+						ECX_LOCATE_SHIFT);
+	else
+		pdata->sgpio_pattern &= sgpio_bit_shift(pdata, port,
+						ECX_LOCATE_SHIFT);
+	if (state & ECX_FAULT_BITS)
+		pdata->sgpio_pattern |= sgpio_bit_shift(pdata, port,
+						ECX_FAULT_SHIFT);
+	else
+		pdata->sgpio_pattern &= sgpio_bit_shift(pdata, port,
+						ECX_FAULT_SHIFT);
+}
+
+/*
+ * Tell the LED controller that the signal has changed by raising the clock
+ * line for 50 uS and then lowering it for 50 uS.
+ */
+static void ecx_led_cycle_clock(struct ecx_plat_data *pdata)
+{
+	gpio_set_value(pdata->sgpio_gpio[SCLOCK], 1);
+	udelay(50);
+	gpio_set_value(pdata->sgpio_gpio[SCLOCK], 0);
+	udelay(50);
+}
+
+static ssize_t ecx_transmit_led_message(struct ata_port *ap, u32 state,
+					ssize_t size)
+{
+	struct ahci_host_priv *hpriv =  ap->host->private_data;
+	struct ecx_plat_data *pdata = (struct ecx_plat_data *) hpriv->plat_data;
+	struct ahci_port_priv *pp = ap->private_data;
+	unsigned long flags;
+	int pmp, i;
+	struct ahci_em_priv *emp;
+	u32 sgpio_out;
+
+	/* get the slot number from the message */
+	pmp = (state & EM_MSG_LED_PMP_SLOT) >> 8;
+	if (pmp < EM_MAX_SLOTS)
+		emp = &pp->em_priv[pmp];
+	else
+		return -EINVAL;
+
+	if (!(hpriv->em_msg_type & EM_MSG_TYPE_LED))
+		return size;
+
+	spin_lock_irqsave(&sgpio_lock, flags);
+	ecx_parse_sgpio(pdata, ap->port_no, state);
+	sgpio_out = pdata->sgpio_pattern;
+	gpio_set_value(pdata->sgpio_gpio[SLOAD], 1);
+	ecx_led_cycle_clock(pdata);
+	gpio_set_value(pdata->sgpio_gpio[SLOAD], 0);
+	/*
+	 * bit-bang out the SGPIO pattern, by consuming a bit and then
+	 * clocking it out.
+	 */
+	for (i = 0; i < (SGPIO_SIGNALS * pdata->n_ports); i++) {
+		gpio_set_value(pdata->sgpio_gpio[SDATA], sgpio_out & 1);
+		sgpio_out >>= 1;
+		ecx_led_cycle_clock(pdata);
+	}
+
+	/* save off new led state for port/slot */
+	emp->led_state = state;
+
+	spin_unlock_irqrestore(&sgpio_lock, flags);
+	return size;
+}
+
+static void highbank_set_em_messages(struct device *dev,
+					struct ahci_host_priv *hpriv,
+					struct ata_port_info *pi)
+{
+	struct device_node *np = dev->of_node;
+	struct ecx_plat_data *pdata = hpriv->plat_data;
+	int i;
+	int err;
+
+	for (i = 0; i < SGPIO_PINS; i++) {
+		err = of_get_named_gpio(np, "calxeda,sgpio-gpio", i);
+		if (IS_ERR_VALUE(err))
+			return;
+
+		pdata->sgpio_gpio[i] = err;
+		err = gpio_request(pdata->sgpio_gpio[i], "CX SGPIO");
+		if (err) {
+			pr_err("sata_highbank gpio_request %d failed: %d\n",
+					i, err);
+			return;
+		}
+		gpio_direction_output(pdata->sgpio_gpio[i], 1);
+	}
+	of_property_read_u32_array(np, "calxeda,led-order",
+						pdata->port_to_sgpio,
+						pdata->n_ports);
+
+	/* store em_loc */
+	hpriv->em_loc = 0;
+	hpriv->em_buf_sz = 4;
+	hpriv->em_msg_type = EM_MSG_TYPE_LED;
+	pi->flags |= ATA_FLAG_EM | ATA_FLAG_SW_ACTIVITY;
+}
+
 static u32 __combo_phy_reg_read(u8 sata_port, u32 addr)
 {
 	u32 data;
@@ -241,6 +384,7 @@ static int ahci_highbank_hardreset(struct ata_link *link, unsigned int *class,
 static struct ata_port_operations ahci_highbank_ops = {
 	.inherits		= &ahci_ops,
 	.hardreset		= ahci_highbank_hardreset,
+	.transmit_led_message   = ecx_transmit_led_message,
 };
 
 static const struct ata_port_info ahci_highbank_port_info = {
@@ -264,12 +408,13 @@ static int ahci_highbank_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ahci_host_priv *hpriv;
+	struct ecx_plat_data *pdata;
 	struct ata_host *host;
 	struct resource *mem;
 	int irq;
-	int n_ports;
 	int i;
 	int rc;
+	u32 n_ports;
 	struct ata_port_info pi = ahci_highbank_port_info;
 	const struct ata_port_info *ppi[] = { &pi, NULL };
 
@@ -290,6 +435,11 @@ static int ahci_highbank_probe(struct platform_device *pdev)
 		dev_err(dev, "can't alloc ahci_host_priv\n");
 		return -ENOMEM;
 	}
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		dev_err(dev, "can't alloc ecx_plat_data\n");
+		return -ENOMEM;
+	}
 
 	hpriv->flags |= (unsigned long)pi.private_data;
 
@@ -313,8 +463,6 @@ static int ahci_highbank_probe(struct platform_device *pdev)
 	if (hpriv->cap & HOST_CAP_PMP)
 		pi.flags |= ATA_FLAG_PMP;
 
-	ahci_set_em_messages(hpriv, &pi);
-
 	/* CAP.NP sometimes indicate the index of the last enabled
 	 * port, at other times, that of the last possible port, so
 	 * determining the maximum port number requires looking at
@@ -322,6 +470,10 @@ static int ahci_highbank_probe(struct platform_device *pdev)
 	 */
 	n_ports = max(ahci_nr_ports(hpriv->cap), fls(hpriv->port_map));
 
+	pdata->n_ports = n_ports;
+	hpriv->plat_data = pdata;
+	highbank_set_em_messages(dev, hpriv, &pi);
+
 	host = ata_host_alloc_pinfo(dev, ppi, n_ports);
 	if (!host) {
 		rc = -ENOMEM;
@@ -333,9 +485,6 @@ static int ahci_highbank_probe(struct platform_device *pdev)
 	if (!(hpriv->cap & HOST_CAP_SSS) || ahci_ignore_sss)
 		host->flags |= ATA_HOST_PARALLEL_SCAN;
 
-	if (pi.flags & ATA_FLAG_EM)
-		ahci_reset_em(host);
-
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 
-- 
1.8.1.4

