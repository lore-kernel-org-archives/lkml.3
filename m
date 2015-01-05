Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbbAEOAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:00:03 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:51565 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbbAEN77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:59:59 -0500
Message-ID: <54AA98E1.704@cogentembedded.com>
Date: Mon, 05 Jan 2015 17:00:01 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2] clk-rcar-gen2: ADSP clock support
References: <30876083.4tlAgq9Aak@wasted.cogentembedded.com> <CAMuHMdXW=_bYbdUGB2TBPFNfz9gBB+AyD1mWyoKD9eFxebma5w@mail.gmail.com>
In-Reply-To: <CAMuHMdXW=_bYbdUGB2TBPFNfz9gBB+AyD1mWyoKD9eFxebma5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 1/5/2015 4:13 PM, Geert Uytterhoeven wrote:

>> Add the ADSP clock support to the R-Car generation 2 CPG driver.  This clock
>> gets derived from  PLL1.  The layout of the ADSPCKCR register is  similar to
>> those of the clocks supported by the 'clk-div6' driver but the divider encoding
>> is non-linear, so can't be supported by that driver...

>> Based on the original patch by Konstantin Kozhevnikov
>> <konstantin.kozhevnikov@cogentembedded.com>.

>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

>> ---
>> The patch is against the 'clk-next' branch of Mike Turquette's 'linux.git' repo
>> plus the RCAN clock support patch posted last week.

>> Changes in version 2:
>> - swapped "adsp" and "rcan" in the binding document.

>> +++ linux/drivers/clk/shmobile/clk-rcar-gen2.c
>> @@ -33,6 +33,7 @@ struct rcar_gen2_cpg {
[...]
>> @@ -162,6 +163,51 @@ static struct clk * __init cpg_z_clk_reg
>>          return clk;
>>   }
>>
>> +/* ADSP divisors */
>> +static const struct clk_div_table cpg_adsp_div_table[] = {
>> +       {  1,  3 }, {  2,  4 }, {  3,  6 }, {  4,  8 },
>> +       {  5, 12 }, {  6, 16 }, {  7, 18 }, {  8, 24 },
>> +       { 10, 36 }, { 11, 48 }, {  0,  0 },
>> +};
>> +
>> +static struct clk * __init cpg_adsp_clk_register(struct rcar_gen2_cpg *cpg)
>> +{
>> +       const char *parent_name = "pll1";
>> +       struct clk_divider *div;
>> +       struct clk_gate *gate;
>> +       struct clk *clk;
>> +
>> +       div = kzalloc(sizeof(*div), GFP_KERNEL);
>> +       if (!div)
>> +               return ERR_PTR(-ENOMEM);
>> +
>> +       div->reg = cpg->reg + CPG_ADSPCKCR;
>> +       div->width = 4;
>> +       div->table = cpg_adsp_div_table;
>> +       div->lock = &cpg->lock;
>> +
>> +       gate = kzalloc(sizeof(*gate), GFP_KERNEL);
>> +       if (!gate) {
>> +               kfree(div);
>> +               return ERR_PTR(-ENOMEM);
>> +       }
>> +
>> +       gate->reg = cpg->reg + CPG_RCANCKCR;

> Shouldn't this be CPG_ADSPCKCR?

    Oops! At least I did it right for the divider component. :-)

>> +       gate->bit_idx = 8;
>> +       gate->flags = CLK_GATE_SET_TO_DISABLE;
>> +       gate->lock = &cpg->lock;
>> +
>> +       clk = clk_register_composite(NULL, "adsp", &parent_name, 1, NULL, NULL,
>> +                                    &div->hw, &clk_divider_ops,
>> +                                    &gate->hw, &clk_gate_ops, 0);
>> +       if (IS_ERR(clk)) {
>> +               kfree(gate);
>> +               kfree(div);
>> +       }
>> +
>> +       return clk;
>> +}

> Please insert the adsp code after the rcan code, to match the clock order
> in bindings and #defines.

    OK. I placed it basing on the register offset...

[...]
>> @@ -301,6 +347,8 @@ rcar_gen2_cpg_register_clock(struct devi
>>                  shift = 0;
>>          } else if (!strcmp(name, "z")) {
>>                  return cpg_z_clk_register(cpg);
>> +       } else if (!strcmp(name, "adsp")) {
>> +               return cpg_adsp_clk_register(cpg);

> Please insert the adsp code after the rcan code.

    OK.

WBR, Sergei

