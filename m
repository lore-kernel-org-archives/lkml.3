Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab3JQOaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:30:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47532 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755999Ab3JQOae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:30:34 -0400
Date: Thu, 17 Oct 2013 10:30:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Gerd Hoffmann <kraxel@redhat.com>, Hans de Goede <hdegoede@redhat.com>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2] xhci: fix usb3 streams
In-Reply-To: <20131016234314.GJ7082@xanatos>
Message-ID: <Pine.LNX.4.44L0.1310171025580.1303-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013, Sarah Sharp wrote:

> > > xhci maintains a radix tree for each stream endpoint because it must
> > > be able to map a trb address to the stream ring.  Each ring segment
> > > must be added to the ring for this to work.  Currently xhci sticks
> > > only the first segment of each stream ring into the radix tree.

> > There may be a simpler approach to this problem.
> > 
> > When using a new ring segment, keep the first TRB entry in reserve.  
> > Don't put a normal TRB in there, instead leave it as a no-op entry
> > containing a pointer to the stream ring.  (Make the prior Link TRB
> > point to the second entry in the new segment instead of the first.)
> > 
> > Then you won't have to add to or remove anything from the radix tree.
> 
> I don't understand how this would help.  Are you advocating a different
> way of mapping TRB DMA addresses to stream rings that would allow us to
> ditch the radix tree all together?
> 
> Ok, so with your solution, we have a virtual stream ring pointer as the
> first TRB of the segment.  We get an event with the DMA address of a TRB
> in one of many stream rings on an endpoint.  From that, I think we can
> infer the DMA address of the first TRB on the segment, due to the
> alignment requirements and ring size.
> 
> And then what do we do with that?  We don't have the virtual address of
> that first TRB, so the xHCI driver can't read the ring pointer from it.
> I'm confused as to what the next steps would be to solve this.

My mistake; I misunderstood the original description of the problem.  
I didn't realize that "map a trb address" referred to the TRB's DMA
address.

BTW, ohci-hcd faces the same problem (of mapping DMA addresses to
kernel addresses).  It solves the problem with a hash table rather than
a radix tree.

Alan Stern

