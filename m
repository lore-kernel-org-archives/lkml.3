Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934731Ab3GWWpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:45:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934553Ab3GWW1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Brassow Jonathan <jbrassow@redhat.com>, NeilBrown <neilb@suse.de>
Subject: [ 051/103] md/raid10: fix two problems with RAID10 resync.
Date: Tue, 23 Jul 2013 15:26:02 -0700
Message-Id: <20130723220424.264452495@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 7bb23c4934059c64cbee2e41d5d24ce122285176 upstream.

1/ When an different between blocks is found, data is copied from
   one bio to the other.  However bv_len is used as the length to
   copy and this could be zero.  So use r10_bio->sectors to calculate
   length instead.
   Using bv_len was probably always a bit dubious, but the introduction
   of bio_advance made it much more likely to be a problem.

2/ When preparing some blocks for sync, we don't set BIO_UPTODATE
   except on bios that we schedule for a read.  This ensures that
   missing/failed devices don't confuse the loop at the top of
   sync_request write.
   Commit 8be185f2c9d54d6 "raid10: Use bio_reset()"
   removed a loop which set BIO_UPTDATE on all appropriate bios.
   So we need to re-add that flag.

These bugs were introduced in 3.10, so this patch is suitable for
3.10-stable, and can remove a potential for data corruption.

Reported-by: Brassow Jonathan <jbrassow@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid10.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2075,11 +2075,17 @@ static void sync_request_write(struct md
 			 * both 'first' and 'i', so we just compare them.
 			 * All vec entries are PAGE_SIZE;
 			 */
-			for (j = 0; j < vcnt; j++)
+			int sectors = r10_bio->sectors;
+			for (j = 0; j < vcnt; j++) {
+				int len = PAGE_SIZE;
+				if (sectors < (len / 512))
+					len = sectors * 512;
 				if (memcmp(page_address(fbio->bi_io_vec[j].bv_page),
 					   page_address(tbio->bi_io_vec[j].bv_page),
-					   fbio->bi_io_vec[j].bv_len))
+					   len))
 					break;
+				sectors -= len/512;
+			}
 			if (j == vcnt)
 				continue;
 			atomic64_add(r10_bio->sectors, &mddev->resync_mismatches);
@@ -3385,6 +3391,7 @@ static sector_t sync_request(struct mdde
 
 		if (bio->bi_end_io == end_sync_read) {
 			md_sync_acct(bio->bi_bdev, nr_sectors);
+			set_bit(BIO_UPTODATE, &bio->bi_flags);
 			generic_make_request(bio);
 		}
 	}


