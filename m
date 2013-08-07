Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034Ab3HGSHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:07:24 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46057 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932745Ab3HGSHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:07:20 -0400
Message-ID: <52028CD6.3040306@codeaurora.org>
Date: Wed, 07 Aug 2013 11:07:18 -0700
From: Hanumant Singh <hanumant@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bjorn Andersson <bjorn@kryo.se>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] pinctrl: msm: Add support for MSM TLMM pinmux
References: <1374702089-2832-1-git-send-email-hanumant@codeaurora.org> <CAJAp7OjbJwaH8SFdSwDU4VLwTAY1PfDWy1S+yF05=oPuUApvNA@mail.gmail.com>
In-Reply-To: <CAJAp7OjbJwaH8SFdSwDU4VLwTAY1PfDWy1S+yF05=oPuUApvNA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/29/2013 4:39 PM, Bjorn Andersson wrote:
> On Wed, Jul 24, 2013 at 1:41 PM, Hanumant Singh <hanumant@codeaurora.org> wrote:
>> Add a new device tree enabled pinctrl driver for
>> Qualcomm MSM SoC's. This driver provides an extensible
>> framework to interface all MSM's that use a TLMM pinmux,
>> with the pinctrl subsytem.
>
> Thanks! I was about to write an implementation for v2 myself when I
> found your patch. I hacked a little bit on it and got it to work on my
> 8960 based board.
>
Sorry for the delayed response. Right now the focus is to add support 
for the pinmux on the snapdragon 800 soc which uses the V3.
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
>
> It seems that the gp pins of TLMM v3 have the same layout and offsets
> as the once in v2. Unless I'm missing something I think this patch
> should be structured (and have appropriate naming) in a way that we
> can support both of them.
>
No, Actually there are significant differences in the v2 and v3 register 
offsets and even hardware capabilities.
We are currently trying to add support for our snapdragon 800
soc which uses V3.
> As a general note on the patch, the pins and pin groups are defined by
> the soc, I'm therefore not convinced that these should be configured
> from the devicetree. It's at least not how it's done in other
> platforms.
>

I have been having a email discussion with Stephen Warren on this.

> After talking to Linus a little bit I concluded that the way the
> design idea behind pinmux is that you have pins and you have
> functions;
> * pins are your 117 gp-pins and with some imagination your sd pins, so
> that's fine.
> * the function is some functionality provided by the hard
> Then you can set up muxes between these two. Therefore I think your
> use of the word "function" in the patch is what normally is called a
> mux. It might be worth sorting this out, to make it easier to maintain
> this code down the road.
>
> @Linus, can you please confirm my understanding of the design?
>
>>

I am not sure that the use of the term func is misleading. You can look 
at the samsung-pinctrl.txt documentation for a similar use of the term.


