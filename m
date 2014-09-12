Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbaILPIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 11:08:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbaILPIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 11:08:18 -0400
Date: Fri, 12 Sep 2014 17:08:15 +0200
From: Petr Mladek <pmladek@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Joe Lawrence <joe.lawrence@stratus.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] usb: hub: convert khubd into workqueue
Message-ID: <20140912150815.GB13354@pathway.suse.cz>
References: <1410524468-15232-2-git-send-email-pmladek@suse.cz>
 <Pine.LNX.4.44L0.1409121011470.1180-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1409121011470.1180-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-09-12 10:16:21, Alan Stern wrote:
> On Fri, 12 Sep 2014, Petr Mladek wrote:
> 
> > There is no need to have separate kthread for handling USB hub events.
> > It is more elegant to use the workqueue framework.
> > 
> > The workqueue is allocated as unbound, cpu intensive, and freezable.
> > There does not seem to be any big advantage to run it on the same CPU.
> > The handler is taking a lock and thus could block for a longer time.
> > And finally, the original thread was freezable as well.
> > 
> > struct usb_hub is passed via the work item. Therefore we do not need
> > hub_event_list.
> > 
> > hub_events() is modified to process the given work item. It is renamed to
> > hub_event(). The while cycle will be removed in a followup patch. It helps
> > to see the real change here.
> > 
> > One nice thing is that we do not need hub_event_lock any longer. It was needed
> > when doing operations with hub_event_list and for balancing the calls
> > usb_autopm_get_interface_no_resume() and usb_autopm_put_interface_no_suspend().
> > It still works because the workqueue operations have their own locking.
> > Also cancel_work_sync() tells us whether any work item was canceled.
> > It means that we could put the interface either in hub_event() handler or when
> > the work item was successfully canceled.
> 
> I don't think you can eliminate the lock quite so easily.  This patch 
> introduces some nasty races.
> 
> > @@ -577,18 +571,20 @@ static int hub_port_status(struct usb_hub *hub, int port1,
> >  
> >  static void kick_khubd(struct usb_hub *hub)
> >  {
> > -	unsigned long	flags;
> > -
> > -	spin_lock_irqsave(&hub_event_lock, flags);
> > -	if (!hub->disconnected && list_empty(&hub->event_list)) {
> > -		list_add_tail(&hub->event_list, &hub_event_list);
> > -
> > -		/* Suppress autosuspend until khubd runs */
> > +	if (!hub->disconnected && !work_pending(&hub->events)) {
> 
> Here you test hub->disconnected, with no lock for protection.

This should not be that big problem. It will schedule hub_event() but
it will do basically nothing. This is why I thought that the lock was
not needed.


> (Also, note that work_pending is not synchronized with anything.  What 
> happens if two threads call this routine at the same time?)

You are right! This is a real problem because it might call
usb_autopm_put_interface_no_suspend() twice but it might schedule
hub_event() and call usb_autopm_put_interface() only once.

Well, it might be possible to check the return value of
queue_work and do something like:

	if (!hub->disconnected && !work_pending(&hub->events)) {
		usb_autopm_get_interface_no_resume(
			to_usb_interface(hub->intfdev));
		if (!queue_work(hub_wq, &hub->events))
			usb_autopm_put_interface_no_suspend(intf);
	}

But there is still problem that we need to call
"INIT_WORK(&hub->events, hub_event)" somewhere and do it only once
before calling kick_hub_wq(). I wonder if it might be safe to do
so in hub_activate().

Hmm, I am not longer that optimistic about it. After all, it might
be better to put the lock back. Would you prefer it, please?


> > @@ -1647,13 +1643,9 @@ static void hub_disconnect(struct usb_interface *intf)
> >  	int port1;
> >  
> >  	/* Take the hub off the event list and don't let it be added again */
> > -	spin_lock_irq(&hub_event_lock);
> > -	if (!list_empty(&hub->event_list)) {
> > -		list_del_init(&hub->event_list);
> > +	if (cancel_work_sync(&hub->events))
> >  		usb_autopm_put_interface_no_suspend(intf);
> > -	}
> >  	hub->disconnected = 1;
> 
> And here you set hub->disconnected with no lock for protection.  So 
> what happens if one thread calls kick_khubd at the same time as another 
> thread calls hub_disconnect?

This should not be that big problem as explained above. Note that
hub->disconnected was tested in hub_events() without the lock
even before this patch. Hence I thought that the new code was as racy
as before.


Best Regards,
Petr
