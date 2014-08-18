Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaHRJe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:34:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42749 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaHRJe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:34:56 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 062/137] [media] hdpvr: fix two audio bugs
Date: Mon, 18 Aug 2014 10:32:03 +0100
Message-Id: <1408354398-10226-63-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil@xs4all.nl>

commit 3445857b22eafb70a6ac258979e955b116bfd2c6 upstream.

When the audio encoding is changed the driver calls hdpvr_set_audio
with the current opt->audio_input value. However, that should have
been opt->audio_input + 1. So changing the audio encoding inadvertently
changes the input as well. This bug has always been there.

The second bug was introduced in kernel 3.10 and that broke the
default_audio_input module option handling: the audio encoding was
never switched to AC3 if default_audio_input was set to 2 (SPDIF input).

In addition, since starting with 3.10 the audio encoding is always set
at the start the first bug now always happens when the driver is loaded.
In the past this bug would only surface if the user would change the
audio encoding after the driver was loaded.

Also fixes a small trivial typo (bufffer -> buffer).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Scott Doty <scott@corp.sonic.net>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/usb/hdpvr/hdpvr-video.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 4f8567aa99d8..068e9c5bfa7f 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -81,7 +81,7 @@ static void hdpvr_read_bulk_callback(struct urb *urb)
 }
 
 /*=========================================================================*/
-/* bufffer bits */
+/* buffer bits */
 
 /* function expects dev->io_mutex to be hold by caller */
 int hdpvr_cancel_queue(struct hdpvr_device *dev)
@@ -927,7 +927,7 @@ static int hdpvr_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_AUDIO_ENCODING:
 		if (dev->flags & HDPVR_FLAG_AC3_CAP) {
 			opt->audio_codec = ctrl->val;
-			return hdpvr_set_audio(dev, opt->audio_input,
+			return hdpvr_set_audio(dev, opt->audio_input + 1,
 					      opt->audio_codec);
 		}
 		return 0;
@@ -1199,7 +1199,7 @@ int hdpvr_register_videodev(struct hdpvr_device *dev, struct device *parent,
 	v4l2_ctrl_new_std_menu(hdl, &hdpvr_ctrl_ops,
 		V4L2_CID_MPEG_AUDIO_ENCODING,
 		ac3 ? V4L2_MPEG_AUDIO_ENCODING_AC3 : V4L2_MPEG_AUDIO_ENCODING_AAC,
-		0x7, V4L2_MPEG_AUDIO_ENCODING_AAC);
+		0x7, ac3 ? dev->options.audio_codec : V4L2_MPEG_AUDIO_ENCODING_AAC);
 	v4l2_ctrl_new_std_menu(hdl, &hdpvr_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_ENCODING,
 		V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC, 0x3,
-- 
1.9.1

