Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab3DXP6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 11:58:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47486 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753407Ab3DXP6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 11:58:49 -0400
Date: Wed, 24 Apr 2013 11:58:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Julius Werner <jwerner@chromium.org>
cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, Vincent Palatin <vpalatin@chromium.org>,
        Sameer Nanda <snanda@chromium.org>
Subject: Re: [PATCH] usb: ehci: Only sleep for post-resume handover if devices
 use persist
In-Reply-To: <1366753762-6194-1-git-send-email-jwerner@chromium.org>
Message-ID: <Pine.LNX.4.44L0.1304241139380.1548-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Apr 2013, Julius Werner wrote:

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

This is a good idea.  The patch needs some fixes, though.

> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  drivers/usb/host/ehci-hub.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
> index 7d06e77..2507afb 100644
> --- a/drivers/usb/host/ehci-hub.c
> +++ b/drivers/usb/host/ehci-hub.c
> @@ -29,6 +29,8 @@
>  /*-------------------------------------------------------------------------*/
>  #include <linux/usb/otg.h>
>  
> +#include "../core/usb.h"

Unfortunately, this won't work if ehci-hcd is built as a module.  
usbcore does not export usb_device_type, which is used by 
is_usb_device().

Also, including a core header into a non-core driver is ugly.  Perhaps
a better approach would be to have usbcore export an iterator that runs
over devices only -- a for_each_usb_device() routine.

> +
>  #define	PORT_WAKE_BITS	(PORT_WKOC_E|PORT_WKDISC_E|PORT_WKCONN_E)
>  
>  #ifdef	CONFIG_PM
> @@ -42,6 +44,18 @@ static int ehci_hub_control(
>  	u16		wLength
>  );
>  
> +
> +static int companion_persist(struct device *dev, void *unused)

This name isn't so great.  Something like
"persistent_device_on_usb11_bus" would be more accurate, if not more
readable.  Maybe you can think of something better.

> +{
> +	struct usb_device *udev = container_of(dev, struct usb_device, dev);
> +
> +	if (!is_usb_device(dev))
> +		return 0;  /* Filter out struct usb_interface on the same bus */
> +
> +	return !udev->maxchild && udev->persist_enabled &&
> +		udev->bus->root_hub->speed < USB_SPEED_HIGH;
> +}
> +
>  /* After a power loss, ports that were owned by the companion must be
>   * reset so that the companion can still own them.
>   */
> @@ -56,6 +70,13 @@ static void ehci_handover_companion_ports(struct ehci_hcd *ehci)
>  	if (!ehci->owned_ports)
>  		return;
>  
> +	/* Check if any USB 1.1 controller in the system uses a non-hub device
> +	 * with persist enabled. If they don't, the device will get reenumerated
> +	 * anyway and there is no need to slow resume down to wait for it.
> +	 */

/*
 * New comments should be formatted like this.
 */

Also, the comment is grammatically unsound: It talks about non-existent
devices getting reenumerated.  What you really mean is more like this:

	If all devices (aside from hubs) on USB-1.1 buses have persist
	disabled then we don't need to perform the handover, with its 
	> 100 ms delay.  Any such devices will get reenumerated
	normally; typically they are only HID anyway.


> +	if (!bus_for_each_dev(&usb_bus_type, NULL, NULL, companion_persist))
> +		return;
> +
>  	/* Make sure the ports are powered */
>  	port = HCS_N_PORTS(ehci->hcs_params);
>  	while (port--) {

Alan Stern

