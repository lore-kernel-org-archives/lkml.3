Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbaHRJxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:53:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42806 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbaHRJfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:35:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 075/137] drm/radeon: fix irq ring buffer overflow handling
Date: Mon, 18 Aug 2014 10:32:16 +0100
Message-Id: <1408354398-10226-76-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>

commit e8c214d22e76dd0ead38f97f8d2dc09aac70d651 upstream.

We must mask out the overflow bit as well, otherwise
the wptr will never match the rptr again and the interrupt
handler will loop forever.

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c       | 1 +
 drivers/gpu/drm/radeon/evergreen.c | 1 +
 drivers/gpu/drm/radeon/r600.c      | 1 +
 drivers/gpu/drm/radeon/si.c        | 1 +
 4 files changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 85647ab99fb1..0aaaa11b7036 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -5591,6 +5591,7 @@ static inline u32 cik_get_ih_wptr(struct radeon_device *rdev)
 		tmp = RREG32(IH_RB_CNTL);
 		tmp |= IH_WPTR_OVERFLOW_CLEAR;
 		WREG32(IH_RB_CNTL, tmp);
+		wptr &= ~RB_OVERFLOW;
 	}
 	return (wptr & rdev->ih.ptr_mask);
 }
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index a34e20921711..415ab58594d9 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -4597,6 +4597,7 @@ static u32 evergreen_get_ih_wptr(struct radeon_device *rdev)
 		tmp = RREG32(IH_RB_CNTL);
 		tmp |= IH_WPTR_OVERFLOW_CLEAR;
 		WREG32(IH_RB_CNTL, tmp);
+		wptr &= ~RB_OVERFLOW;
 	}
 	return (wptr & rdev->ih.ptr_mask);
 }
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 33b35c9e82be..af588cf27293 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -4429,6 +4429,7 @@ static u32 r600_get_ih_wptr(struct radeon_device *rdev)
 		tmp = RREG32(IH_RB_CNTL);
 		tmp |= IH_WPTR_OVERFLOW_CLEAR;
 		WREG32(IH_RB_CNTL, tmp);
+		wptr &= ~RB_OVERFLOW;
 	}
 	return (wptr & rdev->ih.ptr_mask);
 }
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 3479145e8f47..5a46e269e5d5 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -6052,6 +6052,7 @@ static inline u32 si_get_ih_wptr(struct radeon_device *rdev)
 		tmp = RREG32(IH_RB_CNTL);
 		tmp |= IH_WPTR_OVERFLOW_CLEAR;
 		WREG32(IH_RB_CNTL, tmp);
+		wptr &= ~RB_OVERFLOW;
 	}
 	return (wptr & rdev->ih.ptr_mask);
 }
-- 
1.9.1

