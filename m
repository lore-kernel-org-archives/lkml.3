Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993AbaJ2QEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:04:30 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:54087 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933829AbaJ2QE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:04:28 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Cc: ismael.luceno@corp.bluecherry.net, m.chehab@samsung.com,
        hverkuil@xs4all.nl, Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH 3/4] [media] solo6x10: bind start & stop of encoded frames processing thread to device (de)init
Date: Wed, 29 Oct 2014 20:03:53 +0400
Message-Id: <1414598634-13446-3-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1414598634-13446-1-git-send-email-andrey.krieger.utkin@gmail.com>
References: <1414598634-13446-1-git-send-email-andrey.krieger.utkin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before, it was called from individual encoder (de)init procedures, which
lead to spare threads running (which were actually lost, leaked).
The current fix uses trivial approach, and the downside is that the
processing thread is working always, even when there's no consumer.

Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 9afeb69..b9b61b9 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -770,12 +770,8 @@ static void solo_ring_stop(struct solo_dev *solo_dev)
 static int solo_enc_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct solo_enc_dev *solo_enc = vb2_get_drv_priv(q);
-	int ret;
 
-	ret = solo_enc_on(solo_enc);
-	if (ret)
-		return ret;
-	return solo_ring_start(solo_enc->solo_dev);
+	return solo_enc_on(solo_enc);
 }
 
 static void solo_enc_stop_streaming(struct vb2_queue *q)
@@ -794,7 +790,6 @@ static void solo_enc_stop_streaming(struct vb2_queue *q)
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&solo_enc->av_lock, flags);
-	solo_ring_stop(solo_enc->solo_dev);
 }
 
 static struct vb2_ops solo_enc_video_qops = {
@@ -1432,13 +1427,15 @@ int solo_enc_v4l2_init(struct solo_dev *solo_dev, unsigned nr)
 		 solo_dev->v4l2_enc[0]->vfd->num,
 		 solo_dev->v4l2_enc[solo_dev->nr_chans - 1]->vfd->num);
 
-	return 0;
+	return solo_ring_start(solo_dev);
 }
 
 void solo_enc_v4l2_exit(struct solo_dev *solo_dev)
 {
 	int i;
 
+	solo_ring_stop(solo_dev);
+
 	for (i = 0; i < solo_dev->nr_chans; i++)
 		solo_enc_free(solo_dev->v4l2_enc[i]);
 
-- 
1.8.5.5

