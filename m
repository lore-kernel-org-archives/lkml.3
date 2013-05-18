Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab3ERC1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:27:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4820 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab3ERCQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:50 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=vLP5C46XyEkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=N_OEv__elwEA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=ag1SF4gXAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=XNN-oNMjSfgA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021644.646081473@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 018/136 ] usb: chipidea: udc: fix memory leak in _ep_nuke
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0018-usb-chipidea-udc-fix-memory-leak-in-_ep_nuke.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit 7ca2cd291fd84ae499390f227a255ccba2780a81 ]

In hardware_enqueue code adds one extra td with dma_pool_alloc if
mReq->req.zero is true. When _ep_nuke will be called for that endpoint,
dma_pool_free will not be called to free that memory again. That patch
fixes this.

Cc: stable <stable@vger.kernel.org> # v3.5
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/chipidea/udc.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index e0315f9..d5172fa 100644
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
1.7.10.4


