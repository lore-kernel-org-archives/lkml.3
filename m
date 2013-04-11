Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510Ab3DKU2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:28:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11115 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759838Ab3DKU0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:19 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=DXYipD4jybAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=NW5FqY31A4kA:10 a=zd2uoN0lAAAA:8 a=e5mUnYsNAAAA:8 a=VwQbUJbxAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202554.878950962@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 053/171 ] drm/radeon/benchmark: make sure bo blit copy exists before using it
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0053-drm-radeon-benchmark-make-sure-bo-blit-copy-exists-b.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit fa8d387dc3f62062a6b4afbbb2a3438094fd8584 ]

Fixes a segfault on asics without a blit callback.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=62239

Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/radeon_benchmark.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_benchmark.c b/drivers/gpu/drm/radeon/radeon_benchmark.c
index bedda9c..a2f0c24 100644
--- a/drivers/gpu/drm/radeon/radeon_benchmark.c
+++ b/drivers/gpu/drm/radeon/radeon_benchmark.c
@@ -135,13 +135,15 @@ static void radeon_benchmark_move(struct radeon_device *rdev, unsigned size,
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
1.7.10.4


