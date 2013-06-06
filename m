Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3FFOLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 10:11:47 -0400
Received: from mail.abilis.ch ([195.70.19.74]:13373 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab3FFOLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 10:11:45 -0400
Date: Thu, 6 Jun 2013 16:11:18 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Haojian Zhuang <haojian.zhuang@linaro.org>
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
Subject: Re: [PATCH 1/2] pinmux: Add TB10x pinmux driver
Message-ID: <20130606141115.GA10345@ab42.lan>
References: <518AAF31.8080502@wwwdotorg.org>
 <20130510082521.GA2125@ab42.lan>
 <51942472.9010402@wwwdotorg.org>
 <CACRpkdYtKr5w2=1sONG4Qn2TQue38nV7epWfzxNQz5rjSs0DZQ@mail.gmail.com>
 <20130522142824.GC4789@ab42.lan>
 <CAD6h2NT4FqmEsLvtTDwwDL2YVzXYNpw72hTOcSxSMvHLhWvFPQ@mail.gmail.com>
 <20130524115053.GB5203@ab42.lan>
 <CAD6h2NSh_4TNAGeFhg+va5QX2hGia+gkw-mPaeMezghsa=Zc6Q@mail.gmail.com>
 <20130603123001.GD31808@ab42.lan>
 <CAD6h2NQVKKvcoPdD4sm5rUM5G-FpF3abL=k+WfQsnKnm7qhREA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAD6h2NQVKKvcoPdD4sm5rUM5G-FpF3abL=k+WfQsnKnm7qhREA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 09:44:27AM +0800, Haojian Zhuang wrote:
> On 3 June 2013 20:30, Christian Ruppert <christian.ruppert@abilis.com> wrote:
> > OK, here's a simplified example of what we would like to do (this seems
> > pretty common so I suppose there is a way I haven't understood). Our
> > situation is slightly more complex but for the purpose of discussion
> > let's assume a chip with 8 pins which can be configured for the
> > following functions:
> >
> > Pin   GPIO-A    I2C    SPI0     SPI1
> > ------------------------------------
> >  1    GPIOA0    SDA             MISO1
> >  2    GPIOA1    SCL             MOSI1
> >  3    GPIOA2                    SS1_B
> >  4    GPIOA3                    SCLK1
> >  5    GPIOA4           MISO0
> >  6    GPIOA5           MOSI0
> >  7    GPIOA6           SS0_B
> >  8    GPIOA7           SCLK0
> >
> > We can now define the following pinctrl-single:
> >
> > pinmux: pinmux@0xFFEE0000 {
> >         compatible = "pinctrl-single";
> >         reg = <0xFFEE0000 0x8>;
> >         #address-cells = <1>;
> >         #size-cells = <0>;
> >         #gpio-range-cells = <3>;
> >         pinctrl-single,register-width = <32>;
> >         pinctrl-single,function-mask = <0xffffffff>;
> >         pinctrl-single,gpio-range = <&range 1 8 0>;
> >         gpioa_pins: pinmux_gpioa_pins {
> >                 pinctrl-single,pins = <0x0 0 0x4 0>
> >         };
> >         i2c_pins: pinmux_i2c_pins {
> >                 pinctrl-single,pins = <0x0 1>
> >         };
> >         spi0_pins: pinmux_spi0_pins {
> >                 pinctrl-single,pins = <0x1 1>
> <0x1 1>?
> 
> If each pinmux register is only for one pin in your SoC.
> I think that your definitions are wrong above. We use
> register offset as the first argument, not pin number.
> And the second argument should be pin function number.

In our case each pinmux register (bit field) actually controls an entire
group of pins.

> If multiple pins are sharing one register with different bits,
> you need to enable "pinctrl-single,bit-per-mux".

Multiple pins are sharing the same bits in the same register. Do you
think this prevents us from using pinctrl-single?

> >         };
> >         spi1_pins: pinmux_spi1_pins {
> >                 pinctrl-single,pins = <0x0 2>
> >         };
> >         range: gpio-range {
> >                 #pinctrl-single,gpio-range-cells = <3>;
> >         };
> > };
> > gpioa: gpio_a {
> >         /* ... */
> >         gpio-controller;
> >         gpio-ranges = <&pinmux 0 0 8>;
> > };
> >
> > How do I tell pinctrl-single that:
> > 1. I2C and SPI1 cannot be selected at the same time?
> You needn't. If the pin is gotten by I2C driver, SPI driver can't get
> this pin any more.

OK

> > 2. In case I2C is selected, GPIOA0 and GPIOA1 cannot be requested but
> >    GPIOA2 and GPIOA3 are available?
> I think that you have your own GPIO driver. At first, you need to
> define .request()
> & .free() in gpio chip.
> 
> If I2C function is only configured by bootloader & the pin isn't
> controlled by any
> driver, you can use gpio_request() directly to request this GPIO pin.
> 
> If the pin is controlled by I2C driver & you want to declare it as
> GPIO function in
> I2C driver, you can use gpio_request() directly. Then the pin function becomes
> GPIO.
> 
> If the pin is controlled by I2C driver & you want to declare it as
> GPIO function in
> other driver, you'll meet failure on requesting this pin.

This seems to be an issue for us. I think we'll keep pinctrl-single in
mind for the evaluation phase of future chips but in production we
definitely need to be able to use e.g. GPIOA2 from other drivers than
the I2C bus driver.

> > 3. In case SPI1 is selected GPIOA0-GPIOA3 are not available?
> Of course, you can set one pin with two function mode at the same time.
> 
> But you can switch it between SPI and GPIO mode in the same driver. I mentioned
> it in #2 by details.

OK

> > 4. In case SPI0 is selected GPIOA4-GPIOA7 are not available?
> Same #3.

OK

> > Exactly. This is what I'm wondering about in the example above. What
> > must I do to get a clear error message in case someone by mistake tries
> > the following in the above example:
> >
> > spi0: tb10x_spi0 {
> >         /* ... */
> >         pinctrl-names = "default";
> >         pinctrl-0 = <&spi0_pins>;
> > };
> > i2c: tb10x_i2c {
> >         /* ... */
> >         pinctrl-names = "default";
> >         pinctrl-0 = <&i2c_pins>;
> > };
> >
> > And the following:
> >
> > i2c: tb10x_i2c {
> >         /* ... */
> >         pinctrl-names = "default";
> >         pinctrl-0 = <&i2c_pins>;
> > };
> > some_external_component: ext_comp {
> >         /* ... */
> >         gpios = <&gpioa 0>;
> > };
> 
> Which kind of error message do you need? If you're concerning on pin conflict,
> you'll get it while kernel is running.

OK

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
