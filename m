Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaG3MPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:15:52 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36805 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039AbaG3MPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 92/94] drm/radeon: fix irq ring buffer overflow handling
Date: Wed, 30 Jul 2014 14:15:21 +0200
Message-Id: <b50f86698fce9a68b8ef64a66c7acbcbb363e2b5.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e8c214d22e76dd0ead38f97f8d2dc09aac70d651 upstream.

We must mask out the overflow bit as well, otherwise
the wptr will never match the rptr again and the interrupt
handler will loop forever.

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/cik.c       | 1 +
 drivers/gpu/drm/radeon/evergreen.c | 1 +
 drivers/gpu/drm/radeon/r600.c      | 1 +
 drivers/gpu/drm/radeon/si.c        | 1 +
 4 files changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index bb7f2ae7683d..14836dfd04e7 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -6554,6 +6554,7 @@ static inline u32 cik_get_ih_wptr(struct radeon_device *rdev)
 		tmp = RREG32(IH_RB_CNTL);
 		tmp |= IH_WPTR_OVERFLOW_CLEAR;
 		WREG32(IH_RB_CNTL, tmp);
+		wptr &= ~RB_OVERFLOW;
 	}
 	return (wptr & rdev->ih.ptr_mask);
 }
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 4564bb1ab837..7ca58fc7a1c6 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -4664,6 +4664,7 @@ static u32 evergreen_get_ih_wptr(struct radeon_device *rdev)
 		tmp = RREG32(IH_RB_CNTL);
 		tmp |= IH_WPTR_OVERFLOW_CLEAR;
 		WREG32(IH_RB_CNTL, tmp);
+		wptr &= ~RB_OVERFLOW;
 	}
 	return (wptr & rdev->ih.ptr_mask);
 }
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 2c2b91f16ecf..88eb936fbc2f 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -3657,6 +3657,7 @@ static u32 r600_get_ih_wptr(struct radeon_device *rdev)
 		tmp = RREG32(IH_RB_CNTL);
 		tmp |= IH_WPTR_OVERFLOW_CLEAR;
 		WREG32(IH_RB_CNTL, tmp);
+		wptr &= ~RB_OVERFLOW;
 	}
 	return (wptr & rdev->ih.ptr_mask);
 }
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index c9f9c07f888d..4d41a0dc1796 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -6041,6 +6041,7 @@ static inline u32 si_get_ih_wptr(struct radeon_device *rdev)
 		tmp = RREG32(IH_RB_CNTL);
 		tmp |= IH_WPTR_OVERFLOW_CLEAR;
 		WREG32(IH_RB_CNTL, tmp);
+		wptr &= ~RB_OVERFLOW;
 	}
 	return (wptr & rdev->ih.ptr_mask);
 }
-- 
2.0.1

