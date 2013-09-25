Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab3IYAmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:42:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab3IYAUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Grzeschik <mgr@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 042/117] usb: gadget: uvc: Fix error handling in uvc_queue_buffer()
Date: Tue, 24 Sep 2013 17:18:28 -0700
Message-Id: <20130925001745.436414715@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit ebe864a6cb8e087ede047fa1fa6b6d06fcb9a9e4 upstream.

The conversion to videobuf2 failed to check the return value of
vb2_qbuf(). Fix it.

Reported-by: Michael Grzeschik <mgr@pengutronix.de>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-By: Michael Grzeschik <mgr@pengutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/uvc_queue.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/uvc_queue.c
+++ b/drivers/usb/gadget/uvc_queue.c
@@ -193,12 +193,16 @@ static int uvc_queue_buffer(struct uvc_v
 
 	mutex_lock(&queue->mutex);
 	ret = vb2_qbuf(&queue->queue, buf);
+	if (ret < 0)
+		goto done;
+
 	spin_lock_irqsave(&queue->irqlock, flags);
 	ret = (queue->flags & UVC_QUEUE_PAUSED) != 0;
 	queue->flags &= ~UVC_QUEUE_PAUSED;
 	spin_unlock_irqrestore(&queue->irqlock, flags);
-	mutex_unlock(&queue->mutex);
 
+done:
+	mutex_unlock(&queue->mutex);
 	return ret;
 }
 


