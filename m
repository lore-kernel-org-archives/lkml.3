Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179Ab3HNSXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:23:38 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:43955 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754413Ab3HNSXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:23:35 -0400
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, tj@kernel.org,
        devicetree@vger.kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob.herring@calxeda.com, sergei.shtylyov@cogentembedded.com
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: [PATCH v4 2/3] sata, highbank: set tx_atten override bits
Date: Wed, 14 Aug 2013 13:23:31 -0500
Message-Id: <1376504612-17340-2-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376504612-17340-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1374851518-4802-1-git-send-email-mark.langsdorf@calxeda.com>
 <1376504612-17340-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some board designs do not drive the SATA transmit lines within the
specification. The ECME can provide override settings, on a per board
basis, to bring the transmit lines within spec. Read those settings
from the DTB and program them in.

At the time of submission, no production hardware requires this patch.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
---
Changes from v3
	Edited the commit message to describe the hardware impact.
	Renumbered the patch series since the first two got accepted.
Changes from v2
	None.
Changes from v1
	Clarified that the array is a u32 array.
	Added an example in the bindings.

 .../devicetree/bindings/ata/sata_highbank.txt      |  4 ++
 drivers/ata/sata_highbank.c                        | 58 +++++++++++++++++-----
 2 files changed, 49 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/ata/sata_highbank.txt b/Documentation/devicetree/bindings/ata/sata_highbank.txt
index e7a6f28..c84833e 100644
--- a/Documentation/devicetree/bindings/ata/sata_highbank.txt
+++ b/Documentation/devicetree/bindings/ata/sata_highbank.txt
@@ -20,6 +20,9 @@ Optional properties:
 			indicator lights using the indicated GPIOs
 - calxeda,led-order : a u32 array that map port numbers to offsets within the
 			SGPIO bitstream.
+- calxeda,tx-atten  : a u32 array that contains TX attenuation override
+			codes, one per port. The upper 3 bytes are always
+			0 and thus ignored.
 
 Example:
         sata@ffe08000 {
@@ -31,4 +34,5 @@ Example:
 					&combophy0 2 &combophy0 3>;
 		calxeda,sgpio-gpio =<&gpioh 5 1 &gpioh 6 1 &gpioh 7 1>;
 		calxeda,led-order = <4 0 1 2 3>;
+		calxeda,tx-atten = <0xff 22 0xff 0xff 23>;
         };
diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
index 8b40025..a7c8038 100644
--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -46,14 +46,19 @@
 #define CR_BUSY				0x0001
 #define CR_START			0x0001
 #define CR_WR_RDN			0x0002
+#define CPHY_TX_INPUT_STS		0x2001
 #define CPHY_RX_INPUT_STS		0x2002
-#define CPHY_SATA_OVERRIDE	 	0x4000
-#define CPHY_OVERRIDE			0x2005
+#define CPHY_SATA_TX_OVERRIDE		0x8000
+#define CPHY_SATA_RX_OVERRIDE	 	0x4000
+#define CPHY_TX_OVERRIDE		0x2004
+#define CPHY_RX_OVERRIDE		0x2005
 #define SPHY_LANE			0x100
 #define SPHY_HALF_RATE			0x0001
 #define CPHY_SATA_DPLL_MODE		0x0700
 #define CPHY_SATA_DPLL_SHIFT		8
 #define CPHY_SATA_DPLL_RESET		(1 << 11)
+#define CPHY_SATA_TX_ATTEN		0x1c00
+#define CPHY_SATA_TX_ATTEN_SHIFT	10
 #define CPHY_PHY_COUNT			6
 #define CPHY_LANE_COUNT			4
 #define CPHY_PORT_COUNT			(CPHY_PHY_COUNT * CPHY_LANE_COUNT)
@@ -66,6 +71,7 @@ struct phy_lane_info {
 	void __iomem *phy_base;
 	u8 lane_mapping;
 	u8 phy_devs;
+	u8 tx_atten;
 };
 static struct phy_lane_info port_data[CPHY_PORT_COUNT];
 
@@ -76,7 +82,6 @@ static DEFINE_SPINLOCK(sgpio_lock);
 #define SGPIO_PINS			3
 #define SGPIO_PORTS			8
 
