Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaIPPcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:32:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33719 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753045AbaIPPcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:32:15 -0400
Date: Tue, 16 Sep 2014 11:32:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Joe Lawrence <joe.lawrence@stratus.com>, Jiri Kosina <jkosina@suse.cz>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] usb: hub: convert khubd into workqueue
In-Reply-To: <20140916091031.GD2168@dhcp128.suse.cz>
Message-ID: <Pine.LNX.4.44L0.1409161046380.1166-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2014, Petr [iso-8859-1] Mládek wrote:

> Anyway, the solution for the race between kick_hub_wq() and
> hub_event() might be to get the reference already in kick_hub_wq().

Yes, this probably would work.

> I mean something like:
> 
> static void kick_hub_wq(struct usb_hub *hub)
> {
> 	if (hub->disconnected || work_pending(&hub->events))
> 		return;
> 	/*
> 	 * Suppress autosuspend until the event is proceed.
> 	 *
> 	 * Be careful and make sure that the symmetric operation is
> 	 * always called. We are here only when there is no pending
> 	 * work for this hub. Therefore put the interface either when
> 	 * the new work is called or when it is canceled.
> 	 */
> 	usb_autopm_get_interface_no_resume(to_usb_interface(hub->intfdev));
> 	kref_get(&hub->kref);
> 
> 	if (queue_work(hub_wq, &hub->events))
> 		return;
> 
> 	/* the work could not be scheduled twice */
> 	kref_put(&hub->kref, hub_release);
> 	usb_autopm_put_interface_no_suspend(intf);

This should be usb_autopm_put_interface_async, not *_no_suspend,
because you don't know at this point whether the runtime PM usage
counter is > 1.  (You do know it was > 1 at the time queue_work was 
called, but it may have changed since then.)

> }
> 
> And test for hub->disconnected at the very beginning of hub_event().

No, that's no good.  The value isn't fully meaningful unless you are 
holding the device lock.  That's why the test for hub->disconnected is 
placed where it is in hub_events.

> Also we would need to put the reference when the work is canceled in
> hub_disconnect().

You can't cancel the work in hub_disconnect.  That's because cancelling
a work item is always synchronous -- there's no cancel_work, only
cancel_work_sync.

This is okay; removing items from the hub_event_list was only a minor 
optimization anyway.  There's no harm in letting the work item go ahead 
and run.

> Hmm, I am not 100% sure if we could call
> usb_autopm_get_interface_no_resume() without any lock here.
> I guess so because otherwise the original code would not work.
> The check for "hub->disconnected" would fail if the struct was freed
> before the lock was taken.

The caller of kick_khubd has to guarantee that the hub structure hasn't 
been deallocated.

> It looks promissing. hub->intfdev is released together with "hub" in
> hub_release(). Also it seems that kick_* and *disconnect functions
> are called with some top level lock. For example, there is used dev
> lock in drivers/usb/core/device.c.

There's one more improvement you could make.  It's not necessary to
call usb_get_dev and usb_put_dev every time hub_events runs.  
Instead, we can call usb_get_dev once when the hub structure is created 
and usb_put_dev in hub_release.

> > But you ignored what the comment says about "don't let it be added 
> > again".
> 
> If we increase the reference in kick_hub_wq() and test
> hub->disconnected at the very beginning of hub_event() it
> should not cause real problem. In the worst case, it will release
> struct usb_hub there instead of in hub_disconnect(). It already happens
> with the original code in some circumstances.
> 
> If you think that this is too tricky, I will put the lock back.

It's probably okay without the lock.  Please post an updated patch 
(just the first one in the series; the later ones will remain the same) 
with the changes discussed here so I can review it.

Or better yet, rearrange the patch series.  Make the first patch be the 
one that removes the useless loop in hub_events.  That patch will be 
acceptable in any case, regardless of what happens with the workqueue 
change.  Then the second patch can be the conversion to a workqueue.

Alan Stern

