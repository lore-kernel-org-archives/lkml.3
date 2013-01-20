Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab3ATACi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 19:02:38 -0500
Received: from talus.maths.usyd.edu.au ([129.78.68.1]:38114 "EHLO
	talus.maths.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab3ATACg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 19:02:36 -0500
X-smtpdoor-from: psz@maths.usyd.edu.au
X-smtpdoor-want-Message-ID: <201301200002.r0K02Atl031280@como.maths.usyd.edu.au>
Date: Sun, 20 Jan 2013 11:02:10 +1100
From: paul.szabo@sydney.edu.au
Message-Id: <201301200002.r0K02Atl031280@como.maths.usyd.edu.au>
To: linux-mm@kvack.org
Subject: [PATCH] Negative (setpoint-dirty) in bdi_position_ratio()
Cc: 695182@bugs.debian.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Reported-by: Paul Szabo <psz@maths.usyd.edu.au>
Reference: http://bugs.debian.org/695182
Signed-off-by: Paul Szabo <psz@maths.usyd.edu.au>

--- mm/page-writeback.c.old	2012-12-06 22:20:40.000000000 +1100
+++ mm/page-writeback.c	2013-01-20 07:47:55.000000000 +1100
@@ -559,7 +559,7 @@ static unsigned long bdi_position_ratio(
 	 *     => fast response on large errors; small oscillation near setpoint
 	 */
 	setpoint = (freerun + limit) / 2;
-	x = div_s64((setpoint - dirty) << RATELIMIT_CALC_SHIFT,
+	x = div_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
 		    limit - setpoint + 1);
 	pos_ratio = x;
 	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
