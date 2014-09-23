Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaIWCiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:38:52 -0400
Received: from mail.kernel.org ([198.145.19.201]:38107 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbaIWCiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:38:51 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mark Einon <mark.einon@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 18/45] staging: et131x: Fix errors caused by phydev->addr accesses before initialisation
Date: Tue, 23 Sep 2014 10:31:20 +0800
Message-Id: <1411439507-30391-18-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Einon <mark.einon@gmail.com>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit ec0a38bf8b28b036202070cf3ef271e343d9eafc upstream.

Fix two reported bugs, caused by et131x_adapter->phydev->addr being accessed
before it is initialised, by:

- letting et131x_mii_write() take a phydev address, instead of using the one
  stored in adapter by default. This is so et131x_mdio_write() can use it's own
  addr value.
- removing implementation of et131x_mdio_reset(), as it's not needed.
- moving a call to et131x_disable_phy_coma() in et131x_pci_setup(), which uses
  phydev->addr, until after the mdiobus has been registered.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=80751
Link: https://bugzilla.kernel.org/show_bug.cgi?id=77121
Signed-off-by: Mark Einon <mark.einon@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[lizf: Backported to 3.4:
- adjust context
- update more update more et131x_mii_write() calls in
  et1310_phy_access_mii_bit() and et131x_xcvr_init()]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/staging/et131x/et131x.c |   78 +++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 886f565..6a271e9 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -1478,22 +1478,16 @@ static int et131x_mii_read(struct et131x_adapter *adapter, u8 reg, u16 *value)
  *
  * Return 0 on success, errno on failure (as defined in errno.h)
  */
