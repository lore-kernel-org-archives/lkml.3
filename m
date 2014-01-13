Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaAMQDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:03:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53216 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbaAMQCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 086/208] drm/radeon: fix render backend setup for SI and CIK
Date: Mon, 13 Jan 2014 15:58:47 +0000
Message-Id: <1389628849-1614-87-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c | 10 +++++-----
 drivers/gpu/drm/radeon/si.c  | 10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index e4182a6..6796c9d 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -1768,7 +1768,7 @@ static u32 cik_create_bitmask(u32 bit_width)
  * Returns the disabled RB bitmask.
  */
 static u32 cik_get_rb_disabled(struct radeon_device *rdev,
-			      u32 max_rb_num, u32 se_num,
+			      u32 max_rb_num_per_se,
 			      u32 sh_per_se)
 {
 	u32 data, mask;
@@ -1782,7 +1782,7 @@ static u32 cik_get_rb_disabled(struct radeon_device *rdev,
 
 	data >>= BACKEND_DISABLE_SHIFT;
 
-	mask = cik_create_bitmask(max_rb_num / se_num / sh_per_se);
+	mask = cik_create_bitmask(max_rb_num_per_se / sh_per_se);
 
 	return data & mask;
 }
@@ -1799,7 +1799,7 @@ static u32 cik_get_rb_disabled(struct radeon_device *rdev,
  */
 static void cik_setup_rb(struct radeon_device *rdev,
 			 u32 se_num, u32 sh_per_se,
-			 u32 max_rb_num)
+			 u32 max_rb_num_per_se)
 {
 	int i, j;
 	u32 data, mask;
@@ -1809,14 +1809,14 @@ static void cik_setup_rb(struct radeon_device *rdev,
 	for (i = 0; i < se_num; i++) {
 		for (j = 0; j < sh_per_se; j++) {
 			cik_select_se_sh(rdev, i, j);
-			data = cik_get_rb_disabled(rdev, max_rb_num, se_num, sh_per_se);
+			data = cik_get_rb_disabled(rdev, max_rb_num_per_se, sh_per_se);
 			disabled_rbs |= data << ((i * sh_per_se + j) * CIK_RB_BITMAP_WIDTH_PER_SH);
 		}
 	}
 	cik_select_se_sh(rdev, 0xffffffff, 0xffffffff);
 
 	mask = 1;
-	for (i = 0; i < max_rb_num; i++) {
+	for (i = 0; i < max_rb_num_per_se * se_num; i++) {
 		if (!(disabled_rbs & mask))
 			enabled_rbs |= mask;
 		mask <<= 1;
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index a69180c..0da5449 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -2804,7 +2804,7 @@ static void si_setup_spi(struct radeon_device *rdev,
 }
 
 static u32 si_get_rb_disabled(struct radeon_device *rdev,
-			      u32 max_rb_num, u32 se_num,
+			      u32 max_rb_num_per_se,
 			      u32 sh_per_se)
 {
 	u32 data, mask;
@@ -2818,14 +2818,14 @@ static u32 si_get_rb_disabled(struct radeon_device *rdev,
 
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
@@ -2835,14 +2835,14 @@ static void si_setup_rb(struct radeon_device *rdev,
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

