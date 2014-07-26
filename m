Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbaGZUTq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 16:19:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaGZTC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:02:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li RongQing <roy.qing.li@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 06/23] 8021q: fix a potential memory leak
Date: Sat, 26 Jul 2014 12:02:06 -0700
Message-Id: <20140726190149.916041369@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190149.723570428@linuxfoundation.org>
References: <20140726190149.723570428@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <roy.qing.li@gmail.com>

[ Upstream commit 916c1689a09bc1ca81f2d7a34876f8d35aadd11b ]

skb_cow called in vlan_reorder_header does not free the skb when it failed,
and vlan_reorder_header returns NULL to reset original skb when it is called
in vlan_untag, lead to a memory leak.

Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/8021q/vlan_core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -96,8 +96,11 @@ EXPORT_SYMBOL(vlan_dev_vlan_id);
 
 static struct sk_buff *vlan_reorder_header(struct sk_buff *skb)
 {
-	if (skb_cow(skb, skb_headroom(skb)) < 0)
+	if (skb_cow(skb, skb_headroom(skb)) < 0) {
+		kfree_skb(skb);
 		return NULL;
+	}
+
 	memmove(skb->data - ETH_HLEN, skb->data - VLAN_ETH_HLEN, 2 * ETH_ALEN);
 	skb->mac_header += VLAN_HLEN;
 	return skb;


