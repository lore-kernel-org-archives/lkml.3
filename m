Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbaJCVmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:42:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbaJCVc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.16 087/357] drm/radeon/dpm: select the appropriate vce power state for KV/KB/ML
Date: Fri,  3 Oct 2014 14:27:53 -0700
Message-Id: <20141003212936.099682916@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit c83dec3bb6c38629398b65c231c80978b3e00e14 upstream.

Compare the clock in the limits table to the requested evclk rather
than just taking the first value.  Improves vce performance in certain
cases.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/kv_dpm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/kv_dpm.c
+++ b/drivers/gpu/drm/radeon/kv_dpm.c
@@ -1438,14 +1438,14 @@ static int kv_update_uvd_dpm(struct rade
 	return kv_enable_uvd_dpm(rdev, !gate);
 }
 
-static u8 kv_get_vce_boot_level(struct radeon_device *rdev)
+static u8 kv_get_vce_boot_level(struct radeon_device *rdev, u32 evclk)
 {
 	u8 i;
 	struct radeon_vce_clock_voltage_dependency_table *table =
 		&rdev->pm.dpm.dyn_state.vce_clock_voltage_dependency_table;
 
 	for (i = 0; i < table->count; i++) {
-		if (table->entries[i].evclk >= 0) /* XXX */
+		if (table->entries[i].evclk >= evclk)
 			break;
 	}
 
@@ -1468,7 +1468,7 @@ static int kv_update_vce_dpm(struct rade
 		if (pi->caps_stable_p_state)
 			pi->vce_boot_level = table->count - 1;
 		else
-			pi->vce_boot_level = kv_get_vce_boot_level(rdev);
+			pi->vce_boot_level = kv_get_vce_boot_level(rdev, radeon_new_state->evclk);
 
 		ret = kv_copy_bytes_to_smc(rdev,
 					   pi->dpm_table_start +


