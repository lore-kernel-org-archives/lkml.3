Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625AbaCEO5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:57:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41558 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767AbaCEOhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:37:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 08/62] drm/i915/dp: add native aux defer retry limit
Date: Wed,  5 Mar 2014 14:36:12 +0000
Message-Id: <1394030226-26652-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit f51a44b9a6c4982cc25bfb3727de9bb893621ebc upstream.

Retrying indefinitely places too much trust on the aux implementation of
the sink devices.

Reported-by: Daniel Martin <consume.noise@gmail.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=71267
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Tested-by: Theodore Ts'o <tytso@mit.edu>
Tested-by: Sree Harsha Totakura <freedesktop@h.totakura.in>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_dp.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index fa14b42..7632aa0 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -493,6 +493,7 @@ intel_dp_aux_native_write(struct intel_dp *intel_dp,
 	uint8_t	msg[20];
 	int msg_bytes;
 	uint8_t	ack;
+	int retry;
 
 	intel_dp_check_edp(intel_dp);
 	if (send_bytes > 16)
@@ -503,18 +504,20 @@ intel_dp_aux_native_write(struct intel_dp *intel_dp,
 	msg[3] = send_bytes - 1;
 	memcpy(&msg[4], send, send_bytes);
 	msg_bytes = send_bytes + 4;
-	for (;;) {
+	for (retry = 0; retry < 7; retry++) {
 		ret = intel_dp_aux_ch(intel_dp, msg, msg_bytes, &ack, 1);
 		if (ret < 0)
 			return ret;
 		if ((ack & AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_ACK)
-			break;
+			return send_bytes;
 		else if ((ack & AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_DEFER)
 			usleep_range(400, 500);
 		else
 			return -EIO;
 	}
-	return send_bytes;
+
+	DRM_ERROR("too many retries, giving up\n");
+	return -EIO;
 }
 
 /* Write a single byte to the aux channel in native mode */
@@ -536,6 +539,7 @@ intel_dp_aux_native_read(struct intel_dp *intel_dp,
 	int reply_bytes;
 	uint8_t ack;
 	int ret;
+	int retry;
 
 	intel_dp_check_edp(intel_dp);
 	msg[0] = AUX_NATIVE_READ << 4;
@@ -546,7 +550,7 @@ intel_dp_aux_native_read(struct intel_dp *intel_dp,
 	msg_bytes = 4;
 	reply_bytes = recv_bytes + 1;
 
-	for (;;) {
+	for (retry = 0; retry < 7; retry++) {
 		ret = intel_dp_aux_ch(intel_dp, msg, msg_bytes,
 				      reply, reply_bytes);
 		if (ret == 0)
@@ -563,6 +567,9 @@ intel_dp_aux_native_read(struct intel_dp *intel_dp,
 		else
 			return -EIO;
 	}
+
+	DRM_ERROR("too many retries, giving up\n");
+	return -EIO;
 }
 
 static int
-- 
1.9.0

