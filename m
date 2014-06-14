Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbaFNUoB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 16:44:01 -0400
Received: from 1wt.eu ([62.212.114.60]:42865 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbaFNUn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 16:43:58 -0400
Message-Id: <20140614191250.169302421@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sat, 14 Jun 2014 21:12:51 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wang Weidong <wangweidong1@huawei.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 1/9] ethtool: Report link-down while interface is down
In-Reply-To: <57d1129d02f4fc14423dd66474950cb7@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

While an interface is down, many implementations of
ethtool_ops::get_link, including the default, ethtool_op_get_link(),
will report the last link state seen while the interface was up.  In
general the current physical link state is not available if the
interface is down.

Define ETHTOOL_GLINK to reflect whether the interface *and* any
physical port have a working link, and consistently return 0 when the
interface is down.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
(cherry picked from commit e596e6e4d578f2639416e620d367a3af34814a40)
Cc: Wang Weidong <wangweidong1@huawei.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 include/linux/ethtool.h |  4 +++-
 net/core/ethtool.c      | 17 +++++++++++++++--
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 7ffab7cb..3a0fae6 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -517,7 +517,9 @@ struct ethtool_ops {
 #define ETHTOOL_GMSGLVL		0x00000007 /* Get driver message level */
 #define ETHTOOL_SMSGLVL		0x00000008 /* Set driver msg level. */
 #define ETHTOOL_NWAY_RST	0x00000009 /* Restart autonegotiation. */
-#define ETHTOOL_GLINK		0x0000000a /* Get link status (ethtool_value) */
+/* Get link status for host, i.e. whether the interface *and* the
+ * physical port (if there is one) are up (ethtool_value). */
+#define ETHTOOL_GLINK		0x0000000a
 #define ETHTOOL_GEEPROM		0x0000000b /* Get EEPROM data */
 #define ETHTOOL_SEEPROM		0x0000000c /* Set EEPROM data. */
 #define ETHTOOL_GCOALESCE	0x0000000e /* Get coalesce config */
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index abbe8fa..f9e7179 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -365,6 +365,20 @@ static int ethtool_nway_reset(struct net_device *dev)
 	return dev->ethtool_ops->nway_reset(dev);
 }
 
+static int ethtool_get_link(struct net_device *dev, char __user *useraddr)
+{
+	struct ethtool_value edata = { .cmd = ETHTOOL_GLINK };
+
+	if (!dev->ethtool_ops->get_link)
+		return -EOPNOTSUPP;
+
+	edata.data = netif_running(dev) && dev->ethtool_ops->get_link(dev);
+
+	if (copy_to_user(useraddr, &edata, sizeof(edata)))
+		return -EFAULT;
+	return 0;
+}
+
 static int ethtool_get_eeprom(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_eeprom eeprom;
@@ -1016,8 +1030,7 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 		rc = ethtool_nway_reset(dev);
 		break;
 	case ETHTOOL_GLINK:
-		rc = ethtool_get_value(dev, useraddr, ethcmd,
-				       dev->ethtool_ops->get_link);
+		rc = ethtool_get_link(dev, useraddr);
 		break;
 	case ETHTOOL_GEEPROM:
 		rc = ethtool_get_eeprom(dev, useraddr);
-- 
1.7.12.2.21.g234cd45.dirty



