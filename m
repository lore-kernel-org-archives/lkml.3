Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbaDHHdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 03:33:41 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:49516 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbaDHHdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 03:33:39 -0400
Date: Tue, 8 Apr 2014 09:33:06 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Xiao Jin <jin.xiao@intel.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, david.a.cohen@linux.intel.com,
        yanmin.zhang@intel.com
Subject: Re: [PATCH] cdc-acm: some enhancement on acm delayed write
Message-ID: <20140408073306.GB25779@localhost>
References: <53436770.9090008@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53436770.9090008@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 11:05:20AM +0800, Xiao Jin wrote:
> We find two problems on acm tty write delayed mechanism.

Then you should split this into two patches.

> (1) When acm resume, the delayed wb will be started. But now
> only one write can be saved during acm suspend. More acm write
> may be abandoned.

Why not simply return 0 in write and use the tty buffering rather than
implement another buffer in cdc_acm?

> (2) acm tty port ASYNCB_INITIALIZED flag will be cleared when
> close. If acm resume callback run after ASYNCB_INITIALIZED flag
> cleared, there will have no chance for delayed write to start.
> That lead to acm_wb.use can't be cleared. If user space open
> acm tty again and try to setd, tty will be blocked in
> tty_wait_until_sent for ever.
>
> This patch have two modification.
> (1) use list_head to save the write acm_wb during acm suspend.
> It can ensure no acm write abandoned.
> (2) enable flush buffer callback when acm tty close. acm delayed
> wb will start before acm port shutdown callback, it make sure
> the delayed acm_wb.use to be cleared. The patch also clear
> acm_wb.use and acm.transmitting when port shutdown.

This is not the right way to do this. See below.

> Signed-off-by: xiao jin <jin.xiao@intel.com>
> Reviewed-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>   drivers/usb/class/cdc-acm.c |   56 
> ++++++++++++++++++++++++++++++-------------
>   drivers/usb/class/cdc-acm.h |    3 ++-
>   2 files changed, 42 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
> index 900f7ff..cfe00b2 100644
> --- a/drivers/usb/class/cdc-acm.c
> +++ b/drivers/usb/class/cdc-acm.c
> @@ -217,6 +217,24 @@ static int acm_start_wb(struct acm *acm, struct 
> acm_wb *wb)
>   }
> 
>   /*
> + * Delayed write.
> + */
> +static int acm_start_delayed_wb(struct acm *acm)
> +{
> +	struct acm_wb *wb, *n_wb;
> +	LIST_HEAD(delay_wb_list);
> +
> +	spin_lock_irq(&acm->write_lock);
> +	list_replace_init(&acm->delayed_wb_list, &delay_wb_list);
> +	spin_unlock_irq(&acm->write_lock);
> +	list_for_each_entry_safe(wb, n_wb,
> +			&delay_wb_list, delay) {
> +		list_del(&wb->delay);
> +		acm_start_wb(acm, wb);
> +	}
> +}
> +
> +/*
>    * attributes exported through sysfs
>    */
>   static ssize_t show_caps
> @@ -580,8 +598,11 @@ static void acm_port_shutdown(struct tty_port *port)
>   		usb_autopm_get_interface(acm->control);
>   		acm_set_control(acm, acm->ctrlout = 0);
>   		usb_kill_urb(acm->ctrlurb);
> -		for (i = 0; i < ACM_NW; i++)
> +		acm->transmitting = 0;

No need to reset transmitting which is balanced by usb_kill_urb below.

