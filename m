Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbaFJUik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:38:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34856 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbaFJTq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:46:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 003/160] drm/radeon: fix audio pin counts for DCE6+ (v2)
Date: Tue, 10 Jun 2014 12:44:03 -0700
Message-Id: <1402429600-20477-4-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit be0949f5eb9c8133a05cf25f108f09e85e79cd32 upstream.

There is actually quite a bit of variance based on
the asic.

v2: fix typo noticed by Jerome.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/dce6_afmt.c | 14 ++++++++++----
 drivers/gpu/drm/radeon/radeon.h    |  5 ++++-
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/dce6_afmt.c b/drivers/gpu/drm/radeon/dce6_afmt.c
index 36e8f10..ff0001c 100644
--- a/drivers/gpu/drm/radeon/dce6_afmt.c
+++ b/drivers/gpu/drm/radeon/dce6_afmt.c
@@ -307,11 +307,17 @@ int dce6_audio_init(struct radeon_device *rdev)
 
 	rdev->audio.enabled = true;
 
-	if (ASIC_IS_DCE8(rdev))
+	if (ASIC_IS_DCE81(rdev)) /* KV: 4 streams, 7 endpoints */
+		rdev->audio.num_pins = 7;
+	else if (ASIC_IS_DCE83(rdev)) /* KB: 2 streams, 3 endpoints */
+		rdev->audio.num_pins = 3;
+	else if (ASIC_IS_DCE8(rdev)) /* BN/HW: 6 streams, 7 endpoints */
+		rdev->audio.num_pins = 7;
+	else if (ASIC_IS_DCE61(rdev)) /* TN: 4 streams, 6 endpoints */
 		rdev->audio.num_pins = 6;
-	else if (ASIC_IS_DCE61(rdev))
-		rdev->audio.num_pins = 4;
-	else
+	else if (ASIC_IS_DCE64(rdev)) /* OL: 2 streams, 2 endpoints */
+		rdev->audio.num_pins = 2;
+	else /* SI: 6 streams, 6 endpoints */
 		rdev->audio.num_pins = 6;
 
 	for (i = 0; i < rdev->audio.num_pins; i++) {
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index d307cc2..4485236 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -732,7 +732,7 @@ union radeon_irq_stat_regs {
 	struct cik_irq_stat_regs cik;
 };
 
-#define RADEON_MAX_HPD_PINS 6
+#define RADEON_MAX_HPD_PINS 7
 #define RADEON_MAX_CRTCS 6
 #define RADEON_MAX_AFMT_BLOCKS 7
 
@@ -2541,6 +2541,9 @@ void r100_pll_errata_after_index(struct radeon_device *rdev);
 #define ASIC_IS_DCE64(rdev) ((rdev->family == CHIP_OLAND))
 #define ASIC_IS_NODCE(rdev) ((rdev->family == CHIP_HAINAN))
 #define ASIC_IS_DCE8(rdev) ((rdev->family >= CHIP_BONAIRE))
+#define ASIC_IS_DCE81(rdev) ((rdev->family == CHIP_KAVERI))
+#define ASIC_IS_DCE82(rdev) ((rdev->family == CHIP_BONAIRE))
+#define ASIC_IS_DCE83(rdev) ((rdev->family == CHIP_KABINI))
 
 #define ASIC_IS_LOMBOK(rdev) ((rdev->ddev->pdev->device == 0x6849) || \
 			      (rdev->ddev->pdev->device == 0x6850) || \
-- 
1.9.1

