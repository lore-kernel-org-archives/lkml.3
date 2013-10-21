Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3JUJMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:12:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39633 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753910Ab3JUIvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:48 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Nicolas Suzor" <nic@suzor.com>,
        "Jani Nikula" <jani.nikula@intel.com>,
        "Todd Previte" <tprevite@gmail.com>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.116791771@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 085/149] drm/i915/dp: increase i2c-over-aux retry
 interval on AUX DEFER
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_dp.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -621,7 +621,18 @@ intel_dp_i2c_aux_ch(struct i2c_adapter *
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

