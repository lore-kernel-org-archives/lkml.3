Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934889Ab3CZPsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:48:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53864 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965119Ab3CZPWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 076/150] drm/radeon/benchmark: make sure bo blit copy exists before using it
Date: Tue, 26 Mar 2013 15:19:35 +0000
Message-Id: <1364311249-14454-77-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit fa8d387dc3f62062a6b4afbbb2a3438094fd8584 upstream.

Fixes a segfault on asics without a blit callback.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=62239

Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_benchmark.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_benchmark.c b/drivers/gpu/drm/radeon/radeon_benchmark.c
index 364f5b1..5ea1c87 100644
--- a/drivers/gpu/drm/radeon/radeon_benchmark.c
+++ b/drivers/gpu/drm/radeon/radeon_benchmark.c
@@ -141,13 +141,15 @@ static void radeon_benchmark_move(struct radeon_device *rdev, unsigned size,
 						     sdomain, ddomain, "dma");
 	}
 
-	time = radeon_benchmark_do_move(rdev, size, saddr, daddr,
-					RADEON_BENCHMARK_COPY_BLIT, n);
-	if (time < 0)
-		goto out_cleanup;
-	if (time > 0)
-		radeon_benchmark_log_results(n, size, time,
-					     sdomain, ddomain, "blit");
+	if (rdev->asic->copy.blit) {
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
-- 
1.8.1.2

