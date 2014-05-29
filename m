Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934357AbaE2FYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:24:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426AbaE2EfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 070/140] bridge: Fix double free and memory leak around br_allowed_ingress
Date: Wed, 28 May 2014 21:33:29 -0700
Message-Id: <20140529043058.525402286@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>

[ Upstream commit eb7076182d1ae4bc4641534134ed707100d76acc ]

br_allowed_ingress() has two problems.

1. If br_allowed_ingress() is called by br_handle_frame_finish() and
vlan_untag() in br_allowed_ingress() fails, skb will be freed by both
vlan_untag() and br_handle_frame_finish().

2. If br_allowed_ingress() is called by br_dev_xmit() and
br_allowed_ingress() fails, the skb will not be freed.

Fix these two problems by freeing the skb in br_allowed_ingress()
if it fails.

Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_input.c |    2 +-
 net/bridge/br_vlan.c  |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -73,7 +73,7 @@ int br_handle_frame_finish(struct sk_buf
 		goto drop;
 
 	if (!br_allowed_ingress(p->br, nbp_get_vlan_info(p), skb, &vid))
-		goto drop;
+		goto out;
 
 	/* insert into forwarding database after filtering to avoid spoofing */
 	br = p->br;
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -170,7 +170,7 @@ bool br_allowed_ingress(struct net_bridg
 	 * rejected.
 	 */
 	if (!v)
-		return false;
+		goto drop;
 
 	/* If vlan tx offload is disabled on bridge device and frame was
 	 * sent from vlan device on the bridge device, it does not have
@@ -193,7 +193,7 @@ bool br_allowed_ingress(struct net_bridg
 		 * vlan untagged or priority-tagged traffic belongs to.
 		 */
 		if (pvid == VLAN_N_VID)
-			return false;
+			goto drop;
 
 		/* PVID is set on this port.  Any untagged or priority-tagged
 		 * ingress frame is considered to belong to this vlan.
@@ -216,7 +216,8 @@ bool br_allowed_ingress(struct net_bridg
 	/* Frame had a valid vlan tag.  See if vlan is allowed */
 	if (test_bit(*vid, v->vlan_bitmap))
 		return true;
-
+drop:
+	kfree_skb(skb);
 	return false;
 }
 


