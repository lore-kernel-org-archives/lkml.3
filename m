Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab3GKDvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 23:51:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36032 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab3GKDvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 23:51:45 -0400
Message-ID: <51DE2BCF.3030804@codeaurora.org>
Date: Wed, 10 Jul 2013 20:51:43 -0700
From: hanumant <hanumant@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] pinctrl: msm: Add support for MSM TLMM pinmux
References: <371851554-4492-1-git-send-email-hanumant@codeaurora.org> <1372367296-25197-1-git-send-email-hanumant@codeaurora.org> <CACRpkdYg9Hbn5DcfT-_+sxk0eipA1fdcGX2EEWc1ezCNmXrLGA@mail.gmail.com>
In-Reply-To: <CACRpkdYg9Hbn5DcfT-_+sxk0eipA1fdcGX2EEWc1ezCNmXrLGA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/2013 3:05 PM, Linus Walleij wrote:
> On Thu, Jun 27, 2013 at 11:08 PM, Hanumant Singh
> <hanumant@codeaurora.org> wrote:
>
>> Add a new device tree enabled pinctrl driver for
>> Qualcomm MSM SoC's. This driver provides an extensible
>> framework to interface all MSM's that use a TLMM pinmux,
>> with the pinctrl subsytem.
>>
>> This driver is split into two parts: the pinctrl interface
>> and the TLMM version specific implementation. The pinctrl
>> interface parses the device tree and registers with the pinctrl
>> subsytem. The TLMM version specific implementation supports
>> pin configuration/register programming for the different
>> pin types present on a given TLMM pinmux version.
>>
>> Add support only for TLMM version 3 pinmux right now,
>> as well as, only two of the different pin types present on the
>> TLMM v3 pinmux.
>> Pintype 1: General purpose pins.
>> Pintype 2: SDC pins.
>>
>> Signed-off-by: Hanumant Singh <hanumant@codeaurora.org>
>
> This is looking better. (Sorry for late feedback...)
>
>> +Required Properties
>> +  - qcom,pin-type: identifies the pin type.
>
> Define the possible types. If these are enumerable, don't pass a
> generic string, use an hard identifier, e.g:
>
> qcom,pin-type-gp;
> qcom,pin-type-sdc;
will do
>
> (...)
>> +Example 1: A pin-controller node with pin types
>> +
>> +       pinctrl@fd5110000 {
>> +               compatible = "qcom,msm-tlmm-v3";
>> +               reg = <0x11400000 0x4000>;
>> +
>> +               /* General purpose pin type */
>> +               gp: gp {
>> +                       qcom,pin-type = "gp";
>
> Can we use qcom,pin-type-gp; ?
>
> (...)
>> +Example 2: Spi pin entries within the pincontroller node
>> +       pinctrl@fd511000 {
>> +               ....
>> +               ..
>> +               spi-bus {
>> +                       /*
>> +                        * MOSI, MISO and CLK lines
>> +                        * all sharing same function and config
>> +                        * settings for each configuration node.
>> +                        */
>> +                       qcom,pins = <&gp 0>, <&gp 1>, <&gp 3>;
>> +                       qcom,pin-func = <1>;
>> +
>> +                       /* Active configuration of bus pins */
>> +                       spi-bus-active: spi-bus-active {
>> +                               drive-strength = <3>; /* 8 MA */
>
> No that shall be <8>.
>
> If you need a translation table to translate this into your
> magic constants, put a cross-reference table in your driver.
>
Will do
>> +                               bias-disable; /* No PULL */
>> +                       };
>> +                       /* Sleep configuration of bus pins */
>> +                       spi-bus-sleep: spi-bus-sleep {
>> +                               drive-strength = <0>; /* 2 MA */
>
> This shall be <2>;



>
> (...)
>> +static int msm_tlmm_v3_sdc_cfg(uint pin_no, unsigned long *config,
>> +                                               void __iomem *reg_base,
>> +                                               bool write)
>> +{
>> +       unsigned int val, id, data;
>> +       u32 mask, shft;
>> +       void __iomem *cfg_reg;
>> +
>> +       cfg_reg = reg_base + sdc_regs[pin_no].offset;
>> +       id = pinconf_to_config_param(*config);
>> +       /* Get mask and shft values for this config type */
>> +       switch (id) {
>> +       case PIN_CONFIG_BIAS_DISABLE:
>> +       case PIN_CONFIG_BIAS_PULL_DOWN:
>> +       case PIN_CONFIG_BIAS_PULL_UP:
>> +               mask = sdc_regs[pin_no].pull_mask;
>> +               shft = sdc_regs[pin_no].pull_shft;
>> +               break;
>> +       case PIN_CONFIG_DRIVE_STRENGTH:
>> +               mask = sdc_regs[pin_no].drv_mask;
>> +               shft = sdc_regs[pin_no].drv_shft;
>> +               break;
>> +       default:
>> +               return -EINVAL;
>> +       };
>> +
>> +       val = readl_relaxed(cfg_reg);
>> +       if (write) {
>> +               data = pinconf_to_config_argument(*config);
>
> This data needs to be treated per-config option and be more
> optional. This makes it look like you want to supply a <1>
> with any pull up or pull down configuration to nail it in when in
> fact they do not take any argument, and if they do it should
> be the number of Ohms in the resistor, not <1>.
>
OK I will supply the register magic values for each of the
pull config options.
Resistor value is not configurable, so I don't need that.

> For drive strength you need a mA -> selector translation table
> as mentioned.
I will implement the translation table.
>
>> +               val &= ~(mask << shft);
>> +               val |= (data << shft);
>> +               writel_relaxed(val, cfg_reg);
>> +       } else {
>> +               val >>= shft;
>> +               val &= mask;
>> +               *config = pinconf_to_config_packed(id, val);
>
> Same thing applies in reverse here.
>
In that case, for get_config
1) For pull configs: I suppose I can return the default config value 
instead of the register magic value?
2) For drive-strength I can return the reverse translation.

>> +static void msm_tlmm_v3_sdc_set_reg_base(void __iomem **ptype_base,
>> +                                                       void __iomem *tlmm_base)
>> +{
>> +       *ptype_base = tlmm_base + 0x2044;
>> +}
>
> 0x2044 looks a bit magic, use a #define for this or atleast put in
> some comment...
>
Will do


>> +       /*
>> +        * If no pin type specifc config parameters are specified
>> +        * use general puropse pin config parsing
>> +        */
>> +       if (!pinfo->tlmm_cfg_param)
>> +               ret = pinconf_generic_parse_dt_config(cfg_np, &cfg,
>> +                                                               &cfg_cnt);
>> +
>> +        else
>> +               ret = msm_pinconf_parse_dt(cfg_np, &cfg, &cfg_cnt, pinfo);
>
> This looks like *either* generic *or* custom pin configuration,
> but in the previous mail you mentioned using *both*
> simultaneously. I don't see how this could work?
>
Currently the pin types fall in the either or cattegory.
Not in both. But for the currently implemented pintypes I don't
need custom pin configuration. So I will remove the support.

>> +/**
>> + * struct msm_tlmm_cfgs: represent config properties of a pin type.
>> + * @name: name of config.
>> + * @id: id of the config.
>> + */
>> +
>> +struct msm_tlmm_cfg_params {
>> +       const char *name;
>> +       unsigned int id;
>> +};
>
> Since these have no device tree bindings, don't implement them.
> This looks like a free pass to encode just anything in here...
>
As mentioned above I will remove the customer configs.

> Yours,
> Linus Walleij
>

Thanks
Hanumant

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
-- 
