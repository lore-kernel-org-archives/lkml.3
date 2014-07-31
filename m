Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaGaOJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 10:09:56 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40523 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaGaOJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 10:09:55 -0400
Date: Thu, 31 Jul 2014 15:07:53 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Jingoo Han <jg1.han@samsung.com>, Michael Welling <mwelling@ieee.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Joe Schultz <jschultz@xes-inc.com>, Ingo Molnar <mingo@elte.hu>,
        Doug Anderson <dianders@chromium.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] serial/8250: Add support for RS485 IOCTLs
Message-ID: <20140731150753.3f12fc2f@alan.etchedpixels.co.uk>
In-Reply-To: <1406651242-20689-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1406651242-20689-1-git-send-email-ricardo.ribalda@gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch allow the users of the 8250 infrastructure to define a
> handler for RS485 configration.

This feels to me like the right code in the wrong place.
 
> If no handler is defined the 8250 driver will work as usual.

Is there any reasons we can't have uart_ops.rs485_config and the RS485
ioctl logic in the serial_core, or even push rs485_get/put into the tty
ioctl handler and tty ops so it's not duplicated everywhere ?
 
> +	switch (cmd) {
> +	case TIOCSRS485:
> +		if (copy_from_user(&rs485_config, (void __user *)arg,
> +				   sizeof(rs485_config)))
> +			return -EFAULT;
> +
> +		ret = up->rs485_config(up, &rs485_config);
> +		if (ret)
> +			return ret;
> +
> +		memcpy(&up->rs485, &rs485_config, sizeof(rs485_config));
> +
> +		return 0;
> +	case TIOCGRS485:
> +		if (copy_to_user((void __user *)arg, &up->rs485,
> +				 sizeof(up->rs485)))
> +			return -EFAULT;
> +		return 0;

Possibly your mutex needs to cover parallel get an set, but then again
anyone doing that may well deserve what they get 8)

Alan
