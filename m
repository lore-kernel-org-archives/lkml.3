Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaJMC2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:28:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45916 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbaJMC2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:28:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gwenhael Goavec-Merou <gwenhael.goavec-merou@armadeus.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.16 10/55] net: phy: smsc: move smsc_phy_config_init reset part in a soft_reset function
Date: Mon, 13 Oct 2014 04:24:24 +0200
Message-Id: <20141013022444.173187131@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022443.729870634@linuxfoundation.org>
References: <20141013022443.729870634@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gwenhael Goavec-Merou <gwenhael.goavec-merou@armadeus.com>

[ Upstream commit 21009686662fd21412ca35def7cb3cc8346e1c3d ]

On the one hand, phy_device.c provides a generic reset function if the phy
driver does not provide a soft_reset pointer. This generic reset does not take
into account the state of the phy, with a potential failure if the phy is in
powerdown mode. On the other hand, smsc driver provides a function with both
correct reset behaviour and configuration.

This patch moves the reset part into a new smsc_phy_reset function and provides
the soft_reset pointer to have a correct reset behaviour by default.

Signed-off-by: Gwenhael Goavec-Merou <gwenhael.goavec-merou@armadeus.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/smsc.c |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -43,6 +43,22 @@ static int smsc_phy_ack_interrupt(struct
 
 static int smsc_phy_config_init(struct phy_device *phydev)
 {
+	int rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
+
+	if (rc < 0)
+		return rc;
+
+	/* Enable energy detect mode for this SMSC Transceivers */
+	rc = phy_write(phydev, MII_LAN83C185_CTRL_STATUS,
+		       rc | MII_LAN83C185_EDPWRDOWN);
+	if (rc < 0)
+		return rc;
+
+	return smsc_phy_ack_interrupt(phydev);
+}
+
+static int smsc_phy_reset(struct phy_device *phydev)
+{
 	int rc = phy_read(phydev, MII_LAN83C185_SPECIAL_MODES);
 	if (rc < 0)
 		return rc;
@@ -66,18 +82,7 @@ static int smsc_phy_config_init(struct p
 			rc = phy_read(phydev, MII_BMCR);
 		} while (rc & BMCR_RESET);
 	}
-
-	rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
-	if (rc < 0)
-		return rc;
-
-	/* Enable energy detect mode for this SMSC Transceivers */
-	rc = phy_write(phydev, MII_LAN83C185_CTRL_STATUS,
-		       rc | MII_LAN83C185_EDPWRDOWN);
-	if (rc < 0)
-		return rc;
-
-	return smsc_phy_ack_interrupt (phydev);
+	return 0;
 }
 
 static int lan911x_config_init(struct phy_device *phydev)
@@ -142,6 +147,7 @@ static struct phy_driver smsc_phy_driver
 	.config_aneg	= genphy_config_aneg,
 	.read_status	= genphy_read_status,
 	.config_init	= smsc_phy_config_init,
+	.soft_reset	= smsc_phy_reset,
 
 	/* IRQ related */
 	.ack_interrupt	= smsc_phy_ack_interrupt,
@@ -164,6 +170,7 @@ static struct phy_driver smsc_phy_driver
 	.config_aneg	= genphy_config_aneg,
 	.read_status	= genphy_read_status,
 	.config_init	= smsc_phy_config_init,
+	.soft_reset	= smsc_phy_reset,
 
 	/* IRQ related */
 	.ack_interrupt	= smsc_phy_ack_interrupt,
@@ -186,6 +193,7 @@ static struct phy_driver smsc_phy_driver
 	.config_aneg	= genphy_config_aneg,
 	.read_status	= genphy_read_status,
 	.config_init	= smsc_phy_config_init,
+	.soft_reset	= smsc_phy_reset,
 
 	/* IRQ related */
 	.ack_interrupt	= smsc_phy_ack_interrupt,
@@ -230,6 +238,7 @@ static struct phy_driver smsc_phy_driver
 	.config_aneg	= genphy_config_aneg,
 	.read_status	= lan87xx_read_status,
 	.config_init	= smsc_phy_config_init,
+	.soft_reset	= smsc_phy_reset,
 
 	/* IRQ related */
 	.ack_interrupt	= smsc_phy_ack_interrupt,


