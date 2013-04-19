Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161Ab3DSH3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 03:29:43 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:21418
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754241Ab3DSH3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 03:29:42 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Chunhe Lan <Chunhe.Lan@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <davem@davemloft.net>, Chunhe Lan <Chunhe.Lan@freescale.com>,
        Michael Johnston <michael.johnston@freescale.com>
Subject: [PATCH] net/phy: Add Atheros AR8035 PHY support
Date: Fri, 19 Apr 2013 15:33:32 +0800
Message-ID: <1366356812-18844-1-git-send-email-Chunhe.Lan@freescale.com>
X-Mailer: git-send-email 1.7.6.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AR8035 is a single port 10/100/1000 Mbps tri-speed Ethernet PHY.
It supports an RGMII interface to the MAC with wide RGMII I/O voltage
support from 1.5V to 3.3V.

Signed-off-by: Michael Johnston <michael.johnston@freescale.com>
Signed-off-by: Chunhe Lan <Chunhe.Lan@freescale.com>
---
 drivers/net/phy/Kconfig   |    5 ++
 drivers/net/phy/Makefile  |    1 +
 drivers/net/phy/atheros.c |   95 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/phy/atheros.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 4503452..c8d40d4 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -24,6 +24,11 @@ config AMD_PHY
 	---help---
 	  Currently supports the am79c874
 
+config ATHEROS_PHY
+	tristate "Drivers for Atheros PHYs"
+	---help---
+	  Currently supports the AR8035 PHY
+
 config MARVELL_PHY
 	tristate "Drivers for Marvell PHYs"
 	---help---
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 9645e38..762e77e 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -3,6 +3,7 @@
 libphy-objs			:= phy.o phy_device.o mdio_bus.o
 
 obj-$(CONFIG_PHYLIB)		+= libphy.o
+obj-$(CONFIG_ATHEROS_PHY)	+= atheros.o
 obj-$(CONFIG_MARVELL_PHY)	+= marvell.o
 obj-$(CONFIG_DAVICOM_PHY)	+= davicom.o
 obj-$(CONFIG_CICADA_PHY)	+= cicada.o
diff --git a/drivers/net/phy/atheros.c b/drivers/net/phy/atheros.c
new file mode 100644
index 0000000..9a4aa29
--- /dev/null
+++ b/drivers/net/phy/atheros.c
@@ -0,0 +1,95 @@
+/*
+ * drivers/net/phy/atheros.c
+ *
+ * Driver for Atheros PHYs
+ *
+ * Author: Michael Johnston <michael.johnston@freescale.com>
+ *	   Chunhe Lan <Chunhe.Lan@freescale.com>
+ *
+ * Copyright (c) 2013 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+#include <linux/phy.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+
+#define AR8035_PHYSR		0x0011
+#define AR8035_PHYSR_DUPLEX	0x2000
+#define AR8035_PHYSR_SPEED	0xc000
+#define AR8035_INER		0x0012
+#define AR8035_INER_INIT	0xec00
+#define AR8035_INSR		0x0013
+
+MODULE_DESCRIPTION("Atheros PHY driver");
+MODULE_AUTHOR("Michael Johnston");
+MODULE_LICENSE("GPL");
+
+static int ar8035_ack_interrupt(struct phy_device *phydev)
+{
+	int err;
+
+	err = phy_read(phydev, AR8035_INSR);
+
+	return (err < 0) ? err : 0;
+}
+
+static int ar8035_config_intr(struct phy_device *phydev)
+{
+	int err;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+		err = phy_write(phydev, AR8035_INER, AR8035_INER_INIT);
+	else
+		err = phy_write(phydev, AR8035_INER, 0);
+
+	return err;
+}
+
+/* AR8035 */
+static struct phy_driver ar8035_driver = {
+	.phy_id		= 0x004dd072,
+	.name		= "AR8035 Gigabit Ethernet",
+	.phy_id_mask	= 0x007fffff,
+	.features	= PHY_GBIT_FEATURES,
+	.flags		= PHY_HAS_INTERRUPT,
+	.config_aneg	= &genphy_config_aneg,
+	.read_status	= &genphy_read_status,
+	.ack_interrupt	= &ar8035_ack_interrupt,
+	.config_intr	= &ar8035_config_intr,
+	.driver		= {
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init atheros_init(void)
+{
+	int ret;
+
+	ret = phy_driver_register(&ar8035_driver);
+	if (ret < 0)
+		pr_warn("AR8035: phy_driver_register is error\n");
+
+	return ret;
+}
+
+static void __exit atheros_exit(void)
+{
+	phy_driver_unregister(&ar8035_driver);
+}
+
+module_init(atheros_init);
+module_exit(atheros_exit);
+
+static struct mdio_device_id __maybe_unused atheros_tbl[] = {
+	{ 0x004dd072, 0x007fffff },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(mdio, atheros_tbl);
-- 
1.7.6.5


