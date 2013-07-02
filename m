Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab3GBL4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:56:51 -0400
Received: from shell.v3.sk ([195.168.3.45]:59945 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab3GBL4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:56:49 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: linux-media@vger.kernel.org
Cc: Lubomir Rintel <lkundrak@v3.sk>, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] [media] usbtv: Fix deinterlacing
Date: Tue,  2 Jul 2013 13:56:38 +0200
Message-Id: <1372766199-28771-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The image data is laid out a bit more weirdly and thus needs more work to
properly interlace. What we get from hardware is V4L2_FIELD_ALTERNATE, but
since userspace support for it is practically nonexistent, thus we make
V4L2_FIELD_INTERLACED from it so that it's more easily interpreted.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
---
 drivers/media/usb/usbtv/usbtv.c |   36 +++++++++++++++++++++++++-----------
 1 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv.c b/drivers/media/usb/usbtv/usbtv.c
index d44fa63..bdb87d7 100644
--- a/drivers/media/usb/usbtv/usbtv.c
+++ b/drivers/media/usb/usbtv/usbtv.c
@@ -57,7 +57,7 @@
 #define USBTV_CHUNK_SIZE	256
 #define USBTV_CHUNK		240
 #define USBTV_CHUNKS		(USBTV_WIDTH * USBTV_HEIGHT \
-					/ 2 / USBTV_CHUNK)
+					/ 4 / USBTV_CHUNK)
 
 /* Chunk header. */
 #define USBTV_MAGIC_OK(chunk)	((be32_to_cpu(chunk[0]) & 0xff000000) \
@@ -202,6 +202,26 @@ static int usbtv_setup_capture(struct usbtv *usbtv)
 	return 0;
 }
 
+/* Copy data from chunk into a frame buffer, deinterlacing the data
+ * into every second line. Unfortunately, they don't align nicely into
+ * 720 pixel lines, as the chunk is 240 words long, which is 480 pixels.
+ * Therefore, we break down the chunk into two halves before copyting,
+ * so that we can interleave a line if needed. */
+static void usbtv_chunk_to_vbuf(u32 *frame, u32 *src, int chunk_no, int odd)
+{
+	int half;
+
+	for (half = 0; half < 2; half++) {
+		int part_no = chunk_no * 2 + half;
+		int line = part_no / 3;
+		int part_index = (line * 2 + !odd) * 3 + (part_no % 3);
+
+		u32 *dst = &frame[part_index * USBTV_CHUNK/2];
+		memcpy(dst, src, USBTV_CHUNK/2 * sizeof(*src));
+		src += USBTV_CHUNK/2;
+	}
+}
+
 /* Called for each 256-byte image chunk.
  * First word identifies the chunk, followed by 240 words of image
  * data and padding. */
@@ -218,11 +238,6 @@ static void usbtv_image_chunk(struct usbtv *usbtv, u32 *chunk)
 	frame_id = USBTV_FRAME_ID(chunk);
 	odd = USBTV_ODD(chunk);
 	chunk_no = USBTV_CHUNK_NO(chunk);
-
-	/* Deinterlace. TODO: Use interlaced frame format. */
-	chunk_no = (chunk_no - chunk_no % 3) * 2 + chunk_no % 3;
-	chunk_no += !odd * 3;
-
 	if (chunk_no >= USBTV_CHUNKS)
 		return;
 
@@ -241,12 +256,11 @@ static void usbtv_image_chunk(struct usbtv *usbtv, u32 *chunk)
 	buf = list_first_entry(&usbtv->bufs, struct usbtv_buf, list);
 	frame = vb2_plane_vaddr(&buf->vb, 0);
 
-	/* Copy the chunk. */
-	memcpy(&frame[chunk_no * USBTV_CHUNK], &chunk[1],
-			USBTV_CHUNK * sizeof(chunk[1]));
+	/* Copy the chunk data. */
+	usbtv_chunk_to_vbuf(frame, &chunk[1], chunk_no, odd);
 
 	/* Last chunk in a frame, signalling an end */
-	if (usbtv->frame_id && chunk_no == USBTV_CHUNKS-1) {
+	if (odd && chunk_no == USBTV_CHUNKS-1) {
 		int size = vb2_plane_size(&buf->vb, 0);
 
 		buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
@@ -518,7 +532,7 @@ static int usbtv_queue_setup(struct vb2_queue *vq,
 	if (*nbuffers == 0)
 		*nbuffers = 2;
 	*nplanes = 1;
-	sizes[0] = USBTV_CHUNK * USBTV_CHUNKS * sizeof(u32);
+	sizes[0] = USBTV_WIDTH * USBTV_HEIGHT / 2 * sizeof(u32);
 
 	return 0;
 }
-- 
1.7.1

