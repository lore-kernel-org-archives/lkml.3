Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbaBJTtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:49:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35148 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbaBJTra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:47:30 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 043/124] radeon/pm: Guard access to rdev->pm.power_state array
Date: Mon, 10 Feb 2014 11:39:43 -0800
Message-Id: <1392061264-28124-44-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>

commit 370169516e736edad3b3c5aa49858058f8b55195 upstream.

It's never allocated on systems without an ATOMBIOS or COMBIOS ROM.

Should fix an oops I encountered while resetting the GPU after a lockup
on my PowerBook with an RV350.

Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_pm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index 788c64c..469ba71 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -561,8 +561,10 @@ void radeon_pm_resume(struct radeon_device *rdev)
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

