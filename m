Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935036AbaBDV6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:58:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56952 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934211AbaBDVJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:09:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joseph Gasparakis <joseph.gasparakis@intel.com>,
        Pravin B Shelar <pshelar@nicira.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 111/133] net/vxlan: Share RX skb de-marking and checksum checks with ovs
Date: Tue,  4 Feb 2014 13:08:32 -0800
Message-Id: <20140204210740.165684262@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Gerlitz <ogerlitz@mellanox.com>

[ Upstream commit d0bc65557ad09a57b4db176e9e3ccddb26971453 ]

Make sure the practice set by commit 0afb166 "vxlan: Add capability
of Rx checksum offload for inner packet" is applied when the skb
goes through the portion of the RX code which is shared between
vxlan netdevices and ovs vxlan port instances.

Cc: Joseph Gasparakis <joseph.gasparakis@intel.com>
Cc: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1051,6 +1051,15 @@ static int vxlan_udp_encap_recv(struct s
 	if (!vs)
 		goto drop;
 
+	/* If the NIC driver gave us an encapsulated packet
+	 * with the encapsulation mark, the device checksummed it
+	 * for us. Otherwise force the upper layers to verify it.
+	 */
+	if (skb->ip_summed != CHECKSUM_UNNECESSARY || !skb->encapsulation)
+		skb->ip_summed = CHECKSUM_NONE;
+
+	skb->encapsulation = 0;
+
 	vs->rcv(vs, skb, vxh->vx_vni);
 	return 0;
 
@@ -1109,17 +1118,6 @@ static void vxlan_rcv(struct vxlan_sock
 
 	skb_reset_network_header(skb);
 
-	/* If the NIC driver gave us an encapsulated packet with
-	 * CHECKSUM_UNNECESSARY and Rx checksum feature is enabled,
-	 * leave the CHECKSUM_UNNECESSARY, the device checksummed it
-	 * for us. Otherwise force the upper layers to verify it.
-	 */
-	if (skb->ip_summed != CHECKSUM_UNNECESSARY || !skb->encapsulation ||
-	    !(vxlan->dev->features & NETIF_F_RXCSUM))
-		skb->ip_summed = CHECKSUM_NONE;
-
-	skb->encapsulation = 0;
-
 	if (oip6)
 		err = IP6_ECN_decapsulate(oip6, skb);
 	if (oip)


