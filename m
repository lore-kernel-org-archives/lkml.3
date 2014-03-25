Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbaCYRss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:48:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55787 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbaCYRVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:21:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 19/81] drm/i915/dp: add native aux defer retry limit
Date: Tue, 25 Mar 2014 10:15:32 -0700
Message-Id: <1395767794-5012-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_dp.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 394fa61..64c9d7e 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -491,6 +491,7 @@ intel_dp_aux_native_write(struct intel_dp *intel_dp,
 	uint8_t	msg[20];
 	int msg_bytes;
 	uint8_t	ack;
+	int retry;
 
 	intel_dp_check_edp(intel_dp);
 	if (send_bytes > 16)
@@ -501,18 +502,20 @@ intel_dp_aux_native_write(struct intel_dp *intel_dp,
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
@@ -534,6 +537,7 @@ intel_dp_aux_native_read(struct intel_dp *intel_dp,
 	int reply_bytes;
 	uint8_t ack;
 	int ret;
+	int retry;
 
 	intel_dp_check_edp(intel_dp);
 	msg[0] = AUX_NATIVE_READ << 4;
@@ -544,7 +548,7 @@ intel_dp_aux_native_read(struct intel_dp *intel_dp,
 	msg_bytes = 4;
 	reply_bytes = recv_bytes + 1;
 
-	for (;;) {
+	for (retry = 0; retry < 7; retry++) {
 		ret = intel_dp_aux_ch(intel_dp, msg, msg_bytes,
 				      reply, reply_bytes);
 		if (ret == 0)
@@ -561,6 +565,9 @@ intel_dp_aux_native_read(struct intel_dp *intel_dp,
 		else
 			return -EIO;
 	}
+
+	DRM_ERROR("too many retries, giving up\n");
+	return -EIO;
 }
 
 static int
-- 
1.8.3.2

