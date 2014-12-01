Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbaLAOfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 09:35:04 -0500
Received: from mail-oi0-f45.google.com ([209.85.218.45]:60404 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbaLAOfA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 09:35:00 -0500
MIME-Version: 1.0
In-Reply-To: <1417423043.4055.14.camel@AMDC1943>
References: <1417011857-10419-1-git-send-email-k.kozlowski@samsung.com>
	<1417011857-10419-4-git-send-email-k.kozlowski@samsung.com>
	<CACRpkdb8F8YcvFeHPvOKHjx_p4HEpimck3XRabB3oHpZTdmRQQ@mail.gmail.com>
	<1417183724.18249.36.camel@AMDC1943>
	<CA+Ln22Ejo51VPWf6DmuRvV_fZr_H=-BXAshSPSOokNE1bz=-QA@mail.gmail.com>
	<1417423043.4055.14.camel@AMDC1943>
Date: Mon, 1 Dec 2014 23:34:59 +0900
Message-ID: <CA+Ln22H_a9CWxrYO_i9Esm6keXA8XLLYmE1Vg-8ynamJ1sAwpQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] pinctrl: exynos: Fix GPIO setup failure because
 domain clock being gated
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-01 17:37 GMT+09:00 Krzysztof Kozlowski <k.kozlowski@samsung.com>:
>
> On nie, 2014-11-30 at 21:19 +0900, Tomasz Figa wrote:
>> Hi Krzysztof,
>>
>> 2014-11-28 23:08 GMT+09:00 Krzysztof Kozlowski <k.kozlowski@samsung.com>:
>> > On pią, 2014-11-28 at 15:04 +0100, Linus Walleij wrote:
>> >> On Wed, Nov 26, 2014 at 3:24 PM, Krzysztof Kozlowski
>> >> <k.kozlowski@samsung.com> wrote:
>> >>
>> >> > The audio subsystem on Exynos 5420 has separate clocks and GPIO. To
>> >> > operate properly on GPIOs the main block clock 'mau_epll' must be
>> >> > enabled.
>> >> >
>> >> > This was observed on Peach Pi/Pit and Arndale Octa (after enabling i2s0)
>> >> > after introducing runtime PM to pl330 DMA driver. After that commit the
>> >> > 'mau_epll' was gated, because the "amba" clock was disabled and there
>> >> > were no more users of mau_epll.
>> >> >
>> >> > The system hang just before probing i2s0 because
>> >> > samsung_pinmux_setup() tried to access memory from audss block which was
>> >> > gated.
>> >> >
>> >> > Add a clock property to the pinctrl driver and enable the clock during
>> >> > GPIO setup. During normal GPIO operations (set, get, set_direction) the
>> >> > clock is not enabled.
>>
>> Could you make sure that possibility of gating this clock is worth the
>> effort of adding gating code to all affected drivers? If there is no
>> significant change in power consumption maybe it could be simply keep
>> running all the time?
>
> I had an impression that last time you disliked such idea:
> http://www.spinics.net/lists/arm-kernel/msg338127.html
> That's why I developed these patches. Because keeping a clock always on,
> even when it is unused, is undesirable.

I was mostly concerned about the particular solution implemented by
that patch that kept the clocks enabled on all platforms, not only the
affected one. However...

>
> Anyway, I did some simple measurements (after booting Arndale Octa
> to /bin/sh, idle):
>  - with mau_epll gated: ~523 mA
>  - with mau_epll always on: ~531 mA
>
> Keeping it on increases energy usage by 1.5% in idle (with measurement
> uncertainty ~0.4%).
>

...this definitely shows that the effort isn't worthless, which means
that your patch goes in the right direction.

>
>> Also isn't a similar problem happening due to power domains? I believe
>> the whole maudio block is located in a separate power domain but
>> somehow it doesn't get turned off?
>
> There is Maudio power domain... but I think it is not related here.

Could you somehow check what happens when the maudio power domain is
turned off and maudio pin controller is accessed? Could you also check
the difference in power consumption with this domain powered on and
off?

> Pinctrl driver does not have runtime PM and is not attached to a domain.
> I thought about other solution to this problem (with utilization of
> power domains):
>  - add runtime PM to pinctrl and audss clocks,
>  - attach pinctrl and audss clocks to maudio power domain,
>  - enable the clock when power domain is turned on.
> However almost the same changes had to be added to pinctrl and audss
> clocks drivers (replace clock_enable() with pm_runtime_get_sync()).

Well, if the dependency is there due to hardware design, I think it
needs to be reflected in the drivers as well.

Few other issues that came to my mind:

 - Your previous patch added clock control only to pinctrl operations.
Shouldn't GPIO operations be included as well?

 - If power domain dependency is there too, what happens with GPIO
pins if the domain is powered off? If they lose their states, wouldn't
it necessary to keep the domain powered on whenever there is some GPIO
pin requested (which usually = in use)? (I'd assume that special
functions shouldn't take a reference on runtime PM, because they are
related to IP blocks in the same PM domain, which will implicitly keep
the domain powered on.)

 - Doesn't the clock controller also lose its state whenever the power
domain is powered off? I guess that would be similar to ISP clock
controller, issues of which are still not resolved in mainline.
Sylwester could tell you more about this, I guess.

Best regards,
Tomasz
