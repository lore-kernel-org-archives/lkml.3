Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbaIKMeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:34:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51487 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754968AbaIKMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Michel =?UTF-8?Q?D=C3=A4nzer?=" <michel.daenzer@amd.com>,
        "=?UTF-8?q?Christian=20K=C3=B6nig?=" <christian.koenig@amd.com>,
        "Alex Deucher" <alexander.deucher@amd.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.837598570@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 017/131] drm/radeon: fix irq ring buffer overflow handling
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit e8c214d22e76dd0ead38f97f8d2dc09aac70d651 upstream.

We must mask out the overflow bit as well, otherwise
the wptr will never match the rptr again and the interrupt
handler will loop forever.

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
[bwh: Backported to 3.2: drop changes for unsupported GPUs]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2765,6 +2765,7 @@ static u32 evergreen_get_ih_wptr(struct
 		tmp = RREG32(IH_RB_CNTL);
 		tmp |= IH_WPTR_OVERFLOW_CLEAR;
 		WREG32(IH_RB_CNTL, tmp);
+		wptr &= ~RB_OVERFLOW;
 	}
 	return (wptr & rdev->ih.ptr_mask);
 }
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -3280,6 +3280,7 @@ static u32 r600_get_ih_wptr(struct radeo
 		tmp = RREG32(IH_RB_CNTL);
 		tmp |= IH_WPTR_OVERFLOW_CLEAR;
 		WREG32(IH_RB_CNTL, tmp);
+		wptr &= ~RB_OVERFLOW;
 	}
 	return (wptr & rdev->ih.ptr_mask);
 }

