Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbaEZDsE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 23:48:04 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:38417 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaEZDsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 23:48:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140525185624.GR10768@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-10-git-send-email-wens@csie.org> <20140525185624.GR10768@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Mon, 26 May 2014 11:47:39 +0800
X-Google-Sender-Auth: jlCnuga5FCJbg3stKfquvLCPrw0
Message-ID: <CAGb2v67bLh-r4we6yU4YfBh5LKCA6f7uEy8Gbw7Unna2Y6POaQ@mail.gmail.com>
Subject: Re: [PATCH 09/22] clk: sunxi: Implement A31 PLL6 as a divs clock for
 2x output
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 26, 2014 at 2:56 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Fri, May 23, 2014 at 03:51:12PM +0800, Chen-Yu Tsai wrote:
>> Some clock modules on the A31 use PLL6x2 as one of their inputs.
>> This patch changes the PLL6 implementation for A31 to a divs clock,
>> i.e. clock with multiple outputs that have different dividers.
>>
>> This behavior is consistent with previous SoC's by Allwinner.
>>
>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>> ---
>>  drivers/clk/sunxi/clk-sunxi.c | 11 ++++++++++-
>>  1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
>> index 6857c6e..339cabc 100644
>> --- a/drivers/clk/sunxi/clk-sunxi.c
>> +++ b/drivers/clk/sunxi/clk-sunxi.c
>> @@ -496,6 +496,7 @@ static const struct factors_data sun6i_a31_pll6_data __initconst = {
>>       .enable = 31,
>>       .table = &sun6i_a31_pll6_config,
>>       .getter = sun6i_a31_get_pll6_factors,
>> +     .name = "pll6",
>>  };
>>
>>  static const struct factors_data sun4i_apb1_data __initconst = {
>> @@ -969,6 +970,14 @@ static const struct divs_data pll6_divs_data __initconst = {
>>       }
>>  };
>>
>> +static const struct divs_data sun6i_a31_pll6_divs_data __initconst = {
>> +     .factors = &sun6i_a31_pll6_data,
>> +     .ndivs = 1,
>> +     .div = {
>> +             { .fixed = 2 }, /* P, other */
>> +     }
>> +};
>> +
>>  /**
>>   * sunxi_divs_clk_setup() - Setup function for leaf divisors on clocks
>>   *
>> @@ -1108,7 +1117,6 @@ static const struct of_device_id clk_factors_match[] __initconst = {
>>       {.compatible = "allwinner,sun4i-a10-pll1-clk", .data = &sun4i_pll1_data,},
>>       {.compatible = "allwinner,sun6i-a31-pll1-clk", .data = &sun6i_a31_pll1_data,},
>>       {.compatible = "allwinner,sun7i-a20-pll4-clk", .data = &sun7i_a20_pll4_data,},
>> -     {.compatible = "allwinner,sun6i-a31-pll6-clk", .data = &sun6i_a31_pll6_data,},
>>       {.compatible = "allwinner,sun4i-a10-apb1-clk", .data = &sun4i_apb1_data,},
>>       {.compatible = "allwinner,sun4i-a10-mod0-clk", .data = &sun4i_mod0_data,},
>>       {.compatible = "allwinner,sun7i-a20-out-clk", .data = &sun7i_a20_out_data,},
>> @@ -1128,6 +1136,7 @@ static const struct of_device_id clk_div_match[] __initconst = {
>>  static const struct of_device_id clk_divs_match[] __initconst = {
>>       {.compatible = "allwinner,sun4i-a10-pll5-clk", .data = &pll5_divs_data,},
>>       {.compatible = "allwinner,sun4i-a10-pll6-clk", .data = &pll6_divs_data,},
>> +     {.compatible = "allwinner,sun6i-a31-pll6-clk", .data = &sun6i_a31_pll6_divs_data,},
>
> Can't the PLL6x2 clock just be a fixed-factor-clock? It would make the
> change trivial, and better fit what it actually is.

Sounds good. I was worried there might be an extra output. The A23 manual
lists a SATA PHY output, which I have no idea where it's used.

On the IRC someone (you?) mentioned the A31 doesn't have native SATA.
I'll rework this using a fixed-factor clock.


Thanks
ChenYu
