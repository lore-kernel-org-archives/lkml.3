Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbbAVKrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:47:20 -0500
Received: from www.osadl.org ([62.245.132.105]:42379 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbbAVKrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:47:11 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Mike Isely <isely@pobox.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] pvrusb2: use msecs_to_jiffies for conversion
Date: Thu, 22 Jan 2015 11:39:11 +0100
Message-Id: <1421923151-24684-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is only an API consolidation and should make things more readable

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

Converting milliseconds to jiffies by val * HZ / 1000 is technically
not wrong but msecs_to_jiffies(val) is the cleaner solution and handles
all corner cases correctly. This is a minor API cleanup only.

This patch was only compile tested with x86_64_defconfig + 
CONFIG_MEDIA_SUPPORT=m, CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y,
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y, CONFIG_MEDIA_USB_SUPPORT=y,
CONFIG_VIDEO_PVRUSB2=m, CONFIG_VIDEO_PVRUSB2_DVB=y

Patch is against 3.19.0-rc5 -next-20150119

 drivers/media/usb/pvrusb2/pvrusb2-hdw.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index 2fd9b5e..ee187c1 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -4301,9 +4301,8 @@ static int state_eval_encoder_config(struct pvr2_hdw *hdw)
 				   the encoder. */
 				if (!hdw->state_encoder_waitok) {
 					hdw->encoder_wait_timer.expires =
-						jiffies +
-						(HZ * TIME_MSEC_ENCODER_WAIT
-						 / 1000);
+						jiffies + msecs_to_jiffies(
+						TIME_MSEC_ENCODER_WAIT);
 					add_timer(&hdw->encoder_wait_timer);
 				}
 			}
@@ -4426,8 +4425,8 @@ static int state_eval_encoder_run(struct pvr2_hdw *hdw)
 		if (pvr2_encoder_start(hdw) < 0) return !0;
 		hdw->state_encoder_run = !0;
 		if (!hdw->state_encoder_runok) {
-			hdw->encoder_run_timer.expires =
-				jiffies + (HZ * TIME_MSEC_ENCODER_OK / 1000);
+			hdw->encoder_run_timer.expires = jiffies +
+				 msecs_to_jiffies(TIME_MSEC_ENCODER_OK);
 			add_timer(&hdw->encoder_run_timer);
 		}
 	}
@@ -4518,9 +4517,8 @@ static int state_eval_decoder_run(struct pvr2_hdw *hdw)
 				   but before we did the pending check. */
 				if (!hdw->state_decoder_quiescent) {
 					hdw->quiescent_timer.expires =
-						jiffies +
-						(HZ * TIME_MSEC_DECODER_WAIT
-						 / 1000);
+						jiffies + msecs_to_jiffies(
+						TIME_MSEC_DECODER_WAIT);
 					add_timer(&hdw->quiescent_timer);
 				}
 			}
@@ -4544,9 +4542,8 @@ static int state_eval_decoder_run(struct pvr2_hdw *hdw)
 		hdw->state_decoder_run = !0;
 		if (hdw->decoder_client_id == PVR2_CLIENT_ID_SAA7115) {
 			hdw->decoder_stabilization_timer.expires =
-				jiffies +
-				(HZ * TIME_MSEC_DECODER_STABILIZATION_WAIT /
-				 1000);
+				jiffies + msecs_to_jiffies(
+				TIME_MSEC_DECODER_STABILIZATION_WAIT);
 			add_timer(&hdw->decoder_stabilization_timer);
 		} else {
 			hdw->state_decoder_ready = !0;
-- 
1.7.10.4

