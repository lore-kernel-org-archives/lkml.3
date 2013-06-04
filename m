Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3FDWmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:42:37 -0400
Received: from 1wt.eu ([62.212.114.60]:35479 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071Ab3FDWm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:26 -0400
Message-Id: <20130604172133.952707962@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 088/184] xfrm_user: return error pointer instead of NULL #2
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit c25463722509fef0ed630b271576a8c9a70236f3 upstream.

When dump_one_policy() returns an error, e.g. because of a too small
buffer to dump the whole xfrm policy, xfrm_policy_netlink() returns
NULL instead of an error pointer. But its caller expects an error
pointer and therefore continues to operate on a NULL skbuff.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/xfrm/xfrm_user.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index dff20ac..06f42f6 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1306,6 +1306,7 @@ static struct sk_buff *xfrm_policy_netlink(struct sk_buff *in_skb,
 {
 	struct xfrm_dump_info info;
 	struct sk_buff *skb;
+	int err;
 
 	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!skb)
@@ -1316,9 +1317,10 @@ static struct sk_buff *xfrm_policy_netlink(struct sk_buff *in_skb,
 	info.nlmsg_seq = seq;
 	info.nlmsg_flags = 0;
 
-	if (dump_one_policy(xp, dir, 0, &info) < 0) {
+	err = dump_one_policy(xp, dir, 0, &info);
+	if (err) {
 		kfree_skb(skb);
-		return NULL;
+		return ERR_PTR(err);
 	}
 
 	return skb;
-- 
1.7.12.2.21.g234cd45.dirty



