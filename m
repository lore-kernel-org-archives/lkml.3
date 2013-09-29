Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab3I2T3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:29:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045Ab3I2T33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 47/71] drm/radeon/dpm: make sure dc performance level limits are valid (BTC-SI) (v2)
Date: Sun, 29 Sep 2013 12:27:59 -0700
Message-Id: <20130929192646.695545512@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 1ff60ddb84bb9ff6fa182710c4e08b66badf918c upstream.

Check to make sure the dc limits are valid before using them.
Some systems may not have a dc limits table.  In that case just
use the ac limits.  This fixes hangs on systems when the power
state is changed when on battery (dc) due to invalid performance
state parameters.

Should fix:
https://bugs.freedesktop.org/show_bug.cgi?id=68708

v2: fix up limits in dpm_init()

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/btc_dpm.c |    6 ++++++
 drivers/gpu/drm/radeon/ni_dpm.c  |    6 ++++++
 drivers/gpu/drm/radeon/si_dpm.c  |    6 ++++++
 3 files changed, 18 insertions(+)

--- a/drivers/gpu/drm/radeon/btc_dpm.c
+++ b/drivers/gpu/drm/radeon/btc_dpm.c
@@ -2699,6 +2699,12 @@ int btc_dpm_init(struct radeon_device *r
 	else
 		rdev->pm.dpm.dyn_state.sclk_mclk_delta = 10000;
 
+	/* make sure dc limits are valid */
+	if ((rdev->pm.dpm.dyn_state.max_clock_voltage_on_dc.sclk == 0) ||
+	    (rdev->pm.dpm.dyn_state.max_clock_voltage_on_dc.mclk == 0))
+		rdev->pm.dpm.dyn_state.max_clock_voltage_on_dc =
+			rdev->pm.dpm.dyn_state.max_clock_voltage_on_ac;
+
 	return 0;
 }
 
--- a/drivers/gpu/drm/radeon/ni_dpm.c
+++ b/drivers/gpu/drm/radeon/ni_dpm.c
@@ -4270,6 +4270,12 @@ int ni_dpm_init(struct radeon_device *rd
 
 	ni_pi->use_power_boost_limit = true;
 
+	/* make sure dc limits are valid */
+	if ((rdev->pm.dpm.dyn_state.max_clock_voltage_on_dc.sclk == 0) ||
+	    (rdev->pm.dpm.dyn_state.max_clock_voltage_on_dc.mclk == 0))
+		rdev->pm.dpm.dyn_state.max_clock_voltage_on_dc =
+			rdev->pm.dpm.dyn_state.max_clock_voltage_on_ac;
+
 	return 0;
 }
 
--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -6401,6 +6401,12 @@ int si_dpm_init(struct radeon_device *rd
 
 	si_initialize_powertune_defaults(rdev);
 
+	/* make sure dc limits are valid */
+	if ((rdev->pm.dpm.dyn_state.max_clock_voltage_on_dc.sclk == 0) ||
+	    (rdev->pm.dpm.dyn_state.max_clock_voltage_on_dc.mclk == 0))
+		rdev->pm.dpm.dyn_state.max_clock_voltage_on_dc =
+			rdev->pm.dpm.dyn_state.max_clock_voltage_on_ac;
+
 	return 0;
 }
 


