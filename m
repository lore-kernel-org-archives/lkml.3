Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab3FRLtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:49:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56280 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588Ab3FRLpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:45:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Lyakas <alex@zadarastorage.com>, NeilBrown <neilb@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 82/93] md/raid1: consider WRITE as successful only if at least one non-Faulty and non-rebuilding drive completed it.
Date: Tue, 18 Jun 2013 12:43:30 +0100
Message-Id: <1371555821-12820-83-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Lyakas <alex@zadarastorage.com>

commit 3056e3aec8d8ba61a0710fb78b2d562600aa2ea7 upstream.

Without that fix, the following scenario could happen:

- RAID1 with drives A and B; drive B was freshly-added and is rebuilding
- Drive A fails
- WRITE request arrives to the array. It is failed by drive A, so
r1_bio is marked as R1BIO_WriteError, but the rebuilding drive B
succeeds in writing it, so the same r1_bio is marked as
R1BIO_Uptodate.
- r1_bio arrives to handle_write_finished, badblocks are disabled,
md_error()->error() does nothing because we don't fail the last drive
of raid1
- raid_end_bio_io()  calls call_bio_endio()
- As a result, in call_bio_endio():
        if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
                clear_bit(BIO_UPTODATE, &bio->bi_flags);
this code doesn't clear the BIO_UPTODATE flag, and the whole master
WRITE succeeds, back to the upper layer.

So we returned success to the upper layer, even though we had written
the data onto the rebuilding drive only. But when we want to read the
data back, we would not read from the rebuilding drive, so this data
is lost.

[neilb - applied identical change to raid10 as well]

This bug can result in lost data, so it is suitable for any
-stable kernel.

Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/raid1.c  | 12 +++++++++++-
 drivers/md/raid10.c | 12 +++++++++++-
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cb781a1..adba2e7 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -413,7 +413,17 @@ static void raid1_end_write_request(struct bio *bio, int error)
 
 		r1_bio->bios[mirror] = NULL;
 		to_put = bio;
-		set_bit(R1BIO_Uptodate, &r1_bio->state);
+		/*
+		 * Do not set R1BIO_Uptodate if the current device is
+		 * rebuilding or Faulty. This is because we cannot use
+		 * such device for properly reading the data back (we could
+		 * potentially use it, if the current write would have felt
+		 * before rdev->recovery_offset, but for simplicity we don't
+		 * check this here.
+		 */
+		if (test_bit(In_sync, &conf->mirrors[mirror].rdev->flags) &&
+		    !test_bit(Faulty, &conf->mirrors[mirror].rdev->flags))
+			set_bit(R1BIO_Uptodate, &r1_bio->state);
 
 		/* Maybe we can clear some bad blocks. */
 		if (is_badblock(conf->mirrors[mirror].rdev,
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e97d046..9dd81d9 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -461,7 +461,17 @@ static void raid10_end_write_request(struct bio *bio, int error)
 		sector_t first_bad;
 		int bad_sectors;
 
-		set_bit(R10BIO_Uptodate, &r10_bio->state);
+		/*
+		 * Do not set R10BIO_Uptodate if the current device is
+		 * rebuilding or Faulty. This is because we cannot use
+		 * such device for properly reading the data back (we could
+		 * potentially use it, if the current write would have felt
+		 * before rdev->recovery_offset, but for simplicity we don't
+		 * check this here.
+		 */
+		if (test_bit(In_sync, &rdev->flags) &&
+		    !test_bit(Faulty, &rdev->flags))
+			set_bit(R10BIO_Uptodate, &r10_bio->state);
 
 		/* Maybe we can clear some bad blocks. */
 		if (is_badblock(rdev,
-- 
1.8.1.2

