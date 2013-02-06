Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376Ab3BFTvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:51:44 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:42213 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758307Ab3BFTv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:51:26 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net
Subject: [PATCH 74/77] net/9p: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:46 -0800
Message-Id: <1360179649-22465-75-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Cc: v9fs-developer@lists.sourceforge.net
---
 net/9p/util.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/net/9p/util.c b/net/9p/util.c
index 6ceeeb3..59f278e 100644
--- a/net/9p/util.c
+++ b/net/9p/util.c
@@ -87,23 +87,18 @@ EXPORT_SYMBOL(p9_idpool_destroy);
 
 int p9_idpool_get(struct p9_idpool *p)
 {
-	int i = 0;
-	int error;
+	int i;
 	unsigned long flags;
 
-retry:
-	if (idr_pre_get(&p->pool, GFP_NOFS) == 0)
-		return -1;
-
+	idr_preload(GFP_NOFS);
 	spin_lock_irqsave(&p->lock, flags);
 
 	/* no need to store exactly p, we just need something non-null */
-	error = idr_get_new(&p->pool, p, &i);
-	spin_unlock_irqrestore(&p->lock, flags);
+	i = idr_alloc(&p->pool, p, 0, 0, GFP_NOWAIT);
 
-	if (error == -EAGAIN)
-		goto retry;
-	else if (error)
+	spin_unlock_irqrestore(&p->lock, flags);
+	idr_preload_end();
+	if (i < 0)
 		return -1;
 
 	p9_debug(P9_DEBUG_MUX, " id %d pool %p\n", i, p);
-- 
1.8.1

