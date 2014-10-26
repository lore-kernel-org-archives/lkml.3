Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaJZQyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 12:54:47 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:45428 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbaJZQx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 12:53:27 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 11/15] net: dsa/mv88e6352: Implement EEPROM access functions
Date: Sun, 26 Oct 2014 09:52:41 -0700
Message-Id: <1414342365-27191-12-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414342365-27191-1-git-send-email-linux@roeck-us.net>
References: <1414342365-27191-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.544D2706.0177,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 70
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

MV88E6352 supports read and write access to its configuration eeprom.

There is no means to detect if an EEPROM is connected to the switch.
Also, the switch supports EEPROMs with different sizes, but can not detect
or report the type or size of connected EEPROMs. Therefore, do not implement
the get_eeprom_len callback but depend on platform or devicetree data to
provide information about EEPROM presence and size.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2:
- EEPROM length must now be provided through platform or devicetree data

 drivers/net/dsa/mv88e6352.c | 222 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx.h |   5 +
 2 files changed, 224 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6352.c b/drivers/net/dsa/mv88e6352.c
index 744e6fa..8a956f9 100644
--- a/drivers/net/dsa/mv88e6352.c
+++ b/drivers/net/dsa/mv88e6352.c
@@ -22,18 +22,18 @@
 #include <net/dsa.h>
 #include "mv88e6xxx.h"
 
