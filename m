Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaILPoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 11:44:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55033 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752544AbaILPoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 11:44:15 -0400
Date: Fri, 12 Sep 2014 11:44:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Petr Mladek <pmladek@suse.cz>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Joe Lawrence <joe.lawrence@stratus.com>, Jiri Kosina <jkosina@suse.cz>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] usb: hub: convert khubd into workqueue
In-Reply-To: <20140912150815.GB13354@pathway.suse.cz>
Message-ID: <Pine.LNX.4.44L0.1409121137080.1180-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014, Petr Mladek wrote:

> > I don't think you can eliminate the lock quite so easily.  This patch 
> > introduces some nasty races.
> > 
> > > @@ -577,18 +571,20 @@ static int hub_port_status(struct usb_hub *hub, int port1,
> > >  
> > >  static void kick_khubd(struct usb_hub *hub)
> > >  {
> > > -	unsigned long	flags;
> > > -
> > > -	spin_lock_irqsave(&hub_event_lock, flags);
> > > -	if (!hub->disconnected && list_empty(&hub->event_list)) {
> > > -		list_add_tail(&hub->event_list, &hub_event_list);
> > > -
> > > -		/* Suppress autosuspend until khubd runs */
> > > +	if (!hub->disconnected && !work_pending(&hub->events)) {
> > 
> > Here you test hub->disconnected, with no lock for protection.
> 
> This should not be that big problem. It will schedule hub_event() but
> it will do basically nothing. This is why I thought that the lock was
> not needed.

What do you mean "basically nothing"?  hub_event will be scheduled, via 
a work_struct that is embedded in the usb_hub structure.  But that 
structure will be deallocated by hub_disconnect, so you will create a 
"use after free" bug.

> > (Also, note that work_pending is not synchronized with anything.  What 
> > happens if two threads call this routine at the same time?)
> 
> You are right! This is a real problem because it might call
> usb_autopm_put_interface_no_suspend() twice but it might schedule
> hub_event() and call usb_autopm_put_interface() only once.
> 
> Well, it might be possible to check the return value of
> queue_work and do something like:
> 
> 	if (!hub->disconnected && !work_pending(&hub->events)) {
> 		usb_autopm_get_interface_no_resume(
> 			to_usb_interface(hub->intfdev));
> 		if (!queue_work(hub_wq, &hub->events))
> 			usb_autopm_put_interface_no_suspend(intf);
> 	}
> 
> But there is still problem that we need to call
> "INIT_WORK(&hub->events, hub_event)" somewhere and do it only once
> before calling kick_hub_wq(). I wonder if it might be safe to do
> so in hub_activate().

If I thought this was the right way to go, I would suggest initializing 
hub->events in hub_probe, where the structure is created.

> Hmm, I am not longer that optimistic about it. After all, it might
> be better to put the lock back. Would you prefer it, please?

Here's what I think.  If you want to make khubd into a work queue 
thread, you can.  But it should be invoked only once, and the routine 
it runs should be hub_thread, not hub_events.  Overall I don't see any 
advantage in making this change.

> > And here you set hub->disconnected with no lock for protection.  So 
> > what happens if one thread calls kick_khubd at the same time as another 
> > thread calls hub_disconnect?
> 
> This should not be that big problem as explained above. Note that
> hub->disconnected was tested in hub_events() without the lock
> even before this patch. Hence I thought that the new code was as racy
> as before.

But you ignored what the comment says about "don't let it be added 
again".

Alan Stern

