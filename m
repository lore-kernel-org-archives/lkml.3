Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaKDWD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 17:03:57 -0500
Received: from na6sys009bog006.obsmtp.com ([74.125.150.52]:56862 "HELO
	na6sys009bog006.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752056AbaKDWDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 17:03:54 -0500
From: Joe Stringer <joestringer@nicira.com>
To: netdev@vger.kernel.org
Cc: sathya.perla@emulex.com, jeffrey.t.kirsher@intel.com, linux.nics@intel.com,
        amirv@mellanox.com, shahed.shaikh@qlogic.com,
        Dept-GELinuxNICDev@qlogic.com, therbert@google.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 2/5] i40e: Implement ndo_gso_check()
Date: Tue,  4 Nov 2014 13:56:39 -0800
Message-Id: <1415138202-1197-3-git-send-email-joestringer@nicira.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415138202-1197-1-git-send-email-joestringer@nicira.com>
References: <1415138202-1197-1-git-send-email-joestringer@nicira.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ndo_gso_check() was recently introduced to allow NICs to report the
offloading support that they have on a per-skb basis. Add an
implementation for this driver which checks for tunnel headers over UDP
of up to 64 octets in length.

Implementation shamelessly stolen from Tom Herbert:
http://thread.gmane.org/gmane.linux.network/332428/focus=333111

Signed-off-by: Joe Stringer <joestringer@nicira.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index c3a7f4a..21829b5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7444,9 +7444,20 @@ static int i40e_ndo_fdb_dump(struct sk_buff *skb,
 
 	return idx;
 }
-
 #endif /* USE_DEFAULT_FDB_DEL_DUMP */
 #endif /* HAVE_FDB_OPS */
+
+static bool i40e_gso_check(struct sk_buff *skb, struct net_device *dev)
+{
+	if ((skb_shinfo(skb)->gso_type & SKB_GSO_UDP_TUNNEL) &&
+	    (skb->inner_protocol_type != ENCAP_TYPE_ETHER ||
+	     skb->inner_protocol != htons(ETH_P_TEB) ||
+	     skb_inner_mac_header(skb) - skb_transport_header(skb) > 64))
+		return false;
+
+	return true;
+}
+
 static const struct net_device_ops i40e_netdev_ops = {
 	.ndo_open		= i40e_open,
 	.ndo_stop		= i40e_close,
@@ -7487,6 +7498,7 @@ static const struct net_device_ops i40e_netdev_ops = {
 	.ndo_fdb_dump		= i40e_ndo_fdb_dump,
 #endif
 #endif
+	.ndo_gso_check		= i40e_gso_check,
 };
 
 /**
-- 
1.7.10.4

