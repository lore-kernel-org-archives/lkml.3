Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210AbbAYTRw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:17:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbbAYSJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mugunthan V N <mugunthanvnm@ti.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 53/98] drivers: net: cpsw: fix multicast flush in dual emac mode
Date: Sun, 25 Jan 2015 10:07:11 -0800
Message-Id: <20150125180715.161310537@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mugunthan V N <mugunthanvnm@ti.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/ti/cpsw.c     |   11 +++++++++--
 drivers/net/ethernet/ti/cpsw_ale.c |   10 +++++++++-
 drivers/net/ethernet/ti/cpsw_ale.h |    2 +-
 3 files changed, 19 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -596,7 +596,7 @@ static void cpsw_set_promiscious(struct
 
 			/* Clear all mcast from ALE */
 			cpsw_ale_flush_multicast(ale, ALE_ALL_PORTS <<
-						 priv->host_port);
+						 priv->host_port, -1);
 
 			/* Flood All Unicast Packets to Host port */
 			cpsw_ale_control_set(ale, 0, ALE_P0_UNI_FLOOD, 1);
@@ -620,6 +620,12 @@ static void cpsw_set_promiscious(struct
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
@@ -631,7 +637,8 @@ static void cpsw_ndo_set_rx_mode(struct
 	}
 
 	/* Clear all mcast from ALE */
-	cpsw_ale_flush_multicast(priv->ale, ALE_ALL_PORTS << priv->host_port);
+	cpsw_ale_flush_multicast(priv->ale, ALE_ALL_PORTS << priv->host_port,
+				 vid);
 
 	if (!netdev_mc_empty(ndev)) {
 		struct netdev_hw_addr *ha;
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -236,7 +236,7 @@ static void cpsw_ale_flush_mcast(struct
 		cpsw_ale_set_entry_type(ale_entry, ALE_TYPE_FREE);
 }
 
-int cpsw_ale_flush_multicast(struct cpsw_ale *ale, int port_mask)
+int cpsw_ale_flush_multicast(struct cpsw_ale *ale, int port_mask, int vid)
 {
 	u32 ale_entry[ALE_ENTRY_WORDS];
 	int ret, idx;
@@ -247,6 +247,14 @@ int cpsw_ale_flush_multicast(struct cpsw
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
 
--- a/drivers/net/ethernet/ti/cpsw_ale.h
+++ b/drivers/net/ethernet/ti/cpsw_ale.h
@@ -88,7 +88,7 @@ void cpsw_ale_stop(struct cpsw_ale *ale)
 
 int cpsw_ale_set_ageout(struct cpsw_ale *ale, int ageout);
 int cpsw_ale_flush(struct cpsw_ale *ale, int port_mask);
-int cpsw_ale_flush_multicast(struct cpsw_ale *ale, int port_mask);
+int cpsw_ale_flush_multicast(struct cpsw_ale *ale, int port_mask, int vid);
 int cpsw_ale_add_ucast(struct cpsw_ale *ale, u8 *addr, int port,
 		       int flags, u16 vid);
 int cpsw_ale_del_ucast(struct cpsw_ale *ale, u8 *addr, int port,


