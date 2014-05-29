Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935002AbaE2OPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:15:49 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59364 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933227AbaE2Ntb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Kent Overstreet <koverstreet@google.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 033/103] md/raid1: r1buf_pool_alloc: free allocate pages when subsequent allocation fails.
Date: Thu, 29 May 2014 15:48:18 +0200
Message-Id: <6c662df0d0c0770b92283c45b9566e748812d7b8.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit da1aab3dca9aa88ae34ca392470b8943159e25fe upstream.

When performing a user-request check/repair (MD_RECOVERY_REQUEST is set)
on a raid1, we allocate multiple bios each with their own set of pages.

If the page allocations for one bio fails, we currently do *not* free
the pages allocated for the previous bios, nor do we free the bio itself.

This patch frees all the already-allocate pages, and makes sure that
all the bios are freed as well.

This bug can cause a memory leak which can ultimately OOM a machine.
It was introduced in 3.10-rc1.

Fixes: a07876064a0b73ab5ef1ebcf14b1cf0231c07858
Cc: Kent Overstreet <koverstreet@google.com>
Reported-by: Russell King - ARM Linux <linux@arm.linux.org.uk>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/raid1.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6edc2db428e9..66c4aee20c72 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -94,6 +94,7 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 	struct pool_info *pi = data;
 	struct r1bio *r1_bio;
 	struct bio *bio;
+	int need_pages;
 	int i, j;
 
 	r1_bio = r1bio_pool_alloc(gfp_flags, pi);
@@ -116,15 +117,15 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 	 * RESYNC_PAGES for each bio.
 	 */
 	if (test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery))
-		j = pi->raid_disks;
+		need_pages = pi->raid_disks;
 	else
-		j = 1;
-	while(j--) {
+		need_pages = 1;
+	for (j = 0; j < need_pages; j++) {
 		bio = r1_bio->bios[j];
 		bio->bi_vcnt = RESYNC_PAGES;
 
 		if (bio_alloc_pages(bio, gfp_flags))
-			goto out_free_bio;
+			goto out_free_pages;
 	}
 	/* If not user-requests, copy the page pointers to all bios */
 	if (!test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery)) {
@@ -138,6 +139,14 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 
 	return r1_bio;
 
+out_free_pages:
+	while (--j >= 0) {
+		struct bio_vec *bv;
+
+		bio_for_each_segment_all(bv, r1_bio->bios[j], i)
+			__free_page(bv->bv_page);
+	}
+
 out_free_bio:
 	while (++j < pi->raid_disks)
 		bio_put(r1_bio->bios[j]);
-- 
1.9.3

