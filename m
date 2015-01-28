Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202AbbA2KFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:05:43 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44753 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757859AbbA2JBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:01:52 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mugunthan V N <mugunthanvnm@ti.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 101/176] drivers: net: cpsw: fix multicast flush in dual emac mode
Date: Wed, 28 Jan 2015 15:28:51 +0100
Message-Id: <487873cff553e57b6c199b646c4d1561f2db8604.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mugunthan V N <mugunthanvnm@ti.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 25906052d953d3fbdb7e19480b9de5e6bb949f3f upstream.

Since ALE table is a common resource for both the interfaces in Dual EMAC
mode and while bringing up the second interface in cpsw_ndo_set_rx_mode()
all the multicast entries added by the first interface is flushed out and
only second interface multicast addresses are added. Fixing this by
flushing multicast addresses based on dual EMAC port vlans which will not
affect the other emac port multicast addresses.

Fixes: d9ba8f9 (driver: net: ethernet: cpsw: dual emac interface implementation)
Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/ti/cpsw.c     |  9 ++++++++-
 drivers/net/ethernet/ti/cpsw_ale.c | 10 +++++++++-
 drivers/net/ethernet/ti/cpsw_ale.h |  2 +-
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index d7a98d08abd2..07cd14d586dc 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -546,6 +546,12 @@ static inline int cpsw_get_slave_port(struct cpsw_priv *priv, u32 slave_num)
 static void cpsw_ndo_set_rx_mode(struct net_device *ndev)
 {
 	struct cpsw_priv *priv = netdev_priv(ndev);
+	int vid;
+
+	if (priv->data.dual_emac)
+		vid = priv->slaves[priv->emac_port].port_vlan;
+	else
+		vid = priv->data.default_vlan;
 
 	if (ndev->flags & IFF_PROMISC) {
 		/* Enable promiscuous mode */
@@ -554,7 +560,8 @@ static void cpsw_ndo_set_rx_mode(struct net_device *ndev)
 	}
 
 	/* Clear all mcast from ALE */
-	cpsw_ale_flush_multicast(priv->ale, ALE_ALL_PORTS << priv->host_port);
+	cpsw_ale_flush_multicast(priv->ale, ALE_ALL_PORTS << priv->host_port,
+				 vid);
 
 	if (!netdev_mc_empty(ndev)) {
 		struct netdev_hw_addr *ha;
diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 7fa60d6092ed..f7acf76b223c 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -236,7 +236,7 @@ static void cpsw_ale_flush_mcast(struct cpsw_ale *ale, u32 *ale_entry,
 		cpsw_ale_set_entry_type(ale_entry, ALE_TYPE_FREE);
 }
 
-int cpsw_ale_flush_multicast(struct cpsw_ale *ale, int port_mask)
+int cpsw_ale_flush_multicast(struct cpsw_ale *ale, int port_mask, int vid)
 {
 	u32 ale_entry[ALE_ENTRY_WORDS];
 	int ret, idx;
@@ -247,6 +247,14 @@ int cpsw_ale_flush_multicast(struct cpsw_ale *ale, int port_mask)
 		if (ret != ALE_TYPE_ADDR && ret != ALE_TYPE_VLAN_ADDR)
 			continue;
 
+		/* if vid passed is -1 then remove all multicast entry from
+		 * the table irrespective of vlan id, if a valid vlan id is
+		 * passed then remove only multicast added to that vlan id.
+		 * if vlan id doesn't match then move on to next entry.
+		 */
+		if (vid != -1 && cpsw_ale_get_vlan_id(ale_entry) != vid)
+			continue;
+
 		if (cpsw_ale_get_mcast(ale_entry)) {
 			u8 addr[6];
 
diff --git a/drivers/net/ethernet/ti/cpsw_ale.h b/drivers/net/ethernet/ti/cpsw_ale.h
index 30daa1265f0c..20c7976819e7 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.h
+++ b/drivers/net/ethernet/ti/cpsw_ale.h
@@ -86,7 +86,7 @@ void cpsw_ale_stop(struct cpsw_ale *ale);
 
 int cpsw_ale_set_ageout(struct cpsw_ale *ale, int ageout);
 int cpsw_ale_flush(struct cpsw_ale *ale, int port_mask);
-int cpsw_ale_flush_multicast(struct cpsw_ale *ale, int port_mask);
+int cpsw_ale_flush_multicast(struct cpsw_ale *ale, int port_mask, int vid);
 int cpsw_ale_add_ucast(struct cpsw_ale *ale, u8 *addr, int port,
 		       int flags, u16 vid);
 int cpsw_ale_del_ucast(struct cpsw_ale *ale, u8 *addr, int port,
-- 
2.2.2

