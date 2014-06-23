Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaFWEov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 00:44:51 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:44909 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaFWEoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 00:44:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140618100404.GM19730@lukather>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
 <1403016777-15121-10-git-send-email-wens@csie.org> <20140618100404.GM19730@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Mon, 23 Jun 2014 12:44:25 +0800
X-Google-Sender-Auth: tOZ5rS_FxPDMZPVFWxJqiOcxas0
Message-ID: <CAGb2v64GobnAM+J7QxbZxWretA5632Xn9=-pkrobUQWrGHn_ig@mail.gmail.com>
Subject: Re: [PATCH v2 09/20] clk: sunxi: Add sun6i MBUS clock support
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 6:04 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Tue, Jun 17, 2014 at 10:52:46PM +0800, Chen-Yu Tsai wrote:
>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>> ---
>>  Documentation/devicetree/bindings/clock/sunxi.txt |  1 +
>>  drivers/clk/sunxi/clk-sunxi.c                     | 44 +++++++++++++++++++++++
>>  2 files changed, 45 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Documentation/devicetree/bindings/clock/sunxi.txt
>> index b9ec668..7b2ba41 100644
>> --- a/Documentation/devicetree/bindings/clock/sunxi.txt
>> +++ b/Documentation/devicetree/bindings/clock/sunxi.txt
>> @@ -40,6 +40,7 @@ Required properties:
>>       "allwinner,sun6i-a31-apb2-div-clk" - for the APB2 gates on A31
>>       "allwinner,sun6i-a31-apb2-gates-clk" - for the APB2 gates on A31
>>       "allwinner,sun4i-a10-mod0-clk" - for the module 0 family of clocks
>> +     "allwinner,sun6i-a31-mbus-clk" - for the MBUS clocks on A31 / A23
>>       "allwinner,sun7i-a20-out-clk" - for the external output clocks
>>       "allwinner,sun7i-a20-gmac-clk" - for the GMAC clock module on A20/A31
>>       "allwinner,sun4i-a10-usb-clk" - for usb gates + resets on A10 / A20
>> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
>> index eca3c6e..a086b5b 100644
>> --- a/drivers/clk/sunxi/clk-sunxi.c
>> +++ b/drivers/clk/sunxi/clk-sunxi.c
>> @@ -307,6 +307,37 @@ static void sun4i_get_mod0_factors(u32 *freq, u32 parent_rate,
>>
>>
>>  /**
>> + * sun6i_a31_get_mbus_factors() - calculates m factor for MBUS clocks
>> + * MBUS rate is calculated as follows
>> + * rate = parent_rate / (m + 1);
>> + */
>> +
>> +static void sun6i_a31_get_mbus_factors(u32 *freq, u32 parent_rate,
>> +                                    u8 *n, u8 *k, u8 *m, u8 *p)
>> +{
>> +     u8 div;
>> +
>> +     /* These clocks can only divide, so we will never be able to achieve
>> +      * frequencies higher than the parent frequency */
>> +     if (*freq > parent_rate)
>> +             *freq = parent_rate;
>> +
>> +     div = DIV_ROUND_UP(parent_rate, *freq);
>> +
>> +     if (div > 8)
>> +             div = 8;
>> +
>> +     *freq = parent_rate / div;
>> +
>> +     /* we were called to round the frequency, we can now return */
>> +     if (n == NULL)
>
> s/n/m/ ?

The factors clk driver passes all or none pointers.
But I will change this to avoid the confusion.

>> +             return;
>> +
>> +     *m = div - 1;
>> +}
>> +
>> +
>> +/**
>>   * sun7i_a20_get_out_factors() - calculates m, p factors for CLK_OUT_A/B
>>   * CLK_OUT rate is calculated as follows
>>   * rate = (parent_rate >> p) / (m + 1);
>> @@ -447,6 +478,11 @@ static struct clk_factors_config sun4i_mod0_config = {
>>       .pwidth = 2,
>>  };
>>
>> +static struct clk_factors_config sun6i_a31_mbus_config = {
>> +     .mshift = 0,
>> +     .mwidth = 3,
>
> Actually, the A31 has an extra N factor.
>
> So this mbus clock looks like it's only about the A23, and not the A31
> at all.

I checked original sun6i code and sun6i code found in the A23 SDK.
The original code uses the module 0 clock driver for mbus, so yes
there's an extra N factor. The new code in the A23 SDK does not.

Unfortunately I haven't been able to get my Hummingbird A31 up yet,
so I can't poke around to check it.


ChenYu
