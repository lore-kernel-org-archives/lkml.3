Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab3EFUqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:46:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757294Ab3EFUqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:46:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [ 028/115] usb: chipidea: udc: fix memory leak in _ep_nuke
Date: Mon,  6 May 2013 13:44:24 -0700
Message-Id: <20130506203058.457465082@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit 7ca2cd291fd84ae499390f227a255ccba2780a81 upstream.

In hardware_enqueue code adds one extra td with dma_pool_alloc if
mReq->req.zero is true. When _ep_nuke will be called for that endpoint,
dma_pool_free will not be called to free that memory again. That patch
fixes this.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/udc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -563,6 +563,12 @@ __acquires(mEp->lock)
 		struct ci13xxx_req *mReq = \
 			list_entry(mEp->qh.queue.next,
 				   struct ci13xxx_req, queue);
+
+		if (mReq->zptr) {
+			dma_pool_free(mEp->td_pool, mReq->zptr, mReq->zdma);
+			mReq->zptr = NULL;
+		}
+
 		list_del_init(&mReq->queue);
 		mReq->req.status = -ESHUTDOWN;
 


