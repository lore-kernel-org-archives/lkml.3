Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbaCaNs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:48:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35595 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbaCaNXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:23:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lauri Kasanen <cand@gmx.com>, Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 19/71] drm/radeon: TTM must be init with cpu-visible VRAM, v2
Date: Mon, 31 Mar 2014 14:22:25 +0100
Message-Id: <1396272197-13394-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lauri Kasanen <cand@gmx.com>

commit 14eedc32a3c0ec9dd70448a73763ee21feae3111 upstream.

Without this, a bo may get created in the cpu-inaccessible vram.
Before the CP engines get setup, all copies are done via cpu memcpy.

This means that the cpu tries to read from inaccessible memory, fails,
and the radeon module proceeds to disable acceleration.

Doing this has no downsides, as the real VRAM size gets set as soon as the
CP engines get init.

This is a candidate for 3.14 fixes.

v2: Add comment on why the function is used

Signed-off-by: Lauri Kasanen <cand@gmx.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_ttm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index 7296b56..743a217 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -737,6 +737,9 @@ int radeon_ttm_init(struct radeon_device *rdev)
 		DRM_ERROR("Failed initializing VRAM heap.\n");
 		return r;
 	}
+	/* Change the size here instead of the init above so only lpfn is affected */
+	radeon_ttm_set_active_vram_size(rdev, rdev->mc.visible_vram_size);
+
 	r = radeon_bo_create(rdev, 256 * 1024, PAGE_SIZE, true,
 			     RADEON_GEM_DOMAIN_VRAM,
 			     NULL, &rdev->stollen_vga_memory);
-- 
1.9.1

