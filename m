Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaC1Hl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 03:41:59 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:46996
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751126AbaC1Hlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 03:41:42 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zze0eahzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzdchz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
From: Zhao Qiang <B45475@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <B07421@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <mugunthanvnm@ti.com>, <zonque@gmail.com>,
        <helmut.schaa@googlemail.com>, <R63061@freescale.com>,
        Zhao Qiang <B45475@freescale.com>
Subject: [PATCH v2] phy/at8031: enable at8031 to work on interrupt mode
Date: Fri, 28 Mar 2014 15:39:41 +0800
Message-ID: <1395992381-23094-1-git-send-email-B45475@freescale.com>
X-Mailer: git-send-email 1.8.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The at8031 can work on polling mode and interrupt mode.
Add ack_interrupt and config intr funcs to enable
interrupt mode for it.

Signed-off-by: Zhao Qiang <B45475@freescale.com>
---
changes for v2:
	- when interrupt is not enabled, write 0 to interrupt enbale register
	- delete a inner parens not needed
 drivers/net/phy/at803x.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index bc71947..643464d 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -27,6 +27,9 @@
 #define AT803X_MMD_ACCESS_CONTROL		0x0D
 #define AT803X_MMD_ACCESS_CONTROL_DATA		0x0E
 #define AT803X_FUNC_DATA			0x4003
+#define AT803X_INER				0x0012
+#define AT803X_INER_INIT			0xec00
+#define AT803X_INSR				0x0013
 #define AT803X_DEBUG_ADDR			0x1D
 #define AT803X_DEBUG_DATA			0x1E
 #define AT803X_DEBUG_SYSTEM_MODE_CTRL		0x05
@@ -191,6 +194,31 @@ static int at803x_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static int at803x_ack_interrupt(struct phy_device *phydev)
+{
+	int err;
+
+	err = phy_read(phydev, AT803X_INSR);
+
+	return (err < 0) ? err : 0;
+}
+
+static int at803x_config_intr(struct phy_device *phydev)
+{
+	int err;
+	int value;
+
+	value = phy_read(phydev, AT803X_INER);
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+		err = phy_write(phydev, AT803X_INER,
+				value | AT803X_INER_INIT);
+	else
+		err = phy_write(phydev, AT803X_INER, 0);
+
+	return err;
+}
+
 static struct phy_driver at803x_driver[] = {
 {
 	/* ATHEROS 8035 */
@@ -240,6 +268,8 @@ static struct phy_driver at803x_driver[] = {
 	.flags		= PHY_HAS_INTERRUPT,
 	.config_aneg	= genphy_config_aneg,
 	.read_status	= genphy_read_status,
+	.ack_interrupt  = &at803x_ack_interrupt,
+	.config_intr    = &at803x_config_intr,
 	.driver		= {
 		.owner = THIS_MODULE,
 	},
-- 
1.8.5


