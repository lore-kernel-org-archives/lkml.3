Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934666AbaE2FgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:36:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbaE2Ee6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <koverstreet@google.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 3.14 030/140] md/raid1: r1buf_pool_alloc: free allocate pages when subsequent allocation fails.
Date: Wed, 28 May 2014 21:32:49 -0700
Message-Id: <20140529043053.247831291@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid1.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -97,6 +97,7 @@ static void * r1buf_pool_alloc(gfp_t gfp
 	struct pool_info *pi = data;
 	struct r1bio *r1_bio;
 	struct bio *bio;
+	int need_pages;
 	int i, j;
 
 	r1_bio = r1bio_pool_alloc(gfp_flags, pi);
@@ -119,15 +120,15 @@ static void * r1buf_pool_alloc(gfp_t gfp
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
@@ -141,6 +142,14 @@ static void * r1buf_pool_alloc(gfp_t gfp
 
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


