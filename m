Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab3EFUqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:46:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757452Ab3EFUqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:46:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [ 027/115] usb: chipidea: udc: fix memory access of shared memory on armv5 machines
Date: Mon,  6 May 2013 13:44:23 -0700
Message-Id: <20130506203058.365460009@linuxfoundation.org>
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

commit a9c174302b1590ef3ead485d804a303c5f89174b upstream.

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

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/udc.c |    2 ++
 drivers/usb/chipidea/udc.h |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -461,6 +461,8 @@ static int _hardware_enqueue(struct ci13
 		mReq->ptr->page[i] =
 			(mReq->req.dma + i * CI13XXX_PAGE_SIZE) & ~TD_RESERVED_MASK;
 
+	wmb();
+
 	if (!list_empty(&mEp->qh.queue)) {
 		struct ci13xxx_req *mReqPrev;
 		int n = hw_ep_bit(mEp->num, mEp->dir);
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


