Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab3BFTuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:50:46 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:60344 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758238Ab3BFTul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:50:41 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: [PATCH 47/77] dm: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:19 -0800
Message-Id: <1360179649-22465-48-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm.c | 54 +++++++++++++++---------------------------------------
 1 file changed, 15 insertions(+), 39 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c644eb6..ac74b81 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1801,62 +1801,38 @@ static void free_minor(int minor)
  */
 static int specific_minor(int minor)
 {
-	int r, m;
+	int r;
 
 	if (minor >= (1 << MINORBITS))
 		return -EINVAL;
 
-	r = idr_pre_get(&_minor_idr, GFP_KERNEL);
-	if (!r)
-		return -ENOMEM;
-
+	idr_preload(GFP_KERNEL);
 	spin_lock(&_minor_lock);
 
-	if (idr_find(&_minor_idr, minor)) {
-		r = -EBUSY;
-		goto out;
-	}
-
-	r = idr_get_new_above(&_minor_idr, MINOR_ALLOCED, minor, &m);
-	if (r)
-		goto out;
+	r = idr_alloc(&_minor_idr, MINOR_ALLOCED, minor, minor + 1, GFP_NOWAIT);
 
-	if (m != minor) {
-		idr_remove(&_minor_idr, m);
-		r = -EBUSY;
-		goto out;
-	}
-
-out:
 	spin_unlock(&_minor_lock);
-	return r;
+	idr_preload_end();
+	if (r < 0)
+		return r == -ENOSPC ? -EBUSY : r;
+	return 0;
 }
 
 static int next_free_minor(int *minor)
 {
-	int r, m;
-
-	r = idr_pre_get(&_minor_idr, GFP_KERNEL);
-	if (!r)
-		return -ENOMEM;
+	int r;
 
+	idr_preload(GFP_KERNEL);
 	spin_lock(&_minor_lock);
 
-	r = idr_get_new(&_minor_idr, MINOR_ALLOCED, &m);
-	if (r)
-		goto out;
-
-	if (m >= (1 << MINORBITS)) {
-		idr_remove(&_minor_idr, m);
-		r = -ENOSPC;
-		goto out;
-	}
-
-	*minor = m;
+	r = idr_alloc(&_minor_idr, MINOR_ALLOCED, 0, 1 << MINORBITS, GFP_NOWAIT);
 
-out:
 	spin_unlock(&_minor_lock);
-	return r;
+	idr_preload_end();
+	if (r < 0)
+		return r;
+	*minor = r;
+	return 0;
 }
 
 static const struct block_device_operations dm_blk_dops;
-- 
1.8.1

