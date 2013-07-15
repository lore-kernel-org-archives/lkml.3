Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab3GOQ7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:59:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47455 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174Ab3GOQ7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:59:21 -0400
Date: Mon, 15 Jul 2013 09:52:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rong Wang <wr011235813@gmail.com>
Cc: balbi@ti.com, arnd@arndb.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rong.Wang@csr.com
Subject: Re: [PATCH] usb: udc: add gadget state kobject uevent
Message-ID: <20130715165209.GA6000@kroah.com>
References: <CA+k=oDzG+R-ei5WGxP8L1Od6VWTK9SgWcXHNjd89u6+b2bECkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+k=oDzG+R-ei5WGxP8L1Od6VWTK9SgWcXHNjd89u6+b2bECkQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 11:57:24AM +0800, Rong Wang wrote:
>     usb: udc: add gadget state kobject uevent
> 
>     Add USB_UDC_STATE environment variable in udc uevent
>     callback and trigger kobject_uevent in usb_gadget_set_state
>     to inform the user-space the state of the gadget.

Why?

And what's with the indentation?

>     Signed-off-by: Rong Wang <Rong.Wang@csr.com>
> 
> diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
> index ffd8fa5..05715d1 100644
> --- a/drivers/usb/gadget/udc-core.c
> +++ b/drivers/usb/gadget/udc-core.c
> @@ -101,11 +101,32 @@ EXPORT_SYMBOL_GPL(usb_gadget_unmap_request);
> 
>  /* ------------------------------------------------------------------------- */
> 
> +/**
> + * usb_gadget_set_state - set usb gadget state
> + * @gadget: gadget device
> + * @state: state defined in USB specification ch9
> + * Context: !in_interrupt()
> + */
>  void usb_gadget_set_state(struct usb_gadget *gadget,
>                 enum usb_device_state state)
>  {
> +       struct usb_udc          *udc = NULL;
> +
>         gadget->state = state;
>         sysfs_notify(&gadget->dev.kobj, NULL, "status");
> +
> +       mutex_lock(&udc_lock);
> +       list_for_each_entry(udc, &udc_list, list)
> +               if (udc->gadget == gadget)
> +                       goto found;
> +
> +       dev_err(gadget->dev.parent, "gadget not registered.\n");
> +       mutex_unlock(&udc_lock);
> +       return;
> +
> +found:
> +       mutex_unlock(&udc_lock);
> +       kobject_uevent(&udc->dev.kobj, KOBJ_CHANGE);

I really don't like adding kobject change events, as they usually never
get listened to, and there are other ways to get this information from
userspace, right?

Why do you need/want this?  What is it going to be used for?  What tools
will use it?  How will they use it?

And why can't the existing notification events for gadget devices work
for you?

thanks,

greg k-h
