Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934961AbaGYTxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 15:53:30 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:54950 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760868AbaGYTx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 15:53:28 -0400
Date: Fri, 25 Jul 2014 21:53:23 +0200
From: Andreas Mohr <andi@lisas.de>
To: Wang YanQing <udknight@gmail.com>, gregkh@linuxfoundation.org,
        linus.walleij@linaro.org, jhovold@gmail.com, andi@lisas.de,
        dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] usb:serial:pl2303: add GPIOs interface on PL2303
Message-ID: <20140725195323.GA4721@rhlx01.hs-esslingen.de>
References: <20140725173523.GA30320@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140725173523.GA30320@udknight>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jul 26, 2014 at 01:35:23AM +0800, Wang YanQing wrote:

> +         It support 2 GPIOs on PL2303HX currently,
"supports"

> +static u8 gpio_dir_mask[GPIO_NUM] = {0x10, 0x20};
> +static u8 gpio_value_mask[GPIO_NUM] = {0x40, 0x80};

Those two should better be static const, too (sorry).
You're at v5 already (wow, what endurance!),
but if there ever will be a v6... :)

> +static int pl2303_gpio_startup(struct usb_serial *serial)
> +{
> +	struct pl2303_serial_private *spriv = usb_get_serial_data(serial);
> +	char *label;
> +	int ret;
> +	int minor;
> +
> +	if (spriv->type != &pl2303_type_data[TYPE_HX])
> +		return 0;

Hmm, that's some structurally inverted check code.
The pl2303_gpio_startup() function in its entirety
is specific to the GPIO-supporting type TYPE_HX,
thus we shouldn't even *call* a type-specific sub handler
if we know that we're a different chip type.
And in fact pl2303_startup() already has everything in place
for a direct type check.
Yeah, that might be "less reliable" than a type check planted within
pl2303_gpio_startup() (someone might bogusly call pl2303_gpio_startup()
for a different-type chip),
but such an unrelated (external!) type check dependency
shouldn't be interwoven with a type-specific setup helper
which is to be concerned with inner-layer setup handling only.

A probably(!) even better idea here might be
to add some function pointers to spriv->type struct def,
to be able to do != NULL ptr checks and in such cases
call such chip-specific setup functions (i.e., call the HX type helper
which internally knows that it needs to do GPIO setup).
Such a change might be able to get rid of several #ifdef:s, too...
(plus, provide long-lasting generic infrastructure for future chip types).

Andreas Mohr
