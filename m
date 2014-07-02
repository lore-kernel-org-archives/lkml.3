Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbaGBTb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:31:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49797 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754609AbaGBTb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:31:56 -0400
Date: Wed, 2 Jul 2014 15:31:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Stuge <peter@stuge.se>
cc: Stefan Klug <stefan.klug@baslerweb.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] USB: zerocopy support for usbfs
In-Reply-To: <20140702184933.7464.qmail@stuge.se>
Message-ID: <Pine.LNX.4.44L0.1407021457320.874-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2014, Peter Stuge wrote:

> Thank you very much for working on this, Stefan.
> 
> Alan Stern wrote:
> > Also, many host controllers cannot handle arbitrary alignment.  
> > It would be best to require that the buffer start at a page boundary.
> 
> This requires a bit of negotiation with userspace, maybe per-URB but

I don't follow.  What negotiation is needed?  All that needs to happen 
is the user program submits a transfer where the buffer is aligned on a 
page boundary.

> it seems better to negotiate per-claim or even per-open. What about
> large control transfers?

The kernel doesn't support scatter-gather for control transfers, only 
bulk.

> > If you think people will have a reason for avoiding zerocopy then
> > you should make it possible to decide for each URB, by adding a new
> > flag to struct usbdevfs_urb.
> 
> People might want to use zerocopy always, but have buffers in
> userspace which make that impossible with the given hardware.
> 
> It's important that the kernel gives userspace enough information
> about the constraints, if userspace wants zerocopy.

I don't know of any way for the kernel to give userspace any
information about constraints of this sort.  Do you?  For example, the
man page for open(2) says: "The O_DIRECT flag may impose alignment
restrictions on the length and address of user-space buffers and the
file offset of I/Os", but it doesn't say how to find out what those
restrictions are.

> > People will want to use zerocopy with isochronous transfers as well as 
> > bulk.  Implementing that isn't going to be quite so easy; it will be 
> > necessary for the user to set up a memory mapping.  In fact, once 
> > that's done the same mechanism could be used for bulk transfers too.
> 
> Indeed I think userspace wants to be involved in choosing memory also
> with bulk, in order to ensure that zerocopy will always work when
> userspace cares about that.
> 
> Is it enough to expose the DMA mask of the host controller?

It doesn't need to be exposed, since the mmap(2) call would be handled
by the kernel's USB stack (and besides, the user program can't request
that the mapped memory be located in any particular physical address
region).

Furthermore, the DMA mask already is exposed in sysfs.  For example,
the DMA mask for the host controller on bus 2 is given in
/sys/bus/usb/devices/usb2/../dma_mask_bits.

Alan Stern

