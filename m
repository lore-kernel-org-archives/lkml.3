Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbaG2QmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:42:23 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55939 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaG2QmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:42:21 -0400
Date: Wed, 30 Jul 2014 00:40:59 +0800
From: Wang YanQing <udknight@gmail.com>
To: Andreas Mohr <andi@lisas.de>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, jhovold@gmail.com,
        dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] usb:serial:pl2303: add GPIOs interface on PL2303
Message-ID: <20140729164058.GA2440@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Andreas Mohr <andi@lisas.de>, gregkh@linuxfoundation.org,
	linus.walleij@linaro.org, jhovold@gmail.com, dforsi@gmail.com,
	gnomes@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20140725173523.GA30320@udknight>
 <20140725195323.GA4721@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140725195323.GA4721@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 09:53:23PM +0200, Andreas Mohr wrote:
> Hi,
> 
> On Sat, Jul 26, 2014 at 01:35:23AM +0800, Wang YanQing wrote:
> 
> > +         It support 2 GPIOs on PL2303HX currently,
> "supports"
> 

Right!

> > +static u8 gpio_dir_mask[GPIO_NUM] = {0x10, 0x20};
> > +static u8 gpio_value_mask[GPIO_NUM] = {0x40, 0x80};
> 
> Those two should better be static const, too (sorry).
> You're at v5 already (wow, what endurance!),
> but if there ever will be a v6... :)
> 

OK! there will be v6.

> > +static int pl2303_gpio_startup(struct usb_serial *serial)
> > +{
> > +	struct pl2303_serial_private *spriv = usb_get_serial_data(serial);
> > +	char *label;
> > +	int ret;
> > +	int minor;
> > +
> > +	if (spriv->type != &pl2303_type_data[TYPE_HX])
> > +		return 0;
> 
> Hmm, that's some structurally inverted check code.
> The pl2303_gpio_startup() function in its entirety
> is specific to the GPIO-supporting type TYPE_HX,
> thus we shouldn't even *call* a type-specific sub handler
> if we know that we're a different chip type.
> And in fact pl2303_startup() already has everything in place
> for a direct type check.
> Yeah, that might be "less reliable" than a type check planted within
> pl2303_gpio_startup() (someone might bogusly call pl2303_gpio_startup()
> for a different-type chip),

This is just caller vs callee check, and ether of them
has itself advantage in fit situation. I don't think
it is wrong to reuse current pl2303_type_data for type
check in pl2303_gpio_startup just like I don't think 
it is wrong to do the check prior to call pl2303_gpio_starutp
in you suggestion.

> but such an unrelated (external!) type check dependency
> shouldn't be interwoven with a type-specific setup helper
> which is to be concerned with inner-layer setup handling only.

It is not unrelated type check, type-specific setup helper
has right to check whether it is the "really" specified type.:)

> A probably(!) even better idea here might be
> to add some function pointers to spriv->type struct def,
> to be able to do != NULL ptr checks and in such cases
> call such chip-specific setup functions (i.e., call the HX type helper
> which internally knows that it needs to do GPIO setup).

I don't think pl2303_type_data is right place to hold it,
pl2303_type_data is right place for serial concerning function,
not for gpio.

> Such a change might be able to get rid of several #ifdef:s, too...

#ifdef is still necessary, most people don't need this feature,
it bring no benefit to make kernel image bigger.

> (plus, provide long-lasting generic infrastructure for future chip types).

A simple and specified device driver, I doubt the need for
so "generic infrastructure", and current code could just work
for future chip types, just looks like below:

if (type == HX ||
    type == "future type"||
    more future type)
pl2303_gpio_startup();

Thanks for review, and sorry for my delay reply.



