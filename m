Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab3JDNuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:50:08 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:61380 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab3JDNuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:50:05 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] vb2: Allow STREAMOFF for io emulator
Date: Fri,  4 Oct 2013 15:49:58 +0200
Message-Id: <1380894598-11242-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A video device opened and streaming in io emulator mode can only stop
streamming if its file descriptor is closed.

There are some parameters that can only be changed if the device is not
streaming. Also, the power consumption of a device streaming could be
different than one not streaming.

With this patch a video device opened in io emulator can be stopped on
demand.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 9fc4bab..097fba8 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1686,6 +1686,7 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 }
 EXPORT_SYMBOL_GPL(vb2_streamon);
 
+static int __vb2_cleanup_fileio(struct vb2_queue *q);
 
 /**
  * vb2_streamoff - stop streaming
@@ -1704,11 +1705,6 @@ EXPORT_SYMBOL_GPL(vb2_streamon);
  */
 int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 {
-	if (q->fileio) {
-		dprintk(1, "streamoff: file io in progress\n");
-		return -EBUSY;
-	}
-
 	if (type != q->type) {
 		dprintk(1, "streamoff: invalid stream type\n");
 		return -EINVAL;
@@ -1719,6 +1715,11 @@ int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
 		return -EINVAL;
 	}
 
+	if (q->fileio) {
+		__vb2_cleanup_fileio(q);
+		return 0;
+	}
+
 	/*
 	 * Cancel will pause streaming and remove all buffers from the driver
 	 * and videobuf, effectively returning control over them to userspace.
-- 
1.8.4.rc3

