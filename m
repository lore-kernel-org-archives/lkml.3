Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab3ETIKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 04:10:37 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:52412 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab3ETIKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 04:10:34 -0400
MIME-Version: 1.0
In-Reply-To: <51942472.9010402@wwwdotorg.org>
References: <1365608728-30494-1-git-send-email-christian.ruppert@abilis.com>
	<516EEAA0.10906@wwwdotorg.org>
	<20130418090310.GA17636@ab42.lan>
	<CACRpkdZd0_W432od5565phhUcJMRWiV9vXX4QVF4osKkxstC0Q@mail.gmail.com>
	<20130429161725.GB30136@ab42.lan>
	<5182B557.4040804@wwwdotorg.org>
	<CACRpkdaxO0q_P2wJFy3zv4F-QM9dZk54qW8ft350XqcBt1Gr1w@mail.gmail.com>
	<20130508164123.GA10248@ab42.lan>
	<518AAF31.8080502@wwwdotorg.org>
	<20130510082521.GA2125@ab42.lan>
	<51942472.9010402@wwwdotorg.org>
Date: Mon, 20 May 2013 10:10:33 +0200
Message-ID: <CACRpkdYtKr5w2=1sONG4Qn2TQue38nV7epWfzxNQz5rjSs0DZQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinmux: Add TB10x pinmux driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>
Cc: Christian Ruppert <christian.ruppert@abilis.com>,
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

On Thu, May 16, 2013 at 2:12 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/10/2013 02:25 AM, Christian Ruppert wrote:

>> (*1) TB100 GPIO ranges are defined as a phandle to the I/O function
>>      which provides all pins of a given GPIO port. This function is not
>>      necessarily requested from pinctrl and GPIO ports may overlap with
>>      other functions. The pin controller knows about this and provides
>>      whatever GPIO pin is available after mapping other requested
>>      functions.
>> (*2) Here, the entire GPIOB port is explicitly requested by the GPIO
>>      module, i.e. all pins of the port are made available as GPIOs.
>
> So I think all you're looking for is a way in DT to represent GPIO
> ranges? I don't think that should be by string name, but rather numbers:
>
> (actually, doesn't pinctrl-simple already have this?)

Now I'm ever more confused ... we already have this :-)

It's not even pinctrl-simple-centric it is completely generic.
The code is in drivers/gpio/gpiolib-of.c.

It was written by Shiraz Hashin and Haojian Zhuang.
At the time I augmented the core code quite a bit to make
a good fit.

This is from:
Documentation/devicetree/bindings/gpio/gpio.txt

2.1) gpio-controller and pinctrl subsystem
------------------------------------------

gpio-controller on a SOC might be tightly coupled with the pinctrl
subsystem, in the sense that the pins can be used by other functions
together with optional gpio feature.

While the pin allocation is totally managed by the pin ctrl subsystem,
gpio (under gpiolib) is still maintained by gpio drivers. It may happen
that different pin ranges in a SoC is managed by different gpio drivers.

This makes it logical to let gpio drivers announce their pin ranges to
the pin ctrl subsystem and call 'pinctrl_request_gpio' in order to
request the corresponding pin before any gpio usage.

For this, the gpio controller can use a pinctrl phandle and pins to
announce the pinrange to the pin ctrl subsystem. For example,

        qe_pio_e: gpio-controller@1460 {
                #gpio-cells = <2>;
                compatible = "fsl,qe-pario-bank-e", "fsl,qe-pario-bank";
                reg = <0x1460 0x18>;
                gpio-controller;
                gpio-ranges = <&pinctrl1 0 20 10>, <&pinctrl2 10 50 20>;

    }

where,
   &pinctrl1 and &pinctrl2 is the phandle to the pinctrl DT node.

   Next values specify the base pin and number of pins for the range
   handled by 'qe_pio_e' gpio. In the given example from base pin 20 to
   pin 29 under pinctrl1 with gpio offset 0 and pin 50 to pin 69 under
   pinctrl2 with gpio offset 10 is handled by this gpio controller.

The pinctrl node must have "#gpio-range-cells" property to show number of
arguments to pass with phandle from gpio controllers node.

Yours,
Linus Walleij
