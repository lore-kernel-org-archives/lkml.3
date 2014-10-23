Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbaJWEIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 00:08:01 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:49486 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaJWED5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 00:03:57 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 09/14] net: dsa: Add support for switch EEPROM access
Date: Wed, 22 Oct 2014 21:03:17 -0700
Message-Id: <1414037002-25528-10-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414037002-25528-1-git-send-email-linux@roeck-us.net>
References: <1414037002-25528-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.54487E2D.00D3,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 58
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some chips it is possible to access the switch eeprom.
Add infrastructure support for it.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 include/net/dsa.h |  7 +++++++
 net/dsa/slave.c   | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index d8b3057..73146b7 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -248,6 +248,13 @@ struct dsa_switch_driver {
 	int	(*get_temp_limit)(struct dsa_switch *ds, int *temp);
 	int	(*set_temp_limit)(struct dsa_switch *ds, int temp);
 	int	(*get_temp_alarm)(struct dsa_switch *ds, bool *alarm);
+
+	/* EEPROM access */
+	int	(*get_eeprom_len)(struct dsa_switch *ds);
+	int	(*get_eeprom)(struct dsa_switch *ds,
+			      struct ethtool_eeprom *eeprom, u8 *data);
+	int	(*set_eeprom)(struct dsa_switch *ds,
+			      struct ethtool_eeprom *eeprom, u8 *data);
 };
 
 void register_switch_driver(struct dsa_switch_driver *type);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 6d18174..a54ee43 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -271,6 +271,41 @@ static u32 dsa_slave_get_link(struct net_device *dev)
 	return -EOPNOTSUPP;
 }
 
+static int dsa_slave_get_eeprom_len(struct net_device *dev)
+{
+	struct dsa_slave_priv *p = netdev_priv(dev);
+	struct dsa_switch *ds = p->parent;
+
+	if (ds->drv->get_eeprom_len != NULL)
+		return ds->drv->get_eeprom_len(ds);
+
+	return 0;
+}
+
+static int dsa_slave_get_eeprom(struct net_device *dev,
+				struct ethtool_eeprom *eeprom, u8 *data)
+{
+	struct dsa_slave_priv *p = netdev_priv(dev);
+	struct dsa_switch *ds = p->parent;
+
+	if (ds->drv->get_eeprom != NULL)
+		return ds->drv->get_eeprom(ds, eeprom, data);
+
+	return -EOPNOTSUPP;
+}
+
+static int dsa_slave_set_eeprom(struct net_device *dev,
+				struct ethtool_eeprom *eeprom, u8 *data)
+{
+	struct dsa_slave_priv *p = netdev_priv(dev);
+	struct dsa_switch *ds = p->parent;
+
+	if (ds->drv->set_eeprom != NULL)
+		return ds->drv->set_eeprom(ds, eeprom, data);
+
+	return -EOPNOTSUPP;
+}
+
 static void dsa_slave_get_strings(struct net_device *dev,
 				  uint32_t stringset, uint8_t *data)
 {
@@ -387,6 +422,9 @@ static const struct ethtool_ops dsa_slave_ethtool_ops = {
 	.get_drvinfo		= dsa_slave_get_drvinfo,
 	.nway_reset		= dsa_slave_nway_reset,
 	.get_link		= dsa_slave_get_link,
+	.get_eeprom_len		= dsa_slave_get_eeprom_len,
+	.get_eeprom		= dsa_slave_get_eeprom,
+	.set_eeprom		= dsa_slave_set_eeprom,
 	.get_strings		= dsa_slave_get_strings,
 	.get_ethtool_stats	= dsa_slave_get_ethtool_stats,
 	.get_sset_count		= dsa_slave_get_sset_count,
-- 
1.9.1

