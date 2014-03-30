Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbaCaAKG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:10:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753071AbaC3Xmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:42:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "=?UTF-8?q?Michel=20D=C3=A4nzer?=" <michel.daenzer@amd.com>,
        "Alex Deucher" <alexander.deucher@amd.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.73784971@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 029/200] radeon/pm: Guard access to rdev->pm.power_state
 array
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Michel Dänzer <michel.daenzer@amd.com>

commit 370169516e736edad3b3c5aa49858058f8b55195 upstream.

It's never allocated on systems without an ATOMBIOS or COMBIOS ROM.

Should fix an oops I encountered while resetting the GPU after a lockup
on my PowerBook with an RV350.

Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_pm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -573,8 +573,10 @@ void radeon_pm_resume(struct radeon_devi
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