> +		for (i = 0; i < ACM_NW; i++) {
>   			usb_kill_urb(acm->wb[i].urb);
> +			acm->wb[i].use = 0;

Same here: use is generally cleared by the completion handler -- you
only need to handle any delayed urb.

> +		}
>   		for (i = 0; i < acm->rx_buflimit; i++)
>   			usb_kill_urb(acm->read_urbs[i]);
>   		acm->control->needs_remote_wakeup = 0;
> @@ -608,6 +629,8 @@ static void acm_tty_close(struct tty_struct *tty, 
> struct file *filp)
>   {
>   	struct acm *acm = tty->driver_data;
>   	dev_dbg(&acm->control->dev, "%s\n", __func__);
> +	/* Set flow_stopped to enable flush buffer*/
> +	tty->flow_stopped = 1;

You shouldn't abuse the flow_stopped flag. Simply clear the delayed urb
in shutdown (rather than try to use flush_buffer).

>   	tty_port_close(&acm->port, tty, filp);
>   }
> 
> @@ -646,10 +669,7 @@ static int acm_tty_write(struct tty_struct *tty,
> 
>   	usb_autopm_get_interface_async(acm->control);
>   	if (acm->susp_count) {
> -		if (!acm->delayed_wb)
> -			acm->delayed_wb = wb;
> -		else
> -			usb_autopm_put_interface_async(acm->control);
> +		list_add_tail(&wb->delay, &acm->delayed_wb_list);
>   		spin_unlock_irqrestore(&acm->write_lock, flags);
>   		return count;	/* A white lie */
>   	}
> @@ -688,6 +708,18 @@ static int acm_tty_chars_in_buffer(struct 
> tty_struct *tty)
>   	return (ACM_NW - acm_wb_is_avail(acm)) * acm->writesize;
>   }
> 
> +static void acm_tty_flush_buffer(struct tty_struct *tty)
> +{
> +	struct acm *acm = tty->driver_data;
> +
> +	/* flush delayed write buffer */
> +	if (!acm->disconnected) {
> +		usb_autopm_get_interface(acm->control);
> +		acm_start_delayed_wb(acm);
> +		usb_autopm_put_interface(acm->control);
> +	}
> +}
> +

Again, don't use flush_buffer for this (it's used to discard output
buffers).

Johan

>   static void acm_tty_throttle(struct tty_struct *tty)
>   {
>   	struct acm *acm = tty->driver_data;
> @@ -1346,6 +1378,7 @@ made_compressed_probe:
>   		snd->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
>   		snd->instance = acm;
>   	}
> +	INIT_LIST_HEAD(&acm->delayed_wb_list);
> 
>   	usb_set_intfdata(intf, acm);
> 
> @@ -1540,7 +1573,6 @@ static int acm_suspend(struct usb_interface *intf, 
> pm_message_t message)
>   static int acm_resume(struct usb_interface *intf)
>   {
>   	struct acm *acm = usb_get_intfdata(intf);
> -	struct acm_wb *wb;
>   	int rv = 0;
>   	int cnt;
> 
> @@ -1555,16 +1587,7 @@ static int acm_resume(struct usb_interface *intf)
>   	if (test_bit(ASYNCB_INITIALIZED, &acm->port.flags)) {
>   		rv = usb_submit_urb(acm->ctrlurb, GFP_NOIO);
> 
> -		spin_lock_irq(&acm->write_lock);
> -		if (acm->delayed_wb) {
> -			wb = acm->delayed_wb;
> -			acm->delayed_wb = NULL;
> -			spin_unlock_irq(&acm->write_lock);
> -			acm_start_wb(acm, wb);
> -		} else {
> -			spin_unlock_irq(&acm->write_lock);
> -		}
> -
> +		acm_start_delayed_wb(acm);
>   		/*
>   		 * delayed error checking because we must
>   		 * do the write path at all cost
> @@ -1823,6 +1846,7 @@ static const struct tty_operations acm_ops = {
>   	.throttle =		acm_tty_throttle,
>   	.unthrottle =		acm_tty_unthrottle,
>   	.chars_in_buffer =	acm_tty_chars_in_buffer,
> +	.flush_buffer =		acm_tty_flush_buffer,
>   	.break_ctl =		acm_tty_break_ctl,
>   	.set_termios =		acm_tty_set_termios,
>   	.tiocmget =		acm_tty_tiocmget,
> diff --git a/drivers/usb/class/cdc-acm.h b/drivers/usb/class/cdc-acm.h
> index e38dc78..42d6427 100644
> --- a/drivers/usb/class/cdc-acm.h
> +++ b/drivers/usb/class/cdc-acm.h
> @@ -69,6 +69,7 @@ struct acm_wb {
>   	int use;
>   	struct urb		*urb;
>   	struct acm		*instance;
> +	struct list_head	delay;
>   };
> 
>   struct acm_rb {
> @@ -120,7 +121,7 @@ struct acm {
>   	unsigned int throttled:1;			/* actually throttled */
>   	unsigned int throttle_req:1;			/* throttle requested */
>   	u8 bInterval;
> -	struct acm_wb *delayed_wb;			/* write queued for a device about to be 
> woken */
> +	struct list_head delayed_wb_list;		/* delayed wb list */
>   };
> 
>   #define CDC_DATA_INTERFACE_TYPE	0x0a
