Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab3CZW7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:59:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319Ab3CZWwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 48/72] drm/radeon/benchmark: make sure bo blit copy exists before using it
Date: Tue, 26 Mar 2013 15:51:31 -0700
Message-Id: <20130326224924.640523750@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit fa8d387dc3f62062a6b4afbbb2a3438094fd8584 upstream.

Fixes a segfault on asics without a blit callback.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=62239

Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_benchmark.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_benchmark.c
+++ b/drivers/gpu/drm/radeon/radeon_benchmark.c
@@ -141,13 +141,15 @@ static void radeon_benchmark_move(struct
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


