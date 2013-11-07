Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab3KGQFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 11:05:20 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40440 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751483Ab3KGQFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 11:05:16 -0500
Date: Thu, 7 Nov 2013 11:05:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mina86@mina86.com>
cc: David Cohen <david.a.cohen@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/4] usb: ffs: check quirk to pad epout buf size when
 not aligned to maxpacketsize
In-Reply-To: <xa1t1u2t1icl.fsf@mina86.com>
Message-ID: <Pine.LNX.4.44L0.1311071053430.1401-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013, Michal Nazarewicz wrote:

> On Tue, Nov 05 2013, Alan Stern wrote:
> > Maybe Michal can enlighten us.
> 
> Sorry for late response, this thread fell under my radar for some
> reason.
> 
> So here's how it works:
> 
> epfile represents an end point file on the fuctionfs file system,
> i.e. what user space is seeing.  It's numbering is independent of which
> USB configuration is chosen.
> 
> A FunctionFS user space daemon may read/write to those files regardless
> of whether the function is enabled.  If it is not, the operation will
> block until host enables the function.

What happens if the userspace daemon writes to epfile but the host 
changes the config or altsetting before all the data can be sent?  Does 
the remaining data get flushed?

Similarly, what happens if the config or altsetting changes before a 
read of epfile completes?  Does the read get terminated?

> epfile->ep represents an actual USB end point, and it's number does not
> have to correspond to the epfile file name, and may be different in
> different configuration.  FunctionFS hides all that from the user space
> daemon.
> 
> epfile->ep is set when host changes configuration (i.e. function's
> set_alt or disable callbacks).  IIRC this implies that epfile->ep cannot
> be protected by a mutex, and therefore is protected by a spinlock.
> 
> Since it is protected by a spinlock, the ffs_epfile_io function cannot
> lock it and then proceed to allocating memory and copying data from user
> space.  That's why there is the need for the loop since there is no way
> to guarantee that while the memory was allocated and data was read from
> user space (if it is a write), the function has not been disabled and
> re-enabled.

I'm still a little unclear on this.  Disabling the function ought to
have much the same effect as changing the config or altsetting: Writes
to endpoint files should be flushed and reads should be terminated.  
Otherwise you would end up sending stale data to the host or reading 
data that the daemon isn't prepared for.

Given that, there doesn't seem to be any need for a loop.  Copy the 
data; if the function was disabled in the meantime then throw away the 
data and return an appropriate error code.

I don't see any reason why you should ever have to copy the same data 
from userspace multiple times.

> However, I'm not sure whether maxpacketsize can change.  It is part of
> endpoint's descriptor and even though the endpoint number can change
> while ffs_epfile_io is running, all the other descriptor fields should
> stay the same.

If the config or altsetting can change then the maxpacket size can 
change too.  However, the reasoning above indicates that this should be 
moot.

Alan Stern