-static int mv88e6352_phy_wait(struct dsa_switch *ds)
+static int mv88e6352_wait(struct dsa_switch *ds, int reg, u16 mask)
 {
 	unsigned long timeout = jiffies + HZ / 10;
 
 	while (time_before(jiffies, timeout)) {
 		int ret;
 
-		ret = REG_READ(REG_GLOBAL2, 0x18);
+		ret = REG_READ(REG_GLOBAL2, reg);
 		if (ret < 0)
 			return ret;
 
-		if (!(ret & 0x8000))
+		if (!(ret & mask))
 			return 0;
 
 		usleep_range(1000, 2000);
@@ -41,6 +41,21 @@ static int mv88e6352_phy_wait(struct dsa_switch *ds)
 	return -ETIMEDOUT;
 }
 
+static inline int mv88e6352_phy_wait(struct dsa_switch *ds)
+{
+	return mv88e6352_wait(ds, 0x18, 0x8000);
+}
+
+static inline int mv88e6352_eeprom_load_wait(struct dsa_switch *ds)
+{
+	return mv88e6352_wait(ds, 0x14, 0x0800);
+}
+
+static inline int mv88e6352_eeprom_busy_wait(struct dsa_switch *ds)
+{
+	return mv88e6352_wait(ds, 0x14, 0x8000);
+}
+
 static int __mv88e6352_phy_read(struct dsa_switch *ds, int addr, int regnum)
 {
 	int ret;
@@ -429,6 +444,7 @@ static int mv88e6352_setup(struct dsa_switch *ds)
 	mutex_init(&ps->smi_mutex);
 	mutex_init(&ps->stats_mutex);
 	mutex_init(&ps->phy_mutex);
+	mutex_init(&ps->eeprom_mutex);
 
 	ps->id = REG_READ(REG_PORT(0), 0x03) & 0xfff0;
 
@@ -525,6 +541,204 @@ static struct mv88e6xxx_hw_stat mv88e6352_hw_stats[] = {
 	{ "hist_1024_max_bytes", 4, 0x0d, },
 };
 
+static int mv88e6352_read_eeprom_word(struct dsa_switch *ds, int addr)
+{
+	struct mv88e6xxx_priv_state *ps = ds_to_priv(ds);
+	int ret;
+
+	mutex_lock(&ps->eeprom_mutex);
+
+	ret = mv88e6xxx_reg_write(ds, REG_GLOBAL2, 0x14,
+				  0xc000 | (addr & 0xff));
+	if (ret < 0)
+		goto error;
+
+	ret = mv88e6352_eeprom_busy_wait(ds);
+	if (ret < 0)
+		goto error;
+
+	ret = mv88e6xxx_reg_read(ds, REG_GLOBAL2, 0x15);
+error:
+	mutex_unlock(&ps->eeprom_mutex);
+	return ret;
+}
+
+static int mv88e6352_get_eeprom(struct dsa_switch *ds,
+				struct ethtool_eeprom *eeprom, u8 *data)
+{
+	int offset;
+	int len;
+	int ret;
+
+	offset = eeprom->offset;
+	len = eeprom->len;
+	eeprom->len = 0;
+
+	eeprom->magic = 0xc3ec4951;
+
+	ret = mv88e6352_eeprom_load_wait(ds);
+	if (ret < 0)
+		return ret;
+
+	if (offset & 1) {
+		int word;
+
+		word = mv88e6352_read_eeprom_word(ds, offset >> 1);
+		if (word < 0)
+			return word;
+
+		*data++ = (word >> 8) & 0xff;
+
+		offset++;
+		len--;
+		eeprom->len++;
+	}
+
+	while (len >= 2) {
+		int word;
+
+		word = mv88e6352_read_eeprom_word(ds, offset >> 1);
+		if (word < 0)
+			return word;
+
+		*data++ = word & 0xff;
+		*data++ = (word >> 8) & 0xff;
+
+		offset += 2;
+		len -= 2;
+		eeprom->len += 2;
+	}
+
+	if (len) {
+		int word;
+
+		word = mv88e6352_read_eeprom_word(ds, offset >> 1);
+		if (word < 0)
+			return word;
+
+		*data++ = word & 0xff;
+
+		offset++;
+		len--;
+		eeprom->len++;
+	}
+
+	return 0;
+}
+
+static int mv88e6352_eeprom_is_readonly(struct dsa_switch *ds)
+{
+	int ret;
+
+	ret = mv88e6xxx_reg_read(ds, REG_GLOBAL2, 0x14);
+	if (ret < 0)
+		return ret;
+
+	if (!(ret & 0x0400))
+		return -EROFS;
+
+	return 0;
+}
+
+static int mv88e6352_write_eeprom_word(struct dsa_switch *ds, int addr,
+				       u16 data)
+{
+	struct mv88e6xxx_priv_state *ps = ds_to_priv(ds);
+	int ret;
+
+	mutex_lock(&ps->eeprom_mutex);
+
+	ret = mv88e6xxx_reg_write(ds, REG_GLOBAL2, 0x15, data);
+	if (ret < 0)
+		goto error;
+
+	ret = mv88e6xxx_reg_write(ds, REG_GLOBAL2, 0x14,
+				  0xb000 | (addr & 0xff));
+	if (ret < 0)
+		goto error;
+
+	ret = mv88e6352_eeprom_busy_wait(ds);
+error:
+	mutex_unlock(&ps->eeprom_mutex);
+	return ret;
+}
+
+static int mv88e6352_set_eeprom(struct dsa_switch *ds,
+				struct ethtool_eeprom *eeprom, u8 *data)
+{
+	int offset;
+	int ret;
+	int len;
+
+	if (eeprom->magic != 0xc3ec4951)
+		return -EINVAL;
+
+	ret = mv88e6352_eeprom_is_readonly(ds);
+	if (ret)
+		return ret;
+
+	offset = eeprom->offset;
+	len = eeprom->len;
+	eeprom->len = 0;
+
+	ret = mv88e6352_eeprom_load_wait(ds);
+	if (ret < 0)
+		return ret;
+
+	if (offset & 1) {
+		int word;
+
+		word = mv88e6352_read_eeprom_word(ds, offset >> 1);
+		if (word < 0)
+			return word;
+
+		word = (*data++ << 8) | (word & 0xff);
+
+		ret = mv88e6352_write_eeprom_word(ds, offset >> 1, word);
+		if (ret < 0)
+			return ret;
+
+		offset++;
+		len--;
+		eeprom->len++;
+	}
+
+	while (len >= 2) {
+		int word;
+
+		word = *data++;
+		word |= *data++ << 8;
+
+		ret = mv88e6352_write_eeprom_word(ds, offset >> 1, word);
+		if (ret < 0)
+			return ret;
+
+		offset += 2;
+		len -= 2;
+		eeprom->len += 2;
+	}
+
+	if (len) {
+		int word;
+
+		word = mv88e6352_read_eeprom_word(ds, offset >> 1);
+		if (word < 0)
+			return word;
+
+		word = (word & 0xff00) | *data++;
+
+		ret = mv88e6352_write_eeprom_word(ds, offset >> 1, word);
+		if (ret < 0)
+			return ret;
+
+		offset++;
+		len--;
+		eeprom->len++;
+	}
+
+	return 0;
+}
+
 static void
 mv88e6352_get_strings(struct dsa_switch *ds, int port, uint8_t *data)
 {
@@ -562,6 +776,8 @@ struct dsa_switch_driver mv88e6352_switch_driver = {
 	.set_temp_limit		= mv88e6352_set_temp_limit,
 	.get_temp_alarm		= mv88e6352_get_temp_alarm,
 #endif
+	.get_eeprom		= mv88e6352_get_eeprom,
+	.set_eeprom		= mv88e6352_set_eeprom,
 };
 
 MODULE_ALIAS("platform:mv88e6352");
diff --git a/drivers/net/dsa/mv88e6xxx.h b/drivers/net/dsa/mv88e6xxx.h
index c0ce133..29feed0 100644
--- a/drivers/net/dsa/mv88e6xxx.h
+++ b/drivers/net/dsa/mv88e6xxx.h
@@ -43,6 +43,11 @@ struct mv88e6xxx_priv_state {
 	 */
 	struct mutex	phy_mutex;
 
+	/* This mutex serializes eeprom access for chips with
+	 * eeprom support.
+	 */
+	struct mutex eeprom_mutex;
+
 	int		id; /* switch product id */
 };
 
-- 
1.9.1