>> +Example 2: Spi pin entries within the pincontroller node
>> +       pinctrl@fd511000 {
>> +               ....
>> +               ..
>> +               pmx-spi-bus {
>> +                       /*
>> +                        * MOSI, MISO and CLK lines
>> +                        * all sharing same function and config
>> +                        * settings for each configuration node.
>> +                        */
>> +                       qcom,pins = <&gp 0>, <&gp 1>, <&gp 3>;
>> +                       qcom,num-grp-pins = <3>;
>
> qcom,num-grp-pins is not used by the code, please remove it.

Will do
>
>> +                       qcom,pin-func = <1>;
>> +                       label = "spi-bus";
>> +
>> +                       /* Active configuration of bus pins */
>> +                       spi-bus-active: spi-bus-active {
>> +                               /*
>> +                                * Property names as specified in
>> +                                * pinctrl-bindings.txt
>> +                                */
>> +                               drive-strength = <8>; /* 8 MA */
>> +                               bias-disable; /* No PULL */
>> +                       };
>> +                       /* Sleep configuration of bus pins */
>> +                       spi-bus-sleep: spi-bus-sleep {
>> +                               /*
>> +                                * Property values as specified in HW
>> +                                * manual.
>> +                                */
>> +                               drive-strength = <2>; /* 2 MA */
>> +                               bias-disable;
>> +                       };
>> +               };
>> +
>> +               pmx-spi-cs {
>> +                       /*
>> +                        * Chip select for SPI
>> +                        * different config
>> +                        * settings as compared to bus pins.
>> +                        */
>> +                       qcom,pins = <&Gp 2>;
>
> Make Gp lower case.
>
Will do


>> +Example 3: A SPI client node that supports 'active' and 'sleep' states.
>> +
>> +       spi_0: spi@f9923000 { /* BLSP1 QUP1 */
>> +                       compatible = "qcom,spi-qup-v2";
>> +                       #address-cells = <1>;
>> +                       #size-cells = <0>;
>> +                       reg-names = "spi_physical", "spi_bam_physical";
>> +                       reg = <0xf9923000 0x1000>,
>> +                       <0xf9904000 0xF000>;
>> +                       interrupt-names = "spi_irq", "spi_bam_irq";
>> +                       interrupts = <0 95 0>, <0 238 0>;
>> +                       spi-max-frequency = <19200000>;
>> +
>> +                       /* pins used by spi controllers */
>> +                       pinctrl-names = "default", "sleep";
>> +                       pinctrl-0 = <&spi-bus-active &spi-cs-active>;
>> +                       pinctrl-1 = <&spi-bus-sleep &spi-cs-sleep>;
>> +
>> +                       qcom,infinite-mode = <0>;
>> +                       qcom,use-bam;
>> +                       qcom,ver-reg-exists;
>> +               qcom,bam-consumer-pipe-index = <12>;
>> +               qcom,bam-producer-pipe-index = <13>;
>
> Please fix the indentation here.
>

Will do
>> +                };
>> +
>> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
>> index 34f51d2..480cb26 100644
>> --- a/drivers/pinctrl/Kconfig
>> +++ b/drivers/pinctrl/Kconfig
>> @@ -133,6 +133,16 @@ config PINCTRL_IMX28
>>          bool
>>          select PINCTRL_MXS
>>
>> +config PINCTRL_MSM
>> +       depends on OF
>> +       bool
>> +       select PINMUX
>> +       select GENERIC_PINCONF
>> +
>> +config PINCTRL_MSM_TLMM_V3
>> +       bool
>> +       select PINCTRL_MSM
>
> PINCTRL_MSM does selects only to compile the "common" parts, but this
> does not build. Adding e.g MSM_TLMM_V2 here as well (as I did first)
> just made me have to select 2 things to make one thing compile.
>
> My suggestion is that you remove the V3 config and just put it all
> under PINCTRL_MSM
>

I need to distinguish the device tree interface and parsing
from the TLMM version.
I would probably go in the reverse direction and keep only the V3 config
and remove the generic PINCTRL_MSM?
>> +
>> +
>> +/* SDC Pin type register offsets */
>> +#define TLMMV3_SDC_OFFSET              0x2044
>> +#define TLMMV3_SDC1_CFG(base)          (base)
>> +#define TLMMV3_SDC2_CFG(base)          (TLMMV3_SDC1_CFG(base) + 0x4)
>> +
>> +/* GP pin type register offsets */
>> +#define TLMMV3_GP_CFG(base, pin)       (base + 0x1000 + 0x10 * (pin))
>> +#define TLMMV3_GP_INOUT(base, pin)     (base + 0x1004 + 0x10 * (pin))
>> +
>> +struct msm_sdc_regs {
>> +       unsigned int offset;
>> +       unsigned long pull_mask;
>> +       unsigned long pull_shft;
>> +       unsigned long drv_mask;
>> +       unsigned long drv_shft;
>> +};
>> +
>> +static struct msm_sdc_regs sdc_regs[] = {
>> +       /* SDC1 CLK */
>> +       {
>> +               .offset = 0,
>> +               .pull_mask = TLMMV3_SDC1_CLK_PULL_MASK,
>> +               .pull_shft = TLMMV3_SDC1_CLK_PULL_SHFT,
>> +               .drv_mask = TLMMV3_SDC1_CLK_DRV_MASK,
>> +               .drv_shft = TLMMV3_SDC1_CLK_DRV_SHFT,
>> +       },
>> +       /* SDC1 CMD */
>> +       {
>> +               .offset = 0,
>> +               .pull_mask = TLMMV3_SDC1_CMD_PULL_MASK,
>> +               .pull_shft = TLMMV3_SDC1_CMD_PULL_SHFT,
>> +               .drv_mask = TLMMV3_SDC1_CMD_DRV_MASK,
>> +               .drv_shft = TLMMV3_SDC1_CMD_DRV_SHFT,
>> +       },
>> +       /* SDC1 DATA */
>> +       {
>> +               .offset = 0,
>> +               .pull_mask = TLMMV3_SDC1_DATA_PULL_MASK,
>> +               .pull_shft = TLMMV3_SDC1_DATA_PULL_SHFT,
>> +               .drv_mask = TLMMV3_SDC1_DATA_DRV_MASK,
>> +               .drv_shft = TLMMV3_SDC1_DATA_DRV_SHFT,
>> +       },
>> +       /* SDC2 CLK */
>> +       {
>> +               .offset = 0x4,
>> +               .pull_mask = TLMMV3_SDC2_CLK_PULL_MASK,
>> +               .pull_shft = TLMMV3_SDC2_CLK_PULL_SHFT,
>> +               .drv_mask = TLMMV3_SDC2_CLK_DRV_MASK,
>> +               .drv_shft = TLMMV3_SDC2_CLK_DRV_SHFT,
>> +       },
>> +       /* SDC2 CMD */
>> +       {
>> +               .offset = 0x4,
>> +               .pull_mask = TLMMV3_SDC2_CMD_PULL_MASK,
>> +               .pull_shft = TLMMV3_SDC2_CMD_PULL_SHFT,
>> +               .drv_mask = TLMMV3_SDC2_CMD_DRV_MASK,
>> +               .drv_shft = TLMMV3_SDC2_CMD_DRV_SHFT,
>> +       },
>> +       /* SDC2 DATA */
>> +       {
>> +               .offset = 0x4,
>> +               .pull_mask = TLMMV3_SDC2_DATA_PULL_MASK,
>> +               .pull_shft = TLMMV3_SDC2_DATA_PULL_SHFT,
>> +               .drv_mask = TLMMV3_SDC2_DATA_DRV_MASK,
>> +               .drv_shft = TLMMV3_SDC2_DATA_DRV_SHFT,
>> +       },
>> +};
>> +
>> +static int msm_tlmm_v3_sdc_cfg(uint pin_no, unsigned long *config,
>> +                                               void __iomem *reg_base,
>> +                                               bool write)
>
> I strongly recommend you split this function into a get_config and
> set_config. It took me plenty of time to get my head around what
> you're doing here.
>
> I would also suggest that you do:
>
> val = readl()
> switch () {
>    fix val in various ways
> }
> writel(val)
>
> Instead of maintaining mask and shift throughout the function.
>

I thought the bool write would suffice to indicate a bidirectional
function. I can perhaps use a better term for the boolean if readability 
is a concern.
There are more then 2 pin types on the TLMM, which we will be
adding support for. Adding a set and get for each will lead to a lot
of functions that look similar.
Right now the samsung implementation too uses a common function for set 
and get.

>> +{
>> +       unsigned int val, id, data;
>> +       u32 mask, shft;
>> +       void __iomem *cfg_reg;
>> +
>> +       cfg_reg = reg_base + sdc_regs[pin_no].offset;
>> +       id = pinconf_to_config_param(*config);
>> +       val = readl_relaxed(cfg_reg);
>> +       /* Get mask and shft values for this config type */
>> +       switch (id) {
>> +       case PIN_CONFIG_BIAS_DISABLE:
>> +               mask = sdc_regs[pin_no].pull_mask;
>> +               shft = sdc_regs[pin_no].pull_shft;
>> +               data = TLMMV3_NO_PULL;
>> +               if (!write) {
>> +                       val >>= shft;
>> +                       val &= mask;
>> +                       data = rval_to_pull(val);
>> +               }
>> +               break;
>> +       case PIN_CONFIG_BIAS_PULL_DOWN:
>> +               mask = sdc_regs[pin_no].pull_mask;
>> +               shft = sdc_regs[pin_no].pull_shft;
>> +               data = TLMMV3_PULL_DOWN;
>> +               if (!write) {
>> +                       val >>= shft;
>> +                       val &= mask;
>> +                       data = rval_to_pull(val);
>> +               }
>> +               break;
>> +       case PIN_CONFIG_BIAS_PULL_UP:
>> +               mask = sdc_regs[pin_no].pull_mask;
>> +               shft = sdc_regs[pin_no].pull_shft;
>> +               data = TLMMV3_PULL_UP;
>> +               if (!write) {
>> +                       val >>= shft;
>> +                       val &= mask;
>> +                       data = rval_to_pull(val);
>> +               }
>> +               break;
>> +       case PIN_CONFIG_DRIVE_STRENGTH:
>> +               mask = sdc_regs[pin_no].drv_mask;
>> +               shft = sdc_regs[pin_no].drv_shft;
>> +               if (write) {
>> +                       data = pinconf_to_config_argument(*config);
>> +                       data = drv_str_to_rval(data);
>> +               } else {
>> +                       val >>= shft;
>> +                       val &= mask;
>> +                       data = rval_to_drv_str(val);
>> +               }
>> +               break;
>> +       default:
>> +               return -EINVAL;
>> +       };
>> +
>> +       if (write) {
>> +               val &= ~(mask << shft);
>> +               val |= (data << shft);
>> +               writel_relaxed(val, cfg_reg);
>> +       } else
>> +               *config = pinconf_to_config_packed(id, data);
>> +       return 0;
>> +}
>> +
>> +static void msm_tlmm_v3_sdc_set_reg_base(void __iomem **ptype_base,
>> +                                                       void __iomem *tlmm_base)
>> +{
>> +       *ptype_base = tlmm_base + TLMMV3_SDC_OFFSET;
>> +}
>
> This function is used to do "pin type based base offset shifting", if
> you instead moved the calculation into the msm_sdc_regs above you
> could just skip it from your interface and pass the blocks reg_base to
> allt these functions.
>
The TLMM base is going to be maintained by the upper layer.
I need the pintype base to be stored with the pintype struct,
because future implementation of irq chip/gpio chip supported
by a given pin type, will not pass through the upper layer, but
rather arrive in this file directly via gpiolib.

>> +{
>> +       unsigned int val, id, data, inout_val;
>> +       u32 mask = 0, shft = 0;
>> +       void __iomem *inout_reg = NULL;
>> +       void __iomem *cfg_reg = TLMMV3_GP_CFG(reg_base, pin_no);
>> +
>> +       id = pinconf_to_config_param(*config);
>> +       val = readl_relaxed(cfg_reg);
>> +       /* Get mask and shft values for this config type */
>> +       switch (id) {
>> +       case PIN_CONFIG_BIAS_DISABLE:
>> +               mask = TLMMV3_GP_PULL_MASK;
>> +               shft = TLMMV3_GP_PULL_SHFT;
>> +               data = TLMMV3_NO_PULL;
>> +               if (!write) {
>> +                       val >>= shft;
>> +                       val &= mask;
>> +                       data = rval_to_pull(val);
>
> I assume this should return a "boolean" whether or not this mode is
> selected; if so you should return 1 here iff (val & 0x3) == 3. I
> assume the same goes for the sdc config function?
>
> @Linus, could you please confirm this interpretation of the get_config
> for pull config.
>

Right now I use the default values associated with these config params
to program corresponding register values.
If its a BIAS_PULL_DOWN it still needs to return 1.
Only if its BIAS_DISABLE it should return 0.
The function will do that.

>> +static void msm_tlmm_v3_gp_set_reg_base(void __iomem **ptype_base,
>> +                                               void __iomem *tlmm_base)
>> +{
>> +       *ptype_base = tlmm_base;
>> +}
>> +
>> +static struct msm_pintype_info tlmm_v3_pininfo[] = {
>> +       {
>> +               .prg_cfg = msm_tlmm_v3_gp_cfg,
>> +               .prg_func = msm_tlmm_v3_gp_fn,
>
> Please add a separate function for getting the config, as it would
> simplify both sides of the interface.
> Please rename these functions ".get_config", ".set_config" and ".set_function".
>
>> +               .set_reg_base = msm_tlmm_v3_gp_set_reg_base,
>
explanation earlier.
> Please remove this from the interface, better let the sdc definition
> include the offset needed.
>
>> +               .reg_data = NULL,
>
> By removing the set_reg_base, you don't need a per pin-type definition
> of the register base.
>
same as above.
>> +               .prop_name = "qcom,pin-type-gp",
>> +               .name = "gp",
>> +       },
>> +       {
>> +               .prg_cfg = msm_tlmm_v3_sdc_cfg,
>> +               .set_reg_base = msm_tlmm_v3_sdc_set_reg_base,
>> +               .reg_data = NULL,
>> +               .prop_name = "qcom,pin-type-sdc",
>> +               .name = "sdc",
>> +       }
>> +};
>> +
>> +struct msm_tlmm tlmm_v3_pintypes = {
>> +       .num_entries = ARRAY_SIZE(tlmm_v3_pininfo),
>> +       .pintype_info = tlmm_v3_pininfo,
>> +};
>> +
>> +       /* Get function mapping */
>> +       of_property_read_u32(parent, "qcom,pin-func", &val);
>> +       fn_name = kzalloc(strlen(grp_name) + strlen("-func"),
>> +                                               GFP_KERNEL);
>> +       if (!fn_name) {
>> +               ret = -ENOMEM;
>> +               goto func_err;
>> +       }
>> +       snprintf(fn_name, strlen(grp_name) + strlen("-func") + 1, "%s%s",
>> +                                               grp_name, "-func");
>
> Store the size of this in a variable to be used both in the allocation
> and in the snprintf. That way you don't have to line wrap here.
> Also make sure you allocate room for the nul byte (that you have in
> your snprintf).
>
> And move the "-func" into the format string ("%s-func").
>

Will do.

>> +               }
>> +               snprintf(func_name, len, "%s%s", grp_name, "-func");
>
> Move "-func" into the format.
>
will do

>> +               curr_func->name = func_name;
>> +               curr_func->gps = devm_kzalloc(dev, sizeof(char *), GFP_KERNEL);
>> +               if (!curr_func->gps) {
>> +                       dev_err(dev, "failed to alloc memory for group list ");
>> +                       return -ENOMEM;
>> +               }
>> +               of_property_read_u32(pgrp_np, "qcom,pin-func", &func);
>> +               curr_grp->func = func;
>> +               curr_func->gps[0] = grp_name;
>> +               curr_func->num_grps = 1;
>
> This is the only place you store something in gps and the only place
> you read the value is in msm_pmux_get_groups(). As you're in control
> of the msm_pmx_funcs struct I suggest that you remove this allocation
> and just store the group_name in a char * pointer and drops the
> num_grps. Then in msm_pmux_get_groups you assign
>
> *groups = &dd->pmx_funcs[selector].gps;
> *num_groups = 1;
>
> And preferably you rename gps to group_name, or something else that's readable.
>

Will do.
>> +               func_index++;
>> +       }
>> +       dd->pin_grps = pin_grps;
>> +       dd->num_grps = num_grps;
>> +       dd->pmx_funcs = pmx_funcs;
>> +       dd->num_funcs = num_funcs;
>> +       return 0;
>> +}
>> +
>> +static void msm_populate_pindesc(struct msm_pintype_info *pinfo,
>> +                                       struct msm_pindesc *msm_pindesc)
>> +{
>> +       int i;
>> +       struct msm_pindesc *pindesc;
>> +
>> +       for (i = 0; i < pinfo->num_pins; i++) {
>> +               pindesc = &msm_pindesc[i + pinfo->pin_start];
>> +               pindesc->pin_info = pinfo;
>> +               snprintf(pindesc->name, sizeof(pindesc->name),
>> +                                       "%s-%d", pinfo->name, i);
>> +       }
>> +}
>> +
>> +static int msm_pinctrl_dt_parse_pintype(struct device_node *dev_node,
>> +                                               struct msm_pinctrl_dd *dd)
>> +{
>> +       struct device_node *pt_node;
>> +       struct msm_pindesc *msm_pindesc;
>> +       struct msm_pintype_info *pintype, *pinfo;
>> +       void __iomem **ptype_base;
>> +       u32 num_pins, pinfo_entries, curr_pins;
>> +       int i, ret;
>> +       uint total_pins = 0;
>> +
>> +       pinfo = dd->msm_pintype;
>> +       pinfo_entries = dd->num_pintypes;
>> +       curr_pins = 0;
>> +
>> +       for_each_child_of_node(dev_node, pt_node) {
>> +               for (i = 0; i < pinfo_entries; i++) {
>> +                       pintype = &pinfo[i];
>> +                       /* Check if node is pintype node */
>> +                       if (!of_find_property(pt_node, pinfo->prop_name, NULL))
>> +                               continue;
>> +                       of_node_get(pt_node);
>> +                       pintype->node = pt_node;
>> +                       /* determine number of pins of given pin type */
>> +                       ret = of_property_read_u32(pt_node, "qcom,num-pins",
>> +                                                               &num_pins);
>> +                       if (ret) {
>
> The alloc_fail at the bottom is taking care of putting any of_nodes
> you got here, in the event of an allocation failure below. But here
> you simply return. Please roll back your of_node_gets.
>

Will do.
>> +                               dev_err(dd->dev, "num pins not specified\n");
>> +                               return ret;
>> +                       }
>> +                       /* determine pin number range for given pin type */
>> +                       pintype->num_pins = num_pins;
>> +                       pintype->pin_start = curr_pins;
>> +                       pintype->pin_end = curr_pins + num_pins;
>
> How does this work with having multiple pin types defined at the same time.
>
> As far as I can see the order of the definition of the pin types
> matters because of this.
> It also gives an idea that you could have multiple gp/sdc groups, but
> then the addressing will be way confusing.
>
> Compare what actual pin <&gp 0> refers to in these two cases:
>
> gp: gp { qcom,num-pins = <10>; }
> sdc: sdc { qcom,num-pins = <10>; }
>
> sdc: sdc { qcom,num-pins = <10>; }
> gp: gp { qcom,num-pins = <10>; }
>
>
> I suggest that you drop the pin_start and only store num_pins in the
> pintype struct.
>

The framework is going to give me pin numbers which need to map to a 
particular pin number for a pin type (not a group). The pin_start helps 
me achieve this translation. In the above case the framework will know 
of a total of 20 pins. By knowing where the gp pin type starts in the 
above 20, i can map a pin number to it or any other pin type.

> And again, thanks for writing this driver. I look forward to have it
> mainlined! (with support for my 8960 board ;))
>

As I said earlier, I will be adding support for v3. You can start work
in parallel on v2, if you would like, and once this is mainlined, we can 
review and push in your v2 effort as well?


Thanks
Hanumant

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
-- 
