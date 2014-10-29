Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbaJ2TGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:06:18 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:56241 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbaJ2TGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:06:14 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Wed, 29 Oct 2014 15:06:12 -0400
To: linux-kernel@vger.kernel.org
Cc: Len Sorensen <lsorense@csclub.uwaterloo.ca>,
        Mugunthan V N <mugunthanvnm@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: PATCH: Add IFF_ALLMULTI support to cpsw (and fix IFF_PROMISC support
 too)
Message-ID: <20141029190612.GH24110@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpsw driver did not support the IFF_ALLMULTI flag which makes dynamic
multicast routing rather hard to handle.  Related to this, when enabling
IFF_PROMISC in non dual_emac mode, all registered vlans are flushed,
and only broadcast and unicast are allowed which isn't what you would
want from IFF_PROMISC.

A new cpsw_ale_set_allmulti function now scans through the ALE entry
table and adds or removes the host port from the unregistered multicast
port mask depending on the state of IFF_ALLMULTI.  In promisc mode,
it is also called to enable reception of all multicast traffic.

With this change I am now able to run dynamic multicast routing and also
use tcpdump and actually see multicast traffic.

Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 952e1e4..96a61d1 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -638,12 +638,16 @@ static void cpsw_ndo_set_rx_mode(struct net_device *ndev)
 	if (ndev->flags & IFF_PROMISC) {
 		/* Enable promiscuous mode */
 		cpsw_set_promiscious(ndev, true);
+		cpsw_ale_set_allmulti(priv->ale, IFF_ALLMULTI);
 		return;
 	} else {
 		/* Disable promiscuous mode */
 		cpsw_set_promiscious(ndev, false);
 	}
 
+	/* Restore allmulti on vlans if necessary */
+	cpsw_ale_set_allmulti(priv->ale, priv->ndev->flags & IFF_ALLMULTI);
+
 	/* Clear all mcast from ALE */
 	cpsw_ale_flush_multicast(priv->ale, ALE_ALL_PORTS << priv->host_port);
 
@@ -1149,6 +1153,7 @@ static inline void cpsw_add_default_vlan(struct cpsw_priv *priv)
 	const int port = priv->host_port;
 	u32 reg;
 	int i;
+	int unreg_mcast_mask;
 
 	reg = (priv->version == CPSW_VERSION_1) ? CPSW1_PORT_VLAN :
 	       CPSW2_PORT_VLAN;
@@ -1158,9 +1163,14 @@ static inline void cpsw_add_default_vlan(struct cpsw_priv *priv)
 	for (i = 0; i < priv->data.slaves; i++)
 		slave_write(priv->slaves + i, vlan, reg);
 
+	if (priv->ndev->flags & IFF_ALLMULTI)
+		unreg_mcast_mask = ALE_ALL_PORTS;
+	else
+		unreg_mcast_mask = ALE_PORT_1 | ALE_PORT_2;
+
 	cpsw_ale_add_vlan(priv->ale, vlan, ALE_ALL_PORTS << port,
 			  ALE_ALL_PORTS << port, ALE_ALL_PORTS << port,
-			  (ALE_PORT_1 | ALE_PORT_2) << port);
+			  unreg_mcast_mask << port);
 }
 
 static void cpsw_init_host_port(struct cpsw_priv *priv)
@@ -1620,11 +1630,17 @@ static inline int cpsw_add_vlan_ale_entry(struct cpsw_priv *priv,
 				unsigned short vid)
 {
 	int ret;
+	int unreg_mcast_mask;
+
+	if (priv->ndev->flags & IFF_ALLMULTI)
+		unreg_mcast_mask = ALE_ALL_PORTS;
+	else
+		unreg_mcast_mask = ALE_PORT_1 | ALE_PORT_2;
 
 	ret = cpsw_ale_add_vlan(priv->ale, vid,
 				ALE_ALL_PORTS << priv->host_port,
 				0, ALE_ALL_PORTS << priv->host_port,
-				(ALE_PORT_1 | ALE_PORT_2) << priv->host_port);
+				unreg_mcast_mask << priv->host_port);
 	if (ret != 0)
 		return ret;
 
diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 0579b22..3ae8387 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -443,6 +443,35 @@ int cpsw_ale_del_vlan(struct cpsw_ale *ale, u16 vid, int port_mask)
 	return 0;
 }
 
+void cpsw_ale_set_allmulti(struct cpsw_ale *ale, int allmulti)
+{
+	u32 ale_entry[ALE_ENTRY_WORDS];
+	int type, idx;
+	int unreg_mcast = 0;
+
+	/* Only bother doing the work if the setting is actually changing */
+	if (ale->allmulti == allmulti)
+		return;
+
+	/* Remember the new setting to check against next time */
+	ale->allmulti = allmulti;
+
+	for (idx = 0; idx < ale->params.ale_entries; idx++) {
+		cpsw_ale_read(ale, idx, ale_entry);
+		type = cpsw_ale_get_entry_type(ale_entry);
+		if (type != ALE_TYPE_VLAN)
+			continue;
+
+		unreg_mcast = cpsw_ale_get_vlan_unreg_mcast(ale_entry);
+		if (allmulti)
+			unreg_mcast |= 1;
+		else
+			unreg_mcast &= ~1;
+		cpsw_ale_set_vlan_unreg_mcast(ale_entry, unreg_mcast);
+		cpsw_ale_write(ale, idx, ale_entry);
+	}
+}
+
 struct ale_control_info {
 	const char	*name;
 	int		offset, port_offset;
diff --git a/drivers/net/ethernet/ti/cpsw_ale.h b/drivers/net/ethernet/ti/cpsw_ale.h
index 31cf43c..c0d4127 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.h
+++ b/drivers/net/ethernet/ti/cpsw_ale.h
@@ -27,6 +27,7 @@ struct cpsw_ale {
 	struct cpsw_ale_params	params;
 	struct timer_list	timer;
 	unsigned long		ageout;
+	int			allmulti;
 };
 
 enum cpsw_ale_control {
@@ -103,6 +104,7 @@ int cpsw_ale_del_mcast(struct cpsw_ale *ale, u8 *addr, int port_mask,
 int cpsw_ale_add_vlan(struct cpsw_ale *ale, u16 vid, int port, int untag,
 			int reg_mcast, int unreg_mcast);
 int cpsw_ale_del_vlan(struct cpsw_ale *ale, u16 vid, int port);
+void cpsw_ale_set_allmulti(struct cpsw_ale *ale, int allmulti);
 
 int cpsw_ale_control_get(struct cpsw_ale *ale, int port, int control);
 int cpsw_ale_control_set(struct cpsw_ale *ale, int port,

-- 
Len Sorensen
