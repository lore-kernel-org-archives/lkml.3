Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbaJCXcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:32:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757373AbaJCWDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 3.16 327/357] media: vb2: fix vb2 state check when start_streaming fails
Date: Fri,  3 Oct 2014 14:31:53 -0700
Message-Id: <20141003212943.287825788@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hans.verkuil@cisco.com>

commit bf3593d939520559774cbfee03ba5f314d909620 upstream.

Commit bd994ddb2a12a3ff48cd549ec82cdceaea9614df (vb2: Fix stream start and
buffer completion race) broke the buffer state check in vb2_buffer_done.

So accept all three possible states there since I can no longer tell the
difference between vb2_buffer_done called from start_streaming or from
elsewhere.

Instead add a WARN_ON at the end of start_streaming that will check whether
any buffers were added to the done list, since that implies that the wrong
state was used as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/v4l2-core/videobuf2-core.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1161,13 +1161,10 @@ void vb2_buffer_done(struct vb2_buffer *
 	if (WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE))
 		return;
 
-	if (!q->start_streaming_called) {
-		if (WARN_ON(state != VB2_BUF_STATE_QUEUED))
-			state = VB2_BUF_STATE_QUEUED;
-	} else if (WARN_ON(state != VB2_BUF_STATE_DONE &&
-			   state != VB2_BUF_STATE_ERROR)) {
-			state = VB2_BUF_STATE_ERROR;
-	}
+	if (WARN_ON(state != VB2_BUF_STATE_DONE &&
+		    state != VB2_BUF_STATE_ERROR &&
+		    state != VB2_BUF_STATE_QUEUED))
+		state = VB2_BUF_STATE_ERROR;
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	/*
@@ -1774,6 +1771,12 @@ static int vb2_start_streaming(struct vb
 		/* Must be zero now */
 		WARN_ON(atomic_read(&q->owned_by_drv_count));
 	}
+	/*
+	 * If done_list is not empty, then start_streaming() didn't call
+	 * vb2_buffer_done(vb, VB2_BUF_STATE_QUEUED) but STATE_ERROR or
+	 * STATE_DONE.
+	 */
+	WARN_ON(!list_empty(&q->done_list));
 	return ret;
 }
 


