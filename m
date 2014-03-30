Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbaC3XnX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:43:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754506AbaC3XnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:10 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jani Nikula" <jani.nikula@intel.com>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Sree Harsha Totakura" <freedesktop@h.totakura.in>,
        "Daniel Martin" <consume.noise@gmail.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.458981092@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 111/200] drm/i915/dp: add native aux defer retry limit
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_dp.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -483,6 +483,7 @@ intel_dp_aux_native_write(struct intel_d
 	uint8_t	msg[20];
 	int msg_bytes;
 	uint8_t	ack;
+	int retry;
 
 	intel_dp_check_edp(intel_dp);
 	if (send_bytes > 16)
@@ -493,18 +494,20 @@ intel_dp_aux_native_write(struct intel_d
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
@@ -526,6 +529,7 @@ intel_dp_aux_native_read(struct intel_dp
 	int reply_bytes;
 	uint8_t ack;
 	int ret;
+	int retry;
 
 	intel_dp_check_edp(intel_dp);
 	msg[0] = AUX_NATIVE_READ << 4;
@@ -536,7 +540,7 @@ intel_dp_aux_native_read(struct intel_dp
 	msg_bytes = 4;
 	reply_bytes = recv_bytes + 1;
 
-	for (;;) {
+	for (retry = 0; retry < 7; retry++) {
 		ret = intel_dp_aux_ch(intel_dp, msg, msg_bytes,
 				      reply, reply_bytes);
 		if (ret == 0)
@@ -553,6 +557,9 @@ intel_dp_aux_native_read(struct intel_dp
 		else
 			return -EIO;
 	}
+
+	DRM_ERROR("too many retries, giving up\n");
+	return -EIO;
 }
 
 static int

