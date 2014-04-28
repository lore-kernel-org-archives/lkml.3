Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222AbaD1Txq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:53:46 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:50564 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933074AbaD1Txi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:53:38 -0400
MIME-Version: 1.0
In-Reply-To: <535E8F68.7040206@free-electrons.com>
References: <1398697130-8338-1-git-send-email-boris.brezillon@free-electrons.com>
 <1398697130-8338-8-git-send-email-boris.brezillon@free-electrons.com>
 <CAGb2v67GnW_ziDMjg6zObCAHZrHppGzP=+-VhpWet-NaAzx-Fg@mail.gmail.com> <535E8F68.7040206@free-electrons.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Tue, 29 Apr 2014 01:57:04 +0800
X-Google-Sender-Auth: dAivpqMTceYgKTx_zgdMgOptCLI
Message-ID: <CAGb2v65Yt8n0j4WNnzRFjzKrbmEy28cpLcuvWvVFksZZFU5JMQ@mail.gmail.com>
Subject: Re: [PATCH 7/7] ARM: sunxi: dt: add PRCM clk and reset controller subdevices
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: =?UTF-8?Q?Emilio_L=C3=B3pez?= <emilio@elopez.com.ar>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 1:27 AM, Boris BREZILLON
<boris.brezillon@free-electrons.com> wrote:
>
> On 28/04/2014 18:02, Chen-Yu Tsai wrote:
>> Hi,
>>
>> On Mon, Apr 28, 2014 at 10:58 PM, Boris BREZILLON
>> <boris.brezillon@free-electrons.com> wrote:
>>> Add DT definitions for PRCM (Power/Reset/Clock Management) clock and reset
>>> controller subdevices.
>>>
>>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>>> ---
>>>  arch/arm/boot/dts/sun6i-a31.dtsi | 49 ++++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 49 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
>>> index ec3253a..83a1634 100644
>>> --- a/arch/arm/boot/dts/sun6i-a31.dtsi
>>> +++ b/arch/arm/boot/dts/sun6i-a31.dtsi
>>> @@ -501,6 +501,55 @@
>>>                 prcm@01f01c00 {
>> Seems the address here was wrong to start with.
>
> Absolutely, I'll fix it.
>
>>
>>>                         compatible = "allwinner,sun6i-a31-prcm";
>>>                         reg = <0x01f01400 0x200>;
>>> +
>>> +                       ar100_mux: ar100_mux {
>> Might we use clk@01f01XXX for the names of the clock nodes?
>
> Actually, I had a discussion with Maxime, and we decided to remove the
> address suffix because the PRCM block is not a bus, and thus should not
> have child node with addresses.
> But I'm not a DT binding expert (it might be acceptable to define child
> nodes with addresses even when the parent is not a bus :-)).
> Advices from DT maintainers on that specific point would be great.

Then I would suggest using a _clk suffix in the name, so at least we can
tell what type of device it is. That might be enough to satisfy ePAPR.
At least socfpga, omap54xx, omap44xx are doing it this way.

>>> +                               compatible = "allwinner,sun6i-a31-ar100-mux-clk";
>>> +                               #clock-cells = <0>;
>>> +                               clocks = <&osc32k>, <&osc24M>, <&pll6>, <&pll6>;
>>> +                       };
>>> +
>>> +                       ar100: ar100 {
>>> +                               compatible = "allwinner,sun6i-a31-ar100-clk";
>>> +                               #clock-cells = <0>;
>>> +                               clocks = <&ar100_mux>;
>>> +                       };
>>> +
>>> +                       ar100_div: ar100_div {
>>> +                               compatible = "allwinner,sun6i-a31-ar100-div-clk";
>>> +                               #clock-cells = <0>;
>>> +                               clocks = <&ar100>;
>>> +                       };
>>> +
>>> +                       ahb0: ahb0 {
>>> +                               compatible = "fixed-factor-clock";
>>> +                               #clock-cells = <0>;
>>> +                               clock-div = <1>;
>>> +                               clock-mult = <1>;
>>> +                               clocks = <&ar100_div>;
>>> +                               clock-output-names = "ahb0";
>>> +                       };
>>> +
>>> +                       apb0: apb0 {
>>> +                               compatible = "allwinner,sun6i-a31-apb0-clk";
>>> +                               #clock-cells = <0>;
>>> +                               clocks = <&ahb0>;
>>> +                               clock-output-names = "apb0";
>>> +                       };
>>> +
>>> +                       apb0_gates: apb0_gates {
>>> +                               compatible = "allwinner,sun6i-a31-apb0-gates-clk";
>>> +                               #clock-cells = <1>;
>>> +                               clocks = <&apb0>;
>>> +                               clock-output-names = "apb0_pio", "apb0_ir",
>>> +                                               "apb0_timer01", "apb0_p2wi",
>>> +                                               "apb0_uart", "apb0_1wire",
>>> +                                               "apb0_i2c";
>>> +                       };
>>> +
>>> +                       apb0_rst: apb0_rst {
>> Also use reset@01f01XXX here?
>>
>>> +                               compatible = "allwinner,sun6i-a31-clock-reset";
>>> +                               #reset-cells = <1>;
>>> +                       };
>>>                 };
>>>         };
>>>  };
>> Thanks!
>>
>> ChenYu
>
> --
> Boris Brezillon, Free Electrons
> Embedded Linux and Kernel engineering
> http://free-electrons.com
>
