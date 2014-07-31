Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaGaOV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 10:21:27 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40545 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaGaOVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 10:21:25 -0400
Date: Thu, 31 Jul 2014 15:19:41 +0100
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
Subject: Re: [PATCH 2/2] serial: Add support for Fintek F81216A LPC to 4
 UART
Message-ID: <20140731151941.244fd508@alan.etchedpixels.co.uk>
In-Reply-To: <1406651242-20689-2-git-send-email-ricardo.ribalda@gmail.com>
References: <1406651242-20689-1-git-send-email-ricardo.ribalda@gmail.com>
	<1406651242-20689-2-git-send-email-ricardo.ribalda@gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int fintek_8250_get_index(resource_size_t base_addr)
> +{
> +	resource_size_t base[] = {0x3f8, 0x2f8, 0x3e8, 0x2e8};
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(base); i++)
> +		if (base_addr == base[i])
> +			return i;
> +
> +	return -ENODEV;

Less than ideal in some ways because the base may well be remapped by
other hardware or on non x86 devices. No obvious ideas how to fix it
though and PnP kind of implies x86.

> +	mutex_lock(&fintek_mutex);
> +	outb(LDN, ADDR_PORT);
> +	outb(index, DATA_PORT);
> +	outb(RS485, ADDR_PORT);
> +	outb(config, DATA_PORT);
> +	mutex_unlock(&fintek_mutex);

You really need to request that block of addresses because you may not be
the only superIO chip or driver playing with the various mux hack
registers that are used.

On the bright side you can then make the resource layer do your locking
work for you. We have an IORESOURCE_MUXED flag for these little horrors
so you can request the resource with IORESOURCE_MUXED. If the resource is
busy then you will get a failure back, if it is idle you will get the
resource, if it is busy but held by another driver using IORESOURCE_MUXED
then the request will block until they finish with it.

So you do

	request_muxed_region
	if failed then EBUSY
	prod stuff
	release_region


Alan

