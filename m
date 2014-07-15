Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaGOOYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:24:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49550 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752463AbaGOOYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:24:48 -0400
Date: Tue, 15 Jul 2014 10:24:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Gavin Guo <gavin.guo@canonical.com>
cc: sarah.a.sharp@linux.intel.com, <mathias.nyman@intel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yk@canonical.com>, <anthony.wong@canonical.com>,
        <gerald.yang@canonical.com>
Subject: Re: [PATCH 1/1] usb: Check if port status is equal to RxDetect
In-Reply-To: <1405059756-11983-2-git-send-email-gavin.guo@canonical.com>
Message-ID: <Pine.LNX.4.44L0.1407151020060.1206-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Gavin Guo wrote:

> When using USB 3.0 pen drive with the [AMD] FCH USB XHCI Controller
> [1022:7814], the second hotplugging will experience the USB 3.0 pen
> drive is recognized as high-speed device. After bisecting the kernel,
> I found the commit number 41e7e056cdc662f704fa9262e5c6e213b4ab45dd
> (USB: Allow USB 3.0 ports to be disabled.) causes the bug. After doing
> some experiments, the bug can be fixed by avoiding executing the function
> hub_usb3_port_disable(). Because the port status with [AMD] FCH USB
> XHCI Controlleris [1022:7814] is already in RxDetect
> (I tried printing out the port status before setting to Disabled state),
> it's reasonable to check the port status before really executing
> hub_usb3_port_disable().

This seems like a race.  Even if the port isn't in RxDetect when you 
check it, it could switch to RxDetect before the kernel sets it to 
Disabled.

But maybe this is the best we can do.

> Fixes: 41e7e056cdc6 (USB: Allow USB 3.0 ports to be disabled.)
> Signed-off-by: Gavin Guo <gavin.guo@canonical.com>
> ---
>  drivers/usb/core/hub.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index 21b99b4..e02ab62 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -889,6 +889,25 @@ static int hub_usb3_port_disable(struct usb_hub *hub, int port1)
>  	if (!hub_is_superspeed(hub->hdev))
>  		return -EINVAL;
>  
> +	ret = hub_port_status(hub, port1, &portstatus, &portchange);
> +	if (ret < 0)
> +		return ret;
> +
> +	/*
> +	 * USB controller Advanced Micro Devices,
> +	 * Inc. [AMD] FCH USB XHCI Controller [1022:7814] will have spurious result
> +	 * making the following usb 3.0 device hotplugging route to the 2.0 root hub
> +	 * and recognized as high-speed device if we set the usb 3.0 port link state
> +	 *  to Disabled. Since it's already in USB_SS_PORT_LS_RX_DETECT state, we
> +	 *  check the state here to avoid the bug.
> +	 */

Comments should not extend beyond column 80.  And there should be only 
one space, not two, after the '*' in the 6th and 7th lines.

> +	if ((portstatus & USB_PORT_STAT_LINK_STATE) ==
> +				USB_SS_PORT_LS_RX_DETECT) {
> +		dev_dbg(&hub->ports[port1 - 1]->dev,
> +			 "The link state is already in USB_SS_PORT_LS_RX_DETECT\n");

This message does not explain what has happened.  It should say
something like "Not disabling port; link state is RxDetect".

> +		return ret;
> +	}
> +
>  	ret = hub_set_port_link_state(hub, port1, USB_SS_PORT_LS_SS_DISABLED);
>  	if (ret)
>  		return ret;

Alan Stern

