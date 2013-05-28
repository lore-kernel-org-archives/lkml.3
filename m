Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab3E1Via (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:38:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59634 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758306Ab3E1VYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:24:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 32/78] dm stripe: fix regression in stripe_width calculation
Date: Tue, 28 May 2013 14:19:41 -0700
Message-Id: <1369776027-17859-33-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit d793e684277124d55c5d2444007e224635821346 upstream.

Fix a regression in the calculation of the stripe_width in the
dm stripe target which led to incorrect processing of device limits.

The stripe_width is the stripe device length divided by the number of
stripes.  The group of commits in the range f14fa69 ("dm stripe: fix
size test") to eb850de ("dm stripe: support for non power of 2
chunksize") interfered with each other (a merging error) and led to the
stripe_width being set incorrectly to the stripe device length divided by
chunk_size * stripe_count.

For example, a stripe device's table with: 0 33553920 striped 3 512 ...
should result in a stripe_width of 11184640 (33553920 / 3), but due to
the bug it was getting set to 21845 (33553920 / (512 * 3)).

The impact of this bug is that device topologies that previously worked
fine with the stripe target are no longer considered valid.  In
particular, there is a higher risk of seeing this issue if one of the
stripe devices has a 4K logical block size.  Resulting in an error
message like this:
"device-mapper: table: 253:4: len=21845 not aligned to h/w logical block size 4096 of dm-1"

The fix is to swap the order of the divisions and to use a temporary
variable for the second one, so that width retains the intended
value.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-stripe.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index aaecefa..852eab4 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -94,7 +94,7 @@ static int get_stripe(struct dm_target *ti, struct stripe_c *sc,
 static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct stripe_c *sc;
-	sector_t width;
+	sector_t width, tmp_len;
 	uint32_t stripes;
 	uint32_t chunk_size;
 	int r;
@@ -116,15 +116,16 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	width = ti->len;
-	if (sector_div(width, chunk_size)) {
+	if (sector_div(width, stripes)) {
 		ti->error = "Target length not divisible by "
-		    "chunk size";
+		    "number of stripes";
 		return -EINVAL;
 	}
 
-	if (sector_div(width, stripes)) {
+	tmp_len = width;
+	if (sector_div(tmp_len, chunk_size)) {
 		ti->error = "Target length not divisible by "
-		    "number of stripes";
+		    "chunk size";
 		return -EINVAL;
 	}
 
-- 
1.8.1.2

