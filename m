Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab3GBL4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:56:52 -0400
Received: from shell.v3.sk ([195.168.3.45]:59944 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab3GBL4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:56:49 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: linux-media@vger.kernel.org
Cc: Lubomir Rintel <lkundrak@v3.sk>, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] [media] usbtv: Throw corrupted frames away
Date: Tue,  2 Jul 2013 13:56:39 +0200
Message-Id: <1372766199-28771-2-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1372766199-28771-1-git-send-email-lkundrak@v3.sk>
References: <1372766199-28771-1-git-send-email-lkundrak@v3.sk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignore out of order data and mark incomplete buffers as errored.
This gets rid of annoying flicker due to occassional garbage from hardware.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
---
 drivers/media/usb/usbtv/usbtv.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv.c b/drivers/media/usb/usbtv/usbtv.c
index bdb87d7..acd649c 100644
--- a/drivers/media/usb/usbtv/usbtv.c
+++ b/drivers/media/usb/usbtv/usbtv.c
@@ -89,6 +89,7 @@ struct usbtv {
 	/* Number of currently processed frame, useful find
 	 * out when a new one begins. */
 	u32 frame_id;
+	int chunks_done;
 
 	int iso_size;
 	unsigned int sequence;
@@ -242,8 +243,13 @@ static void usbtv_image_chunk(struct usbtv *usbtv, u32 *chunk)
 		return;
 
 	/* Beginning of a frame. */
-	if (chunk_no == 0)
+	if (chunk_no == 0) {
 		usbtv->frame_id = frame_id;
+		usbtv->chunks_done = 0;
+	}
+
+	if (usbtv->frame_id != frame_id)
+		return;
 
 	spin_lock_irqsave(&usbtv->buflock, flags);
 	if (list_empty(&usbtv->bufs)) {
@@ -258,16 +264,21 @@ static void usbtv_image_chunk(struct usbtv *usbtv, u32 *chunk)
 
 	/* Copy the chunk data. */
 	usbtv_chunk_to_vbuf(frame, &chunk[1], chunk_no, odd);
+	usbtv->chunks_done++;
 
 	/* Last chunk in a frame, signalling an end */
 	if (odd && chunk_no == USBTV_CHUNKS-1) {
 		int size = vb2_plane_size(&buf->vb, 0);
+		enum vb2_buffer_state state = usbtv->chunks_done ==
+						USBTV_CHUNKS ?
+						VB2_BUF_STATE_DONE :
+						VB2_BUF_STATE_ERROR;
 
 		buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
 		buf->vb.v4l2_buf.sequence = usbtv->sequence++;
 		v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
 		vb2_set_plane_payload(&buf->vb, 0, size);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&buf->vb, state);
 		list_del(&buf->list);
 	}
 
-- 
1.7.1

