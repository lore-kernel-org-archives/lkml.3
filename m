Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaIQRb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 13:31:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39817 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755801AbaIQRb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 13:31:27 -0400
Date: Wed, 17 Sep 2014 13:31:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Petr Mladek <pmladek@suse.cz>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Joe Lawrence <joe.lawrence@stratus.com>, Jiri Kosina <jkosina@suse.cz>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] usb: hub: convert khubd into workqueue
In-Reply-To: <1410967150-25240-2-git-send-email-pmladek@suse.cz>
Message-ID: <Pine.LNX.4.44L0.1409171310430.1579-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 17 Sep 2014, Petr Mladek wrote:

> There is no need to have separate kthread for handling USB hub events.
> It is more elegant to use the workqueue framework.
> 
> The workqueue is allocated as freezable because the original thread was
> freezable as well.

I've got a few comments about style.

> -static void kick_khubd(struct usb_hub *hub)
> +static void kick_hub_wq(struct usb_hub *hub)
>  {
> -	unsigned long	flags;
> +	struct usb_interface *intf;
>  
> -	spin_lock_irqsave(&hub_event_lock, flags);
> -	if (!hub->disconnected && list_empty(&hub->event_list)) {
> -		list_add_tail(&hub->event_list, &hub_event_list);
> +	if (hub->disconnected || work_pending(&hub->events))
> +		return;
>  
> -		/* Suppress autosuspend until khubd runs */
> -		usb_autopm_get_interface_no_resume(
> -				to_usb_interface(hub->intfdev));
> -		wake_up(&khubd_wait);
> -	}
> -	spin_unlock_irqrestore(&hub_event_lock, flags);
> +	intf = to_usb_interface(hub->intfdev);
> +	/*
> +	 * Suppress autosuspend until the event is proceed.
> +	 *
> +	 * Be careful and make sure that the symmetric operation is
> +	 * always called. We are here only when there is no pending
> +	 * work for this hub. Therefore put the interface either when
> +	 * the new work is called or when it is canceled.
> +	 */
> +	kref_get(&hub->kref);
> +	usb_autopm_get_interface_no_resume(intf);

This looks a little weird.  The assignment to intf and the call to
usb_autopm_get_interface_no_resume naturally go together.  So why
put the big comment and the kref_get call in between them?  Put the
comment first, then the assigment and the autopm call, and then the
kref_get.

> @@ -5130,40 +5115,15 @@ static void hub_events(void)
>  			}
>  		}
>  
> - loop_autopm:
> + out_autopm:
>  		/* Balance the usb_autopm_get_interface() above */
>  		usb_autopm_put_interface_no_suspend(intf);
> - loop:
> -		/* Balance the usb_autopm_get_interface_no_resume() in
> -		 * kick_khubd() and allow autosuspend.
> -		 */
> -		usb_autopm_put_interface(intf);
> - loop_disconnected:
> + out_hdev_lock:
>  		usb_unlock_device(hdev);
> -		usb_put_dev(hdev);
> +		/* Ballance the stuff in kick_hub_wq() and allow autosuspend */
> +		usb_autopm_put_interface(intf);

You misspelled "Balance".  Also, there should be a blank line before
this comment.

> @@ -5203,21 +5163,26 @@ int usb_hub_init(void)
>  		return -1;
>  	}
>  
> -	khubd_task = kthread_run(hub_thread, NULL, "khubd");
> -	if (!IS_ERR(khubd_task))
> +	/*
> +	 * The workqueue needs to be freezable to avoid interfering with
> +	 * USB-PERSIST port handover. Otherwise it might see that a full-speed
> +	 * device was gone before the EHCI controller had handed its port
> +	 * over to the companion full-speed controller.
> +	 */
> +	hub_wq = alloc_workqueue("hub", WQ_FREEZABLE, 0);

Is "hub" really a good name for the workqueue?  If somebody reads it,
will they know what sort of hub it refers to?  Would "usb_hub" or even
"usb_hub_wq" be better?

>  void usb_hub_cleanup(void)
>  {
> -       kthread_stop(khubd_task);
> -
> +       destroy_workqueue(hub_wq);
>         /*

Don't get rid of this blank line.

More to come...

Alan Stern

