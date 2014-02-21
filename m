Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295AbaBUNkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:40:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47045 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbaBUMuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 065/121] md/raid1: restore ability for check and repair to fix read errors.
Date: Fri, 21 Feb 2014 12:48:09 +0000
Message-Id: <1392986945-9693-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 1877db75589a895bbdc4c4c3f23558e57b521141 upstream.

commit 30bc9b53878a9921b02e3b5bc4283ac1c6de102a
    md/raid1: fix bio handling problems in process_checks()

Move the bio_reset() to a point before where BIO_UPTODATE is checked,
so that check now always report that the bio is uptodate, even if it is not.

This causes process_check() to sometimes treat read-errors as
successful matches so the good data isn't written out.

This patch preserves the flag until it is needed.

Bug was introduced in 3.11, but backported to 3.10-stable (as it fixed
an even worse bug).  So suitable for any -stable since 3.10.

Reported-and-tested-by: Michael Tokarev <mjt@tls.msk.ru>
Fixed: 30bc9b53878a9921b02e3b5bc4283ac1c6de102a
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/raid1.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index aacf6bf..6edc2db 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1855,11 +1855,15 @@ static int process_checks(struct r1bio *r1_bio)
 	for (i = 0; i < conf->raid_disks * 2; i++) {
 		int j;
 		int size;
+		int uptodate;
 		struct bio *b = r1_bio->bios[i];
 		if (b->bi_end_io != end_sync_read)
 			continue;
-		/* fixup the bio for reuse */
+		/* fixup the bio for reuse, but preserve BIO_UPTODATE */
+		uptodate = test_bit(BIO_UPTODATE, &b->bi_flags);
 		bio_reset(b);
+		if (!uptodate)
+			clear_bit(BIO_UPTODATE, &b->bi_flags);
 		b->bi_vcnt = vcnt;
 		b->bi_size = r1_bio->sectors << 9;
 		b->bi_sector = r1_bio->sector +
@@ -1892,11 +1896,14 @@ static int process_checks(struct r1bio *r1_bio)
 		int j;
 		struct bio *pbio = r1_bio->bios[primary];
 		struct bio *sbio = r1_bio->bios[i];
+		int uptodate = test_bit(BIO_UPTODATE, &sbio->bi_flags);
 
 		if (sbio->bi_end_io != end_sync_read)
 			continue;
+		/* Now we can 'fixup' the BIO_UPTODATE flag */
+		set_bit(BIO_UPTODATE, &sbio->bi_flags);
 
-		if (test_bit(BIO_UPTODATE, &sbio->bi_flags)) {
+		if (uptodate) {
 			for (j = vcnt; j-- ; ) {
 				struct page *p, *s;
 				p = pbio->bi_io_vec[j].bv_page;
@@ -1911,7 +1918,7 @@ static int process_checks(struct r1bio *r1_bio)
 		if (j >= 0)
 			atomic64_add(r1_bio->sectors, &mddev->resync_mismatches);
 		if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)
-			      && test_bit(BIO_UPTODATE, &sbio->bi_flags))) {
+			      && uptodate)) {
 			/* No need to write to this device. */
 			sbio->bi_end_io = NULL;
 			rdev_dec_pending(conf->mirrors[i].rdev, mddev);
-- 
1.9.0

