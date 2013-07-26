Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161028Ab3GZVg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:36:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759920Ab3GZUsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sarveshwar Bandi <sarveshwar.bandi@emulex.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 36/79] be2net: Fix to avoid hardware workaround when not needed
Date: Fri, 26 Jul 2013 13:47:26 -0700
Message-Id: <20130726204725.697657654@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarveshwar Bandi <sarveshwar.bandi@emulex.com>

[ Upstream commit 52fe29e4bb614367c108b717c6d7fe5953eb7af3 ]

Hardware workaround requesting hardware to skip vlan insertion is necessary
only when umc or qnq is enabled. Enabling this workaround in other scenarios
could cause controller to stall.

Signed-off-by: Sarveshwar Bandi <sarveshwar.bandi@emulex.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/emulex/benet/be_main.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -782,16 +782,22 @@ static struct sk_buff *be_insert_vlan_in
 
 	if (vlan_tx_tag_present(skb))
 		vlan_tag = be_get_tx_vlan_tag(adapter, skb);
-	else if (qnq_async_evt_rcvd(adapter) && adapter->pvid)
-		vlan_tag = adapter->pvid;
+
+	if (qnq_async_evt_rcvd(adapter) && adapter->pvid) {
+		if (!vlan_tag)
+			vlan_tag = adapter->pvid;
+		/* f/w workaround to set skip_hw_vlan = 1, informs the F/W to
+		 * skip VLAN insertion
+		 */
+		if (skip_hw_vlan)
+			*skip_hw_vlan = true;
+	}
 
 	if (vlan_tag) {
 		skb = __vlan_put_tag(skb, htons(ETH_P_8021Q), vlan_tag);
 		if (unlikely(!skb))
 			return skb;
 		skb->vlan_tci = 0;
-		if (skip_hw_vlan)
-			*skip_hw_vlan = true;
 	}
 
 	/* Insert the outer VLAN, if any */


