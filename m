Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbaGCOPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:15:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41149 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752318AbaGCOPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:15:35 -0400
Date: Thu, 3 Jul 2014 10:15:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefan Klug <stefan.klug@baslerweb.com>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] USB: zerocopy support for usbfs
In-Reply-To: <53B50AB7.2090709@baslerweb.com>
Message-ID: <Pine.LNX.4.44L0.1407030953420.867-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2014, Stefan Klug wrote:

> >> Questions/Notes:
> >> - I'm quite unhappy with the added member async::is_user_mem. Is there a
> >> better place
> >>     where I could store this information?
> > No, async is the right place.  Why are you unhappy about it?
> A whole byte for this flag felt a bit like an overkill, but I'm fine 
> with that.

It's not a big deal.  Besides, the structure has to be padded to at 
least 4-byte alignment anyway.

> >> - I had a look at some other drivers using the get_user_pages ->
> >> sg_set_page -> page_cache_release
> >>     technique and didn't see any special code to handle corner cases.
> >>     Are there corner cases? - Like usb controllers not supporting the
> >> whole memory etc. ?
> > Indeed yes.  The page addresses have to be checked against the DMA
> > mask.  Also, many host controllers cannot handle arbitrary alignment.
> > It would be best to require that the buffer start at a page boundary.
> 
> Is there any way to check if the host controller supports arbitrary 
> alignment?

No.  Besides, if there were and you made use of it then users would
find that zerocopy worked correctly on some computers and did not work
(i.e., fell back to copying) mysteriously on others.  Not a good
situation.

> If I read the xhci spec correctly arbitrary alignment is explicitly 
> permitted.

Not all host controllers are xHCI.

>  In my use case
> the user allocates large amounts of memory, which is passed down to 
> submiturb in smaller chunks.

The user could allocate a little more memory than needed, so that the 
start of each transfer buffer could be rounded up to a page boundary 
within the memory region.

> So asking the kernel for aligned memory for every chunk would force me 
> to recombine to urbs on the user side,
> adding another copy operation.

Not necessarily.  See above.

> So I would vote for a solution where the 
> user can allocate the memory and pass it down
> without restrictions.
> The system should fallback to copying in kernel space, if the buffer is 
> not supported by the
> host-controller (but this is only the case for USB 2 and 1, right?).

Well, it's the case for non-xHCI.  Your choice of words is ambiguous,
because xHCI supports USB-1 and USB-2 as well as USB-3.

> > Using a global module parameter to control the use of zerocopy (for
> > anything other than debugging or testing) is a bad idea.  If you think
> > people will have a reason for avoiding zerocopy then you should make it
> > possible to decide for each URB, by adding a new flag to struct
> > usbdevfs_urb.
> 
> I'd like to leave the parameter in for debugging purposes mostly, at 
> least as long as this is not stable.

Then add a comment and an explanation in the patch description that the 
module parameter is meant for debugging.

> And it is a security measure. If anything goes wrong with zerocopy (are 
> there buggy host-controllers out there?),
> the user is able to disable it on a system wide basis.

Yes, there are buggy host controllers.  But I don't see how disabling 
zerocopy would improve security.  Buggy hardware can mess things up 
even if zerocopy isn't used.

> > People will want to use zerocopy with isochronous transfers as well as
> > bulk.  Implementing that isn't going to be quite so easy; it will be
> > necessary for the user to set up a memory mapping.  In fact, once
> > that's done the same mechanism could be used for bulk transfers too.
> >
> Yes you are right. I'll look into that. Is this a either both or nothing 
> decision?

It doesn't have to be.  If both mechanisms are present, users could get 
the benefit of zerocopy without the need for setting up a memory 
mapping.

Some patches along this line were posted last fall by Markus 
Rechberger.  See

	http://marc.info/?l=linux-usb&m=138046339714340&w=2

and the following messages in that thread.

> As I don't use isochronous transfers at all, it will be quite difficult 
> for me to correctly test that.

That is a problem.  By far the most common uses for isochronous are
audio and video, and customizing user programs for those applications
isn't easy.

Alan Stern

