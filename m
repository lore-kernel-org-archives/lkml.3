Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaBGLk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:40:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41026 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbaBGLYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:24:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 46/88] drm/radeon: skip colorbuffer checking if COLOR_INFO.FORMAT is set to INVALID
Date: Fri,  7 Feb 2014 11:22:43 +0000
Message-Id: <1391772205-22239-47-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>

commit 56492e0fac2dbaf7735ffd66b206a90624917789 upstream.

This fixes a bug which was causing rejections of valid GPU commands
from userspace.

Signed-off-by: Marek Olšák <marek.olsak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen_cs.c | 5 ++++-
 drivers/gpu/drm/radeon/r600_cs.c      | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen_cs.c b/drivers/gpu/drm/radeon/evergreen_cs.c
index 4324c0d..64bc1fa 100644
--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -942,7 +942,10 @@ static int evergreen_cs_track_check(struct radeon_cs_parser *p)
 	if (track->cb_dirty) {
 		tmp = track->cb_target_mask;
 		for (i = 0; i < 8; i++) {
-			if ((tmp >> (i * 4)) & 0xF) {
+			u32 format = G_028C70_FORMAT(track->cb_color_info[i]);
+
+			if (format != V_028C70_COLOR_INVALID &&
+			    (tmp >> (i * 4)) & 0xF) {
 				/* at least one component is enabled */
 				if (track->cb_color_bo[i] == NULL) {
 					dev_warn(p->dev, "%s:%d mask 0x%08X | 0x%08X no cb for %d\n",
diff --git a/drivers/gpu/drm/radeon/r600_cs.c b/drivers/gpu/drm/radeon/r600_cs.c
index c05e88a..d11c75e 100644
--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -747,7 +747,10 @@ static int r600_cs_track_check(struct radeon_cs_parser *p)
 	if (track->cb_dirty) {
 		tmp = track->cb_target_mask;
 		for (i = 0; i < 8; i++) {
-			if ((tmp >> (i * 4)) & 0xF) {
+			u32 format = G_0280A0_FORMAT(track->cb_color_info[i]);
+
+			if (format != V_0280A0_COLOR_INVALID &&
+			    (tmp >> (i * 4)) & 0xF) {
 				/* at least one component is enabled */
 				if (track->cb_color_bo[i] == NULL) {
 					dev_warn(p->dev, "%s:%d mask 0x%08X | 0x%08X no cb for %d\n",
-- 
1.8.3.2

