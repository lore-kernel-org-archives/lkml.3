Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbaAOWej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:34:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40846 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbaAOV4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:56:11 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 119/166] drm/radeon: fix render backend setup for SI and CIK
Date: Wed, 15 Jan 2014 13:52:13 -0800
Message-Id: <1389822780-4729-120-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>

commit 9fadb352ed73edd7801a280b552d33a6040c8721 upstream.

Only the render backends of the first shader engine were enabled. The others
were erroneously disabled. Enabling the other render backends improves
performance a lot.

Unigine Sanctuary on Bonaire:
  Before: 15 fps
  After:  90 fps

Judging from the fan noise, the GPU was also underclocked when the other
render backends were disabled, resulting in horrible performance. The fan is
a lot noisy under load now.

Signed-off-by: Marek Olšák <marek.olsak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ kamal: backport to 3.8 (SI only; no CIK in 3.8) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/si.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index ff9a680..0746272 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -1456,7 +1456,7 @@ static void si_setup_spi(struct radeon_device *rdev,
 }
 
 static u32 si_get_rb_disabled(struct radeon_device *rdev,
-			      u32 max_rb_num, u32 se_num,
+			      u32 max_rb_num_per_se,
 			      u32 sh_per_se)
 {
 	u32 data, mask;
@@ -1470,14 +1470,14 @@ static u32 si_get_rb_disabled(struct radeon_device *rdev,
 
 	data >>= BACKEND_DISABLE_SHIFT;
 
-	mask = si_create_bitmask(max_rb_num / se_num / sh_per_se);
+	mask = si_create_bitmask(max_rb_num_per_se / sh_per_se);
 
 	return data & mask;
 }
 
 static void si_setup_rb(struct radeon_device *rdev,
 			u32 se_num, u32 sh_per_se,
-			u32 max_rb_num)
+			u32 max_rb_num_per_se)
 {
 	int i, j;
 	u32 data, mask;
@@ -1487,14 +1487,14 @@ static void si_setup_rb(struct radeon_device *rdev,
 	for (i = 0; i < se_num; i++) {
 		for (j = 0; j < sh_per_se; j++) {
 			si_select_se_sh(rdev, i, j);
-			data = si_get_rb_disabled(rdev, max_rb_num, se_num, sh_per_se);
+			data = si_get_rb_disabled(rdev, max_rb_num_per_se, sh_per_se);
 			disabled_rbs |= data << ((i * sh_per_se + j) * TAHITI_RB_BITMAP_WIDTH_PER_SH);
 		}
 	}
 	si_select_se_sh(rdev, 0xffffffff, 0xffffffff);
 
 	mask = 1;
-	for (i = 0; i < max_rb_num; i++) {
+	for (i = 0; i < max_rb_num_per_se * se_num; i++) {
 		if (!(disabled_rbs & mask))
 			enabled_rbs |= mask;
 		mask <<= 1;
-- 
1.8.3.2

