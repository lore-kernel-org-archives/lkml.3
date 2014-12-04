Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993AbaLDSj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:39:59 -0500
Received: from na6sys009bog029.obsmtp.com ([74.125.150.103]:60053 "HELO
	na6sys009bog029.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932215AbaLDSjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:39:55 -0500
From: Joe Stringer <joestringer@nicira.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jesse@nicira.com, shannon.nelson@intel.com,
        jesse.brandeburg@intel.com, jeffrey.t.kirsher@intel.com,
        therbert@google.com, linux.nics@intel.com
Subject: [PATCHv3 net] i40e: Implement ndo_gso_check()
Date: Thu,  4 Dec 2014 10:39:26 -0800
Message-Id: <1417718366-14310-1-git-send-email-joestringer@nicira.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ndo_gso_check() was recently introduced to allow NICs to report the
offloading support that they have on a per-skb basis. Add an
implementation for this driver which checks for IPIP, GRE, UDP tunnels.

Signed-off-by: Joe Stringer <joestringer@nicira.com>
---
v3: Drop IPIP and GRE (no driver support even though hw supports it).
    Check for UDP outer protocol for UDP tunnels.
v2: Expand to include IP in IP and IPv4/IPv6 inside GRE/UDP tunnels.
    Add MAX_INNER_LENGTH (as 80).
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index c3a7f4a..0d6493a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7447,6 +7447,31 @@ static int i40e_ndo_fdb_dump(struct sk_buff *skb,
 
 #endif /* USE_DEFAULT_FDB_DEL_DUMP */
 #endif /* HAVE_FDB_OPS */
+static bool i40e_gso_check(struct sk_buff *skb, struct net_device *dev)
+{
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_TUNNEL) {
+		unsigned char *ihdr;
+
+		if (skb->protocol != IPPROTO_UDP ||
+		    skb->inner_protocol_type != ENCAP_TYPE_ETHER)
+			return false;
+
+		if (skb->inner_protocol == htons(ETH_P_TEB))
+			ihdr = skb_inner_mac_header(skb);
+		else if (skb->inner_protocol == htons(ETH_P_IP) ||
+			 skb->inner_protocol == htons(ETH_P_IPV6))
+			ihdr = skb_inner_network_header(skb);
+		else
+			return false;
+
+#define MAX_TUNNEL_HDR_LEN	80
+		if (ihdr - skb_transport_header(skb) > MAX_TUNNEL_HDR_LEN)
+			return false;
+	}
+
+	return true;
+}
+
 static const struct net_device_ops i40e_netdev_ops = {
 	.ndo_open		= i40e_open,
 	.ndo_stop		= i40e_close,
@@ -7487,6 +7512,7 @@ static const struct net_device_ops i40e_netdev_ops = {
 	.ndo_fdb_dump		= i40e_ndo_fdb_dump,
 #endif
 #endif
+	.ndo_gso_check		= i40e_gso_check,
 };
 
 /**
-- 
1.7.10.4

