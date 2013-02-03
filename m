Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab3BCBYd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:24:33 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33749 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab3BCBXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:23:10 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net
Subject: [PATCH 58/62] net/9p: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:59 -0800
Message-Id: <1359854463-2538-59-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
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
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

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

