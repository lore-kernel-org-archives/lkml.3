Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaFGBcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:32:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36094 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752659AbaFGBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "paul.szabo@sydney.edu.au" <paul.szabo@sydney.edu.au>,
        "Fengguang Wu" <fengguang.wu@intel.com>, "Jan Kara" <jack@suse.cz>,
        "Paul Szabo" <psz@maths.usyd.edu.au>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.148768940@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 59/92] Negative (setpoint-dirty) in bdi_position_ratio()
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "paul.szabo@sydney.edu.au" <paul.szabo@sydney.edu.au>

commit ed84825b785ceb932af7dd5aa08614801721320b upstream.

In bdi_position_ratio(), get difference (setpoint-dirty) right even when
negative. Both setpoint and dirty are unsigned long, the difference was
zero-padded thus wrongly sign-extended to s64. This issue affects all
32-bit architectures, does not affect 64-bit architectures where long
and s64 are equivalent.

In this function, dirty is between freerun and limit, the pseudo-float x
is between [-1,1], expected to be negative about half the time. With
zero-padding, instead of a small negative x we obtained a large positive
one so bdi_position_ratio() returned garbage.

Casting the difference to s64 also prevents overflow with left-shift;
though normally these numbers are small and I never observed a 32-bit
overflow there.

(This patch does not solve the PAE OOM issue.)

Paul Szabo   psz@maths.usyd.edu.au   http://www.maths.usyd.edu.au/u/psz/
School of Mathematics and Statistics   University of Sydney    Australia

Reviewed-by: Jan Kara <jack@suse.cz>
Reported-by: Paul Szabo <psz@maths.usyd.edu.au>
Reference: http://bugs.debian.org/695182
Signed-off-by: Paul Szabo <psz@maths.usyd.edu.au>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/page-writeback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -559,7 +559,7 @@ static unsigned long bdi_position_ratio(
 	 *     => fast response on large errors; small oscillation near setpoint
 	 */
 	setpoint = (freerun + limit) / 2;
-	x = div_s64((setpoint - dirty) << RATELIMIT_CALC_SHIFT,
+	x = div_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
 		    limit - setpoint + 1);
 	pos_ratio = x;
 	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;

