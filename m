Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbaFWNIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:08:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37242 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877AbaFWNFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:05:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 79/93] mm/page-writeback.c: fix divide by zero in pos_ratio_polynom
Date: Mon, 23 Jun 2014 14:02:58 +0100
Message-Id: <1403528592-2163-80-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@redhat.com>

commit d5c9fde3dae750889168807038243ff36431d276 upstream.

It is possible for "limit - setpoint + 1" to equal zero, after getting
truncated to a 32 bit variable, and resulting in a divide by zero error.

Using the fully 64 bit divide functions avoids this problem.  It also
will cause pos_ratio_polynom() to return the correct value when
(setpoint - limit) exceeds 2^32.

Also uninline pos_ratio_polynom, at Andrew's request.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2:
 Adjust context - pos_ratio_polynom() is not a separate function]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/page-writeback.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 7298e741ae35..ad494ae5703f 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -689,7 +689,7 @@ static unsigned long bdi_position_ratio(struct backing_dev_info *bdi,
 	 *     => fast response on large errors; small oscillation near setpoint
 	 */
 	setpoint = (freerun + limit) / 2;
-	x = div_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
+	x = div64_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
 		    limit - setpoint + 1);
 	pos_ratio = x;
 	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
@@ -755,7 +755,7 @@ static unsigned long bdi_position_ratio(struct backing_dev_info *bdi,
 	x_intercept = bdi_setpoint + span;
 
 	if (bdi_dirty < x_intercept - span / 4) {
-		pos_ratio = div_u64(pos_ratio * (x_intercept - bdi_dirty),
+		pos_ratio = div64_u64(pos_ratio * (x_intercept - bdi_dirty),
 				    x_intercept - bdi_setpoint + 1);
 	} else
 		pos_ratio /= 4;
-- 
1.9.1

