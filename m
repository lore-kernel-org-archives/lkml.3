Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717AbaJaDub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 23:50:31 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:42312 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039AbaJaDu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 23:50:29 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] net: ethtool: Return -EOPNOTSUPP if user space tries to read EEPROM with lengh 0
Date: Thu, 30 Oct 2014 20:50:15 -0700
Message-Id: <1414727415-5470-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.54530705.00D5,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
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

If a driver supports reading EEPROM but no EEPROM is installed in the system,
the driver's get_eeprom_len function returns 0. ethtool will subsequently
try to read that zero-length EEPROM anyway. If the driver does not support
EEPROM access at all, this operation will return -EOPNOTSUPP. If the driver
does support EEPROM access but no EEPROM is installed, the operation will
return -EINVAL. Return -EOPNOTSUPP in both cases for consistency.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 net/core/ethtool.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 1600aa2..06dfb29 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1036,7 +1036,8 @@ static int ethtool_get_eeprom(struct net_device *dev, void __user *useraddr)
 {
 	const struct ethtool_ops *ops = dev->ethtool_ops;
 
-	if (!ops->get_eeprom || !ops->get_eeprom_len)
+	if (!ops->get_eeprom || !ops->get_eeprom_len ||
+	    !ops->get_eeprom_len(dev))
 		return -EOPNOTSUPP;
 
 	return ethtool_get_any_eeprom(dev, useraddr, ops->get_eeprom,
@@ -1052,7 +1053,8 @@ static int ethtool_set_eeprom(struct net_device *dev, void __user *useraddr)
 	u8 *data;
 	int ret = 0;
 
-	if (!ops->set_eeprom || !ops->get_eeprom_len)
+	if (!ops->set_eeprom || !ops->get_eeprom_len ||
+	    !ops->get_eeprom_len(dev))
 		return -EOPNOTSUPP;
 
 	if (copy_from_user(&eeprom, useraddr, sizeof(eeprom)))
-- 
1.9.1

