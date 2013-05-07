Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241Ab3EGN7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:59:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42439 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933189Ab3EGNlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:51 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 077/118] usb: chipidea: udc: fix memory leak in _ep_nuke
Date: Tue,  7 May 2013 14:38:43 +0100
Message-Id: <1367933964-1564-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/chipidea/udc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index 60bcf1c..113b4f1 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -541,6 +541,12 @@ __acquires(mEp->lock)
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
 
-- 
1.8.1.2

