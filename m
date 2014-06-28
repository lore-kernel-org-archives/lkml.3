Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbaF1Snu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:43:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbaF1Rt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:49:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.14 065/110] media: saa7134: fix regression with tvtime
Date: Sat, 28 Jun 2014 10:47:02 -0700
Message-Id: <20140628174549.474027667@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hans.verkuil@cisco.com>

commit 17e7f1b515803e1a79b246688aacbddd2e34165d upstream.

This solves this bug:

https://bugzilla.kernel.org/show_bug.cgi?id=73361

The problem is that when you quit tvtime it calls STREAMOFF, but then it queues a
bunch of buffers for no good reason before closing the file descriptor.

In the past closing the fd would free the vb queue since that was part of the file
handle struct. Since that was moved to the global struct that no longer happened.

This wouldn't be a problem, but the extra QBUF calls that tvtime does meant that
the buffer list in videobuf (q->stream) contained buffers, so REQBUFS would fail
with -EBUSY.

The solution is to init the list head explicitly when releasing the file
descriptor and to not free the video resource when calling streamoff.

The real fix will hopefully go into kernel 3.16 when the vb2 conversion is
merged. Basically the saa7134 driver with the old videobuf is so full of holes it
ain't funny anymore, so consider this a band-aid for kernels 3.14 and 15.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/pci/saa7134/saa7134-video.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1243,6 +1243,7 @@ static int video_release(struct file *fi
 		videobuf_streamoff(&dev->cap);
 		res_free(dev, fh, RESOURCE_VIDEO);
 		videobuf_mmap_free(&dev->cap);
+		INIT_LIST_HEAD(&dev->cap.stream);
 	}
 	if (dev->cap.read_buf) {
 		buffer_release(&dev->cap, dev->cap.read_buf);
@@ -1254,6 +1255,7 @@ static int video_release(struct file *fi
 		videobuf_stop(&dev->vbi);
 		res_free(dev, fh, RESOURCE_VBI);
 		videobuf_mmap_free(&dev->vbi);
+		INIT_LIST_HEAD(&dev->vbi.stream);
 	}
 
 	/* ts-capture will not work in planar mode, so turn it off Hac: 04.05*/
@@ -1987,17 +1989,12 @@ int saa7134_streamoff(struct file *file,
 					enum v4l2_buf_type type)
 {
 	struct saa7134_dev *dev = video_drvdata(file);
-	int err;
 	int res = saa7134_resource(file);
 
 	if (res != RESOURCE_EMPRESS)
 		pm_qos_remove_request(&dev->qos_request);
 
-	err = videobuf_streamoff(saa7134_queue(file));
-	if (err < 0)
-		return err;
-	res_free(dev, priv, res);
-	return 0;
+	return videobuf_streamoff(saa7134_queue(file));
 }
 EXPORT_SYMBOL_GPL(saa7134_streamoff);
 


