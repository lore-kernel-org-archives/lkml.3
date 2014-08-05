Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbaHENzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 09:55:32 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:41073 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbaHENz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:55:28 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 5 Aug 2014 15:54:08 +0200
From: Johan Hovold <johan@kernel.org>
To: Wang YanQing <udknight@gmail.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, jhovold@gmail.com,
        andi@lisas.de, dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: Re: Resend Re: [PATCH v6] usb:serial:pl2303: add GPIOs interface on
 PL2303
Message-ID: <20140805135408.GD25529@localhost>
References: <20140729165709.GA3380@udknight>
 <20140804140032.GA25529@localhost>
 <20140804171536.GA2330@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804171536.GA2330@udknight>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 01:15:36AM +0800, Wang YanQing wrote:
> I change my system recently, and sendmail has trouble
> to send mails to kernel mail list, so I resend it 
> with my old system.

I got all three.

> Ok, before I send out next version, I still has some
> vague places, see below:
> 	
> On Mon, Aug 04, 2014 at 04:00:32PM +0200, Johan Hovold wrote:
> > > +config USB_SERIAL_PL2303_GPIO
> > > +	bool "USB Prolific 2303 Single Port GPIOs support"
> > > +	depends on USB_SERIAL_PL2303 && GPIOLIB
> > > +	---help---
> > > +	  Say Y here if you want to use the GPIOs on PL2303 USB Serial single port
> > > +	  adapter from Prolific.
> > > +
> > > +	  It supports 2 GPIOs on PL2303HX currently,
> > > +	  if unsure, say N.
> > 
> > You can drop the "unsure" bit (or at least split it into two sentences).
> 
> I don't understand here, what is your meaning?
> I add "if unsure, say N" to make checkpatch.pl happy,
> it seems like checkpatch.pl want at least two lines here.

If you just added it to make checkpatch happy, then you should
definitely remove it. It adds no value (and is not grammatically correct
as it stands as one sentence).

If you want you could extend the description and mention that these
GPIOs are only accessible on some serial-converters and that only two
out of four are currently supported, for example.

> > I noticed that setting direction to output and setting the gpio high has
> > no effect on the read-back value (i.e. I still read back 0) for my
> > pl2303hx (note that my device has no easily accessible gpios so I
> > haven't verified the actual state of the output pin).
> > 
> > What happens on your system? Is the read-back value still 0, even when
> > the GPIO output is actually high? Should we return the cached value in
> > this case?
> 
> If i set direction to output, then I could control gpio high and low
> by set 1 or 0, and the read-back value is 1 or 0 according to high and
> low(I test high and low by oscillscope)
> 
> I test it with my pl2303hx with only two gpios.
>
> Could you use usbmon to see whether the traffic is right according
> to comment in struct pl2303_gpio?

The traffic appears correct judging from the debug output (which I
trust). Output-enable is reflected in register 0x81, but the value
isn't.

What is the lsusb -v output for your device?

> > > +	spriv->gpio->index = 0x00;
> > > +	spriv->gpio->serial = serial;
> > > +
> > > +	mutex_lock(&gpiochip_lock);
> > > +	minor = idr_alloc(&gpiochip_minor, serial, 0, 0, GFP_KERNEL);
> > > +	if (minor < 0) {
> > > +		mutex_unlock(&gpiochip_lock);
> > > +		ret = minor;
> > > +		goto ERROR1;
> > > +	}
> > > +	spriv->gpio->minor = minor;
> > > +	mutex_unlock(&gpiochip_lock);
> > > +
> > > +	label = kasprintf(GFP_KERNEL, "pl2303-gpio%d",
> > > +			  spriv->gpio->minor);
> > > +	if (label == NULL) {
> > > +		ret = -ENOMEM;
> > > +		goto ERROR2;
> > > +	}
> > 
> > The id allocation and label generation is just overkill (if anything,
> > you'd want the generated name to include the interface name rather
> > than some new random number).
> > 
> > But as we can always find the parent device via sysfs, simply set the
> > label to "pl2303".
> I don't understand here, I want to fix we can't distinguish
> multi pl2303 gpios in kernel space, not userspace by different
> label name when there are more than one pl2303.

Ok, but why do you want to fix that? What is the use case? When would
you want to use such an unreliable (can go away anytime and hard to
match to a specific device) gpio chip for anything from within the
kernel (except possibly from the driver itself)?

> I find usb-serial use idr_alloc to manage minor, so I use it,
> I hope the label's name looks like below:
> pl2303-gpio0, pl2303-gpio1.

Yes, the usb-serial port minors are actually needed. (And you cannot
rely on them as they haven't been allocated yet when you initialise the
gpio chip).

> Because gpiolib could use label to find out specified gpio chio,
> then we could distinguish them by standard gpio interface, after
> acquire pl2303 gpio by different label name, we could test their
> parent device to make sure whether right one or not, and release
> it when not.

That just seems backwards. If there's a valid use case, we should have a
generic way to iterate over any gpio chips of the parent device instead.  

> With different label names, we could predict their name depend on
> fix usb bus scanning order in a fix hardare environment, then we could
> acquire "right" pl2303 gpio chip by pl2303-gpio0, pl2303-gpio1.

This will never be fully predictable. Userspace can always find the
right gpio based on chip serial number or similar, however.

I suggest you just set the label to pl2303 until we have a valid
use-case that requires something more elaborate.

Thanks,
Johan
