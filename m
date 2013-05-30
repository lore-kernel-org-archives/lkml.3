Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364Ab3E3UR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 16:17:59 -0400
Received: from smtp89.ord1c.emailsrvr.com ([108.166.43.89]:56615 "EHLO
	smtp89.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757876Ab3E3URk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 16:17:40 -0400
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, tj@kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: [PATCH 2/2] sata highbank: add bit-banged SGPIO driver support
Date: Thu, 30 May 2013 15:17:31 -0500
Message-Id: <1369945051-2582-2-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369945051-2582-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1369945051-2582-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Highbank supports SGPIO by bit-banging out the SGPIO signals over
three GPIO pins defined in the DTB. Add support for this SGPIO
functionality.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
---
 .../devicetree/bindings/ata/ahci-platform.txt      |   9 ++
 arch/arm/boot/dts/ecx-common.dtsi                  |   1 +
 drivers/ata/sata_highbank.c                        | 128 ++++++++++++++++++++-
 3 files changed, 133 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt b/Documentation/devicetree/bindings/ata/ahci-platform.txt
index b519f9b..123b7ae 100644
--- a/Documentation/devicetree/bindings/ata/ahci-platform.txt
+++ b/Documentation/devicetree/bindings/ata/ahci-platform.txt
@@ -12,6 +12,15 @@ Optional properties:
 - calxeda,port-phys: phandle-combophy and lane assignment, which maps each
 			SATA port to a combophy and a lane within that
 			combophy
+- calxeda,sgpio-gpio: phandle-gpio bank, bit offset, and default on or off,
+			which indicates that the driver supports SGPIO 
+			indicator lights using the indicated GPIOs
+- calxeda,led-order : a u32 array that map port numbers to offsets within the
+			SGPIO bitstream. By default, port 0 has offset 4
+			and the other ports are offset by their port number
+			less 1. if calxeda,sgpio-gpio is used and that port
+			to led mapping is incorrect, this array should have
+			each port's offset within the bitstream.
 - dma-coherent      : Present if dma operations are coherent
 
 Example:
diff --git a/arch/arm/boot/dts/ecx-common.dtsi b/arch/arm/boot/dts/ecx-common.dtsi
index d61b535..8c1d643 100644
--- a/arch/arm/boot/dts/ecx-common.dtsi
+++ b/arch/arm/boot/dts/ecx-common.dtsi
@@ -33,6 +33,7 @@
 			calxeda,port-phys = <&combophy5 0 &combophy0 0
 					     &combophy0 1 &combophy0 2
 					     &combophy0 3>;
+			calxeda,sgpio-gpio =<&gpioh 5 1 &gpioh 6 1 &gpioh 7 1>;
 		};
 
 		sdhci@ffe0e000 {
diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
index b20aa96..d48f708 100644
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
@@ -66,6 +69,124 @@ struct phy_lane_info {
 };
 static struct phy_lane_info port_data[CPHY_PORT_COUNT];
 
+static DEFINE_SPINLOCK(sgpio_lock);
+#define SCLOCK				0
+#define SLOAD				1
+#define SDATA				2
+static unsigned ecx_sgpio[3];
+static unsigned long ecx_sgpio_pattern;
+static int port_to_sgpio[] = { 4, 0, 1, 2, 3};
+static int n_ports;
+
+#define ACTIVITY_BITS			0x300000 // 0x7
+#define ACTIVITY_SHIFT			2
+#define LOCATE_BITS 			0x80000  // 0x38
+#define LOCATE_SHIFT			1
+#define FAULT_BITS 			0x400000 // 0x1c0
+#define FAULT_SHIFT			1
+#define SGPIO_BIT(port, shift)		1 << (3 * port_to_sgpio[(port)] + \
+							(shift))
+static void ecx_parse_sgpio(u32 port, u32 state)
+{
+	if (state == 0) {
+		ecx_sgpio_pattern &= ~(SGPIO_BIT(port, ACTIVITY_SHIFT) |
+					SGPIO_BIT(port, LOCATE_SHIFT) |
+					SGPIO_BIT(port, FAULT_SHIFT));
+		return;
+	}
+	if (state & ACTIVITY_BITS)
+		ecx_sgpio_pattern |= SGPIO_BIT(port, ACTIVITY_SHIFT);
+	if (state & LOCATE_BITS)
+		ecx_sgpio_pattern |= SGPIO_BIT(port, LOCATE_SHIFT);
+	if (state & FAULT_BITS)
+		ecx_sgpio_pattern |= SGPIO_BIT(port, FAULT_SHIFT);
+}
+
+/*
+ * Tell the LED controller that the signal has changed by raising the clock
+ * line for 50 uS and then lowering it for 50 uS.
+ */
+static void ecx_led_cycle_clock(void)
+{
+       gpio_set_value(ecx_sgpio[SCLOCK], 1);
+       udelay(50);
+       gpio_set_value(ecx_sgpio[SCLOCK], 0);
+       udelay(50);
+}
+
+static ssize_t ecx_transmit_led_message(struct ata_port *ap, u32 state,
+					ssize_t size)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
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
+	ecx_parse_sgpio(ap->port_no, state);
+	sgpio_out = ecx_sgpio_pattern;
+	gpio_set_value(ecx_sgpio[SLOAD], 1);
+	ecx_led_cycle_clock();
+	gpio_set_value(ecx_sgpio[SLOAD], 0);
+	for (i = 0; i < (3 * n_ports); i++) {
+		gpio_set_value(ecx_sgpio[SDATA], sgpio_out & 1);
+		sgpio_out >>= 1;
+		ecx_led_cycle_clock();
+	}
+
+	/* save off new led state for port/slot */
+	emp->led_state = state;
+
+	spin_unlock_irqrestore(&sgpio_lock, flags);
+	return size;
+}
+
+void highbank_set_em_messages(struct device *dev, struct ahci_host_priv *hpriv,
+			  struct ata_port_info *pi)
+{
+	struct device_node *np = dev->of_node;
+	int i;
+	int err;
+
+	for (i = 0;i < 3; i++) {
+		ecx_sgpio[i] = of_get_named_gpio(np, "calxeda,sgpio-gpio", i);
+		if (IS_ERR_VALUE(ecx_sgpio[i]))
+		       return;
+
+	        err = gpio_request(ecx_sgpio[i], "CX SGPIO");
+		if (err) {
+			printk(KERN_ERR
+				"sata_highbank gpio_request %d failed: %d\n",
+					i, err);
+		                return;
+		}
+		gpio_direction_output(ecx_sgpio[i], 1);
+	}
+	/* there's a default ordering, but give it an optional override */
+	for (i = 0; i < n_ports; i++) {
+		of_property_read_u32_array(np, "calxeda,led-order", 
+						port_to_sgpio, i);
+	}
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
@@ -241,6 +362,7 @@ static int ahci_highbank_hardreset(struct ata_link *link, unsigned int *class,
 static struct ata_port_operations ahci_highbank_ops = {
 	.inherits		= &ahci_ops,
 	.hardreset		= ahci_highbank_hardreset,
+	.transmit_led_message   = ecx_transmit_led_message,
 };
 
 static const struct ata_port_info ahci_highbank_port_info = {
@@ -267,7 +389,6 @@ static int ahci_highbank_probe(struct platform_device *pdev)
 	struct ata_host *host;
 	struct resource *mem;
 	int irq;
-	int n_ports;
 	int i;
 	int rc;
 	struct ata_port_info pi = ahci_highbank_port_info;
@@ -313,7 +434,7 @@ static int ahci_highbank_probe(struct platform_device *pdev)
 	if (hpriv->cap & HOST_CAP_PMP)
 		pi.flags |= ATA_FLAG_PMP;
 
-	ahci_set_em_messages(hpriv, &pi);
+	highbank_set_em_messages(dev, hpriv, &pi);
 
 	/* CAP.NP sometimes indicate the index of the last enabled
 	 * port, at other times, that of the last possible port, so
@@ -333,9 +454,6 @@ static int ahci_highbank_probe(struct platform_device *pdev)
 	if (!(hpriv->cap & HOST_CAP_SSS) || ahci_ignore_sss)
 		host->flags |= ATA_HOST_PARALLEL_SCAN;
 
-	if (pi.flags & ATA_FLAG_EM)
-		ahci_reset_em(host);
-
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 
-- 
1.8.1.4

