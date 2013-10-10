Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab3JJPx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:53:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53069 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757632Ab3JJPud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:50:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 065/104] drm/i915/dp: increase i2c-over-aux retry interval on AUX DEFER
Date: Thu, 10 Oct 2013 08:41:53 -0700
Message-Id: <1381419752-29733-66-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 8d16f258217f2f583af1fd57c5144aa4bbe73e48 upstream.

There is no clear cut rules or specs for the retry interval, as there
are many factors that affect overall response time. Increase the
interval, and even more so on branch devices which may have limited i2c
bit rates.

Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reference: https://bugs.freedesktop.org/show_bug.cgi?id=60263
Tested-by: Nicolas Suzor <nic@suzor.com>
Reviewed-by: Todd Previte <tprevite@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_dp.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 616aaea..37c6d3f 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -629,7 +629,18 @@ intel_dp_i2c_aux_ch(struct i2c_adapter *adapter, int mode,
 			DRM_DEBUG_KMS("aux_ch native nack\n");
 			return -EREMOTEIO;
 		case AUX_NATIVE_REPLY_DEFER:
-			udelay(100);
+			/*
+			 * For now, just give more slack to branch devices. We
+			 * could check the DPCD for I2C bit rate capabilities,
+			 * and if available, adjust the interval. We could also
+			 * be more careful with DP-to-Legacy adapters where a
+			 * long legacy cable may force very low I2C bit rates.
+			 */
+			if (intel_dp->dpcd[DP_DOWNSTREAMPORT_PRESENT] &
+			    DP_DWN_STRM_PORT_PRESENT)
+				usleep_range(500, 600);
+			else
+				usleep_range(300, 400);
 			continue;
 		default:
 			DRM_ERROR("aux_ch invalid native reply 0x%02x\n",
-- 
1.8.1.2

