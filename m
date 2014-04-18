Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbaDRJbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:31:16 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45986 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752354AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nishanth Menon <nm@ti.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 53/72] net: micrel : ks8851-ml: add vdd-supply support
Date: Fri, 18 Apr 2014 11:22:26 +0200
Message-Id: <d8496cba73e6eb7f5fd36adbd3dbaf348bbe0ef2.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit ebf4ad955d3e26d4d2a33709624fc7b5b9d3b969 ]

Few platforms use external regulator to keep the ethernet MAC supplied.
So, request and enable the regulator for driver functionality.

Fixes: 66fda75f47dc (regulator: core: Replace direct ops->disable usage)
Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
Suggested-by: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 .../devicetree/bindings/net/micrel-ks8851.txt      |  1 +
 drivers/net/ethernet/micrel/ks8851.c               | 30 +++++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/micrel-ks8851.txt b/Documentation/devicetree/bindings/net/micrel-ks8851.txt
index 11ace3c3d805..4fc392763611 100644
--- a/Documentation/devicetree/bindings/net/micrel-ks8851.txt
+++ b/Documentation/devicetree/bindings/net/micrel-ks8851.txt
@@ -7,3 +7,4 @@ Required properties:
 
 Optional properties:
 - local-mac-address : Ethernet mac address to use
+- vdd-supply:	supply for Ethernet mac
diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 727b546a9eb8..e0c92e0e5e1d 100644
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
@@ -1414,6 +1417,21 @@ static int ks8851_probe(struct spi_device *spi)
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
 
@@ -1508,8 +1526,14 @@ static int ks8851_probe(struct spi_device *spi)
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
@@ -1523,6 +1547,10 @@ static int ks8851_remove(struct spi_device *spi)
 
 	unregister_netdev(priv->netdev);
 	free_irq(spi->irq, priv);
+	if (!IS_ERR(priv->vdd_reg)) {
+		regulator_disable(priv->vdd_reg);
+		regulator_put(priv->vdd_reg);
+	}
 	free_netdev(priv->netdev);
 
 	return 0;
-- 
1.9.2

