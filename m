Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbaGBTm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:42:26 -0400
Received: from foo.stuge.se ([212.116.89.98]:45431 "EHLO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756736AbaGBTmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:42:24 -0400
Message-ID: <20140702194222.11771.qmail@stuge.se>
Date: Wed, 2 Jul 2014 21:42:22 +0200
From: Peter Stuge <peter@stuge.se>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stefan Klug <stefan.klug@baslerweb.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] USB: zerocopy support for usbfs
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Stefan Klug <stefan.klug@baslerweb.com>, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20140702184933.7464.qmail@stuge.se> <Pine.LNX.4.44L0.1407021457320.874-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1407021457320.874-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> > > Also, many host controllers cannot handle arbitrary alignment.  
> > > It would be best to require that the buffer start at a page boundary.
> > 
> > This requires a bit of negotiation with userspace, maybe per-URB but
> 
> I don't follow.  What negotiation is needed?  All that needs to happen 
> is the user program submits a transfer where the buffer is aligned on a 
> page boundary.

The negotiation needed would be for userspace to learn what alignment
is required, so that it can make sure to provide only such buffers.
But see below on mmap..


> > it seems better to negotiate per-claim or even per-open. What about
> > large control transfers?
> 
> The kernel doesn't support scatter-gather for control transfers, only 
> bulk.

That could possibly change, right, and then it would be nice to have
zerocopy for free there as well?


> > It's important that the kernel gives userspace enough information
> > about the constraints, if userspace wants zerocopy.
> 
> I don't know of any way for the kernel to give userspace any
> information about constraints of this sort.  Do you?

I don't know of any at the moment, no. It might be done through an
ioctl into usbfs, but if sysfs already has all neccessary information
then no ioctl is needed. Anyway...


> > Indeed I think userspace wants to be involved in choosing memory also
> > with bulk, in order to ensure that zerocopy will always work when
> > userspace cares about that.
> > 
> > Is it enough to expose the DMA mask of the host controller?
> 
> It doesn't need to be exposed, since the mmap(2) call would be handled
> by the kernel's USB stack (and besides, the user program can't request
> that the mapped memory be located in any particular physical address
> region).

Since alignment isn't the only issue I don't think there's a way to
avoid it. I was just hoping to be able to avoid allocating zerocopy
buffers with mmap().


> Furthermore, the DMA mask already is exposed in sysfs.
> For example, the DMA mask for the host controller on bus 2 is
> given in /sys/bus/usb/devices/usb2/../dma_mask_bits.

I realize that this doesn't help much, since userspace can't get the
physical address for its virtual addresses anyway.


//Peter
