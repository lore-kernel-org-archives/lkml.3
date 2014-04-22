Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbaDVKQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:16:37 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:28416 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754420AbaDVKPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:15:01 -0400
X-IronPort-AV: E=Sophos;i="4.97,900,1389715200"; 
   d="scan'208";a="29566557"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 1/4] idr: proper invalid argument handling
Date: Tue, 22 Apr 2014 18:16:18 +0800
Message-ID: <1398161781-12105-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1398161781-12105-1-git-send-email-laijs@cn.fujitsu.com>
References: <1398161781-12105-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the arguments passed by the caller are invalid, WARN_ON_ONCE()
is proper than BUG_ON() which may crash the kernel.

ida_remove()/idr_remove() add checks for "id < 0".
BUG_ON() in ida_simple_remove() is simply removed, due to
ida_remove() already checks for "id < 0".

In idr_alloc(), it still returns -ENOSPC when "start == end",
but it returns -EINVAL when "max < start" while old code returns
-ENOSPC. -EINVAL is proper here, the caller must passed wrong
arguments.

ida_simple_get()'s argument-checks are changed as the same as
idr_alloc().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 lib/idr.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 96bb252..87c98fc 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -457,8 +457,10 @@ int idr_alloc(struct idr *idr, void *ptr, int start, int end, gfp_t gfp_mask)
 	/* sanity checks */
 	if (WARN_ON_ONCE(start < 0))
 		return -EINVAL;
-	if (unlikely(max < start))
+	if (unlikely(end > 0 && start == end))
 		return -ENOSPC;
+	if (WARN_ON_ONCE(max < start))
+		return -EINVAL;
 
 	/* allocate id */
 	id = idr_get_empty_slot(idr, start, pa, gfp_mask, NULL);
@@ -551,10 +553,7 @@ void idr_remove(struct idr *idp, int id)
 	struct idr_layer *p;
 	struct idr_layer *to_free;
 
-	if (id < 0)
-		return;
-
-	if (id > idr_max(idp->layers)) {
+	if (id < 0 || id > idr_max(idp->layers)) {
 		idr_remove_warning(id);
 		return;
 	}
@@ -1012,7 +1011,7 @@ void ida_remove(struct ida *ida, int id)
 	int n;
 	struct ida_bitmap *bitmap;
 
-	if (idr_id > idr_max(ida->idr.layers))
+	if (id < 0 || idr_id > idr_max(ida->idr.layers))
 		goto err;
 
 	/* clear full bits while looking up the leaf idr_layer */
@@ -1078,14 +1077,17 @@ int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
 	unsigned int max;
 	unsigned long flags;
 
-	BUG_ON((int)start < 0);
-	BUG_ON((int)end < 0);
+	if (WARN_ON_ONCE((int)start < 0))
+		return -EINVAL;
 
-	if (end == 0)
-		max = 0x80000000;
+	if ((int)end <= 0)
+		max = INT_MAX;
 	else {
-		BUG_ON(end < start);
 		max = end - 1;
+		if (unlikely(start == end))
+			return -ENOSPC;
+		if (WARN_ON_ONCE(max < start))
+			return -EINVAL;
 	}
 
 again:
@@ -1120,7 +1122,6 @@ void ida_simple_remove(struct ida *ida, unsigned int id)
 {
 	unsigned long flags;
 
-	BUG_ON((int)id < 0);
 	spin_lock_irqsave(&simple_ida_lock, flags);
 	ida_remove(ida, id);
 	spin_unlock_irqrestore(&simple_ida_lock, flags);
-- 
1.7.4.4

