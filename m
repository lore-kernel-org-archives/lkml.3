Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbaGBNI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:08:27 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:61424 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaGBNIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:08:25 -0400
Subject: [RFC PATCH] [blk]: fix NULL bdev dereference in driver's merge
 callbacks
From: Stanislav Kinsbursky <stanislav.kinsbursky@profitbricks.com>
To: axboe@kernel.dk
Cc: florian-ewald.mueller@profitbricks.com, linux-kernel@vger.kernel.org,
        stanislav.kinsbursky@profitbricks.com
Date: Wed, 02 Jul 2014 15:02:01 +0200
Message-ID: <20140702130149.25700.32590.stgit@skinsbursky-OptiPlex-9020>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function __bio_map_kern() allocates new fresh bio with bi_bdev field undefined
and set to NULL. Than it calls bio_add_pc_page() which in turn calls
merge_bvec_fn() callback if defined, passing bvec_megre_data structure
pointer, with bi_bdev filesd initialized to "bio::bi_bdev" (equal to NULL).
There are 9 of them so far. At least some of them (like "rbd_merge_bvec",
"linear_mergeable_bvec") then dereference undefined "bvec_megre_data::bi_bdev"
to get start sector of the device, resulting in NULL pointer dereference.
This patch adds check for non-NULL bio->bi_bdev pointer to make sure, that the
device is defined, otherwise there is no sense to call this callback at all.

Signed-of-by: Stanislav Kinsbursky <stanislav.kinsbursky@profitbricks.com>
---
 block/bio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 0ec61c9..cb45186 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -725,7 +725,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 			unsigned int prev_bv_len = prev->bv_len;
 			prev->bv_len += len;
 
-			if (q->merge_bvec_fn) {
+			if (q->merge_bvec_fn && bio->bi_bdev) {
 				struct bvec_merge_data bvm = {
 					/* prev_bvec is already charged in
 					   bi_size, discharge it in order to
@@ -787,7 +787,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	 * depending on offset), it can specify a merge_bvec_fn in the
 	 * queue to get further control
 	 */
-	if (q->merge_bvec_fn) {
+	if (q->merge_bvec_fn && bio->bi_bdev) {
 		struct bvec_merge_data bvm = {
 			.bi_bdev = bio->bi_bdev,
 			.bi_sector = bio->bi_iter.bi_sector,

