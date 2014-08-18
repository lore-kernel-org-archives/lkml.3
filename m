Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbaHRKCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:02:25 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:41862 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbaHRKCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 06:02:22 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 18 Aug 2014 12:00:50 +0200
From: Johan Hovold <johan@kernel.org>
To: Wang YanQing <udknight@gmail.com>
Cc: Johan Hovold <johan@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        gregkh@linuxfoundation.org, jhovold@gmail.com, andi@lisas.de,
        dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7] usb:serial:pl2303: add GPIOs interface on PL2303
Message-ID: <20140818100050.GE31755@localhost>
References: <20140809052828.GA28307@udknight>
 <20140812144625.GB9799@localhost>
 <20140817010432.GA2907@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140817010432.GA2907@localhost.localdomain>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2014 at 09:04:32AM +0800, Wang YanQing wrote:
> On Tue, Aug 12, 2014 at 04:46:25PM +0200, Johan Hovold wrote:
> > On Sat, Aug 09, 2014 at 01:28:28PM +0800, Wang YanQing wrote:
> > > PL2303 USB Serial devices always has GPIOs,
> > 
> > Always? Are you sure? It's probably better to write "might have" as they
> > are unlikely to be accessible even if the pins exist.
> http://prolificusa.com/docs/2303/all/an_PL2303_GPIO_LED_Indicator_v1.0.pdf
> 
> "All of the PL2303 chips aside from PL2303HXD have two dedicated GPIO
> pins (GP0 and GP1) while PL2303HXD have four GPIO pins (GP0, GP1, GP2,
> GP3)."

That's true for the HX family (when the document was written), but for
example the PL2303SA has none.

> > >  enum pl2303_type {
> > >  	TYPE_01,	/* Type 0 and 1 (difference unknown) */
> > > @@ -141,11 +145,15 @@ enum pl2303_type {
> > >  struct pl2303_type_data {
> > >  	speed_t max_baud_rate;
> > >  	unsigned long quirks;
> > > +	u16 ngpio;
> > 
> > u8 should be enough.
> 
> Yes, but struct gpio_chip use u16, so maybe u16 is better?.

Not really, unless you foresee pl2303 device with more than 256 GPIOs. ;)
And even then the type could have been changed later. It's just static
type data so it really does not make much difference, but still.

> > > +	int (*gpio_startup)(struct usb_serial *serial);
> > > +	void (*gpio_release)(struct usb_serial *serial);
> > 
> > This isn't the right place for this abstraction. Most of the setup code
> > would be common for any device type with GPIOs.
> 
> For any pl2303 variant instead of any device type ?

Yes, I meant pl2303 device type.

> > Just keep the generic gpio_startup and release from v6, and verify that
> > ngpio > 0. Any further abstraction should only be added once we know how
> > the other types handles GPIOs.
> > 
> > >  };
> > >  
> > >  struct pl2303_serial_private {
> > >  	const struct pl2303_type_data *type;
> > >  	unsigned long quirks;
> > > +	void *gpio;
> > 
> > No void pointers, please.
> 
> void pointer is abstraction for different pl2303 gpio_data struct,
> just like driver core or subsystem core does. I mean void pointer is
> right thing when we need abstraction, and we don't need type-specified
> startup|release, we don't need this void pointer.

You gonna have to store the gpio state somewhere. And it should be done
in a struct of some specific sort just as in your previous versions. Use
forward declarations, or compile guards, if that's what you need.

> > > +
> > > +static int pl2303hx_gpio_direction_in(struct gpio_chip *chip, unsigned offset)
> > > +{
> > > +	struct pl2303hx_gpio_data *gpio = to_pl2303hx_gpio_data(chip);
> > > +	int ret;
> > > +
> > > +	mutex_lock(&gpio->lock);
> > > +	gpio->index &= ~pl2303hx_gpio_dir_mask(offset);
> > > +	ret = pl2303_vendor_write(gpio->serial, PL2303HX_REG_GPIO_CONTROL, gpio->index);
> > 
> > This line is too long.
> > 
> > Apparently you did not run checkpatch on v7 because there are a whole
> > bunch of warning and errors now.
> 
> Yes, I haven't run checkpatch on v7, I will do it on v8 if there is one.
> 
> > > +static void pl2303hx_gpio_release(struct usb_serial *serial)
> > > +{
> > > +	struct pl2303_serial_private *spriv = usb_get_serial_data(serial);
> > > +	struct pl2303hx_gpio_data *gpio = (struct pl2303hx_gpio_data *)spriv->gpio;
> > > +
> > > +	gpiochip_remove(&gpio->gpio_chip);
> > 
> > So this will corrupt the gpiolib structures if there are requested /
> > exported gpios.
> 
> We can do nothing here, indeed we must call gpiochip_remove to notify 
> gpio layer our leave, and hope gpio layer could handle it.

I'm not saying that you should do something different here. But I'm
hesitant of merging this functionality before gpiolib is fixed.

Johan
