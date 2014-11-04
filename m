Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaKDWEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 17:04:07 -0500
Received: from na6sys009bog029.obsmtp.com ([74.125.150.103]:41217 "HELO
	na6sys009bog029.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752056AbaKDWEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 17:04:05 -0500
From: Joe Stringer <joestringer@nicira.com>
To: netdev@vger.kernel.org
Cc: sathya.perla@emulex.com, jeffrey.t.kirsher@intel.com, linux.nics@intel.com,
        amirv@mellanox.com, shahed.shaikh@qlogic.com,
        Dept-GELinuxNICDev@qlogic.com, therbert@google.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 5/5] qlcnic: Implement ndo_gso_check()
Date: Tue,  4 Nov 2014 13:56:42 -0800
Message-Id: <1415138202-1197-6-git-send-email-joestringer@nicira.com>
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
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index f5e29f7..6184f47 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -505,6 +505,17 @@ static void qlcnic_del_vxlan_port(struct net_device *netdev,
 }
 #endif
 
+static bool qlcnic_gso_check(struct sk_buff *skb, struct net_device *dev)
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
 static const struct net_device_ops qlcnic_netdev_ops = {
 	.ndo_open	   = qlcnic_open,
 	.ndo_stop	   = qlcnic_close,
@@ -537,6 +548,7 @@ static const struct net_device_ops qlcnic_netdev_ops = {
 	.ndo_set_vf_vlan	= qlcnic_sriov_set_vf_vlan,
 	.ndo_set_vf_spoofchk	= qlcnic_sriov_set_vf_spoofchk,
 #endif
+	.ndo_gso_check		= qlcnic_gso_check,
 };
 
 static const struct net_device_ops qlcnic_netdev_failed_ops = {
-- 
1.7.10.4

