Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423204AbaDKQmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:42:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422817AbaDKQJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Markus Pargmann <mpa@pengutronix.de>, Nishanth Menon <nm@ti.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 38/65] net: micrel : ks8851-ml: add vdd-supply support
Date: Fri, 11 Apr 2014 09:11:10 -0700
Message-Id: <20140411161002.974423332@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
References: <20140411160957.714773410@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Menon <nm@ti.com>

[ Upstream commit ebf4ad955d3e26d4d2a33709624fc7b5b9d3b969 ]

Few platforms use external regulator to keep the ethernet MAC supplied.
So, request and enable the regulator for driver functionality.

Fixes: 66fda75f47dc (regulator: core: Replace direct ops->disable usage)
Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
Suggested-by: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/net/micrel-ks8851.txt |    1 
 drivers/net/ethernet/micrel/ks8851.c                    |   30 +++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/net/micrel-ks8851.txt
+++ b/Documentation/devicetree/bindings/net/micrel-ks8851.txt
@@ -7,3 +7,4 @@ Required properties:
 
 Optional properties:
 - local-mac-address : Ethernet mac address to use
+- vdd-supply:	supply for Ethernet mac
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -23,6 +23,7 @@
 #include <linux/crc32.h>
 #include <linux/mii.h>
 #include <linux/eeprom_93cx6.h>
+#include <linux/regulator/consumer.h>
 
 #include <linux/spi/spi.h>
 
@@ -83,6 +84,7 @@ union ks8851_tx_hdr {
  * @rc_rxqcr: Cached copy of KS_RXQCR.
  * @eeprom_size: Companion eeprom size in Bytes, 0 if no eeprom
  * @eeprom: 93CX6 EEPROM state for accessing on-board EEPROM.
+ * @vdd_reg:	Optional regulator supplying the chip
  *
  * The @lock ensures that the chip is protected when certain operations are
  * in progress. When the read or write packet transfer is in progress, most
@@ -130,6 +132,7 @@ struct ks8851_net {
 	struct spi_transfer	spi_xfer2[2];
 
 	struct eeprom_93cx6	eeprom;
+	struct regulator	*vdd_reg;
 };
 
 static int msg_enable;
@@ -1414,6 +1417,21 @@ static int ks8851_probe(struct spi_devic
 	ks->spidev = spi;
 	ks->tx_space = 6144;
 
+	ks->vdd_reg = regulator_get_optional(&spi->dev, "vdd");
+	if (IS_ERR(ks->vdd_reg)) {
+		ret = PTR_ERR(ks->vdd_reg);
+		if (ret == -EPROBE_DEFER)
+			goto err_reg;
+	} else {
+		ret = regulator_enable(ks->vdd_reg);
+		if (ret) {
+			dev_err(&spi->dev, "regulator enable fail: %d\n",
+				ret);
+			goto err_reg_en;
+		}
+	}
+
+
 	mutex_init(&ks->lock);
 	spin_lock_init(&ks->statelock);
 
@@ -1508,8 +1526,14 @@ static int ks8851_probe(struct spi_devic
 err_netdev:
 	free_irq(ndev->irq, ks);
 
-err_id:
 err_irq:
+err_id:
+	if (!IS_ERR(ks->vdd_reg))
+		regulator_disable(ks->vdd_reg);
+err_reg_en:
+	if (!IS_ERR(ks->vdd_reg))
+		regulator_put(ks->vdd_reg);
+err_reg:
 	free_netdev(ndev);
 	return ret;
 }
@@ -1523,6 +1547,10 @@ static int ks8851_remove(struct spi_devi
 
 	unregister_netdev(priv->netdev);
 	free_irq(spi->irq, priv);
+	if (!IS_ERR(priv->vdd_reg)) {
+		regulator_disable(priv->vdd_reg);
+		regulator_put(priv->vdd_reg);
+	}
 	free_netdev(priv->netdev);
 
 	return 0;


