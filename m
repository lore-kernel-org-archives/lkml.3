Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965371Ab3GCTQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:16:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20027 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933451Ab3GCTAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:14 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=oEOFmBnEXU4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=6OMNPqgMwyMA:10 a=ASTB1Uf0AAAA:8 a=VwQbUJbxAAAA:8 a=OOrwYj2FSiaMdqAGCxgA:9 a=pDhNVk4yl4oA:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184107.950822331@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:41:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Lyakas <alex@zadarastorage.com>, NeilBrown <neilb@suse.de>
Subject: [128/141] md/raid1: consider WRITE as successful only if at least one
 non-Faulty and non-rebuilding drive completed it.
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0128-md-raid1-consider-WRITE-as-successful-only-if-at-lea.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Lyakas <alex@zadarastorage.com>

[ Upstream commit 3056e3aec8d8ba61a0710fb78b2d562600aa2ea7 ]

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

Cc: stable@vger.kernel.org
Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/md/raid1.c  |   12 +++++++++++-
 drivers/md/raid10.c |   12 +++++++++++-
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 36c6003..cda27cb 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -427,7 +427,17 @@ static void raid1_end_write_request(struct bio *bio, int error)
 
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
index bec9db8..5c3fb0b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -475,7 +475,17 @@ static void raid10_end_write_request(struct bio *bio, int error)
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
1.7.10.4


