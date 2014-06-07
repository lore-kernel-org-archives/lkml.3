Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaFGBab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:30:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36108 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675AbaFGBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Michal Hocko" <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Rik van Riel" <riel@redhat.com>,
        "Nishanth Aravamudan" <nacc@linux.vnet.ibm.com>,
        "Masayoshi Mizuma" <m.mizuma@jp.fujitsu.com>,
        "Mel Gorman" <mgorman@suse.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Luiz Capitulino" <lcapitulino@redhat.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.671190598@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 60/92] mm/page-writeback.c: fix divide by zero in
 pos_ratio_polynom
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
---
 mm/page-writeback.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -559,7 +559,7 @@ static unsigned long bdi_position_ratio(
 	 *     => fast response on large errors; small oscillation near setpoint
 	 */
 	setpoint = (freerun + limit) / 2;
-	x = div_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
+	x = div64_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
 		    limit - setpoint + 1);
 	pos_ratio = x;
 	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
@@ -625,7 +625,7 @@ static unsigned long bdi_position_ratio(
 	x_intercept = bdi_setpoint + span;
 
 	if (bdi_dirty < x_intercept - span / 4) {
-		pos_ratio = div_u64(pos_ratio * (x_intercept - bdi_dirty),
+		pos_ratio = div64_u64(pos_ratio * (x_intercept - bdi_dirty),
 				    x_intercept - bdi_setpoint + 1);
 	} else
 		pos_ratio /= 4;

