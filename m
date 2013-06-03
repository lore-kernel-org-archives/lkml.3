Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab3FCNfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:35:40 -0400
Received: from smtp105.ord1c.emailsrvr.com ([108.166.43.105]:36829 "EHLO
	smtp105.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754036Ab3FCNfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:35:36 -0400
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, tj@kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: [PATCH 2/2 v2] sata highbank: add bit-banged SGPIO driver support
Date: Mon,  3 Jun 2013 08:35:38 -0500
Message-Id: <1370266538-14211-1-git-send-email-mark.langsdorf@calxeda.com>
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
Changes from v1:
	Moved all global variables to a private structure
	Replaced all magic numbers with defined symbols
	Added some comments
	Removed the default ordering of ports to LEDs
	Fixed several bugs the code to read led-order
	Made highbank_set_em_messages static

 .../devicetree/bindings/ata/ahci-platform.txt      |   5 +
 arch/arm/boot/dts/ecx-common.dtsi                  |   2 +
 drivers/ata/sata_highbank.c                        | 167 +++++++++++++++++++--
 3 files changed, 165 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt b/Documentation/devicetree/bindings/ata/ahci-platform.txt
index b519f9b..b271712 100644
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
diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
index b20aa96..64f2acf 100644
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
@@ -66,6 +69,154 @@ struct phy_lane_info {
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
+struct ecx_host_priv {
+	void __iomem	*mmio;		/* bus-independent mem map */
+	unsigned int	flags;		/* AHCI_HFLAG_* */
+	u32		cap;		/* cap to use */
+	u32		cap2;		/* cap2 to use */
+	u32		port_map;	/* port map to use */
+	u32		saved_cap;	/* saved initial cap */
+	u32		saved_cap2;	/* saved initial cap2 */
+	u32		saved_port_map;	/* saved initial port_map */
+	u32		em_loc;		/* enclosure management location */
+	u32		em_buf_sz;      /* EM buffer size in byte */
+	u32		em_msg_type;    /* EM message type */
+	struct clk	*clk;		/* Only for platforms supporting clk */
+	u32		n_ports;
+	unsigned	sgpio_gpio[SGPIO_PINS];
+	u32		sgpio_pattern;
+	u32		port_to_sgpio[SGPIO_PORTS];
+};
+
+#define SGPIO_SIGNALS			3
+#define ECX_ACTIVITY_BITS		0x300000
+#define ECX_ACTIVITY_SHIFT		2
+#define ECX_LOCATE_BITS		0x80000
+#define ECX_LOCATE_SHIFT		1
+#define ECX_FAULT_BITS			0x400000
+#define ECX_FAULT_SHIFT			0
+static inline int sgpio_bit_shift(struct ecx_host_priv *hpriv, u32 port,
+				u32 shift)
+{
+	return 1 << (3 * hpriv->port_to_sgpio[port] + shift);
+}
+
+static void ecx_parse_sgpio(struct ecx_host_priv *hpriv, u32 port, u32 state)
+{
+	if (state == 0) {
+		hpriv->sgpio_pattern &= ~(sgpio_bit_shift(hpriv, port,
+						ECX_ACTIVITY_SHIFT) |
+			sgpio_bit_shift(hpriv, port, ECX_LOCATE_SHIFT) |
+			sgpio_bit_shift(hpriv, port, ECX_FAULT_SHIFT));
+		return;
+	}
+	if (state & ECX_ACTIVITY_BITS)
+		hpriv->sgpio_pattern |= sgpio_bit_shift(hpriv, port,
+						ECX_ACTIVITY_SHIFT);
+	if (state & ECX_LOCATE_BITS)
+		hpriv->sgpio_pattern |= sgpio_bit_shift(hpriv, port,
+						ECX_LOCATE_SHIFT);
+	if (state & ECX_FAULT_BITS)
+		hpriv->sgpio_pattern |= sgpio_bit_shift(hpriv, port,
+						ECX_FAULT_SHIFT);
+}
+
+/*
+ * Tell the LED controller that the signal has changed by raising the clock
+ * line for 50 uS and then lowering it for 50 uS.
+ */
+static void ecx_led_cycle_clock(struct ecx_host_priv *hpriv)
+{
+	gpio_set_value(hpriv->sgpio_gpio[SCLOCK], 1);
+	udelay(50);
+	gpio_set_value(hpriv->sgpio_gpio[SCLOCK], 0);
+	udelay(50);
+}
+
+static ssize_t ecx_transmit_led_message(struct ata_port *ap, u32 state,
+					ssize_t size)
+{
+	struct ecx_host_priv *hpriv = ap->host->private_data;
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
+	if (!hpriv->em_msg_type & EM_MSG_TYPE_LED)
+		return size;
+
+	spin_lock_irqsave(&sgpio_lock, flags);
+	ecx_parse_sgpio(hpriv, ap->port_no, state);
+	sgpio_out = hpriv->sgpio_pattern;
+	gpio_set_value(hpriv->sgpio_gpio[SLOAD], 1);
+	ecx_led_cycle_clock(hpriv);
+	gpio_set_value(hpriv->sgpio_gpio[SLOAD], 0);
+	/*
+	 * bit-bang out the SGPIO pattern, by consuming a bit and then
+	 * clocking it out.
+	 */
+	for (i = 0; i < (SGPIO_SIGNALS * hpriv->n_ports); i++) {
+		gpio_set_value(hpriv->sgpio_gpio[SDATA], sgpio_out & 1);
+		sgpio_out >>= 1;
+		ecx_led_cycle_clock(hpriv);
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
+					struct ecx_host_priv *hpriv,
+					struct ata_port_info *pi)
+{
+	struct device_node *np = dev->of_node;
+	int i;
+	int err;
+
+	for (i = 0; i < SGPIO_PINS; i++) {
+		err = of_get_named_gpio(np, "calxeda,sgpio-gpio", i);
+		if (IS_ERR_VALUE(err))
+			return;
+
+		hpriv->sgpio_gpio[i] = err;
+		err = gpio_request(hpriv->sgpio_gpio[i], "CX SGPIO");
+		if (err) {
+			pr_err("sata_highbank gpio_request %d failed: %d\n",
+					i, err);
+			return;
+		}
+		gpio_direction_output(hpriv->sgpio_gpio[i], 1);
+	}
+	of_property_read_u32_array(np, "calxeda,led-order",
+						hpriv->port_to_sgpio,
+						hpriv->n_ports);
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
@@ -241,6 +392,7 @@ static int ahci_highbank_hardreset(struct ata_link *link, unsigned int *class,
 static struct ata_port_operations ahci_highbank_ops = {
 	.inherits		= &ahci_ops,
 	.hardreset		= ahci_highbank_hardreset,
+	.transmit_led_message   = ecx_transmit_led_message,
 };
 
 static const struct ata_port_info ahci_highbank_port_info = {
@@ -263,13 +415,13 @@ MODULE_DEVICE_TABLE(of, ahci_of_match);
 static int ahci_highbank_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct ahci_host_priv *hpriv;
+	struct ecx_host_priv *hpriv;
 	struct ata_host *host;
 	struct resource *mem;
 	int irq;
-	int n_ports;
 	int i;
 	int rc;
+	u32 n_ports;
 	struct ata_port_info pi = ahci_highbank_port_info;
 	const struct ata_port_info *ppi[] = { &pi, NULL };
 
@@ -303,8 +455,7 @@ static int ahci_highbank_probe(struct platform_device *pdev)
 	if (rc)
 		return rc;
 
-
-	ahci_save_initial_config(dev, hpriv, 0, 0);
+	ahci_save_initial_config(dev, (struct ahci_host_priv *) hpriv, 0, 0);
 
 	/* prepare host */
 	if (hpriv->cap & HOST_CAP_NCQ)
@@ -313,8 +464,6 @@ static int ahci_highbank_probe(struct platform_device *pdev)
 	if (hpriv->cap & HOST_CAP_PMP)
 		pi.flags |= ATA_FLAG_PMP;
 
-	ahci_set_em_messages(hpriv, &pi);
-
 	/* CAP.NP sometimes indicate the index of the last enabled
 	 * port, at other times, that of the last possible port, so
 	 * determining the maximum port number requires looking at
@@ -322,6 +471,9 @@ static int ahci_highbank_probe(struct platform_device *pdev)
 	 */
 	n_ports = max(ahci_nr_ports(hpriv->cap), fls(hpriv->port_map));
 
+	hpriv->n_ports = n_ports;
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

