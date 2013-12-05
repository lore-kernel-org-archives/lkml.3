Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517Ab3LERsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:48:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38325 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332Ab3LERhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:37:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 59/90] drm/radeon: add semaphore trace point
Date: Thu,  5 Dec 2013 17:35:41 +0000
Message-Id: <1386264972-5399-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>

commit bd80c8ba995c1dbdddee14acc55c541c499e0442 upstream.

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_semaphore.c |  6 +++++-
 drivers/gpu/drm/radeon/radeon_trace.h     | 36 +++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_semaphore.c b/drivers/gpu/drm/radeon/radeon_semaphore.c
index e2ace5d..5ba2d38 100644
--- a/drivers/gpu/drm/radeon/radeon_semaphore.c
+++ b/drivers/gpu/drm/radeon/radeon_semaphore.c
@@ -30,7 +30,7 @@
 #include "drmP.h"
 #include "drm.h"
 #include "radeon.h"
-
+#include "radeon_trace.h"
 
 int radeon_semaphore_create(struct radeon_device *rdev,
 			    struct radeon_semaphore **semaphore)
@@ -57,6 +57,8 @@ int radeon_semaphore_create(struct radeon_device *rdev,
 void radeon_semaphore_emit_signal(struct radeon_device *rdev, int ring,
 			          struct radeon_semaphore *semaphore)
 {
+	trace_radeon_semaphore_signale(ring, semaphore);
+
 	--semaphore->waiters;
 	radeon_semaphore_ring_emit(rdev, ring, &rdev->ring[ring], semaphore, false);
 }
@@ -64,6 +66,8 @@ void radeon_semaphore_emit_signal(struct radeon_device *rdev, int ring,
 void radeon_semaphore_emit_wait(struct radeon_device *rdev, int ring,
 			        struct radeon_semaphore *semaphore)
 {
+	trace_radeon_semaphore_wait(ring, semaphore);
+
 	++semaphore->waiters;
 	radeon_semaphore_ring_emit(rdev, ring, &rdev->ring[ring], semaphore, true);
 }
diff --git a/drivers/gpu/drm/radeon/radeon_trace.h b/drivers/gpu/drm/radeon/radeon_trace.h
index eafd816..a20bc7e 100644
--- a/drivers/gpu/drm/radeon/radeon_trace.h
+++ b/drivers/gpu/drm/radeon/radeon_trace.h
@@ -74,6 +74,42 @@ DEFINE_EVENT(radeon_fence_request, radeon_fence_wait_end,
 	    TP_ARGS(dev, seqno)
 );
 
+DECLARE_EVENT_CLASS(radeon_semaphore_request,
+
+	    TP_PROTO(int ring, struct radeon_semaphore *sem),
+
+	    TP_ARGS(ring, sem),
+
+	    TP_STRUCT__entry(
+			     __field(int, ring)
+			     __field(signed, waiters)
+			     __field(uint64_t, gpu_addr)
+			     ),
+
+	    TP_fast_assign(
+			   __entry->ring = ring;
+			   __entry->waiters = sem->waiters;
+			   __entry->gpu_addr = sem->gpu_addr;
+			   ),
+
+	    TP_printk("ring=%u, waiters=%d, addr=%010Lx", __entry->ring,
+		      __entry->waiters, __entry->gpu_addr)
+);
+
+DEFINE_EVENT(radeon_semaphore_request, radeon_semaphore_signale,
+
+	    TP_PROTO(int ring, struct radeon_semaphore *sem),
+
+	    TP_ARGS(ring, sem)
+);
+
+DEFINE_EVENT(radeon_semaphore_request, radeon_semaphore_wait,
+
+	    TP_PROTO(int ring, struct radeon_semaphore *sem),
+
+	    TP_ARGS(ring, sem)
+);
+
 #endif
 
 /* This part must be outside protection */
-- 
1.8.3.2

