Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934091AbbA1CMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:12:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbbA1B2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 3.18 26/61] [media] vb2: fix vb2_thread_stop race conditions
Date: Tue, 27 Jan 2015 17:26:38 -0800
Message-Id: <20150128012639.863011842@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hans.verkuil@cisco.com>

commit 6cf11ee6300f38b7cfc43af9b7be2afaa5e05869 upstream.

The locking scheme inside the vb2 thread is unsafe when stopping the
thread. In particular kthread_stop was called *after* internal data
structures were cleaned up instead of doing that before. In addition,
internal vb2 functions were called after threadio->stop was set to
true and vb2_internal_streamoff was called. This is also not allowed.

All this led to a variety of race conditions and kernel warnings and/or
oopses.

Fixed by moving the kthread_stop call up before the cleanup takes
place, and by checking threadio->stop before calling internal vb2
queuing operations.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/v4l2-core/videobuf2-core.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -3142,27 +3142,26 @@ static int vb2_thread(void *data)
 			prequeue--;
 		} else {
 			call_void_qop(q, wait_finish, q);
-			ret = vb2_internal_dqbuf(q, &fileio->b, 0);
+			if (!threadio->stop)
+				ret = vb2_internal_dqbuf(q, &fileio->b, 0);
 			call_void_qop(q, wait_prepare, q);
 			dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
 		}
-		if (threadio->stop)
-			break;
-		if (ret)
+		if (ret || threadio->stop)
 			break;
 		try_to_freeze();
 
 		vb = q->bufs[fileio->b.index];
 		if (!(fileio->b.flags & V4L2_BUF_FLAG_ERROR))
-			ret = threadio->fnc(vb, threadio->priv);
-		if (ret)
-			break;
+			if (threadio->fnc(vb, threadio->priv))
+				break;
 		call_void_qop(q, wait_finish, q);
 		if (set_timestamp)
 			v4l2_get_timestamp(&fileio->b.timestamp);
-		ret = vb2_internal_qbuf(q, &fileio->b);
+		if (!threadio->stop)
+			ret = vb2_internal_qbuf(q, &fileio->b);
 		call_void_qop(q, wait_prepare, q);
-		if (ret)
+		if (ret || threadio->stop)
 			break;
 	}
 
@@ -3231,11 +3230,11 @@ int vb2_thread_stop(struct vb2_queue *q)
 	threadio->stop = true;
 	vb2_internal_streamoff(q, q->type);
 	call_void_qop(q, wait_prepare, q);
+	err = kthread_stop(threadio->thread);
 	q->fileio = NULL;
 	fileio->req.count = 0;
 	vb2_reqbufs(q, &fileio->req);
 	kfree(fileio);
-	err = kthread_stop(threadio->thread);
 	threadio->thread = NULL;
 	kfree(threadio);
 	q->fileio = NULL;


