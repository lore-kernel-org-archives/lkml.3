Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbaIOT0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:26:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbaIOT0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.16 009/158] media: v4l: vb2: Fix stream start and buffer completion race
Date: Mon, 15 Sep 2014 12:24:08 -0700
Message-Id: <20140915192543.157766974@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

commit bd994ddb2a12a3ff48cd549ec82cdceaea9614df upstream.

videobuf2 stores the driver streaming state internally in the queue in
the start_streaming_called variable. The state is set right after the
driver start_stream operation returns, and checked in the
vb2_buffer_done() function, typically called from the frame completion
interrupt handler. A race condition exists if the hardware finishes
processing the first frame before the start_stream operation returns.

Fix this by setting start_streaming_called to 1 before calling the
start_stream operation, and resetting it to 0 if the operation fails.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/v4l2-core/videobuf2-core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1750,12 +1750,14 @@ static int vb2_start_streaming(struct vb
 		__enqueue_in_driver(vb);
 
 	/* Tell the driver to start streaming */
+	q->start_streaming_called = 1;
 	ret = call_qop(q, start_streaming, q,
 		       atomic_read(&q->owned_by_drv_count));
-	q->start_streaming_called = ret == 0;
 	if (!ret)
 		return 0;
 
+	q->start_streaming_called = 0;
+
 	dprintk(1, "driver refused to start streaming\n");
 	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
 		unsigned i;


