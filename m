Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbaBVPOv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 10:14:51 -0500
Received: from netrider.rowland.org ([192.131.102.5]:50765 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751392AbaBVPOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 10:14:49 -0500
Date: Sat, 22 Feb 2014 10:14:48 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: laijs@cn.fujitsu.com, <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2 5/9] usb: don't use PREPARE_DELAYED_WORK
In-Reply-To: <20140222145959.GF12830@htj.dyndns.org>
Message-ID: <Pine.LNX.4.44L0.1402221002440.24585-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Feb 2014, Tejun Heo wrote:

> Hello,
> 
> If this is actually safe, let's do it from the get-go.
> 
> Thanks!
> ------- 8< -------
> PREPARE_[DELAYED_]WORK() are being phased out.  They have few users
> and a nasty surprise in terms of reentrancy guarantee as workqueue
> considers work items to be different if they don't have the same work
> function.
> 
> usb_hub->init_work is multiplexed with multiple work functions;
> however, the work item is never queued while in-flight, so we can
> simply use INIT_DELAYED_WORK() before each queueing.
> 
> It would probably be best to route this with other related updates
> through the workqueue tree.
> 
> Lightly tested.
> 
> v2: Greg and Alan confirm that the work item is never queued while
>     in-flight.  Simply use INIT_DELAYED_WORK().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: linux-usb@vger.kernel.org
> ---
>  drivers/usb/core/hub.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -1040,7 +1040,7 @@ static void hub_activate(struct usb_hub
>  		 */
>  		if (type == HUB_INIT) {
>  			delay = hub_power_on(hub, false);
> -			PREPARE_DELAYED_WORK(&hub->init_work, hub_init_func2);
> +			INIT_DELAYED_WORK(&hub->init_work, hub_init_func2);
>  			schedule_delayed_work(&hub->init_work,
>  					msecs_to_jiffies(delay));
>  
> @@ -1194,7 +1194,7 @@ static void hub_activate(struct usb_hub
>  
>  		/* Don't do a long sleep inside a workqueue routine */
>  		if (type == HUB_INIT2) {
> -			PREPARE_DELAYED_WORK(&hub->init_work, hub_init_func3);
> +			INIT_DELAYED_WORK(&hub->init_work, hub_init_func3);
>  			schedule_delayed_work(&hub->init_work,
>  					msecs_to_jiffies(delay));
>  			return;		/* Continues at init3: below */
> 

This should work okay.  But while you're making these changes, you 
should remove the INIT_DELAYED_WORK(&hub->init_work, NULL) call in 
hub_probe().  It is now unnecessary.

Is the cancel_delayed_work_sync(&hub->init_work) call in hub_quiesce()
going to get confused by all this?

It's worth mentioning that the only reason for the hub_init_func3 stuff
is, as the comment says, to avoid a long sleep (100 ms) inside a work
routine.  With all the changes to the work queue infrastructure, maybe
this doesn't matter so much any more.  If we got rid of it then there
wouldn't be any multiplexing, and this whole issue would become moot.

Alan Stern

