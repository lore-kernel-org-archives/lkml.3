Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767AbaCDUm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:42:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941AbaCDUEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Martin <consume.noise@gmail.com>,
        Jani Nikula <jani.nikula@intel.com>, Theodore Tso <tytso@mit.edu>,
        Sree Harsha Totakura <freedesktop@h.totakura.in>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.13 172/172] drm/i915/dp: add native aux defer retry limit
Date: Tue,  4 Mar 2014 12:04:16 -0800
Message-Id: <20140304200305.192273420@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_dp.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -537,6 +537,7 @@ intel_dp_aux_native_write(struct intel_d
 	uint8_t	msg[20];
 	int msg_bytes;
 	uint8_t	ack;
+	int retry;
 
 	if (WARN_ON(send_bytes > 16))
 		return -E2BIG;
@@ -548,18 +549,20 @@ intel_dp_aux_native_write(struct intel_d
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
@@ -581,6 +584,7 @@ intel_dp_aux_native_read(struct intel_dp
 	int reply_bytes;
 	uint8_t ack;
 	int ret;
+	int retry;
 
 	if (WARN_ON(recv_bytes > 19))
 		return -E2BIG;
@@ -594,7 +598,7 @@ intel_dp_aux_native_read(struct intel_dp
 	msg_bytes = 4;
 	reply_bytes = recv_bytes + 1;
 
-	for (;;) {
+	for (retry = 0; retry < 7; retry++) {
 		ret = intel_dp_aux_ch(intel_dp, msg, msg_bytes,
 				      reply, reply_bytes);
 		if (ret == 0)
@@ -611,6 +615,9 @@ intel_dp_aux_native_read(struct intel_dp
 		else
 			return -EIO;
 	}
+
+	DRM_ERROR("too many retries, giving up\n");
+	return -EIO;
 }
 
 static int


