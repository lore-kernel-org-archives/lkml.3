Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbaD1TWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:22:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52035 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753127AbaD1TWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:22:51 -0400
Message-ID: <535E8F68.7040206@free-electrons.com>
Date: Mon, 28 Apr 2014 19:27:04 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>
CC: =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin <kevin@allwinnertech.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        devicetree <devicetree@vger.kernel.org>, linux-doc@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, dev <dev@linux-sunxi.org>
Subject: Re: [PATCH 7/7] ARM: sunxi: dt: add PRCM clk and reset controller
 subdevices
References: <1398697130-8338-1-git-send-email-boris.brezillon@free-electrons.com> <1398697130-8338-8-git-send-email-boris.brezillon@free-electrons.com> <CAGb2v67GnW_ziDMjg6zObCAHZrHppGzP=+-VhpWet-NaAzx-Fg@mail.gmail.com>
In-Reply-To: <CAGb2v67GnW_ziDMjg6zObCAHZrHppGzP=+-VhpWet-NaAzx-Fg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 28/04/2014 18:02, Chen-Yu Tsai wrote:
> Hi,
>
> On Mon, Apr 28, 2014 at 10:58 PM, Boris BREZILLON
> <boris.brezillon@free-electrons.com> wrote:
>> Add DT definitions for PRCM (Power/Reset/Clock Management) clock and reset
>> controller subdevices.
>>
>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> ---
>>  arch/arm/boot/dts/sun6i-a31.dtsi | 49 ++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 49 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
>> index ec3253a..83a1634 100644
>> --- a/arch/arm/boot/dts/sun6i-a31.dtsi
>> +++ b/arch/arm/boot/dts/sun6i-a31.dtsi
>> @@ -501,6 +501,55 @@
>>                 prcm@01f01c00 {
> Seems the address here was wrong to start with.

Absolutely, I'll fix it.

>
>>                         compatible = "allwinner,sun6i-a31-prcm";
>>                         reg = <0x01f01400 0x200>;
>> +
>> +                       ar100_mux: ar100_mux {
> Might we use clk@01f01XXX for the names of the clock nodes?

Actually, I had a discussion with Maxime, and we decided to remove the
address suffix because the PRCM block is not a bus, and thus should not
have child node with addresses.
But I'm not a DT binding expert (it might be acceptable to define child
nodes with addresses even when the parent is not a bus :-)).
Advices from DT maintainers on that specific point would be great.

Best Regards,

Boris

>> +                               compatible = "allwinner,sun6i-a31-ar100-mux-clk";
>> +                               #clock-cells = <0>;
>> +                               clocks = <&osc32k>, <&osc24M>, <&pll6>, <&pll6>;
>> +                       };
>> +
>> +                       ar100: ar100 {
>> +                               compatible = "allwinner,sun6i-a31-ar100-clk";
>> +                               #clock-cells = <0>;
>> +                               clocks = <&ar100_mux>;
>> +                       };
>> +
>> +                       ar100_div: ar100_div {
>> +                               compatible = "allwinner,sun6i-a31-ar100-div-clk";
>> +                               #clock-cells = <0>;
>> +                               clocks = <&ar100>;
>> +                       };
>> +
>> +                       ahb0: ahb0 {
>> +                               compatible = "fixed-factor-clock";
>> +                               #clock-cells = <0>;
>> +                               clock-div = <1>;
>> +                               clock-mult = <1>;
>> +                               clocks = <&ar100_div>;
>> +                               clock-output-names = "ahb0";
>> +                       };
>> +
>> +                       apb0: apb0 {
>> +                               compatible = "allwinner,sun6i-a31-apb0-clk";
>> +                               #clock-cells = <0>;
>> +                               clocks = <&ahb0>;
>> +                               clock-output-names = "apb0";
>> +                       };
>> +
>> +                       apb0_gates: apb0_gates {
>> +                               compatible = "allwinner,sun6i-a31-apb0-gates-clk";
>> +                               #clock-cells = <1>;
>> +                               clocks = <&apb0>;
>> +                               clock-output-names = "apb0_pio", "apb0_ir",
>> +                                               "apb0_timer01", "apb0_p2wi",
>> +                                               "apb0_uart", "apb0_1wire",
>> +                                               "apb0_i2c";
>> +                       };
>> +
>> +                       apb0_rst: apb0_rst {
> Also use reset@01f01XXX here?
>
>> +                               compatible = "allwinner,sun6i-a31-clock-reset";
>> +                               #reset-cells = <1>;
>> +                       };
>>                 };
>>         };
>>  };
> Thanks!
>
> ChenYu

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