-/* can be cast as an ahci_host_priv for compatibility with most functions */
 struct ecx_plat_data {
 	u32		n_ports;
 	unsigned	sgpio_gpio[SGPIO_PINS];
@@ -259,8 +264,27 @@ static void highbank_cphy_disable_overrides(u8 sata_port)
 	if (unlikely(port_data[sata_port].phy_base == NULL))
 		return;
 	tmp = combo_phy_read(sata_port, CPHY_RX_INPUT_STS + lane * SPHY_LANE);
-	tmp &= ~CPHY_SATA_OVERRIDE;
-	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
+	tmp &= ~CPHY_SATA_RX_OVERRIDE;
+	combo_phy_write(sata_port, CPHY_RX_OVERRIDE + lane * SPHY_LANE, tmp);
+}
+
+static void cphy_override_tx_attenuation(u8 sata_port, u32 val)
+{
+	u8 lane = port_data[sata_port].lane_mapping;
+	u32 tmp;
+
+	if (val & 0x8)
+		return;
+
+	tmp = combo_phy_read(sata_port, CPHY_TX_INPUT_STS + lane * SPHY_LANE);
+	tmp &= ~CPHY_SATA_TX_OVERRIDE;
+	combo_phy_write(sata_port, CPHY_TX_OVERRIDE + lane * SPHY_LANE, tmp);
+
+	tmp |= CPHY_SATA_TX_OVERRIDE;
+	combo_phy_write(sata_port, CPHY_TX_OVERRIDE + lane * SPHY_LANE, tmp);
+
+	tmp |= (val << CPHY_SATA_TX_ATTEN_SHIFT) & CPHY_SATA_TX_ATTEN;
+	combo_phy_write(sata_port, CPHY_TX_OVERRIDE + lane * SPHY_LANE, tmp);
 }
 
 static void cphy_override_rx_mode(u8 sata_port, u32 val)
@@ -268,21 +292,21 @@ static void cphy_override_rx_mode(u8 sata_port, u32 val)
 	u8 lane = port_data[sata_port].lane_mapping;
 	u32 tmp;
 	tmp = combo_phy_read(sata_port, CPHY_RX_INPUT_STS + lane * SPHY_LANE);
-	tmp &= ~CPHY_SATA_OVERRIDE;
-	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
+	tmp &= ~CPHY_SATA_RX_OVERRIDE;
+	combo_phy_write(sata_port, CPHY_RX_OVERRIDE + lane * SPHY_LANE, tmp);
 
-	tmp |= CPHY_SATA_OVERRIDE;
-	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
+	tmp |= CPHY_SATA_RX_OVERRIDE;
+	combo_phy_write(sata_port, CPHY_RX_OVERRIDE + lane * SPHY_LANE, tmp);
 
 	tmp &= ~CPHY_SATA_DPLL_MODE;
 	tmp |= val << CPHY_SATA_DPLL_SHIFT;
-	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
+	combo_phy_write(sata_port, CPHY_RX_OVERRIDE + lane * SPHY_LANE, tmp);
 
 	tmp |= CPHY_SATA_DPLL_RESET;
-	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
+	combo_phy_write(sata_port, CPHY_RX_OVERRIDE + lane * SPHY_LANE, tmp);
 
 	tmp &= ~CPHY_SATA_DPLL_RESET;
-	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
+	combo_phy_write(sata_port, CPHY_RX_OVERRIDE + lane * SPHY_LANE, tmp);
 
 	msleep(15);
 }
@@ -299,16 +323,20 @@ static void highbank_cphy_override_lane(u8 sata_port)
 						lane * SPHY_LANE);
 	} while ((tmp & SPHY_HALF_RATE) && (k++ < 1000));
 	cphy_override_rx_mode(sata_port, 3);
+	cphy_override_tx_attenuation(sata_port, port_data[sata_port].tx_atten);
 }
 
 static int highbank_initialize_phys(struct device *dev, void __iomem *addr)
 {
 	struct device_node *sata_node = dev->of_node;
-	int phy_count = 0, phy, port = 0;
+	int phy_count = 0, phy, port = 0, i;
 	void __iomem *cphy_base[CPHY_PHY_COUNT];
 	struct device_node *phy_nodes[CPHY_PHY_COUNT];
+	u32 tx_atten[CPHY_PORT_COUNT];
+
 	memset(port_data, 0, sizeof(struct phy_lane_info) * CPHY_PORT_COUNT);
 	memset(phy_nodes, 0, sizeof(struct device_node*) * CPHY_PHY_COUNT);
+	memset(tx_atten, 0xff, CPHY_PORT_COUNT);
 
 	do {
 		u32 tmp;
@@ -336,6 +364,10 @@ static int highbank_initialize_phys(struct device *dev, void __iomem *addr)
 		of_node_put(phy_data.np);
 		port += 1;
 	} while (port < CPHY_PORT_COUNT);
+	of_property_read_u32_array(sata_node, "calxeda,tx-atten",
+				tx_atten, port);
+	for (i = 0; i < port; i++)
+		port_data[i].tx_atten = (u8) tx_atten[i];
 	return 0;
 }
 
-- 
1.8.1.2

