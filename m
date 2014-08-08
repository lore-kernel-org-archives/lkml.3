Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbaHHWZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:25:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40378 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbaHHUpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:45:55 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 170/259] drm/radeon: fix irq ring buffer overflow handling
Date: Fri,  8 Aug 2014 13:39:53 -0700
Message-Id: <1407530482-4483-171-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>

commit e8c214d22e76dd0ead38f97f8d2dc09aac70d651 upstream.

We must mask out the overflow bit as well, otherwise
the wptr will never match the rptr again and the interrupt
handler will loop forever.

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c       | 1 +
 drivers/gpu/drm/radeon/evergreen.c | 1 +
 drivers/gpu/drm/radeon/r600.c      | 1 +
 drivers/gpu/drm/radeon/si.c        | 1 +
 4 files changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index bc5fad4..950c94a 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -7067,6 +7067,7 @@ static inline u32 cik_get_ih_wptr(struct radeon_device *rdev)
 		tmp = RREG32(IH_RB_CNTL);
 		tmp |= IH_WPTR_OVERFLOW_CLEAR;
 		WREG32(IH_RB_CNTL, tmp);
+		wptr &= ~RB_OVERFLOW;
 	}
 	return (wptr & rdev->ih.ptr_mask);
 }
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 47463d8..838dcd5 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -4713,6 +4713,7 @@ static u32 evergreen_get_ih_wptr(struct radeon_device *rdev)
 		tmp = RREG32(IH_RB_CNTL);
 		tmp |= IH_WPTR_OVERFLOW_CLEAR;
 		WREG32(IH_RB_CNTL, tmp);
+		wptr &= ~RB_OVERFLOW;
 	}
 	return (wptr & rdev->ih.ptr_mask);
 }
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 3a55ae4..b9038b6 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -3707,6 +3707,7 @@ static u32 r600_get_ih_wptr(struct radeon_device *rdev)
 		tmp = RREG32(IH_RB_CNTL);
 		tmp |= IH_WPTR_OVERFLOW_CLEAR;
 		WREG32(IH_RB_CNTL, tmp);
+		wptr &= ~RB_OVERFLOW;
 	}
 	return (wptr & rdev->ih.ptr_mask);
 }
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index d9d8e55..d5c8438 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -5982,6 +5982,7 @@ static inline u32 si_get_ih_wptr(struct radeon_device *rdev)
 		tmp = RREG32(IH_RB_CNTL);
 		tmp |= IH_WPTR_OVERFLOW_CLEAR;
 		WREG32(IH_RB_CNTL, tmp);
+		wptr &= ~RB_OVERFLOW;
 	}
 	return (wptr & rdev->ih.ptr_mask);
 }
-- 
1.9.1

