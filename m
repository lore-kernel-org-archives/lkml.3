Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaJWEJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 00:09:05 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:49478 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaJWEDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 00:03:53 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 07/14] net: dsa/mv88e6352: Report chip temperature
Date: Wed, 22 Oct 2014 21:03:15 -0700
Message-Id: <1414037002-25528-8-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414037002-25528-1-git-send-email-linux@roeck-us.net>
References: <1414037002-25528-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.54487E29.003B,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 128
X-CTCH-SenderID-TotalMessages: 50
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

MV88E6352 supports reading the chip temperature from two PHY registers,
6:26 and 6:27. Report it using the more accurate register 6:27.
Also report temperature limit and alarm.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/net/dsa/mv88e6352.c | 96 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)

diff --git a/drivers/net/dsa/mv88e6352.c b/drivers/net/dsa/mv88e6352.c
index f17364f..aff6695 100644
--- a/drivers/net/dsa/mv88e6352.c
+++ b/drivers/net/dsa/mv88e6352.c
@@ -63,6 +63,41 @@ static int __mv88e6352_phy_write(struct dsa_switch *ds, int addr, int regnum,
 	return mv88e6352_phy_wait(ds);
 }
 
+static int mv88e6352_phy_page_read(struct dsa_switch *ds,
+				   int port, int page, int reg)
+{
+	struct mv88e6xxx_priv_state *ps = ds_to_priv(ds);
+	int ret;
+
+	mutex_lock(&ps->phy_mutex);
+	ret = __mv88e6352_phy_write(ds, port, 0x16, page);
+	if (ret < 0)
+		goto error;
+	ret = __mv88e6352_phy_read(ds, port, reg);
+error:
+	__mv88e6352_phy_write(ds, port, 0x16, 0x0);
+	mutex_unlock(&ps->phy_mutex);
+	return ret;
+}
+
+static int mv88e6352_phy_page_write(struct dsa_switch *ds,
+				    int port, int page, int reg, int val)
+{
+	struct mv88e6xxx_priv_state *ps = ds_to_priv(ds);
+	int ret;
+
+	mutex_lock(&ps->phy_mutex);
+	ret = __mv88e6352_phy_write(ds, port, 0x16, page);
+	if (ret < 0)
+		goto error;
+
+	ret = __mv88e6352_phy_write(ds, port, reg, val);
+error:
+	__mv88e6352_phy_write(ds, port, 0x16, 0x0);
+	mutex_unlock(&ps->phy_mutex);
+	return ret;
+}
+
 static char *mv88e6352_probe(struct device *host_dev, int sw_addr)
 {
 	struct mii_bus *bus = dsa_host_dev_to_mii_bus(host_dev);
@@ -325,6 +360,63 @@ static int mv88e6352_setup_port(struct dsa_switch *ds, int p)
 	return 0;
 }
 
+static int mv88e6352_get_temp(struct dsa_switch *ds, int *temp)
+{
+	int ret;
+
+	*temp = 0;
+
+	ret = mv88e6352_phy_page_read(ds, 0, 6, 27);
+	if (ret < 0)
+		return ret;
+
+	*temp = (ret & 0xff) - 25;
+
+	return 0;
+}
+
+static int mv88e6352_get_temp_limit(struct dsa_switch *ds, int *temp)
+{
+	int ret;
+
+	*temp = 0;
+
+	ret = mv88e6352_phy_page_read(ds, 0, 6, 26);
+	if (ret < 0)
+		return ret;
+
+	*temp = (((ret >> 8) & 0x1f) * 5) - 25;
+
+	return 0;
+}
+
+static int mv88e6352_set_temp_limit(struct dsa_switch *ds, int temp)
+{
+	int ret;
+
+	ret = mv88e6352_phy_page_read(ds, 0, 6, 26);
+	if (ret < 0)
+		return ret;
+	temp = clamp_val(DIV_ROUND_CLOSEST(temp, 5) + 5, 0, 0x1f);
+	return mv88e6352_phy_page_write(ds, 0, 6, 26,
+					(ret & 0xe0ff) | (temp << 8));
+}
+
+static int mv88e6352_get_temp_alarm(struct dsa_switch *ds, bool *alarm)
+{
+	int ret;
+
+	*alarm = false;
+
+	ret = mv88e6352_phy_page_read(ds, 0, 6, 26);
+	if (ret < 0)
+		return ret;
+
+	*alarm = !!(ret & 0x40);
+
+	return 0;
+}
+
 static int mv88e6352_setup(struct dsa_switch *ds)
 {
 	struct mv88e6xxx_priv_state *ps = ds_to_priv(ds);
@@ -461,6 +553,10 @@ struct dsa_switch_driver mv88e6352_switch_driver = {
 	.get_strings		= mv88e6352_get_strings,
 	.get_ethtool_stats	= mv88e6352_get_ethtool_stats,
 	.get_sset_count		= mv88e6352_get_sset_count,
+	.get_temp		= mv88e6352_get_temp,
+	.get_temp_limit		= mv88e6352_get_temp_limit,
+	.set_temp_limit		= mv88e6352_set_temp_limit,
+	.get_temp_alarm		= mv88e6352_get_temp_alarm,
 };
 
 MODULE_ALIAS("platform:mv88e6352");
-- 
1.9.1

