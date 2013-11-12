Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab3KLPui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:50:38 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59807 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752556Ab3KLPug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:50:36 -0500
Date: Tue, 12 Nov 2013 10:50:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Cohen <david.a.cohen@linux.intel.com>
cc: Michal Nazarewicz <mina86@mina86.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 2/2] check quirk to pad epout buf size when not aligned
 to maxpacketsize
In-Reply-To: <5281595D.9030602@linux.intel.com>
Message-ID: <Pine.LNX.4.44L0.1311121046200.1200-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Nov 2013, David Cohen wrote:

> Hi Alan, Michal,
> 
> On 11/11/2013 01:09 PM, Michal Nazarewicz wrote:
> > On Mon, Nov 11 2013, Alan Stern wrote:
> >> On Mon, 11 Nov 2013, Michal Nazarewicz wrote:
> >>
> >>> Check gadget.quirk_ep_out_aligned_size to decide if buffer size requires
> >>> to be aligned to maxpacketsize of an out endpoint.  ffs_epfile_io() needs
> >>> to pad epout buffer to match above condition if quirk is found.
> >>>
> >>> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> >>
> >> I think this is still wrong.
> >>
> >>> @@ -824,7 +832,7 @@ static ssize_t ffs_epfile_io(struct file *file,
> >>>   		req->context  = &done;
> >>>   		req->complete = ffs_epfile_io_complete;
> >>>   		req->buf      = data;
> >>> -		req->length   = len;
> >>> +		req->length   = data_len;
> >>
> >> IIUC, req->length should still be set to len, not to data_len.
> 
> I misunderstood the first time I read it:
> In order to avoid DWC3 to stall, we need to update req->length (this is
> the most important fix). kmalloc() is updated too to prevent USB
> controller to overflow buffer boundaries.

Here I disagree.

If the DWC3 hardware stalls, it is up to the DWC3 UDC driver to fix it.  
Gadget drivers should not have to worry.  Most especially, gadget 
drivers should not lie about a request length.

If the UDC driver decides to round up req->length before sending it to
the hardware, that's okay.  But req->length should be set to len, not
data_len.  And if the hardware receives more than len bytes of data,
the UDC driver should set req->status to -EOVERFLOW.

Alan Stern

