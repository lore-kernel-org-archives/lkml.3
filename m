Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaKDWCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 17:02:55 -0500
Received: from na6sys009bog003.obsmtp.com ([74.125.150.46]:48578 "HELO
	na6sys009bog003.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751665AbaKDWCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 17:02:53 -0500
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Nov 2014 17:02:53 EST
From: Joe Stringer <joestringer@nicira.com>
To: netdev@vger.kernel.org
Cc: sathya.perla@emulex.com, jeffrey.t.kirsher@intel.com, linux.nics@intel.com,
        amirv@mellanox.com, shahed.shaikh@qlogic.com,
        Dept-GELinuxNICDev@qlogic.com, therbert@google.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 4/5] net/mlx4_en: Implement ndo_gso_check()
Date: Tue,  4 Nov 2014 13:56:41 -0800
Message-Id: <1415138202-1197-5-git-send-email-joestringer@nicira.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415138202-1197-1-git-send-email-joestringer@nicira.com>
References: <1415138202-1197-1-git-send-email-joestringer@nicira.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ndo_gso_check() was recently introduced to allow NICs to report the
offloading support that they have on a per-skb basis. Add an
implementation for this driver which checks for something that looks
like VXLAN.

Implementation shamelessly stolen from Tom Herbert:
http://thread.gmane.org/gmane.linux.network/332428/focus=333111

Signed-off-by: Joe Stringer <joestringer@nicira.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index f3032fe..aca9908 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2344,6 +2344,17 @@ static void mlx4_en_del_vxlan_port(struct  net_device *dev,
 }
 #endif
 
+static bool mlx4_en_gso_check(struct sk_buff *skb, struct net_device *dev)
+{
+	if ((skb_shinfo(skb)->gso_type & SKB_GSO_UDP_TUNNEL) &&
+	    (skb->inner_protocol_type != ENCAP_TYPE_ETHER ||
+	     skb->inner_protocol != htons(ETH_P_TEB) ||
+	     skb_inner_mac_header(skb) - skb_transport_header(skb) != 16))
+		return false;
+
+	return true;
+}
+
 static const struct net_device_ops mlx4_netdev_ops = {
 	.ndo_open		= mlx4_en_open,
 	.ndo_stop		= mlx4_en_close,
@@ -2374,6 +2385,7 @@ static const struct net_device_ops mlx4_netdev_ops = {
 	.ndo_add_vxlan_port	= mlx4_en_add_vxlan_port,
 	.ndo_del_vxlan_port	= mlx4_en_del_vxlan_port,
 #endif
+	.ndo_gso_check		= mlx4_en_gso_check,
 };
 
 static const struct net_device_ops mlx4_netdev_ops_master = {
-- 
1.7.10.4

