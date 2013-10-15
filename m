Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848Ab3JOOx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:53:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58540 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932633Ab3JOOx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:53:58 -0400
Date: Tue, 15 Oct 2013 10:53:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Gerd Hoffmann <kraxel@redhat.com>
cc: Hans de Goede <hdegoede@redhat.com>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2] xhci: fix usb3 streams
In-Reply-To: <20131015015424.GA5032@xanatos>
Message-ID: <Pine.LNX.4.44L0.1310151049130.1377-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Oct 2013, Gerd Hoffmann wrote:

> Gerd, Hans, any objections to this updated patch?  The warning is fixed
> with it.
> 
> The patch probably still needs to address the case where the ring
> expansion fails because we can't insert the new segments into the radix
> tree.  The patch should probably allocate the segments, attempt to add
> them to the radix tree, and fail without modifying the link TRBs of the
> ring.  I'd have to look more deeply into the code to see what exactly
> should be done there.
> 
> I would like that issue fixed before I merge these patches, so if you
> want to take a stab at fixing it, please do.
> 
> Sarah Sharp

Sarah, how did you manage to send an email with the "From:" line set to 
Gerd's name and address?

> 8<---------------------------------------------------------------->8
> 
> xhci maintains a radix tree for each stream endpoint because it must
> be able to map a trb address to the stream ring.  Each ring segment
> must be added to the ring for this to work.  Currently xhci sticks
> only the first segment of each stream ring into the radix tree.
> 
> Result is that things work initially, but as soon as the first segment
> is full xhci can't map the trb address from the completion event to the
> stream ring any more -> BOOM.  You'll find this message in the logs:
> 
>   ERROR Transfer event for disabled endpoint or incorrect stream ring
> 
> This patch adds a helper function to update the radix tree, and a
> function to remove ring segments from the tree.  Both functions loop
> over the segment list and handles all segments instead of just the
> first.

There may be a simpler approach to this problem.

When using a new ring segment, keep the first TRB entry in reserve.  
Don't put a normal TRB in there, instead leave it as a no-op entry
containing a pointer to the stream ring.  (Make the prior Link TRB
point to the second entry in the new segment instead of the first.)

Then you won't have to add to or remove anything from the radix tree.

Alan Stern

