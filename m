Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab3EVO24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:28:56 -0400
Received: from mail.abilis.ch ([195.70.19.74]:27273 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106Ab3EVO2z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:28:55 -0400
Date: Wed, 22 May 2013 16:28:26 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
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
Subject: Re: [PATCH 1/2] pinmux: Add TB10x pinmux driver
Message-ID: <20130522142824.GC4789@ab42.lan>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CACRpkdYtKr5w2=1sONG4Qn2TQue38nV7epWfzxNQz5rjSs0DZQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 10:10:33AM +0200, Linus Walleij wrote:
> On Thu, May 16, 2013 at 2:12 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> > On 05/10/2013 02:25 AM, Christian Ruppert wrote:
> 
> >> (*1) TB100 GPIO ranges are defined as a phandle to the I/O function
> >>      which provides all pins of a given GPIO port. This function is not
> >>      necessarily requested from pinctrl and GPIO ports may overlap with
> >>      other functions. The pin controller knows about this and provides
> >>      whatever GPIO pin is available after mapping other requested
> >>      functions.
> >> (*2) Here, the entire GPIOB port is explicitly requested by the GPIO
> >>      module, i.e. all pins of the port are made available as GPIOs.
> >
> > So I think all you're looking for is a way in DT to represent GPIO
> > ranges? I don't think that should be by string name, but rather numbers:
> >
> > (actually, doesn't pinctrl-simple already have this?)
> 
> Now I'm ever more confused ... we already have this :-)
> 
> It's not even pinctrl-simple-centric it is completely generic.
> The code is in drivers/gpio/gpiolib-of.c.
> 
> It was written by Shiraz Hashin and Haojian Zhuang.
> At the time I augmented the core code quite a bit to make
> a good fit.

I agree. Unluckily, it uses pinctrl-internal pin numbering which we
would have to make coherent with the physical pin numbers of the
individual packaging variants of the chip in order to expose them to
customers (see my previous mail at https://lkml.org/lkml/2013/5/22/207).

Adapting the kernel-internal pin numbering in function of the product
variant doesn't seem such a good idea to me: All pin groups etc. will
have to be redefined for every product, a huge source of bugs and
unnecessary static data within the drivers.

> This is from:
> Documentation/devicetree/bindings/gpio/gpio.txt
> 
> 2.1) gpio-controller and pinctrl subsystem
> ------------------------------------------
> 
> gpio-controller on a SOC might be tightly coupled with the pinctrl
> subsystem, in the sense that the pins can be used by other functions
> together with optional gpio feature.
> 
> While the pin allocation is totally managed by the pin ctrl subsystem,
> gpio (under gpiolib) is still maintained by gpio drivers. It may happen
> that different pin ranges in a SoC is managed by different gpio drivers.
> 
> This makes it logical to let gpio drivers announce their pin ranges to
> the pin ctrl subsystem and call 'pinctrl_request_gpio' in order to
> request the corresponding pin before any gpio usage.
> 
> For this, the gpio controller can use a pinctrl phandle and pins to
> announce the pinrange to the pin ctrl subsystem. For example,
> 
>         qe_pio_e: gpio-controller@1460 {
>                 #gpio-cells = <2>;
>                 compatible = "fsl,qe-pario-bank-e", "fsl,qe-pario-bank";
>                 reg = <0x1460 0x18>;
>                 gpio-controller;
>                 gpio-ranges = <&pinctrl1 0 20 10>, <&pinctrl2 10 50 20>;
> 
>     }
> 
> where,
>    &pinctrl1 and &pinctrl2 is the phandle to the pinctrl DT node.
> 
>    Next values specify the base pin and number of pins for the range
>    handled by 'qe_pio_e' gpio. In the given example from base pin 20 to
>    pin 29 under pinctrl1 with gpio offset 0 and pin 50 to pin 69 under
>    pinctrl2 with gpio offset 10 is handled by this gpio controller.
> 
> The pinctrl node must have "#gpio-range-cells" property to show number of
> arguments to pass with phandle from gpio controllers node.
> 
> Yours,
> Linus Walleij

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
