Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab3AQS7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 13:59:08 -0500
Received: from amsterdam.lcs.mit.edu ([18.26.4.9]:11409 "EHLO
	amsterdam.lcs.mit.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763Ab3AQS7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 13:59:06 -0500
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/xfrm/xfrm_replay: avoid division by zero
Date: Thu, 17 Jan 2013 13:58:28 -0500
Message-Id: <1358449108-67839-1-git-send-email-nickolai@csail.mit.edu>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of the xfrm_replay->advance functions in xfrm_replay.c check if
x->replay_esn->replay_window is zero (and return if so).  However,
one of them, xfrm_replay_advance_bmp(), divides by that value (in the
'%' operator) before doing the check, which can potentially trigger
a divide-by-zero exception.  Some compilers will also assume that the
earlier division means the value cannot be zero later, and thus will
eliminate the subsequent zero check as dead code.

This patch moves the division to after the check.

Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---
 net/xfrm/xfrm_replay.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index 765f6fe..35754cc 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -242,11 +242,13 @@ static void xfrm_replay_advance_bmp(struct xfrm_state *x, __be32 net_seq)
 	u32 diff;
 	struct xfrm_replay_state_esn *replay_esn = x->replay_esn;
 	u32 seq = ntohl(net_seq);
-	u32 pos = (replay_esn->seq - 1) % replay_esn->replay_window;
+	u32 pos;
 
 	if (!replay_esn->replay_window)
 		return;
 
+	pos = (replay_esn->seq - 1) % replay_esn->replay_window;
+
 	if (seq > replay_esn->seq) {
 		diff = seq - replay_esn->seq;
 
-- 
1.7.10.4

