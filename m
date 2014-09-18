Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbaIRQPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:15:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380AbaIRQPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:15:07 -0400
Date: Thu, 18 Sep 2014 18:15:02 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Lawrence <joe.lawrence@stratus.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] usb: hub: rename khubd to hub_wq in documentation
 and comments
Message-ID: <20140918161501.GG2168@dhcp128.suse.cz>
References: <20140917212238.GB15795@mtj.dyndns.org>
 <Pine.LNX.4.44L0.1409181013550.1326-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1409181013550.1326-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 18-09-14 10:24:23, Alan Stern wrote:
> On Thu, 18 Sep 2014, Tejun Heo wrote:
> 
> > Hello, Alan, Petr.
> > 
> > On Wed, Sep 17, 2014 at 01:36:26PM -0400, Alan Stern wrote:
> > > > -	/* If khubd ever becomes multithreaded, this will need a lock */
> > > > +	/* If hub_wq ever becomes multithreaded, this will need a lock */
> > > >  	if (udev->wusb) {
> > > >  		devnum = udev->portnum + 1;
> > > >  		BUG_ON(test_bit(devnum, bus->devmap.devicemap));
> > > 
> > > You probably didn't notice when changing this comment.  But in fact,
> > > workqueues _are_ multithreaded.  Therefore you need to add a lock to 
> > > this routine.
> 
> > Haven't read the code but if this function is called from a single
> > work_struct, workqueue guarantees that there's only single thread of
> > execution at any given time.  A work item is never executed
> > concurrently no matter what.
> 
> This routine can be called from multiple work_structs, because a USB 
> bus can have multiple hubs.

The easiest solution would be to allocate the work queue with
the flag WQ_UNBOUND and max_active = 1. It will force serialization
of all work items.

Alternatively, we might add the locking. But to be honest, I am not
sure that I am brave enough to do so.


First, I am not sure if this is the only location that might be
affected by the parallel execution of hub_event().

Second, there are used so many locks and the code is so complex that I
would need many days and maybe weeks to understand it.


Well, if we assume that this is the only problematic location, here
are the ideas how to prevent the parallel execution:

1. Use some brand new lock, e.g. call it hub_devnum_lock, and do:

   static void choose_devnum(struct usb_device *udev)
   {
	spin_lock_irq(&hub_devnum_lock);
	[...]
	spin_unlock_irq(&hub_event_lock);
   }

   This looks clean but it creates another lock.


2. Alternatively, we could use an existing global lock the same way,
   for example usb_bus_list_lock.

   But this looks like a hack and I do not like it much.


3. Alternatively, it seems the the function affects one
   "struct usb_device" and one "struct usb_bus". It might
   be enough to take the appropriate locks for these
   structures.

   This would mean to take two locks. It would be slower
   and we would need to make sure that it does not cause
   a dead lock.


Best Regards,
Petr