-static int et131x_mii_write(struct et131x_adapter *adapter, u8 reg, u16 value)
+static int et131x_mii_write(struct et131x_adapter *adapter, u8 addr, u8 reg,
+			    u16 value)
 {
 	struct mac_regs __iomem *mac = &adapter->regs->mac;
-	struct phy_device *phydev = adapter->phydev;
 	int status = 0;
-	u8 addr;
 	u32 delay = 0;
 	u32 mii_addr;
 	u32 mii_cmd;
 	u32 mii_indicator;
 
-	if (!phydev)
-		return -EIO;
-
-	addr = phydev->addr;
-
 	/* Save a local copy of the registers we are dealing with so we can
 	 * set them back
 	 */
@@ -1550,6 +1544,7 @@ static void et1310_phy_access_mii_bit(struct et131x_adapter *adapter,
 {
 	u16 reg;
 	u16 mask = 0x0001 << bitnum;
+	struct  phy_device *phydev = adapter->phydev;
 
 	/* Read the requested register */
 	et131x_mii_read(adapter, regnum, &reg);
@@ -1560,11 +1555,11 @@ static void et1310_phy_access_mii_bit(struct et131x_adapter *adapter,
 		break;
 
 	case TRUEPHY_BIT_SET:
-		et131x_mii_write(adapter, regnum, reg | mask);
+		et131x_mii_write(adapter, phydev->addr, regnum, reg | mask);
 		break;
 
 	case TRUEPHY_BIT_CLEAR:
-		et131x_mii_write(adapter, regnum, reg & ~mask);
+		et131x_mii_write(adapter, phydev->addr, regnum, reg & ~mask);
 		break;
 
 	default:
@@ -1715,17 +1710,7 @@ static int et131x_mdio_write(struct mii_bus *bus, int phy_addr, int reg, u16 val
 	struct net_device *netdev = bus->priv;
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 
-	return et131x_mii_write(adapter, reg, value);
-}
-
-static int et131x_mdio_reset(struct mii_bus *bus)
-{
-	struct net_device *netdev = bus->priv;
-	struct et131x_adapter *adapter = netdev_priv(netdev);
-
-	et131x_mii_write(adapter, MII_BMCR, BMCR_RESET);
-
-	return 0;
+	return et131x_mii_write(adapter, phy_addr, reg, value);
 }
 
 /**
@@ -1741,12 +1726,13 @@ static int et131x_mdio_reset(struct mii_bus *bus)
 static void et1310_phy_power_down(struct et131x_adapter *adapter, bool down)
 {
 	u16 data;
+	struct  phy_device *phydev = adapter->phydev;
 
 	et131x_mii_read(adapter, MII_BMCR, &data);
 	data &= ~BMCR_PDOWN;
 	if (down)
 		data |= BMCR_PDOWN;
-	et131x_mii_write(adapter, MII_BMCR, data);
+	et131x_mii_write(adapter, phydev->addr, MII_BMCR, data);
 }
 
 /**
@@ -1759,6 +1745,7 @@ static void et131x_xcvr_init(struct et131x_adapter *adapter)
 	u16 imr;
 	u16 isr;
 	u16 lcr2;
+	struct  phy_device *phydev = adapter->phydev;
 
 	et131x_mii_read(adapter, PHY_INTERRUPT_STATUS, &isr);
 	et131x_mii_read(adapter, PHY_INTERRUPT_MASK, &imr);
@@ -1770,7 +1757,7 @@ static void et131x_xcvr_init(struct et131x_adapter *adapter)
 		ET_PHY_INT_MASK_LINKSTAT &
 		ET_PHY_INT_MASK_ENABLE);
 
-	et131x_mii_write(adapter, PHY_INTERRUPT_MASK, imr);
+	et131x_mii_write(adapter, phydev->addr, PHY_INTERRUPT_MASK, imr);
 
 	/* Set the LED behavior such that LED 1 indicates speed (off =
 	 * 10Mbits, blink = 100Mbits, on = 1000Mbits) and LED 2 indicates
@@ -1791,7 +1778,7 @@ static void et131x_xcvr_init(struct et131x_adapter *adapter)
 		else
 			lcr2 |= (LED_VAL_LINKON << LED_TXRX_SHIFT);
 
-		et131x_mii_write(adapter, PHY_LED_2, lcr2);
+		et131x_mii_write(adapter, phydev->addr, PHY_LED_2, lcr2);
 	}
 }
 
@@ -4202,14 +4189,14 @@ static void et131x_adjust_link(struct net_device *netdev)
 
 			et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG,
 					 &register18);
-			et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG,
-					 register18 | 0x4);
-			et131x_mii_write(adapter, PHY_INDEX_REG,
+			et131x_mii_write(adapter, phydev->addr,
+					 PHY_MPHY_CONTROL_REG, register18 | 0x4);
+			et131x_mii_write(adapter, phydev->addr, PHY_INDEX_REG,
 					 register18 | 0x8402);
-			et131x_mii_write(adapter, PHY_DATA_REG,
+			et131x_mii_write(adapter, phydev->addr, PHY_DATA_REG,
 					 register18 | 511);
-			et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG,
-					 register18);
+			et131x_mii_write(adapter, phydev->addr,
+					 PHY_MPHY_CONTROL_REG, register18);
 		}
 
 		et1310_config_flow_control(adapter);
@@ -4221,7 +4208,8 @@ static void et131x_adjust_link(struct net_device *netdev)
 			et131x_mii_read(adapter, PHY_CONFIG, &reg);
 			reg &= ~ET_PHY_CONFIG_TX_FIFO_DEPTH;
 			reg |= ET_PHY_CONFIG_FIFO_DEPTH_32;
-			et131x_mii_write(adapter, PHY_CONFIG, reg);
+			et131x_mii_write(adapter, phydev->addr, PHY_CONFIG,
+					 reg);
 		}
 
 		et131x_set_rx_dma_timer(adapter);
@@ -4254,14 +4242,17 @@ static void et131x_adjust_link(struct net_device *netdev)
 
 				et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG,
 						 &register18);
-				et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG,
-						 register18 | 0x4);
-				et131x_mii_write(adapter, PHY_INDEX_REG,
-						 register18 | 0x8402);
-				et131x_mii_write(adapter, PHY_DATA_REG,
-						 register18 | 511);
-				et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG,
-						 register18);
+				et131x_mii_write(adapter, phydev->addr,
+						PHY_MPHY_CONTROL_REG,
+						register18 | 0x4);
+				et131x_mii_write(adapter, phydev->addr,
+						PHY_INDEX_REG,
+						register18 | 0x8402);
+				et131x_mii_write(adapter, phydev->addr,
+						PHY_DATA_REG, register18 | 511);
+				et131x_mii_write(adapter, phydev->addr,
+						PHY_MPHY_CONTROL_REG,
+						register18);
 			}
 
 			/* Free the packets being actively sent & stopped */
@@ -5343,10 +5334,6 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	/* Copy address into the net_device struct */
 	memcpy(netdev->dev_addr, adapter->addr, ETH_ALEN);
 
-	/* Init variable for counting how long we do not have link status */
-	adapter->boot_coma = 0;
-	et1310_disable_phy_coma(adapter);
-
 	rc = -ENOMEM;
 
 	/* Setup the mii_bus struct */
@@ -5362,7 +5349,6 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	adapter->mii_bus->priv = netdev;
 	adapter->mii_bus->read = et131x_mdio_read;
 	adapter->mii_bus->write = et131x_mdio_write;
-	adapter->mii_bus->reset = et131x_mdio_reset;
 	adapter->mii_bus->irq = kmalloc(sizeof(int)*PHY_MAX_ADDR, GFP_KERNEL);
 	if (!adapter->mii_bus->irq) {
 		dev_err(&pdev->dev, "mii_bus irq allocation failed\n");
@@ -5387,6 +5373,10 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	/* Setup et1310 as per the documentation */
 	et131x_adapter_setup(adapter);
 
+	/* Init variable for counting how long we do not have link status */
+	adapter->boot_coma = 0;
+	et1310_disable_phy_coma(adapter);
+
 	/* We can enable interrupts now
 	 *
 	 *  NOTE - Because registration of interrupt handler is done in the
-- 
1.7.9.5

