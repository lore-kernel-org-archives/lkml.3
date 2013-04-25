Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab3DYOiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:38:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60457 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932084Ab3DYOix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:38:53 -0400
Date: Thu, 25 Apr 2013 10:38:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Julius Werner <jwerner@chromium.org>
cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, Vincent Palatin <vpalatin@chromium.org>,
        Sameer Nanda <snanda@chromium.org>
Subject: Re: [PATCH v2] usb: ehci: Only sleep for post-resume handover if
 devices use persist
In-Reply-To: <1366858352-25422-1-git-send-email-jwerner@chromium.org>
Message-ID: <Pine.LNX.4.44L0.1304251034070.1185-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Apr 2013, Julius Werner wrote:

> The current EHCI code sleeps a flat 110ms in the resume path if there
> was a USB 1.1 device connected to its companion controller during
> suspend, waiting for the device to reappear and reset so that it can be
> handed back to the companion. This is necessary if the device uses
> persist, so that the companion controller can actually see it during its
> own resume path.
> 
> However, if the device doesn't use persist, this is entirely
> unnecessary. We might just as well ignore it and have the normal device
> detection/reset/handoff code handle it asynchronously when it eventually
> shows up. As USB 1.1 devices are almost exclusively HIDs these days (for
> which persist has no value), this can allow distros to shave another
> tenth of a second off their resume time.

The patch description needs to mention the new for_each_usb_device() 
core routine.

> --- a/drivers/usb/host/ehci-hub.c
> +++ b/drivers/usb/host/ehci-hub.c
> @@ -42,6 +42,13 @@ static int ehci_hub_control(
>  	u16		wLength
>  );
>  
> +

Unnecessary blank line added.

> +static int persist_enabled_on_companion(struct usb_device *udev, void *unused)
> +{


> --- a/include/linux/usb.h
> +++ b/include/linux/usb.h
> @@ -719,6 +719,7 @@ const struct usb_device_id *usb_match_id(struct usb_interface *interface,
>  extern int usb_match_one_id(struct usb_interface *interface,
>  			    const struct usb_device_id *id);
>  
> +extern int usb_for_each_dev(void *data, int (*fn)(struct usb_device *, void *));

Line is too long.

Aside from these minor issues, the patch is fine.  Fix them and you can 
add

Acked-by: Alan Stern <stern@rowland.harvard.edu>

