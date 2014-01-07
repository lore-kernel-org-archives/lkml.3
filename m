Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbaAGVVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 16:21:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:19369 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105AbaAGVVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 16:21:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,620,1384329600"; 
   d="scan'208,223";a="435322239"
Date: Tue, 7 Jan 2014 13:21:01 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: walt <w41ter@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        David Laight <david.laight@aculab.com>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within a
 USB payload burst
Message-ID: <20140107212101.GA4199@xanatos>
References: <20131218211219.461663463@linuxfoundation.org>
 <20131218211220.412278148@linuxfoundation.org>
 <52C32BB0.90600@gmail.com>
 <20140102191510.GA9621@xanatos>
 <52C6D9F1.9000709@gmail.com>
 <20140103195455.GA4193@xanatos>
 <52C729CE.9050307@gmail.com>
 <20140103232929.GD4193@xanatos>
 <20140107003157.GA7963@xanatos>
 <52CC014C.5060604@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <52CC014C.5060604@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 07, 2014 at 05:29:48AM -0800, walt wrote:
> On 01/06/2014 04:31 PM, Sarah Sharp wrote:
> > Hi Walt,
> > 
> > I have a couple of patches for you to test.
> 
> > Please only apply the first patch (which is diagnostic only), trigger
> > your issue, and send me the resulting dmesg.  Then try applying the
> > other two patches, and see if the issue goes away.  (I suspect it won't
> > but I can't be sure.)
> 
> Thanks Sarah.  dmesg0 is from the diagnostic patch only.  dmesg1 has all
> three patches applied.  Some of the messages in dmesg1 fell off the end of
> the kernel buffer, so I may need to make the buffer larger next time but
> I'll need a reminder of how to do it.

Set CONFIG_LOG_BUF_SHIFT to 21.

> As you suspected, the patches didn't fix the problem, sorry.

Yep, I thought so.  I did glean one bit of information from the logs: it
seems that your host does handle no-op TRBs, at least for a while.
However, after a bigger chunk of TRBs, it goes off into la-la-land.

Assuming one of the rings is comprised of two segments:
0xbb711000 (start)
0xbb7113f0 (end)
0xbb711400 (start)
0xbb7117f0 (end)

The log show no-ops were inserted at:
0xbb7207d0
0xbb7206a0
0xbb720be0
0xbb720be0
0xbb720bd0
0xbb7207e0
0xbb711370 = 8 no-ops
0xbb7117c0 = 3
0xbb7113b0 = 4
0xbb7113a0 = 5
0xbb7117d0 = 2
0xbb711340 = 11
0xbb711770 = 8
0xbb711230 = 28
0xbb7117e0 = 1
0xbb7117b0 = 4
0xbb7113d0 = 2
0xbb7117b0 = 4
0xbb711340 = 11
0xbb711690 = 22

So the host was able to process 28 no-op TRBs, but failed on 22 no-ops
later.  The event ring debugging shows the last event was for
0xbb711680, which is the last TRB before the first no-op inserted before
the host died.  There's no Stop Endpoint Command completion, and it
looks like the command was correctly put on the command ring, so it
seems the host is actually hanging for some reason.

Unfortunately, I made a mistake in the debugging patch I sent
you, so it didn't print out the endpoint rings when the host died.  I
need that info, to see whether the link TRB was still intact, or if we
over-wrote it and caused the host to go fetch some invalid memory.

Can you please try the attached patch, on top of the previous three
patches, and send me dmesg?

> I find that I can tell in advance whether the copy is going to succeed,
> just by watching the light flicker on the usb3 drive.  When the flicker
> is absolutely regular, with no variation whatever, I can tell in 10 or
> 15 seconds that the copy will fail.
> 
> At the same time the light on the main drive goes dark after 10 seconds,
> implying that the usb3 drive stops receiving any data from the main drive
> after 10 seconds, yet the light on the usb3 drive continues to flicker as
> if writing data -- even after the cp officially fails.  The light on the
> usb3 drive never stops flickering until I reboot the machine or unplug
> the usb cable.

Interesting.  Without a USB analyzer, we can't really tell what's
happening.  However, one hypothesis could be that the blinking light is
triggered by an active SCSI command (read/write, etc).

There are three phases of the command: setup, data, and status.  I think
your device is getting the setup phase, and the host is dying before it
sends the data phase.  If the light blinks when it gets a setup phase,
and turns off when the devices sends a status phase, that would explain
its behavior.

But that's just a hypothesis, I have no idea whether it's correct.

Sarah Sharp

--TB36FDmn/VVEgNH/
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-More-debugging.patch"

>From d085fb5b9630e935d7954fe5947b48402e43bdc1 Mon Sep 17 00:00:00 2001
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Date: Tue, 7 Jan 2014 12:39:47 -0800
Subject: [PATCH] More debugging.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---
 drivers/usb/host/xhci-ring.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 2afaf15009e8..228ab8cf868e 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -993,6 +993,9 @@ void xhci_stop_endpoint_command_watchdog(unsigned long arg)
 	for (i = 0; i < MAX_HC_SLOTS; i++) {
 		if (!xhci->devs[i])
 			continue;
+
+		xhci_dbg(xhci, "Slot %d output context\n", i);
+		xhci_dbg_ctx(xhci, xhci->devs[i]->out_ctx, 30);
 		for (j = 0; j < 31; j++) {
 			temp_ep = &xhci->devs[i]->eps[j];
 			ring = temp_ep->ring;
@@ -1001,6 +1004,10 @@ void xhci_stop_endpoint_command_watchdog(unsigned long arg)
 			xhci_dbg_trace(xhci, trace_xhci_dbg_cancel_urb,
 					"Killing URBs for slot ID %u, "
 					"ep index %u", i, j);
+			xhci_dbg(xhci, "Dev %i Ep 0x%x:\n", i,
+					xhci_get_endpoint_address(j));
+			xhci_debug_ring(xhci, ring);
+			xhci_dbg_ring_ptrs(xhci, ring);
 			while (!list_empty(&ring->td_list)) {
 				cur_td = list_first_entry(&ring->td_list,
 						struct xhci_td,
@@ -1011,12 +1018,6 @@ void xhci_stop_endpoint_command_watchdog(unsigned long arg)
 				xhci_giveback_urb_in_irq(xhci, cur_td,
 						-ESHUTDOWN, "killed");
 			}
-			if (!list_empty(&temp_ep->cancelled_td_list)) {
-				xhci_dbg(xhci, "Dev %i Ep 0x%x:\n", i,
-						xhci_get_endpoint_address(j));
-				xhci_debug_ring(xhci, ring);
-				xhci_dbg_ring_ptrs(xhci, ring);
-			}
 			while (!list_empty(&temp_ep->cancelled_td_list)) {
 				cur_td = list_first_entry(
 						&temp_ep->cancelled_td_list,
@@ -2980,10 +2981,10 @@ static int prepare_ring(struct xhci_hcd *xhci, struct xhci_ring *ep_ring,
 						num_trbs, TRBS_PER_SEGMENT - 1);
 				return -EINVAL;
 			}
-			xhci_dbg(xhci, "Insert no-op TRBs at 0x%llx\n",
-					(unsigned long long)
+			xhci_dbg(xhci, "Insert %i no-op TRBs from 0x%llx for TD with %i TRBs\n",
+					usable, (unsigned long long)
 					xhci_trb_virt_to_dma(ep_ring->enq_seg,
-						ep_ring->enqueue));
+						ep_ring->enqueue), num_trbs);
 
 			nop_cmd = cpu_to_le32(TRB_TYPE(TRB_TR_NOOP) |
 					ep_ring->cycle_state);
-- 
1.8.3.3


--TB36FDmn/VVEgNH/--
