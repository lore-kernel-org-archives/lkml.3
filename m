Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760361Ab3GaOnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:43:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36662 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759811Ab3GaOnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:43:31 -0400
Date: Wed, 31 Jul 2013 10:43:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Julius Werner <jwerner@chromium.org>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Benson Leung <bleung@chromium.org>
Subject: Re: [PATCH v2] usb: core: don't try to reset_device() a port that
 got just disconnected
In-Reply-To: <1375239080-21322-1-git-send-email-jwerner@chromium.org>
Message-ID: <Pine.LNX.4.44L0.1307311041540.1546-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jul 2013, Julius Werner wrote:

> The USB hub driver's event handler contains a check to catch SuperSpeed
> devices that transitioned into the SS.Inactive state and tries to fix
> them with a reset. It decides whether to do a plain hub port reset or
> call the usb_reset_device() function based on whether there was a device
> attached to the port.
> 
> However, there are device/hub combinations (found with a JetFlash
> Transcend mass storage stick (8564:1000) on the root hub of an Intel
> LynxPoint PCH) which can transition to the SS.Inactive state on
> disconnect (and stay there long enough for the host to notice). In this
> case, above-mentioned reset check will call usb_reset_device() on the
> stale device data structure. The kernel will send pointless LPM control
> messages to the no longer connected device address and can even cause
> several 5 second khubd stalls on some (buggy?) host controllers, before
> finally accepting the device's fate amongst a flurry of error messages.
> 
> This patch makes the choice of reset dependent on the port status that
> has just been read from the hub in addition to the existence of an
> in-kernel data structure for the device, and only proceeds with the more
> extensive reset if both are valid.
> 
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  drivers/usb/core/hub.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index 4a8a1d6..558313d 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -4798,7 +4798,8 @@ static void hub_events(void)
>  					hub->ports[i - 1]->child;
>  
>  				dev_dbg(hub_dev, "warm reset port %d\n", i);
> -				if (!udev) {
> +				if (!udev || !(portstatus &
> +						USB_PORT_STAT_CONNECTION)) {
>  					status = hub_port_reset(hub, i,
>  							NULL, HUB_BH_RESET_TIME,
>  							true);
> @@ -4808,8 +4809,8 @@ static void hub_events(void)
>  					usb_lock_device(udev);
>  					status = usb_reset_device(udev);
>  					usb_unlock_device(udev);
> +					connect_change = 0;
>  				}
> -				connect_change = 0;
>  			}
>  
>  			if (connect_change)

This version looks better.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

