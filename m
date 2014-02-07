Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaBGLla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:41:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41022 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaBGLYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:24:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 45/88] radeon/pm: Guard access to rdev->pm.power_state array
Date: Fri,  7 Feb 2014 11:22:42 +0000
Message-Id: <1391772205-22239-46-git-send-email-luis.henriques@canonical.com>
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

From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>

commit 370169516e736edad3b3c5aa49858058f8b55195 upstream.

It's never allocated on systems without an ATOMBIOS or COMBIOS ROM.

Should fix an oops I encountered while resetting the GPU after a lockup
on my PowerBook with an RV350.

Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_pm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index c7f3d6c..bb51395 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -575,8 +575,10 @@ void radeon_pm_resume(struct radeon_device *rdev)
 	rdev->pm.current_clock_mode_index = 0;
 	rdev->pm.current_sclk = rdev->pm.default_sclk;
 	rdev->pm.current_mclk = rdev->pm.default_mclk;
-	rdev->pm.current_vddc = rdev->pm.power_state[rdev->pm.default_power_state_index].clock_info[0].voltage.voltage;
-	rdev->pm.current_vddci = rdev->pm.power_state[rdev->pm.default_power_state_index].clock_info[0].voltage.vddci;
+	if (rdev->pm.power_state) {
+		rdev->pm.current_vddc = rdev->pm.power_state[rdev->pm.default_power_state_index].clock_info[0].voltage.voltage;
+		rdev->pm.current_vddci = rdev->pm.power_state[rdev->pm.default_power_state_index].clock_info[0].voltage.vddci;
+	}
 	if (rdev->pm.pm_method == PM_METHOD_DYNPM
 	    && rdev->pm.dynpm_state == DYNPM_STATE_SUSPENDED) {
 		rdev->pm.dynpm_state = DYNPM_STATE_ACTIVE;
-- 
1.8.3.2

