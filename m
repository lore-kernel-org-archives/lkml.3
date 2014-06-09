Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936444AbaFIJ1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:27:39 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936418AbaFIJ1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:27:35 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 067/146] mm/page-writeback.c: fix divide by zero in pos_ratio_polynom
Date: Mon,  9 Jun 2014 10:50:02 +0200
Message-Id: <68d2ecc46104bf57213ee0bb8aa067319f3544a8.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/page-writeback.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 7106cb1aca8e..8f6daa62206d 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -593,14 +593,14 @@ unsigned long bdi_dirty_limit(struct backing_dev_info *bdi, unsigned long dirty)
  * (5) the closer to setpoint, the smaller |df/dx| (and the reverse)
  *     => fast response on large errors; small oscillation near setpoint
  */
-static inline long long pos_ratio_polynom(unsigned long setpoint,
+static long long pos_ratio_polynom(unsigned long setpoint,
 					  unsigned long dirty,
 					  unsigned long limit)
 {
 	long long pos_ratio;
 	long x;
 
-	x = div_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
+	x = div64_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
 		    limit - setpoint + 1);
 	pos_ratio = x;
 	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
@@ -842,7 +842,7 @@ static unsigned long bdi_position_ratio(struct backing_dev_info *bdi,
 	x_intercept = bdi_setpoint + span;
 
 	if (bdi_dirty < x_intercept - span / 4) {
-		pos_ratio = div_u64(pos_ratio * (x_intercept - bdi_dirty),
+		pos_ratio = div64_u64(pos_ratio * (x_intercept - bdi_dirty),
 				    x_intercept - bdi_setpoint + 1);
 	} else
 		pos_ratio /= 4;
-- 
1.9.3

