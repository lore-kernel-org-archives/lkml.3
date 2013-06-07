Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab3FGTSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:18:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56623 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab3FGTSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:18:39 -0400
Message-ID: <51B2320B.6060101@wwwdotorg.org>
Date: Fri, 07 Jun 2013 13:18:35 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>
CC: Haojian Zhuang <haojian.zhuang@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
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
References: <51942472.9010402@wwwdotorg.org> <CACRpkdYtKr5w2=1sONG4Qn2TQue38nV7epWfzxNQz5rjSs0DZQ@mail.gmail.com> <20130522142824.GC4789@ab42.lan> <CAD6h2NT4FqmEsLvtTDwwDL2YVzXYNpw72hTOcSxSMvHLhWvFPQ@mail.gmail.com> <20130524115053.GB5203@ab42.lan> <CAD6h2NSh_4TNAGeFhg+va5QX2hGia+gkw-mPaeMezghsa=Zc6Q@mail.gmail.com> <20130603123001.GD31808@ab42.lan> <CAD6h2NQVKKvcoPdD4sm5rUM5G-FpF3abL=k+WfQsnKnm7qhREA@mail.gmail.com> <20130606141115.GA10345@ab42.lan> <CAD6h2NRNMQP-ZQ0Cc613tGThVEo7AzRExBmWsbtr1DXgiPwz7w@mail.gmail.com> <20130606153030.GA19876@ab42.lan>
In-Reply-To: <20130606153030.GA19876@ab42.lan>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 09:30 AM, Christian Ruppert wrote:
> On Thu, Jun 06, 2013 at 10:32:21PM +0800, Haojian Zhuang wrote:
>> On 6 June 2013 22:11, Christian Ruppert <christian.ruppert@abilis.com> wrote:
>>> On Wed, Jun 05, 2013 at 09:44:27AM +0800, Haojian Zhuang wrote:
>>>> On 3 June 2013 20:30, Christian Ruppert <christian.ruppert@abilis.com> wrote:
>>>>> OK, here's a simplified example of what we would like to do (this seems
>>>>> pretty common so I suppose there is a way I haven't understood). Our
>>>>> situation is slightly more complex but for the purpose of discussion
>>>>> let's assume a chip with 8 pins which can be configured for the
>>>>> following functions:
>>>>>
>>>>> Pin   GPIO-A    I2C    SPI0     SPI1
>>>>> ------------------------------------
>>>>>  1    GPIOA0    SDA             MISO1
>>>>>  2    GPIOA1    SCL             MOSI1
>>>>>  3    GPIOA2                    SS1_B
>>>>>  4    GPIOA3                    SCLK1
>>>>>  5    GPIOA4           MISO0
>>>>>  6    GPIOA5           MOSI0
>>>>>  7    GPIOA6           SS0_B
>>>>>  8    GPIOA7           SCLK0
>>>>>
>>>>> We can now define the following pinctrl-single:
>>>>>
>>>>> pinmux: pinmux@0xFFEE0000 {
>>>>>         compatible = "pinctrl-single";
>>>>>         reg = <0xFFEE0000 0x8>;
>>>>>         #address-cells = <1>;
>>>>>         #size-cells = <0>;
>>>>>         #gpio-range-cells = <3>;
>>>>>         pinctrl-single,register-width = <32>;
>>>>>         pinctrl-single,function-mask = <0xffffffff>;
>>>>>         pinctrl-single,gpio-range = <&range 1 8 0>;
>>>>>         gpioa_pins: pinmux_gpioa_pins {
>>>>>                 pinctrl-single,pins = <0x0 0 0x4 0>
>>>>>         };
>>>>>         i2c_pins: pinmux_i2c_pins {
>>>>>                 pinctrl-single,pins = <0x0 1>
>>>>>         };
>>>>>         spi0_pins: pinmux_spi0_pins {
>>>>>                 pinctrl-single,pins = <0x1 1>
>>>> <0x1 1>?
>>>>
>>>> If each pinmux register is only for one pin in your SoC.
>>>> I think that your definitions are wrong above. We use
>>>> register offset as the first argument, not pin number.
>>>> And the second argument should be pin function number.
>>>
>>> In our case each pinmux register (bit field) actually controls an entire
>>> group of pins.
>>>
>>>> If multiple pins are sharing one register with different bits,
>>>> you need to enable "pinctrl-single,bit-per-mux".
>>>
>>> Multiple pins are sharing the same bits in the same register. Do you
>>> think this prevents us from using pinctrl-single?
>>>
>> Could you give me your register definition? Then I can understand you
>> better.
> 
> In our example, the register map would look a bit like the following.
> Note that every register configures four pins at a time.
> 
> Register 0x0:
>  Mode  GPIO-A    I2C    SPI1
>  Value 0x0       0x1    0x2
>  ---------------------------
>  Pin1  GPIOA0    SDA    MISO1
>  Pin2  GPIOA1    SCL    MOSI1
>  Pin3  GPIOA2           SS1_B
>  Pin4  GPIOA3           SCLK1
> 
> Register 0x4:
>  Mode  GPIO-A    SPI0
>  Value 0x0       0x1
>  ---------------------
>  Pin5  GPIOA4    MISO0
>  Pin6  GPIOA5    MOSI0
>  Pin7  GPIOA6    SS0_B
>  Pin8  GPIOA7    SCLK0

My suggestion here is that pinctrl-single isn't appropriate. The only
way it could work is if you pretend that each group-of-pins is actually
a single pin.

However, then the correlation between these pretend pins (i.e. really
the groups) and GPIOs won't work, because each "pin" is really 4 pins,
and hence 4 GPIOs, and hence you won't be able to gpio_get() more than 1
GPIO per pin group, I think.

It's not hard (although possibly data intensive depending on your SoC)
to represent your HW just fine with a native pinctrl driver; pinctrl
itself has the ability to separate the concepts of pins, groups-of-pins,
and the mux-functions-that-are-assigned-to-groups. If any of your HW
registers actually do control only a single pin, you can simply create
both a pin and a group that contains only that one pin. This is all very
similar to how Tegra works, although it sounds like your registers may
be a bit more regular than Tegras - Tegra has a very variable number of
pins in each grop, and even some overlap between groups (mux function
groups and pin configuration groups aren't aligned).
