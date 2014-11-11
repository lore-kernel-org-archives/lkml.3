Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaKKLLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:11:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57776 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbaKKLLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 133/170] drm/i915: Do a dummy DPCD read before the actual read
Date: Tue, 11 Nov 2014 11:08:12 +0000
Message-Id: <1415704129-12709-134-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>

commit f6a1906674005377b64ee5431c1418077c1b2425 upstream.

Sometimes we seem to get utter garbage from DPCD reads. The resulting
buffer is filled with the same byte, and the operation completed without
errors. My HP ZR24w monitor seems particularly susceptible to this
problem once it's gone into a sleep mode.

The issue seems to happen only for the first AUX message that wakes the
sink up. But as the first AUX read we often do is the DPCD receiver
cap it does wreak a bit of havoc with subsequent link training etc. when
the receiver cap bw/lane/etc. information is garbage.

A sufficient workaround seems to be to perform a single byte dummy read
before reading the actual data. I suppose that just wakes up the sink
sufficiently and we can just throw away the returned data in case it's
crap. DP_DPCD_REV seems like a sufficiently safe location to read here.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Todd Previte <tprevite@gmail.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_dp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index fbffcbb9a0f8..ca6a8cf58ab0 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -2166,6 +2166,13 @@ intel_dp_dpcd_read_wake(struct drm_dp_aux *aux, unsigned int offset,
 	ssize_t ret;
 	int i;
 
+	/*
+	 * Sometime we just get the same incorrect byte repeated
+	 * over the entire buffer. Doing just one throw away read
+	 * initially seems to "solve" it.
+	 */
+	drm_dp_dpcd_read(aux, DP_DPCD_REV, buffer, 1);
+
 	for (i = 0; i < 3; i++) {
 		ret = drm_dp_dpcd_read(aux, offset, buffer, size);
 		if (ret == size)
-- 
2.1.0

