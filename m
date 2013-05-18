Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab3ERCQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:16:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31662 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab3ERCQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:48 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Qvnonan1qIIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=SdPBcy1wnQwA:10 a=VwQbUJbxAAAA:8 a=sozttTNsAAAA:8 a=QyXUC8HyAAAA:8 a=ag1SF4gXAAAA:8 a=ZN6Tve_4AAAA:8 a=6KUtQZpEXG406qUnFdAA:9 a=XNN-oNMjSfgA:10 a=x2szoZtqnggA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=aHwB7QAmzZcA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021644.493202724@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 017/136 ] usb: chipidea: udc: fix memory access of shared memory on armv5
 machines
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0017-usb-chipidea-udc-fix-memory-access-of-shared-memory-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit a9c174302b1590ef3ead485d804a303c5f89174b ]

The udc uses an shared dma memory space between hard and software. This
memory layout is described in ci13xxx_qh and ci13xxx_td which are marked
with the attribute ((packed)).

The compiler currently does not know about the alignment of the memory
layout, and will create strb and ldrb operations.

The Datasheet of the synopsys core describes, that some operations on
the mapped memory need to be atomic double word operations. I.e. the
next pointer addressing in the qhead, as otherwise the hardware will
read wrong data and totally stuck.

This is also possible while working with the current active td queue,
and preparing the td->ptr.next in software while the hardware is still
working with the current active td which is supposed to be changed:

writeb(0xde, &td->ptr.next + 0x0); /* strb */
writeb(0xad, &td->ptr.next + 0x1); /* strb */

<----- hardware reads value of td->ptr.next and get stuck!

writeb(0xbe, &td->ptr.next + 0x2); /* strb */
writeb(0xef, &td->ptr.next + 0x3); /* strb */

This appeares on armv5 machines where the hardware does not support
unaligned 32bit operations.

This patch adds the attribute ((aligned(4))) to the structures to tell
the compiler to use 32bit operations. It also adds an wmb() for the
prepared TD data before it gets enqueued into the qhead.

Cc: stable <stable@vger.kernel.org> # v3.5
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/chipidea/udc.c |    2 ++
 drivers/usb/chipidea/udc.h |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index d214448..e0315f9 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -439,6 +439,8 @@ static int _hardware_enqueue(struct ci13xxx_ep *mEp, struct ci13xxx_req *mReq)
 		mReq->ptr->page[i] =
 			(mReq->req.dma + i * CI13XXX_PAGE_SIZE) & ~TD_RESERVED_MASK;
 
+	wmb();
+
 	if (!list_empty(&mEp->qh.queue)) {
 		struct ci13xxx_req *mReqPrev;
 		int n = hw_ep_bit(mEp->num, mEp->dir);
diff --git a/drivers/usb/chipidea/udc.h b/drivers/usb/chipidea/udc.h
index 4ff2384d..d12e8b5 100644
--- a/drivers/usb/chipidea/udc.h
+++ b/drivers/usb/chipidea/udc.h
@@ -40,7 +40,7 @@ struct ci13xxx_td {
 #define TD_CURR_OFFSET        (0x0FFFUL <<  0)
 #define TD_FRAME_NUM          (0x07FFUL <<  0)
 #define TD_RESERVED_MASK      (0x0FFFUL <<  0)
-} __attribute__ ((packed));
+} __attribute__ ((packed, aligned(4)));
 
 /* DMA layout of queue heads */
 struct ci13xxx_qh {
@@ -57,7 +57,7 @@ struct ci13xxx_qh {
 	/* 9 */
 	u32 RESERVED;
 	struct usb_ctrlrequest   setup;
-} __attribute__ ((packed));
+} __attribute__ ((packed, aligned(4)));
 
 /**
  * struct ci13xxx_req - usb request representation
-- 
1.7.10.4


