Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555Ab3EQW0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:26:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818Ab3EQVhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [ 014/102] dm stripe: fix regression in stripe_width calculation
Date: Fri, 17 May 2013 14:35:29 -0700
Message-Id: <20130517213245.821266131@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-stripe.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -94,7 +94,7 @@ static int get_stripe(struct dm_target *
 static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct stripe_c *sc;
-	sector_t width;
+	sector_t width, tmp_len;
 	uint32_t stripes;
 	uint32_t chunk_size;
 	int r;
@@ -116,15 +116,16 @@ static int stripe_ctr(struct dm_target *
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
 


