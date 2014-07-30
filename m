Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbaG3CHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 22:07:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60476 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbaG3Btl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:49:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Scott Doty <scott@corp.sonic.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.14 03/29] media: hdpvr: fix two audio bugs
Date: Tue, 29 Jul 2014 18:48:38 -0700
Message-Id: <20140730014809.450307484@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014809.316066303@linuxfoundation.org>
References: <20140730014809.316066303@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/hdpvr/hdpvr-video.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -82,7 +82,7 @@ static void hdpvr_read_bulk_callback(str
 }
 
 /*=========================================================================*/
-/* bufffer bits */
+/* buffer bits */
 
 /* function expects dev->io_mutex to be hold by caller */
 int hdpvr_cancel_queue(struct hdpvr_device *dev)
@@ -926,7 +926,7 @@ static int hdpvr_s_ctrl(struct v4l2_ctrl
 	case V4L2_CID_MPEG_AUDIO_ENCODING:
 		if (dev->flags & HDPVR_FLAG_AC3_CAP) {
 			opt->audio_codec = ctrl->val;
-			return hdpvr_set_audio(dev, opt->audio_input,
+			return hdpvr_set_audio(dev, opt->audio_input + 1,
 					      opt->audio_codec);
 		}
 		return 0;
@@ -1198,7 +1198,7 @@ int hdpvr_register_videodev(struct hdpvr
 	v4l2_ctrl_new_std_menu(hdl, &hdpvr_ctrl_ops,
 		V4L2_CID_MPEG_AUDIO_ENCODING,
 		ac3 ? V4L2_MPEG_AUDIO_ENCODING_AC3 : V4L2_MPEG_AUDIO_ENCODING_AAC,
-		0x7, V4L2_MPEG_AUDIO_ENCODING_AAC);
+		0x7, ac3 ? dev->options.audio_codec : V4L2_MPEG_AUDIO_ENCODING_AAC);
 	v4l2_ctrl_new_std_menu(hdl, &hdpvr_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_ENCODING,
 		V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC, 0x3,


