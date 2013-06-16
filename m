Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab3FPWJY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:09:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46376 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755636Ab3FPWJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:09:02 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Lyakas" <alex@zadarastorage.com>,
        "NeilBrown" <neilb@suse.de>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.622931823@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [81/83] md/raid1: consider WRITE as successful only if at least
 one non-Faulty and non-rebuilding drive completed it.
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: for raid10, s/rdev/conf->mirrors[dev].rdev/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/raid1.c  |   12 +++++++++++-
 drivers/md/raid10.c |   12 +++++++++++-
 2 files changed, 22 insertions(+), 2 deletions(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -407,7 +407,17 @@ static void raid1_end_write_request(stru
 
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
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -390,7 +390,17 @@ static void raid10_end_write_request(str
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
+		if (test_bit(In_sync, &conf->mirrors[dev].rdev->flags) &&
+		    !test_bit(Faulty, &conf->mirrors[dev].rdev->flags))
+			set_bit(R10BIO_Uptodate, &r10_bio->state);
 
 		/* Maybe we can clear some bad blocks. */
 		if (is_badblock(conf->mirrors[dev].rdev,

