Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaLSJuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 04:50:08 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59974 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaLSJuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 04:50:04 -0500
Date: Fri, 19 Dec 2014 10:50:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, khilman@kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: Re: bluetooth: Add hci_h4p driver
Message-ID: <20141219095000.GA24703@amd>
References: <20141213223727.GA13894@amd>
 <97C706D6-765B-446A-8180-600F5FB6C68B@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97C706D6-765B-446A-8180-600F5FB6C68B@holtmann.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> And you want to set the QUIRK_INVALID_BADDR. At least you want to do that in the final submission.
> 

Ok, I found out that I can do it and result works, provided that I do
hciconfig hci0 up/down first.

I have trouble understanding... h4p_hci_open() seems to be called as
soon as I insmod the driver. Who does that? Is it some kind of udev
magic?

...
> > +#include "hci_h4p.h"
> > +
> > +#define BT_DBG(a...) do {} while(0)
> 
> Why is this needed? BT_DBG is hooked up with dynamic debug.
...

I did all the changes as requested. Thanks. I did't see harm in
include guards, but I removed them; it is not important.

> > +	if (info->rx_count == 0) {
> > +		/* H4+ devices should always send word aligned packets */
> > +		if (!(info->rx_skb->len % 2))
> > +			info->garbage_bytes++;
> > +		h4p_recv_frame(info, info->rx_skb);
> 
> The h4p_recv_frame should maybe done inline here since it only handles 2 exception packets. Also to make it easy, just leave the function if (info->rx_count).
> 
> This packet processing feels like a bit of spaghetti code. I think that is better handled in a proper function that goes through it and not with many tiny sub functions.
>

Well, CodingStyle says something about functions that should be kept
short... And when manually inlined, the inner function would have to
be made less readable, as it uses return to shortcut processing. 


To use __hci_cmd_sync()

> > +
> > +	SET_HCIDEV_DEV(hdev, info->dev);
> > +
> > +	if (hci_register_dev(hdev) >= 0)
> > +		return 0;
> > +
> > +	dev_err(info->dev, "hci_register failed %s.\n", hdev->name);
> > +	hci_free_dev(info->hdev);
> > +	return -ENODEV;
> > +}
> 
> And normally this is folded into the probe handling and not in a
> separate function.

The probe function is too long, already...

> > +#include <linux/delay.h>
> > +#include <linux/clk.h>
> > +
> > +#include <linux/io.h>
> > +
> > +#include "hci_h4p.h"
> 
> Why is this a separate file? And if so, why not all UART specific details are in this file. Including bunch of the defines you have in the header.
> 

Well, you wanted less global functions, so I moved some as inlines to
headers. I guess I can merge nokia_core and nokia_uart if really wanted.

I did rest of requested changes.

Thanks,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
