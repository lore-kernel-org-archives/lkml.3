Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab3JCEoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:44:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab3JCEU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:20:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>, Nicolas Suzor <nic@suzor.com>,
        Todd Previte <tprevite@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 45/57] drm/i915/dp: increase i2c-over-aux retry interval on AUX DEFER
Date: Wed,  2 Oct 2013 21:09:11 -0700
Message-Id: <20131003040639.674203089@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_dp.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -567,7 +567,18 @@ intel_dp_i2c_aux_ch(struct i2c_adapter *
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


