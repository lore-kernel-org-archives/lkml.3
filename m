Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaARUXc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 15:23:32 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60035 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaARUXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 15:23:30 -0500
Message-ID: <52DAE2BF.7020208@gmail.com>
Date: Sat, 18 Jan 2014 12:23:27 -0800
From: walt <w41ter@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst [NEW HARDWARE]
References: <20140109235045.GA17660@xanatos> <52D4791B.3030309@gmail.com> <20140114172056.GB12126@xanatos> <52D5ABBD.7090202@gmail.com> <063D6719AE5E284EB5DD2968C1650D6D45EDA3@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D45EDA3@AcuExch.aculab.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 06:34 AM, David Laight wrote:

> Can you try the patch I posted that stops the ownership on LINK TRBs
> being changed before that on the linked-to TRB?

Please disregard my earlier post about the patch not applying cleanly.
That was the usual html corruption, so I found the original on the usb
list and it was okay.

Sadly, the patch didn't fix the ASMedia lockup behavior, however :(

I did notice that the lockup occurred only when copying *to* the usb3
drive, and not when copying from it.  I think that may be new behavior
but I can't swear to it.

Just to confirm, here are the first few lines of the patch I used.
Please let me know if it's the wrong patch:


diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 53c2e29..589d336 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2928,6 +2928,11 @@ static void queue_trb(struct xhci_hcd *xhci, struct xhci_ring *ring,
        struct xhci_generic_trb *trb;
 
        trb = &amp;ring-&gt;enqueue-&gt;generic;
+
+       field4 = (field4 &amp; ~TRB_CYCLE) | ring-&gt;cycle_state;
+       if (trb == &amp;ring-&gt;enqueue_first-&gt;generic)
+               field4 ^= TRB_CYCLE;
+
        trb-&gt;field[0] = cpu_to_le32(field1);

        <big snip>
