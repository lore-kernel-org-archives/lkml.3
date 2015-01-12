Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbbALLp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:45:57 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:64701 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbbALLom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:44:42 -0500
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>, Neil Brown <neilb@suse.de>,
        linux-raid@vger.kernel.org, Dongsu Park <dongsu.park@profitbricks.com>
Subject: [PATCH v2 5/7] md/raid10: make sync_request_write() call bio_copy_data()
Date: Mon, 12 Jan 2015 12:44:02 +0100
Message-Id: <9ef99a9bae03003ae7b2fff1bf942e63aff6e45a.1421052656.git.dongsu.park@profitbricks.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <63ea4e86f2a06cbe273692932bdf2499fef01644.1421052656.git.dongsu.park@profitbricks.com>
References: <cover.1421052656.git.dongsu.park@profitbricks.com>
 <19cceed4e701430bfb307301a38cdf8d40fbfcac.1421052656.git.dongsu.park@profitbricks.com>
 <0bdbbd2ef9d449be2d00e01ca7dc7f101b6cfb88.1421052656.git.dongsu.park@profitbricks.com>
 <0117035a25929ae97e2039edc895f582d53cf217.1421052656.git.dongsu.park@profitbricks.com>
 <63ea4e86f2a06cbe273692932bdf2499fef01644.1421052656.git.dongsu.park@profitbricks.com>
In-Reply-To: <cover.1421052656.git.dongsu.park@profitbricks.com>
References: <cover.1421052656.git.dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <kmo@daterainc.com>

Refactor sync_request_write() of md/raid10 to use bio_copy_data()
instead of open coding bio_vec iterations.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
Signed-off-by: Kent Overstreet <kmo@daterainc.com>
[dpark: add more description in commit message]
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
---
 drivers/md/raid10.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 32e282f..4a40354 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2107,18 +2107,11 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		tbio->bi_vcnt = vcnt;
 		tbio->bi_iter.bi_size = r10_bio->sectors << 9;
 		tbio->bi_rw = WRITE;
-		tbio->bi_private = r10_bio;
 		tbio->bi_iter.bi_sector = r10_bio->devs[i].addr;
-
-		for (j=0; j < vcnt ; j++) {
-			tbio->bi_io_vec[j].bv_offset = 0;
-			tbio->bi_io_vec[j].bv_len = PAGE_SIZE;
-
-			memcpy(page_address(tbio->bi_io_vec[j].bv_page),
-			       page_address(fbio->bi_io_vec[j].bv_page),
-			       PAGE_SIZE);
-		}
 		tbio->bi_end_io = end_sync_write;
+		tbio->bi_private = r10_bio;
+
+		bio_copy_data(tbio, fbio);
 
 		d = r10_bio->devs[i].devnum;
 		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
@@ -2134,17 +2127,14 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	 * that are active
 	 */
 	for (i = 0; i < conf->copies; i++) {
-		int j, d;
+		int d;
 
 		tbio = r10_bio->devs[i].repl_bio;
 		if (!tbio || !tbio->bi_end_io)
 			continue;
 		if (r10_bio->devs[i].bio->bi_end_io != end_sync_write
 		    && r10_bio->devs[i].bio != fbio)
-			for (j = 0; j < vcnt; j++)
-				memcpy(page_address(tbio->bi_io_vec[j].bv_page),
-				       page_address(fbio->bi_io_vec[j].bv_page),
-				       PAGE_SIZE);
+			bio_copy_data(tbio, fbio);
 		d = r10_bio->devs[i].devnum;
 		atomic_inc(&r10_bio->remaining);
 		md_sync_acct(conf->mirrors[d].replacement->bdev,
-- 
2.1.0

