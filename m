Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbaAHRPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 12:15:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115AbaAHRPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 12:15:19 -0500
Date: Wed, 8 Jan 2014 09:15:48 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Shen Guang <shenguang10@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb:hub set hub->change_bits when over-current happens
Message-ID: <20140108171548.GA16878@kroah.com>
References: <CANthSfYiQZXJ46SsbeqSS2eMHMLu7t+NOnCQd87BwvhcYp8aUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANthSfYiQZXJ46SsbeqSS2eMHMLu7t+NOnCQd87BwvhcYp8aUA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 02:45:42PM +0800, Shen Guang wrote:
> When we are doing compliance test with xHCI, we found that if we
> enable CONFIG_USB_SUSPEND and plug in a bad device which causes
> over-current condition to the root port, software will not be noticed.
> The reason is that current code don't set hub->change_bits in
> hub_activate() when over-current happens, and then hub_events() will
> not check the port status because it thinks nothing changed.
> If CONFIG_USB_SUSPEND is disabled, the interrupt pipe of the hub will
> report the change and set hub->event_bits, and then hub_events() will
> check what events happened.In this case over-current can be detected.
> 
> Signed-off-by: Shen Guang <shenguang10@gmail.com>
> ---
>  drivers/usb/core/hub.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index bd9dc35..98b5679 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -1154,7 +1154,8 @@ static void hub_activate(struct usb_hub *hub,
> enum hub_activation_type type)
>                         /* Tell khubd to disconnect the device or
>                          * check for a new connection
>                          */
> -                       if (udev || (portstatus & USB_PORT_STAT_CONNECTION))
> +                       if (udev || (portstatus & USB_PORT_STAT_CONNECTION) ||
> +                               (portstatus & USB_PORT_STAT_OVERCURRENT))
>                                 set_bit(port1, hub->change_bits);
> 
>                 } else if (portstatus & USB_PORT_STAT_ENABLE) {
> --
> 1.7.9.5

Alan and Sarah, any objection to this patch?

thanks,

gre k-h
