Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaKEUMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:12:41 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:51043 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaKEUMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:12:39 -0500
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, hans.verkuil@cisco.com,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Subject: [PATCH] solo6x10: just pass frame motion flag from hardware, drop additional handling as complicated and unstable
Date: Thu,  6 Nov 2014 00:11:14 +0400
Message-Id: <1415218274-28132-1-git-send-email-andrey.utkin@corp.bluecherry.net>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dropping code (introduced in 316d9e84a72069e04e483de0d5934c1d75f6a44c)
which intends to make raising of motion events more "smooth"(?).

It made motion event never appear in my installation.
That code is complicated, so I couldn't figure out quickly how to fix
it, so dropping it seems better to me.

Another justification is that anyway application would implement
"motion signal stabilization" if required, it is not necessarily kernel
driver's job.

Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
---
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c | 30 +-------------------------
 drivers/media/pci/solo6x10/solo6x10.h          |  2 --
 2 files changed, 1 insertion(+), 31 deletions(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 30e09d9..866f7b3 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -239,8 +239,6 @@ static int solo_enc_on(struct solo_enc_dev *solo_enc)
 	if (solo_enc->bw_weight > solo_dev->enc_bw_remain)
 		return -EBUSY;
 	solo_enc->sequence = 0;
-	solo_enc->motion_last_state = false;
-	solo_enc->frames_since_last_motion = 0;
 	solo_dev->enc_bw_remain -= solo_enc->bw_weight;
 
 	if (solo_enc->type == SOLO_ENC_TYPE_EXT)
@@ -555,36 +553,12 @@ static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
 	}
 
 	if (!ret) {
-		bool send_event = false;
-
 		vb->v4l2_buf.sequence = solo_enc->sequence++;
 		vb->v4l2_buf.timestamp.tv_sec = vop_sec(vh);
 		vb->v4l2_buf.timestamp.tv_usec = vop_usec(vh);
 
 		/* Check for motion flags */
-		if (solo_is_motion_on(solo_enc)) {
-			/* It takes a few frames for the hardware to detect
-			 * motion. Once it does it clears the motion detection
-			 * register and it takes again a few frames before
-			 * motion is seen. This means in practice that when the
-			 * motion field is 1, it will go back to 0 for the next
-			 * frame. This leads to motion detection event being
-			 * sent all the time, which is not what we want.
-			 * Instead wait a few frames before deciding that the
-			 * motion has halted. After some experimentation it
-			 * turns out that waiting for 5 frames works well.
-			 */
-			if (enc_buf->motion == 0 &&
-			    solo_enc->motion_last_state &&
-			    solo_enc->frames_since_last_motion++ > 5)
-				send_event = true;
-			else if (enc_buf->motion) {
-				solo_enc->frames_since_last_motion = 0;
-				send_event = !solo_enc->motion_last_state;
-			}
-		}
-
-		if (send_event) {
+		if (solo_is_motion_on(solo_enc) && enc_buf->motion) {
 			struct v4l2_event ev = {
 				.type = V4L2_EVENT_MOTION_DET,
 				.u.motion_det = {
@@ -594,8 +568,6 @@ static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
 				},
 			};
 
-			solo_enc->motion_last_state = enc_buf->motion;
-			solo_enc->frames_since_last_motion = 0;
 			v4l2_event_queue(solo_enc->vfd, &ev);
 		}
 	}
diff --git a/drivers/media/pci/solo6x10/solo6x10.h b/drivers/media/pci/solo6x10/solo6x10.h
index 72017b7..dc503fd 100644
--- a/drivers/media/pci/solo6x10/solo6x10.h
+++ b/drivers/media/pci/solo6x10/solo6x10.h
@@ -159,8 +159,6 @@ struct solo_enc_dev {
 	u16			motion_thresh;
 	bool			motion_global;
 	bool			motion_enabled;
-	bool			motion_last_state;
-	u8			frames_since_last_motion;
 	u16			width;
 	u16			height;
 
-- 
1.8.5.5

