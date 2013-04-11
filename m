Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936475Ab3DKVGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:06:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23956 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935698Ab3DKUtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:14 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=E784MlmosOIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=aCifndSud74A:10 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=U2SIHj-WA3ss6q3cvBoA:9 a=5KVauyKsRKMA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202603.852837968@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Soeren Moch <smoch@web.de>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 107/171 ] USB: EHCI: fix bug in iTD/siTD DMA pool allocation
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0107-USB-EHCI-fix-bug-in-iTD-siTD-DMA-pool-allocation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Soeren Moch <smoch@web.de>

[ Upstream commit 85ecd0322b9a1a9f451d9150e9460ab42fd17219 ]

[Description written by Alan Stern]

Soeren tracked down a very difficult bug in ehci-hcd's DMA pool
management of iTD and siTD structures.  Some background: ehci-hcd
gives each isochronous endpoint its own set of active and free itd's
(or sitd's for full-speed devices).  When a new itd is needed, it is
taken from the head of the free list, if possible.  However, itd's
must not be used twice in a single frame because the hardware
continues to access the data structure for the entire duration of a
frame.  Therefore if the itd at the head of the free list has its
"frame" member equal to the current value of ehci->now_frame, it
cannot be reused and instead a new itd is allocated from the DMA pool.
The entries on the free list are not released back to the pool until
the endpoint is no longer in use.

The bug arises from the fact that sometimes an itd can be moved back
onto the free list before itd->frame has been set properly.  In
Soeren's case, this happened because ehci-hcd can allocate one more
itd than it actually needs for an URB; the extra itd may or may not be
required depending on how the transfer aligns with a frame boundary.
For example, an URB with 8 isochronous packets will cause two itd's to
be allocated.  If the URB is scheduled to start in microframe 3 of
frame N then it will require both itds: one for microframes 3 - 7 of
frame N and one for microframes 0 - 2 of frame N+1.  But if the URB
had been scheduled to start in microframe 0 then it would require only
the first itd, which could cover microframes 0 - 7 of frame N.  The
second itd would be returned to the end of the free list.

The itd allocation routine initializes the entire structure to 0, so
the extra itd ends up on the free list with itd->frame set to 0
instead of a meaningful value.  After a while the itd reaches the head
of the list, and occasionally this happens when ehci->now_frame is
equal to 0.  Then, even though it would be okay to reuse this itd, the
driver thinks it must get another itd from the DMA pool.

For as long as the isochronous endpoint remains in use, this flaw in
the mechanism causes more and more itd's to be taken slowly from the
DMA pool.  Since none are released back, the pool eventually becomes
exhausted.

This reuslts in memory allocation failures, which typically show up
during a long-running audio stream.  Video might suffer the same
effect.

The fix is very simple.  To prevent allocations from the pool when
they aren't needed, make sure that itd's sent back to the free list
prematurely have itd->frame set to an invalid value which can never be
equal to ehci->now_frame.

This should be applied to -stable kernels going back to 3.6.

Signed-off-by: Soeren Moch <smoch@web.de>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/host/ehci-sched.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index 528a540..56a1907 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1237,6 +1237,7 @@ itd_urb_transaction (
 
 		memset (itd, 0, sizeof *itd);
 		itd->itd_dma = itd_dma;
+		itd->frame = 9999;		/* an invalid value */
 		list_add (&itd->itd_list, &sched->td_list);
 	}
 	spin_unlock_irqrestore (&ehci->lock, flags);
@@ -1931,6 +1932,7 @@ sitd_urb_transaction (
 
 		memset (sitd, 0, sizeof *sitd);
 		sitd->sitd_dma = sitd_dma;
+		sitd->frame = 9999;		/* an invalid value */
 		list_add (&sitd->sitd_list, &iso_sched->td_list);
 	}
 
-- 
1.7.10.4


