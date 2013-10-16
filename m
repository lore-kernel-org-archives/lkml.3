Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434Ab3JPXnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 19:43:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:14180 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052Ab3JPXnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 19:43:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,509,1378882800"; 
   d="scan'208";a="420295492"
Date: Wed, 16 Oct 2013 16:43:14 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Gerd Hoffmann <kraxel@redhat.com>, Hans de Goede <hdegoede@redhat.com>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2] xhci: fix usb3 streams
Message-ID: <20131016234314.GJ7082@xanatos>
References: <20131015015424.GA5032@xanatos>
 <Pine.LNX.4.44L0.1310151049130.1377-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1310151049130.1377-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 10:53:57AM -0400, Alan Stern wrote:
> On Mon, 14 Oct 2013, Gerd Hoffmann wrote:
> 
> > Gerd, Hans, any objections to this updated patch?  The warning is fixed
> > with it.
> > 
> > The patch probably still needs to address the case where the ring
> > expansion fails because we can't insert the new segments into the radix
> > tree.  The patch should probably allocate the segments, attempt to add
> > them to the radix tree, and fail without modifying the link TRBs of the
> > ring.  I'd have to look more deeply into the code to see what exactly
> > should be done there.
> > 
> > I would like that issue fixed before I merge these patches, so if you
> > want to take a stab at fixing it, please do.
> > 
> > Sarah Sharp
> 
> Sarah, how did you manage to send an email with the "From:" line set to 
> Gerd's name and address?

I sent it using git format-patch and mutt, and accidentally left Gerd's
>From line intact.  Looking at the headers, it seems like the default
Intel exchange servers simply passed the email through.  Header forging,
what fun!

> > 8<---------------------------------------------------------------->8
> > 
> > xhci maintains a radix tree for each stream endpoint because it must
> > be able to map a trb address to the stream ring.  Each ring segment
> > must be added to the ring for this to work.  Currently xhci sticks
> > only the first segment of each stream ring into the radix tree.
> > 
> > Result is that things work initially, but as soon as the first segment
> > is full xhci can't map the trb address from the completion event to the
> > stream ring any more -> BOOM.  You'll find this message in the logs:
> > 
> >   ERROR Transfer event for disabled endpoint or incorrect stream ring
> > 
> > This patch adds a helper function to update the radix tree, and a
> > function to remove ring segments from the tree.  Both functions loop
> > over the segment list and handles all segments instead of just the
> > first.
> 
> There may be a simpler approach to this problem.
> 
> When using a new ring segment, keep the first TRB entry in reserve.  
> Don't put a normal TRB in there, instead leave it as a no-op entry
> containing a pointer to the stream ring.  (Make the prior Link TRB
> point to the second entry in the new segment instead of the first.)
> 
> Then you won't have to add to or remove anything from the radix tree.

I don't understand how this would help.  Are you advocating a different
way of mapping TRB DMA addresses to stream rings that would allow us to
ditch the radix tree all together?

Ok, so with your solution, we have a virtual stream ring pointer as the
first TRB of the segment.  We get an event with the DMA address of a TRB
in one of many stream rings on an endpoint.  From that, I think we can
infer the DMA address of the first TRB on the segment, due to the
alignment requirements and ring size.

And then what do we do with that?  We don't have the virtual address of
that first TRB, so the xHCI driver can't read the ring pointer from it.
I'm confused as to what the next steps would be to solve this.

Sarah Sharp
