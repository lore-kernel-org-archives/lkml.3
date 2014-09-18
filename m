Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477AbaIRRVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 13:21:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51034 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756218AbaIRRVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 13:21:39 -0400
Date: Thu, 18 Sep 2014 13:21:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Lawrence <joe.lawrence@stratus.com>, Jiri Kosina <jkosina@suse.cz>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] usb: hub: rename khubd to hub_wq in documentation
 and comments
In-Reply-To: <20140918161501.GG2168@dhcp128.suse.cz>
Message-ID: <Pine.LNX.4.44L0.1409181307550.894-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014, Petr [iso-8859-1] Mládek wrote:

> > This routine can be called from multiple work_structs, because a USB 
> > bus can have multiple hubs.
> 
> The easiest solution would be to allocate the work queue with
> the flag WQ_UNBOUND and max_active = 1. It will force serialization
> of all work items.
> 
> Alternatively, we might add the locking. But to be honest, I am not
> sure that I am brave enough to do so.
> 
> 
> First, I am not sure if this is the only location that might be
> affected by the parallel execution of hub_event().
> 
> Second, there are used so many locks and the code is so complex that I
> would need many days and maybe weeks to understand it.

In the past I have considered making khubd multithreaded.  But it
didn't seem especially important.  Apart from initial device discovery
while the system is starting up (which works out well enough now, even  
if it could be faster) there usually is activity on only one USB hub
and port at a time.

On the whole, I would be happy if we can simply guarantee that
max_active never gets higher than 1.  As Tejun recommended,
alloc_ordered_workqueue should be enough.

> Well, if we assume that this is the only problematic location, here
> are the ideas how to prevent the parallel execution:
> 
> 1. Use some brand new lock, e.g. call it hub_devnum_lock, and do:
> 
>    static void choose_devnum(struct usb_device *udev)
>    {
> 	spin_lock_irq(&hub_devnum_lock);
> 	[...]
> 	spin_unlock_irq(&hub_event_lock);
>    }
> 
>    This looks clean but it creates another lock.

That would be okay.  It shouldn't be a spinlock; a mutex would be
better.  And adding a new lock doesn't hurt if it is private to this
one routine, since this is a leaf routine.

Or if you want, you could reuse udev->bus->usb_address0_mutex.  That 
would make sense, because that mutex is already associated with device 
address assignment.

> 2. Alternatively, we could use an existing global lock the same way,
>    for example usb_bus_list_lock.
> 
>    But this looks like a hack and I do not like it much.
> 
> 
> 3. Alternatively, it seems the the function affects one
>    "struct usb_device" and one "struct usb_bus". It might
>    be enough to take the appropriate locks for these
>    structures.
> 
>    This would mean to take two locks. It would be slower
>    and we would need to make sure that it does not cause
>    a dead lock.

The right answer is to use either a private mutex or the bus-specific
usb_address0_mutex.  As far as I know, this is the only place that 
relies on khubd being a single thread.

Alan Stern

