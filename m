Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbaJMC0p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:26:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45699 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbaJMC0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:26:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Vladislav Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 21/37] tg3: Allow for recieve of full-size 8021AD frames
Date: Mon, 13 Oct 2014 04:24:18 +0200
Message-Id: <20141013022401.176669853@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022400.286360067@linuxfoundation.org>
References: <20141013022400.286360067@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/tg3.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -6923,7 +6923,8 @@ static int tg3_rx(struct tg3_napi *tnapi
 		skb->protocol = eth_type_trans(skb, tp->dev);
 
 		if (len > (tp->dev->mtu + ETH_HLEN) &&
-		    skb->protocol != htons(ETH_P_8021Q)) {
+		    skb->protocol != htons(ETH_P_8021Q) &&
+		    skb->protocol != htons(ETH_P_8021AD)) {
 			dev_kfree_skb(skb);
 			goto drop_it_no_recycle;
 		}


