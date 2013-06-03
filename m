Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124Ab3FCWMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:12:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2298 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758621Ab3FCWLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:11:54 -0400
X-Authority-Analysis: v=2.0 cv=BcJaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Pni-4Zq7uKIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=mWXZIYVl1I4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=KmqCZUEVAza2QQZapJAA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=3MYYLAfUVtVyGaky:21 a=puHSMBMonwbFkv_h:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221153.128001464@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [06/65] dm stripe: fix regression in stripe_width calculation
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0006-dm-stripe-fix-regression-in-stripe_width-calculation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

[ Upstream commit d793e684277124d55c5d2444007e224635821346 ]

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
Cc: stable@vger.kernel.org # 3.6+
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/md/dm-stripe.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index a087bf2..c6cdd1a 100644
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
1.7.10.4


