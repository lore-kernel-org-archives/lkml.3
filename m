Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaKFWhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:37:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58466 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaKFWhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:37:33 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Vladislav Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 017/162] tg3: Allow for recieve of full-size 8021AD frames
Date: Thu,  6 Nov 2014 14:34:41 -0800
Message-Id: <1415313426-9622-18-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevich@gmail.com>

[ Upstream commit 7d3083ee36b51e425b6abd76778a2046906b0fd3 ]

When receiving a vlan-tagged frame that still contains
a vlan header, the length of the packet will be greater
then MTU+ETH_HLEN since it will account of the extra
vlan header.  TG3 checks this for the case for 802.1Q,
but not for 802.1ad.  As a result, full sized 802.1ad
frames get dropped by the card.

Add a check for 802.1ad protocol when receving full
sized frames.

Suggested-by: Prashant Sreedharan <prashant@broadcom.com>
CC: Prashant Sreedharan <prashant@broadcom.com>
CC: Michael Chan <mchan@broadcom.com>
Signed-off-by: Vladislav Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 072f401..1b84139 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -6907,7 +6907,8 @@ static int tg3_rx(struct tg3_napi *tnapi, int budget)
 		skb->protocol = eth_type_trans(skb, tp->dev);
 
 		if (len > (tp->dev->mtu + ETH_HLEN) &&
-		    skb->protocol != htons(ETH_P_8021Q)) {
+		    skb->protocol != htons(ETH_P_8021Q) &&
+		    skb->protocol != htons(ETH_P_8021AD)) {
 			dev_kfree_skb(skb);
 			goto drop_it_no_recycle;
 		}
-- 
1.9.1

