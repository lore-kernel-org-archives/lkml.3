Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbaG3MX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:23:58 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36780 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002AbaG3MPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 77/94] media: hdpvr: fix two audio bugs
Date: Wed, 30 Jul 2014 14:15:06 +0200
Message-Id: <21e636e72e52ef809de79c36f568fbc4acd30914.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hverkuil@xs4all.nl>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/usb/hdpvr/hdpvr-video.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 0500c4175d5f..6bce01a674f9 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -82,7 +82,7 @@ static void hdpvr_read_bulk_callback(struct urb *urb)
 }
 
 /*=========================================================================*/
-/* bufffer bits */
+/* buffer bits */
 
 /* function expects dev->io_mutex to be hold by caller */
 int hdpvr_cancel_queue(struct hdpvr_device *dev)
@@ -926,7 +926,7 @@ static int hdpvr_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_AUDIO_ENCODING:
 		if (dev->flags & HDPVR_FLAG_AC3_CAP) {
 			opt->audio_codec = ctrl->val;
-			return hdpvr_set_audio(dev, opt->audio_input,
+			return hdpvr_set_audio(dev, opt->audio_input + 1,
 					      opt->audio_codec);
 		}
 		return 0;
@@ -1198,7 +1198,7 @@ int hdpvr_register_videodev(struct hdpvr_device *dev, struct device *parent,
 	v4l2_ctrl_new_std_menu(hdl, &hdpvr_ctrl_ops,
 		V4L2_CID_MPEG_AUDIO_ENCODING,
 		ac3 ? V4L2_MPEG_AUDIO_ENCODING_AC3 : V4L2_MPEG_AUDIO_ENCODING_AAC,
-		0x7, V4L2_MPEG_AUDIO_ENCODING_AAC);
+		0x7, ac3 ? dev->options.audio_codec : V4L2_MPEG_AUDIO_ENCODING_AAC);
 	v4l2_ctrl_new_std_menu(hdl, &hdpvr_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_ENCODING,
 		V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC, 0x3,
-- 
2.0.1

