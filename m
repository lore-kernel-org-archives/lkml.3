Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbaFEA27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:28:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbaFDXWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 101/228] mm/page-writeback.c: fix divide by zero in pos_ratio_polynom
Date: Wed,  4 Jun 2014 16:22:10 -0700
Message-Id: <20140604232351.287321795@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page-writeback.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -593,14 +593,14 @@ unsigned long bdi_dirty_limit(struct bac
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
@@ -842,7 +842,7 @@ static unsigned long bdi_position_ratio(
 	x_intercept = bdi_setpoint + span;
 
 	if (bdi_dirty < x_intercept - span / 4) {
-		pos_ratio = div_u64(pos_ratio * (x_intercept - bdi_dirty),
+		pos_ratio = div64_u64(pos_ratio * (x_intercept - bdi_dirty),
 				    x_intercept - bdi_setpoint + 1);
 	} else
 		pos_ratio /= 4;


