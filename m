Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab3BCBaZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:30:25 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:48239 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab3BCBWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:22:16 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: [PATCH 31/62] dm: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:32 -0800
Message-Id: <1359854463-2538-32-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/md/dm.c | 54 +++++++++++++++---------------------------------------
 1 file changed, 15 insertions(+), 39 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ea1a6ca..29cd4e2 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1753,62 +1753,38 @@ static void free_minor(int minor)
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

