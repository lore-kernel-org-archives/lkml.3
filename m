Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbaJWEGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 00:06:11 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:49511 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaJWEED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 00:04:03 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 11/14] net: dsa: Add support for reading switch registers with ethtool
Date: Wed, 22 Oct 2014 21:03:19 -0700
Message-Id: <1414037002-25528-12-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414037002-25528-1-git-send-email-linux@roeck-us.net>
References: <1414037002-25528-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.54487E33.002D,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 69
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

Add support for reading switch registers with 'ethtool -d'.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 include/net/dsa.h |  7 +++++++
 net/dsa/slave.c   | 22 ++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 73146b7..edc5e71 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -255,6 +255,13 @@ struct dsa_switch_driver {
 			      struct ethtool_eeprom *eeprom, u8 *data);
 	int	(*set_eeprom)(struct dsa_switch *ds,
 			      struct ethtool_eeprom *eeprom, u8 *data);
+
+	/*
+	 * Register access.
+	 */
+	int	(*get_regs_len)(struct dsa_switch *ds, int port);
+	void	(*get_regs)(struct dsa_switch *ds, int port,
+			    struct ethtool_regs *regs, void *p);
 };
 
 void register_switch_driver(struct dsa_switch_driver *type);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a54ee43..e988d07 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -249,6 +249,26 @@ static void dsa_slave_get_drvinfo(struct net_device *dev,
 	strlcpy(drvinfo->bus_info, "platform", sizeof(drvinfo->bus_info));
 }
 
+static int dsa_slave_get_regs_len(struct net_device *dev)
+{
+	struct dsa_slave_priv *p = netdev_priv(dev);
+	struct dsa_switch *ds = p->parent;
+
+	if (ds->drv->get_regs_len != NULL)
+		return ds->drv->get_regs_len(ds, p->port);
+
+	return -EOPNOTSUPP;
+}
+
+static void
+dsa_slave_get_regs(struct net_device *dev, struct ethtool_regs *regs, void *_p)
+{
+	struct dsa_slave_priv *p = netdev_priv(dev);
+	struct dsa_switch *ds = p->parent;
+
+	ds->drv->get_regs(ds, p->port, regs, _p);
+}
+
 static int dsa_slave_nway_reset(struct net_device *dev)
 {
 	struct dsa_slave_priv *p = netdev_priv(dev);
@@ -420,6 +440,8 @@ static const struct ethtool_ops dsa_slave_ethtool_ops = {
 	.get_settings		= dsa_slave_get_settings,
 	.set_settings		= dsa_slave_set_settings,
 	.get_drvinfo		= dsa_slave_get_drvinfo,
+	.get_regs_len		= dsa_slave_get_regs_len,
+	.get_regs		= dsa_slave_get_regs,
 	.nway_reset		= dsa_slave_nway_reset,
 	.get_link		= dsa_slave_get_link,
 	.get_eeprom_len		= dsa_slave_get_eeprom_len,
-- 
1.9.1

