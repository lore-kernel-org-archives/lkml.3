Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbaIPJKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:10:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33571 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbaIPJKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:10:46 -0400
Date: Tue, 16 Sep 2014 11:10:33 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Joe Lawrence <joe.lawrence@stratus.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] usb: hub: convert khubd into workqueue
Message-ID: <20140916091031.GD2168@dhcp128.suse.cz>
References: <20140912150815.GB13354@pathway.suse.cz>
 <Pine.LNX.4.44L0.1409121137080.1180-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1409121137080.1180-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 12-09-14 11:44:14, Alan Stern wrote:
> On Fri, 12 Sep 2014, Petr Mladek wrote:
> 
> > > I don't think you can eliminate the lock quite so easily.  This patch 
> > > introduces some nasty races.
> > > 
> > > > @@ -577,18 +571,20 @@ static int hub_port_status(struct usb_hub *hub, int port1,
> > > >  
> > > >  static void kick_khubd(struct usb_hub *hub)
> > > >  {
> > > > -	unsigned long	flags;
> > > > -
> > > > -	spin_lock_irqsave(&hub_event_lock, flags);
> > > > -	if (!hub->disconnected && list_empty(&hub->event_list)) {
> > > > -		list_add_tail(&hub->event_list, &hub_event_list);
> > > > -
> > > > -		/* Suppress autosuspend until khubd runs */
> > > > +	if (!hub->disconnected && !work_pending(&hub->events)) {
> > > 
> > > Here you test hub->disconnected, with no lock for protection.
> > 
> > This should not be that big problem. It will schedule hub_event() but
> > it will do basically nothing. This is why I thought that the lock was
> > not needed.
> 
> What do you mean "basically nothing"?  hub_event will be scheduled, via 
> a work_struct that is embedded in the usb_hub structure.  But that 
> structure will be deallocated by hub_disconnect, so you will create a 
> "use after free" bug.

Sigh, I feel like an idiot. The code is not easy but still. I hope
that it was just a temporary parental dementia that I got when taking
care of our new born twins.

Feel free to ask me to send another version of the patch set if you
are getting lost in this Xth reply.


Anyway, the solution for the race between kick_hub_wq() and
hub_event() might be to get the reference already in kick_hub_wq().
I mean something like:

static void kick_hub_wq(struct usb_hub *hub)
{
	if (hub->disconnected || work_pending(&hub->events))
		return;
	/*
	 * Suppress autosuspend until the event is proceed.
	 *
	 * Be careful and make sure that the symmetric operation is
	 * always called. We are here only when there is no pending
	 * work for this hub. Therefore put the interface either when
	 * the new work is called or when it is canceled.
	 */
	usb_autopm_get_interface_no_resume(to_usb_interface(hub->intfdev));
	kref_get(&hub->kref);

	if (queue_work(hub_wq, &hub->events))
		return;

	/* the work could not be scheduled twice */
	kref_put(&hub->kref, hub_release);
	usb_autopm_put_interface_no_suspend(intf);
}

And test for hub->disconnected at the very beginning of hub_event().
Also we would need to put the reference when the work is canceled in
hub_disconnect().

Hmm, I am not 100% sure if we could call
usb_autopm_get_interface_no_resume() without any lock here.
I guess so because otherwise the original code would not work.
The check for "hub->disconnected" would fail if the struct was freed
before the lock was taken.

It looks promissing. hub->intfdev is released together with "hub" in
hub_release(). Also it seems that kick_* and *disconnect functions
are called with some top level lock. For example, there is used dev
lock in drivers/usb/core/device.c.

> > > (Also, note that work_pending is not synchronized with anything.  What 
> > > happens if two threads call this routine at the same time?)
> > 
> > You are right! This is a real problem because it might call
> > usb_autopm_put_interface_no_suspend() twice but it might schedule
> > hub_event() and call usb_autopm_put_interface() only once.
> > 
> > Well, it might be possible to check the return value of
> > queue_work and do something like:
> > 
> > 	if (!hub->disconnected && !work_pending(&hub->events)) {
> > 		usb_autopm_get_interface_no_resume(
> > 			to_usb_interface(hub->intfdev));
> > 		if (!queue_work(hub_wq, &hub->events))
> > 			usb_autopm_put_interface_no_suspend(intf);
> > 	}
> > 
> > But there is still problem that we need to call
> > "INIT_WORK(&hub->events, hub_event)" somewhere and do it only once
> > before calling kick_hub_wq(). I wonder if it might be safe to do
> > so in hub_activate().
>
> If I thought this was the right way to go, I would suggest initializing 
> hub->events in hub_probe, where the structure is created.

Thanks for hint.

> > Hmm, I am not longer that optimistic about it. After all, it might
> > be better to put the lock back. Would you prefer it, please?
> 
> Here's what I think.  If you want to make khubd into a work queue 
> thread, you can.  But it should be invoked only once,

sure

> and the routine it runs should be hub_thread, not hub_events.

Yes, but most of the hub_thread() content is handled by the
workqueue() framework. In fact, after I removed all the obsolete stuff
then only "hub_events() call was left. So, there was no reason to keep it.


> Overall I don't see any advantage in making this change.

There are several motivations:

First, workqueues have clean and rich API for all basic operations.
The code is usually easier and better readable. For example, see how we
reduced hub_thread() and avoided operations with hub_event_list.

Also it should be more safe because the workqueue code has matured
and all the internal locking is well tested.

You might think that there is less control over the job but workqueues
are specialized on these scheduled tasks. There are many options, so
you could easily switch to a better mode if needed. All this is
standardized and thus should be better tested than any local "hacks".

In many cases, it allows to avoid extra kernel thread. It helps to stop the
growing number of them.  Also there will be less thread-specific
hacks all over the kernel code.

It forces making the task selfcontained. There is no longer an unclear
infinite loop. This helps to avoid problems with suspend. Also it will
be very helpful for kGraft (kernel live patching).

I guess that Tejun could come with more advantages.
 
> > > And here you set hub->disconnected with no lock for protection.  So 
> > > what happens if one thread calls kick_khubd at the same time as another 
> > > thread calls hub_disconnect?
> > 
> > This should not be that big problem as explained above. Note that
> > hub->disconnected was tested in hub_events() without the lock
> > even before this patch. Hence I thought that the new code was as racy
> > as before.
> 
> But you ignored what the comment says about "don't let it be added 
> again".

If we increase the reference in kick_hub_wq() and test
hub->disconnected at the very beginning of hub_event() it
should not cause real problem. In the worst case, it will release
struct usb_hub there instead of in hub_disconnect(). It already happens
with the original code in some circumstances.

If you think that this is too tricky, I will put the lock back.


Thanks for patience.

Best Regards,
Petr
