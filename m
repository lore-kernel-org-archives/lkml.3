Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab3EWHna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 03:43:30 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:54272 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211Ab3EWHn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 03:43:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130522142824.GC4789@ab42.lan>
References: <20130418090310.GA17636@ab42.lan>
	<CACRpkdZd0_W432od5565phhUcJMRWiV9vXX4QVF4osKkxstC0Q@mail.gmail.com>
	<20130429161725.GB30136@ab42.lan>
	<5182B557.4040804@wwwdotorg.org>
	<CACRpkdaxO0q_P2wJFy3zv4F-QM9dZk54qW8ft350XqcBt1Gr1w@mail.gmail.com>
	<20130508164123.GA10248@ab42.lan>
	<518AAF31.8080502@wwwdotorg.org>
	<20130510082521.GA2125@ab42.lan>
	<51942472.9010402@wwwdotorg.org>
	<CACRpkdYtKr5w2=1sONG4Qn2TQue38nV7epWfzxNQz5rjSs0DZQ@mail.gmail.com>
	<20130522142824.GC4789@ab42.lan>
Date: Thu, 23 May 2013 15:43:27 +0800
Message-ID: <CAD6h2NT4FqmEsLvtTDwwDL2YVzXYNpw72hTOcSxSMvHLhWvFPQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinmux: Add TB10x pinmux driver
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 May 2013 22:28, Christian Ruppert <christian.ruppert@abilis.com> wrote:
>
> On Mon, May 20, 2013 at 10:10:33AM +0200, Linus Walleij wrote:
> > On Thu, May 16, 2013 at 2:12 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> > > On 05/10/2013 02:25 AM, Christian Ruppert wrote:
> >
> > >> (*1) TB100 GPIO ranges are defined as a phandle to the I/O function
> > >>      which provides all pins of a given GPIO port. This function is not
> > >>      necessarily requested from pinctrl and GPIO ports may overlap with
> > >>      other functions. The pin controller knows about this and provides
> > >>      whatever GPIO pin is available after mapping other requested
> > >>      functions.
> > >> (*2) Here, the entire GPIOB port is explicitly requested by the GPIO
> > >>      module, i.e. all pins of the port are made available as GPIOs.
> > >
> > > So I think all you're looking for is a way in DT to represent GPIO
> > > ranges? I don't think that should be by string name, but rather numbers:
> > >
> > > (actually, doesn't pinctrl-simple already have this?)
> >
> > Now I'm ever more confused ... we already have this :-)
> >
> > It's not even pinctrl-simple-centric it is completely generic.
> > The code is in drivers/gpio/gpiolib-of.c.
> >
> > It was written by Shiraz Hashin and Haojian Zhuang.
> > At the time I augmented the core code quite a bit to make
> > a good fit.
>
> I agree. Unluckily, it uses pinctrl-internal pin numbering which we
> would have to make coherent with the physical pin numbers of the
> individual packaging variants of the chip in order to expose them to
> customers (see my previous mail at https://lkml.org/lkml/2013/5/22/207).
>
> Adapting the kernel-internal pin numbering in function of the product
> variant doesn't seem such a good idea to me: All pin groups etc. will
> have to be redefined for every product, a huge source of bugs and
> unnecessary static data within the drivers.
>I review two methods you mentioned in this mail.

I think that you want to keep the logic simple. If so, I prefer you can
check pinctrl-single driver first. All pins are defined in DTS instead.

Here's the sample on Hi3620 SoC. And some pins even share one pinctrl
registers.

gpio controller:
                        gpio-ranges = < &pmx0 3 94 1 &pmx0 7 96 1>;
Each gpio pins in gpio controller could trace to the pin controller.

pin controller:
                        pinctrl-single,gpio-range = <&range 0 3 0 &range 3 9 1
                                                &range 12 1 0 &range 13 29 1
                                                &range 43 1 0 &range 44 49 1
                                                &range 94 1 1 &range 96 2 1>;

                        range: gpio-range {
                                #pinctrl-single,gpio-range-cells = <3>;
                        };
If the pin could be configured as GPIO mode, we could trace to the
gpio controller by this table. We can see those pins are not continuous,
and it doesn't matter. And it could handle the relations between
multiple gpio controllers and multiple pin controllers.

These pin numbers are only used to bind GPIO number. Customers
needn't to know the details. The device driver only set the pins to
right mode (GPIO or any other) with right configuration. The device
driver even needn't know the GPIO number and the pin number.
Because everything is already handled. They only need the pinctrl
array. I prefer you to check drivers/tty/serial/amba-pl011.c.

In some SoC, both pin26 & pin104 could be configured as GPIO3.
We only need to define one in your DTS because only one could
be effect in the real world.

And we abstract pin number from the register offset. You also needn't
worry the pin name such as AA1, AB1. Those names are used to
communicate with hardware guys, not software guys.

If you want to redefine the pin groups because they're used as LCD pins,
not MMC pins any more. You needn't have to modify the pin arrays in
your pinctrl driver anymore. Because pinctrl-single driver don't define
any pin arrays. You can only define pin arrays in your DTS file.

Is it helpful to you?

Regards
Haojian
