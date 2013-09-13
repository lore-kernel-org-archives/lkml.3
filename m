Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab3IMPyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:54:00 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:37910 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab3IMPx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:53:58 -0400
Date: Fri, 13 Sep 2013 17:53:55 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Paul Chavent <Paul.Chavent@onera.fr>
Cc: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, jhovold@gmail.com,
        fschaefer.oss@googlemail.com, jslaby@suse.cz, max@suse.de,
        giometti@enneenne.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] USB : serial : invoke dcd_change ldisc's handler.
Message-ID: <20130913155355.GB9054@localhost>
References: <1379086513-2434-1-git-send-email-paul.chavent@onera.fr>
 <1379086513-2434-3-git-send-email-paul.chavent@onera.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379086513-2434-3-git-send-email-paul.chavent@onera.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 05:35:12PM +0200, Paul Chavent wrote:
> Signed-off-by: Paul Chavent <paul.chavent@onera.fr>
> ---
>  Documentation/pps/pps.txt    | 15 +++++++++++++++
>  drivers/usb/serial/generic.c |  9 +++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/Documentation/pps/pps.txt b/Documentation/pps/pps.txt
> index d35dcdd..67b9a94 100644
> --- a/Documentation/pps/pps.txt
> +++ b/Documentation/pps/pps.txt
> @@ -66,6 +66,21 @@ In LinuxPPS the PPS sources are simply char devices usually mapped
>  into files /dev/pps0, /dev/pps1, etc..
>  
>  
> +PPS with USB to serial devices
> +------------------------------
> +
> +It is possible to grab the PPS from an USB to serial device. However,
> +you should take into account the latencies and jitter introduced by
> +the USB stack. Users has reported clock instability around +-1ms when
> +synchronized with PPS through USB. This isn't suited for time server
> +synchronisation.
> +
> +If your device doesn't report PPS, you can check that the feature is
> +supported by its driver. Most of the time, you only need to add a call
> +to usb_serial_handle_dcd_change after checking the DCD status (see
> +ch341 and pl2303 examples).
> +
> +
>  Coding example
>  --------------
>  
> diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
> index 1f31e6b..877d6e0 100644
> --- a/drivers/usb/serial/generic.c
> +++ b/drivers/usb/serial/generic.c
> @@ -568,6 +568,15 @@ void usb_serial_handle_dcd_change(struct usb_serial_port *usb_port,
>  {
>  	struct tty_port *port = &usb_port->port;
>  
> +	if (tty) {
> +		struct tty_ldisc *ld = tty_ldisc_ref(tty);
> +		if (ld) {
> +			if (ld->ops->dcd_change)
> +				ld->ops->dcd_change(tty, status);
> +			tty_ldisc_deref(ld);
> +		}
> +	}
> +
>  	dev_dbg(&usb_port->dev, "%s - status %d\n", __func__, status);

Please add your ldisc handling after the debug statement.

Thanks,
Johan
