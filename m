Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab3CYBQG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:16:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34009 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756057Ab3CYBQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:02 -0400
Message-Id: <20130325010530.597448227@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:28 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Alex Deucher <alexander.deucher@amd.com>,
        =?ISO-8859-15?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>
Subject: [ 064/104] drm/radeon/benchmark: make sure bo blit copy exists before using it
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit fa8d387dc3f62062a6b4afbbb2a3438094fd8584 upstream.

Fixes a segfault on asics without a blit callback.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=62239

Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2: s/copy\.blit/copy_blit/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_benchmark.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_benchmark.c
+++ b/drivers/gpu/drm/radeon/radeon_benchmark.c
@@ -139,13 +139,15 @@ static void radeon_benchmark_move(struct
 						     sdomain, ddomain, "dma");
 	}
 
-	time = radeon_benchmark_do_move(rdev, size, saddr, daddr,
-					RADEON_BENCHMARK_COPY_BLIT, n);
-	if (time < 0)
-		goto out_cleanup;
-	if (time > 0)
-		radeon_benchmark_log_results(n, size, time,
-					     sdomain, ddomain, "blit");
+	if (rdev->asic->copy_blit) {
+		time = radeon_benchmark_do_move(rdev, size, saddr, daddr,
+						RADEON_BENCHMARK_COPY_BLIT, n);
+		if (time < 0)
+			goto out_cleanup;
+		if (time > 0)
+			radeon_benchmark_log_results(n, size, time,
+						     sdomain, ddomain, "blit");
+	}
 
 out_cleanup:
 	if (sobj) {


