Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaJZQxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 12:53:55 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:45453 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbaJZQxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 12:53:38 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 15/15] net: dsa: Provide additional RMON statistics
Date: Sun, 26 Oct 2014 09:52:45 -0700
Message-Id: <1414342365-27191-16-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414342365-27191-1-git-send-email-linux@roeck-us.net>
References: <1414342365-27191-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.544D2712.00BA,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 85
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

Display sw_in_discards, sw_in_filtered, and sw_out_filtered for chips
supported by mv88e6123_61_65 and mv88e6352 drivers.

The variables are provided in port registers, not the normal status registers.
Mark by adding 0x100 to the register offset and add special handling code
to mv88e6xxx_get_ethtool_stats.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2:
- No change

 drivers/net/dsa/mv88e6123_61_65.c |  3 +++
 drivers/net/dsa/mv88e6352.c       |  3 +++
 drivers/net/dsa/mv88e6xxx.c       | 26 +++++++++++++++++++++-----
 3 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6123_61_65.c b/drivers/net/dsa/mv88e6123_61_65.c
index e2d2e37..9a3f9e0 100644
--- a/drivers/net/dsa/mv88e6123_61_65.c
+++ b/drivers/net/dsa/mv88e6123_61_65.c
@@ -433,6 +433,9 @@ static struct mv88e6xxx_hw_stat mv88e6123_61_65_hw_stats[] = {
 	{ "hist_256_511bytes", 4, 0x0b, },
 	{ "hist_512_1023bytes", 4, 0x0c, },
 	{ "hist_1024_max_bytes", 4, 0x0d, },
+	{ "sw_in_discards", 4, 0x110, },
+	{ "sw_in_filtered", 2, 0x112, },
+	{ "sw_out_filtered", 2, 0x113, },
 };
 
 static void
diff --git a/drivers/net/dsa/mv88e6352.c b/drivers/net/dsa/mv88e6352.c
index d5bbe49..258d9ef 100644
--- a/drivers/net/dsa/mv88e6352.c
+++ b/drivers/net/dsa/mv88e6352.c
@@ -539,6 +539,9 @@ static struct mv88e6xxx_hw_stat mv88e6352_hw_stats[] = {
 	{ "hist_256_511bytes", 4, 0x0b, },
 	{ "hist_512_1023bytes", 4, 0x0c, },
 	{ "hist_1024_max_bytes", 4, 0x0d, },
+	{ "sw_in_discards", 4, 0x110, },
+	{ "sw_in_filtered", 2, 0x112, },
+	{ "sw_out_filtered", 2, 0x113, },
 };
 
 static int mv88e6352_read_eeprom_word(struct dsa_switch *ds, int addr)
diff --git a/drivers/net/dsa/mv88e6xxx.c b/drivers/net/dsa/mv88e6xxx.c
index c071fde..da558d8 100644
--- a/drivers/net/dsa/mv88e6xxx.c
+++ b/drivers/net/dsa/mv88e6xxx.c
@@ -485,17 +485,33 @@ void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds,
 	for (i = 0; i < nr_stats; i++) {
 		struct mv88e6xxx_hw_stat *s = stats + i;
 		u32 low;
-		u32 high;
-
+		u32 high = 0;
+
+		if (s->reg >= 0x100) {
+			int ret;
+
+			ret = mv88e6xxx_reg_read(ds, REG_PORT(port),
+						 s->reg - 0x100);
+			if (ret < 0)
+				goto error;
+			low = ret;
+			if (s->sizeof_stat == 4) {
+				ret = mv88e6xxx_reg_read(ds, REG_PORT(port),
+							 s->reg - 0x100 + 1);
+				if (ret < 0)
+					goto error;
+				high = ret;
+			}
+			data[i] = (((u64)high) << 16) | low;
+			continue;
+		}
 		mv88e6xxx_stats_read(ds, s->reg, &low);
 		if (s->sizeof_stat == 8)
 			mv88e6xxx_stats_read(ds, s->reg + 1, &high);
-		else
-			high = 0;
 
 		data[i] = (((u64)high) << 32) | low;
 	}
-
+error:
 	mutex_unlock(&ps->stats_mutex);
 }
 
-- 
1.9.1

