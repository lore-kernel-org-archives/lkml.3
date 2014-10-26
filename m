Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbaJZQzp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 12:55:45 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:45410 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbaJZQxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 12:53:20 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 08/15] net: dsa/mv88e6123_61_65: Report chip temperature
Date: Sun, 26 Oct 2014 09:52:38 -0700
Message-Id: <1414342365-27191-9-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414342365-27191-1-git-send-email-linux@roeck-us.net>
References: <1414342365-27191-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.544D26FF.01AB,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

MV88E6123 and compatible chips support reading the chip temperature
from PHY register 6:26.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2:
- Make new functionality optional, depending on CONFIG_NET_DSA_HWMON

 drivers/net/dsa/mv88e6123_61_65.c | 68 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6123_61_65.c b/drivers/net/dsa/mv88e6123_61_65.c
index a332c53..9f43c9b 100644
--- a/drivers/net/dsa/mv88e6123_61_65.c
+++ b/drivers/net/dsa/mv88e6123_61_65.c
@@ -291,6 +291,54 @@ static int mv88e6123_61_65_setup_port(struct dsa_switch *ds, int p)
 	return 0;
 }
 
+#ifdef CONFIG_NET_DSA_HWMON
+
+static int  mv88e6123_61_65_get_temp(struct dsa_switch *ds, int *temp)
+{
+	struct mv88e6xxx_priv_state *ps = ds_to_priv(ds);
+	int ret;
+	int val;
+
+	*temp = 0;
+
+	mutex_lock(&ps->phy_mutex);
+
+	ret = mv88e6xxx_phy_write(ds, 0x0, 0x16, 0x6);
+	if (ret < 0)
+		goto error;
+
+	/* Enable temperature sensor */
+	ret = mv88e6xxx_phy_read(ds, 0x0, 0x1a);
+	if (ret < 0)
+		goto error;
+
+	ret = mv88e6xxx_phy_write(ds, 0x0, 0x1a, ret | (1 << 5));
+	if (ret < 0)
+		goto error;
+
+	/* Wait for temperature to stabilize */
+	usleep_range(10000, 12000);
+
+	val = mv88e6xxx_phy_read(ds, 0x0, 0x1a);
+	if (val < 0) {
+		ret = val;
+		goto error;
+	}
+
+	/* Disable temperature sensor */
+	ret = mv88e6xxx_phy_write(ds, 0x0, 0x1a, ret & ~(1 << 5));
+	if (ret < 0)
+		goto error;
+
+	*temp = ((val & 0x1f) - 5) * 5;
+
+error:
+	mv88e6xxx_phy_write(ds, 0x0, 0x16, 0x0);
+	mutex_unlock(&ps->phy_mutex);
+	return ret;
+}
+#endif /* CONFIG_NET_DSA_HWMON */
+
 static int mv88e6123_61_65_setup(struct dsa_switch *ds)
 {
 	struct mv88e6xxx_priv_state *ps = ds_to_priv(ds);
@@ -299,6 +347,7 @@ static int mv88e6123_61_65_setup(struct dsa_switch *ds)
 
 	mutex_init(&ps->smi_mutex);
 	mutex_init(&ps->stats_mutex);
+	mutex_init(&ps->phy_mutex);
 
 	ret = mv88e6123_61_65_switch_reset(ds);
 	if (ret < 0)
@@ -329,16 +378,28 @@ static int mv88e6123_61_65_port_to_phy_addr(int port)
 static int
 mv88e6123_61_65_phy_read(struct dsa_switch *ds, int port, int regnum)
 {
+	struct mv88e6xxx_priv_state *ps = ds_to_priv(ds);
 	int addr = mv88e6123_61_65_port_to_phy_addr(port);
-	return mv88e6xxx_phy_read(ds, addr, regnum);
+	int ret;
+
+	mutex_lock(&ps->phy_mutex);
+	ret = mv88e6xxx_phy_read(ds, addr, regnum);
+	mutex_unlock(&ps->phy_mutex);
+	return ret;
 }
 
 static int
 mv88e6123_61_65_phy_write(struct dsa_switch *ds,
 			      int port, int regnum, u16 val)
 {
+	struct mv88e6xxx_priv_state *ps = ds_to_priv(ds);
 	int addr = mv88e6123_61_65_port_to_phy_addr(port);
-	return mv88e6xxx_phy_write(ds, addr, regnum, val);
+	int ret;
+
+	mutex_lock(&ps->phy_mutex);
+	ret = mv88e6xxx_phy_write(ds, addr, regnum, val);
+	mutex_unlock(&ps->phy_mutex);
+	return ret;
 }
 
 static struct mv88e6xxx_hw_stat mv88e6123_61_65_hw_stats[] = {
@@ -406,6 +467,9 @@ struct dsa_switch_driver mv88e6123_61_65_switch_driver = {
 	.get_strings		= mv88e6123_61_65_get_strings,
 	.get_ethtool_stats	= mv88e6123_61_65_get_ethtool_stats,
 	.get_sset_count		= mv88e6123_61_65_get_sset_count,
+#ifdef CONFIG_NET_DSA_HWMON
+	.get_temp		= mv88e6123_61_65_get_temp,
+#endif
 };
 
 MODULE_ALIAS("platform:mv88e6123");
-- 
1.9.1

