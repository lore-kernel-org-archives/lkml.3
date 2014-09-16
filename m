Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbaIPPRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:17:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39769 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbaIPPRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:17:33 -0400
Date: Tue, 16 Sep 2014 17:17:28 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Joe Lawrence <joe.lawrence@stratus.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] usb: hub: convert khubd into workqueue
Message-ID: <20140916151725.GE2168@dhcp128.suse.cz>
References: <20140912150815.GB13354@pathway.suse.cz>
 <Pine.LNX.4.44L0.1409121137080.1180-100000@iolanthe.rowland.org>
 <20140916091031.GD2168@dhcp128.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140916091031.GD2168@dhcp128.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 16-09-14 11:10:31, Petr Mládek wrote:
> Anyway, the solution for the race between kick_hub_wq() and
> hub_event() might be to get the reference already in kick_hub_wq().
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
> }

I have just realized that I was working in the Linus' three where the
commit c605f3cdff53a743f6d87 ("usb: hub: take hub->hdev reference when
processing from eventlist") was missing :-(

It means that we would need to call also usb_get_dev(hdev) in
kick_hub_wq() to make sure that everything is valid when the work
hub_event() is proceed.


Hmm, it stopped being nice. So, I was looking for another solution and
found an interesting behavior of cancel_work_sync() that is used in
hub_disconnect(). It either removes the work item from the queue or it
waits until the work is done. Anyway, no work is pending when the
function returns. It means that struct usb_hub never will be released
when hub_event() is in progress and we do not need to get the
references in advance at all.


I am really sorry for sending so many mails. I am still getting familiar with
kernel hacking. I am often surprised how complex it is. I do not want
to spam and lose your interest, definitely. So, I am going to calm
down and be more patient when doing the homework.


Best Regards,
Petr
