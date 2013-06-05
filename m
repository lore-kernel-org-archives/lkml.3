Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab3FEBoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 21:44:30 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:39395 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab3FEBo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 21:44:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130603123001.GD31808@ab42.lan>
References: <CACRpkdaxO0q_P2wJFy3zv4F-QM9dZk54qW8ft350XqcBt1Gr1w@mail.gmail.com>
	<20130508164123.GA10248@ab42.lan>
	<518AAF31.8080502@wwwdotorg.org>
	<20130510082521.GA2125@ab42.lan>
	<51942472.9010402@wwwdotorg.org>
	<CACRpkdYtKr5w2=1sONG4Qn2TQue38nV7epWfzxNQz5rjSs0DZQ@mail.gmail.com>
	<20130522142824.GC4789@ab42.lan>
	<CAD6h2NT4FqmEsLvtTDwwDL2YVzXYNpw72hTOcSxSMvHLhWvFPQ@mail.gmail.com>
	<20130524115053.GB5203@ab42.lan>
	<CAD6h2NSh_4TNAGeFhg+va5QX2hGia+gkw-mPaeMezghsa=Zc6Q@mail.gmail.com>
	<20130603123001.GD31808@ab42.lan>
Date: Wed, 5 Jun 2013 09:44:27 +0800
Message-ID: <CAD6h2NQVKKvcoPdD4sm5rUM5G-FpF3abL=k+WfQsnKnm7qhREA@mail.gmail.com>
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

On 3 June 2013 20:30, Christian Ruppert <christian.ruppert@abilis.com> wrote:
> OK, here's a simplified example of what we would like to do (this seems
> pretty common so I suppose there is a way I haven't understood). Our
> situation is slightly more complex but for the purpose of discussion
> let's assume a chip with 8 pins which can be configured for the
> following functions:
>
> Pin   GPIO-A    I2C    SPI0     SPI1
> ------------------------------------
>  1    GPIOA0    SDA             MISO1
>  2    GPIOA1    SCL             MOSI1
>  3    GPIOA2                    SS1_B
>  4    GPIOA3                    SCLK1
>  5    GPIOA4           MISO0
>  6    GPIOA5           MOSI0
>  7    GPIOA6           SS0_B
>  8    GPIOA7           SCLK0
>
> We can now define the following pinctrl-single:
>
> pinmux: pinmux@0xFFEE0000 {
>         compatible = "pinctrl-single";
>         reg = <0xFFEE0000 0x8>;
>         #address-cells = <1>;
>         #size-cells = <0>;
>         #gpio-range-cells = <3>;
>         pinctrl-single,register-width = <32>;
>         pinctrl-single,function-mask = <0xffffffff>;
>         pinctrl-single,gpio-range = <&range 1 8 0>;
>         gpioa_pins: pinmux_gpioa_pins {
>                 pinctrl-single,pins = <0x0 0 0x4 0>
>         };
>         i2c_pins: pinmux_i2c_pins {
>                 pinctrl-single,pins = <0x0 1>
>         };
>         spi0_pins: pinmux_spi0_pins {
>                 pinctrl-single,pins = <0x1 1>
<0x1 1>?

If each pinmux register is only for one pin in your SoC.
I think that your definitions are wrong above. We use
register offset as the first argument, not pin number.
And the second argument should be pin function number.

If multiple pins are sharing one register with different bits,
you need to enable "pinctrl-single,bit-per-mux".

>         };
>         spi1_pins: pinmux_spi1_pins {
>                 pinctrl-single,pins = <0x0 2>
>         };
>         range: gpio-range {
>                 #pinctrl-single,gpio-range-cells = <3>;
>         };
> };
> gpioa: gpio_a {
>         /* ... */
>         gpio-controller;
>         gpio-ranges = <&pinmux 0 0 8>;
> };
>
> How do I tell pinctrl-single that:
> 1. I2C and SPI1 cannot be selected at the same time?
You needn't. If the pin is gotten by I2C driver, SPI driver can't get
this pin any more.

> 2. In case I2C is selected, GPIOA0 and GPIOA1 cannot be requested but
>    GPIOA2 and GPIOA3 are available?
I think that you have your own GPIO driver. At first, you need to
define .request()
& .free() in gpio chip.

If I2C function is only configured by bootloader & the pin isn't
controlled by any
driver, you can use gpio_request() directly to request this GPIO pin.

If the pin is controlled by I2C driver & you want to declare it as
GPIO function in
I2C driver, you can use gpio_request() directly. Then the pin function becomes
GPIO.

If the pin is controlled by I2C driver & you want to declare it as
GPIO function in
other driver, you'll meet failure on requesting this pin.

> 3. In case SPI1 is selected GPIOA0-GPIOA3 are not available?
Of course, you can set one pin with two function mode at the same time.

But you can switch it between SPI and GPIO mode in the same driver. I mentioned
it in #2 by details.

> 4. In case SPI0 is selected GPIOA4-GPIOA7 are not available?
Same #3.

>
>
> Exactly. This is what I'm wondering about in the example above. What
> must I do to get a clear error message in case someone by mistake tries
> the following in the above example:
>
> spi0: tb10x_spi0 {
>         /* ... */
>         pinctrl-names = "default";
>         pinctrl-0 = <&spi0_pins>;
> };
> i2c: tb10x_i2c {
>         /* ... */
>         pinctrl-names = "default";
>         pinctrl-0 = <&i2c_pins>;
> };
>
> And the following:
>
> i2c: tb10x_i2c {
>         /* ... */
>         pinctrl-names = "default";
>         pinctrl-0 = <&i2c_pins>;
> };
> some_external_component: ext_comp {
>         /* ... */
>         gpios = <&gpioa 0>;
> };

Which kind of error message do you need? If you're concerning on pin conflict,
you'll get it while kernel is running.
