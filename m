Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab3GJWFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 18:05:12 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:33903 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab3GJWFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 18:05:09 -0400
MIME-Version: 1.0
In-Reply-To: <1372367296-25197-1-git-send-email-hanumant@codeaurora.org>
References: <371851554-4492-1-git-send-email-hanumant@codeaurora.org>
	<1372367296-25197-1-git-send-email-hanumant@codeaurora.org>
Date: Thu, 11 Jul 2013 00:05:08 +0200
Message-ID: <CACRpkdYg9Hbn5DcfT-_+sxk0eipA1fdcGX2EEWc1ezCNmXrLGA@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: msm: Add support for MSM TLMM pinmux
From: Linus Walleij <linus.walleij@linaro.org>
To: Hanumant Singh <hanumant@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 11:08 PM, Hanumant Singh
<hanumant@codeaurora.org> wrote:

> Add a new device tree enabled pinctrl driver for
> Qualcomm MSM SoC's. This driver provides an extensible
> framework to interface all MSM's that use a TLMM pinmux,
> with the pinctrl subsytem.
>
> This driver is split into two parts: the pinctrl interface
> and the TLMM version specific implementation. The pinctrl
> interface parses the device tree and registers with the pinctrl
> subsytem. The TLMM version specific implementation supports
> pin configuration/register programming for the different
> pin types present on a given TLMM pinmux version.
>
> Add support only for TLMM version 3 pinmux right now,
> as well as, only two of the different pin types present on the
> TLMM v3 pinmux.
> Pintype 1: General purpose pins.
> Pintype 2: SDC pins.
>
> Signed-off-by: Hanumant Singh <hanumant@codeaurora.org>

This is looking better. (Sorry for late feedback...)

> +Required Properties
> +  - qcom,pin-type: identifies the pin type.

Define the possible types. If these are enumerable, don't pass a
generic string, use an hard identifier, e.g:

qcom,pin-type-gp;
qcom,pin-type-sdc;

(...)
> +Example 1: A pin-controller node with pin types
> +
> +       pinctrl@fd5110000 {
> +               compatible = "qcom,msm-tlmm-v3";
> +               reg = <0x11400000 0x4000>;
> +
> +               /* General purpose pin type */
> +               gp: gp {
> +                       qcom,pin-type = "gp";

Can we use qcom,pin-type-gp; ?

(...)
> +Example 2: Spi pin entries within the pincontroller node
> +       pinctrl@fd511000 {
> +               ....
> +               ..
> +               spi-bus {
> +                       /*
> +                        * MOSI, MISO and CLK lines
> +                        * all sharing same function and config
> +                        * settings for each configuration node.
> +                        */
> +                       qcom,pins = <&gp 0>, <&gp 1>, <&gp 3>;
> +                       qcom,pin-func = <1>;
> +
> +                       /* Active configuration of bus pins */
> +                       spi-bus-active: spi-bus-active {
> +                               drive-strength = <3>; /* 8 MA */

No that shall be <8>.

If you need a translation table to translate this into your
magic constants, put a cross-reference table in your driver.

> +                               bias-disable; /* No PULL */
> +                       };
> +                       /* Sleep configuration of bus pins */
> +                       spi-bus-sleep: spi-bus-sleep {
> +                               drive-strength = <0>; /* 2 MA */

This shall be <2>;

> +                               bias-disable; /* No PULL */
> +                       };
> +               };
> +
> +               spi-cs {
> +                       /*
> +                        * Chip select for SPI
> +                        * different config
> +                        * settings as compared to bus pins.
> +                        */
> +                       qcom,pins = <&Gp 2>;
> +                       qcom,num-grp-pins = <1>;
> +                       qcom,pin-func = <1>;
> +
> +                       /* Active configuration of cs pin */
> +                       spi-cs-active: spi-cs-active {
> +                               drive-strength = <2>; /* 4 MA */

This shall be <4>;

> +                               bias-disable; /* No PULL */
> +                       };
> +                       /* Sleep configuration of cs pin */
> +                       spi-bus-sleep: spi-bus-sleep {
> +                               drive-strength = <0>; /* 2 MA */

This shall be <2>;

> +                               bias-disable = <0>; /* No PULL */

Just bias-disable;

(...)
> +Example 3: A SPI client node that supports 'active' and 'sleep' states.
> +
> +       spi_0: spi@f9923000 { /* BLSP1 QUP1 */
> +                       compatible = "qcom,spi-qup-v2";
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> +                       reg-names = "spi_physical", "spi_bam_physical";
> +                       reg = <0xf9923000 0x1000>,
> +                       <0xf9904000 0xF000>;
> +                       interrupt-names = "spi_irq", "spi_bam_irq";
> +                       interrupts = <0 95 0>, <0 238 0>;
> +                       spi-max-frequency = <19200000>;
> +
> +                       /* pins used by spi controllers */
> +                       pinctrl-names = "default", "sleep";
> +                       pinctrl-0 = <&spi-bus-active &spi-cs-active>;
> +                       pinctrl-1 = <&spi-bus-sleep &spi-cs-sleep>;
> +
> +                       qcom,infinite-mode = <0>;
> +                       qcom,use-bam;
> +                       qcom,ver-reg-exists;
> +               qcom,bam-consumer-pipe-index = <12>;
> +               qcom,bam-producer-pipe-index = <13>;
> +                };

Looks good.

> +Example 4: Set up the default pin state for spi controller.
> +
> +       static inline int msm_spi_request_pins{struct msm_spi *dd)
> +       {
> +               /* ... */
> +               state = pinctrl_lookup_state(dd->dev->pins->p, "sleep");
> +               pinctrl_select_state(dd->dev->pins->p, state);
> +       }

Do not put such things into the OS-neutral devicetree bindings
documentation.

(...)
> +static int msm_tlmm_v3_sdc_cfg(uint pin_no, unsigned long *config,
> +                                               void __iomem *reg_base,
> +                                               bool write)
> +{
> +       unsigned int val, id, data;
> +       u32 mask, shft;
> +       void __iomem *cfg_reg;
> +
> +       cfg_reg = reg_base + sdc_regs[pin_no].offset;
> +       id = pinconf_to_config_param(*config);
> +       /* Get mask and shft values for this config type */
> +       switch (id) {
> +       case PIN_CONFIG_BIAS_DISABLE:
> +       case PIN_CONFIG_BIAS_PULL_DOWN:
> +       case PIN_CONFIG_BIAS_PULL_UP:
> +               mask = sdc_regs[pin_no].pull_mask;
> +               shft = sdc_regs[pin_no].pull_shft;
> +               break;
> +       case PIN_CONFIG_DRIVE_STRENGTH:
> +               mask = sdc_regs[pin_no].drv_mask;
> +               shft = sdc_regs[pin_no].drv_shft;
> +               break;
> +       default:
> +               return -EINVAL;
> +       };
> +
> +       val = readl_relaxed(cfg_reg);
> +       if (write) {
> +               data = pinconf_to_config_argument(*config);

This data needs to be treated per-config option and be more
optional. This makes it look like you want to supply a <1>
with any pull up or pull down configuration to nail it in when in
fact they do not take any argument, and if they do it should
be the number of Ohms in the resistor, not <1>.

For drive strength you need a mA -> selector translation table
as mentioned.

> +               val &= ~(mask << shft);
> +               val |= (data << shft);
> +               writel_relaxed(val, cfg_reg);
> +       } else {
> +               val >>= shft;
> +               val &= mask;
> +               *config = pinconf_to_config_packed(id, val);

Same thing applies in reverse here.

> +static void msm_tlmm_v3_sdc_set_reg_base(void __iomem **ptype_base,
> +                                                       void __iomem *tlmm_base)
> +{
> +       *ptype_base = tlmm_base + 0x2044;
> +}

0x2044 looks a bit magic, use a #define for this or atleast put in
some comment...

> +static int msm_tlmm_v3_gp_cfg(uint pin_no, unsigned long *config,
> +                                               void *reg_base, bool write)
> +{
> +       unsigned int val, id, data;
> +       u32 mask = 0, shft = 0;
> +       void __iomem *inout_reg = NULL;
> +       void __iomem *cfg_reg = TLMMV3_GP_CFG(reg_base, pin_no);
> +
> +       id = pinconf_to_config_param(*config);
> +       /* Get mask and shft values for this config type */
> +       switch (id) {
> +       case PIN_CONFIG_BIAS_DISABLE:
> +       case PIN_CONFIG_BIAS_PULL_DOWN:
> +       case PIN_CONFIG_BIAS_PULL_UP:
> +               mask = TLMMV3_GP_PULL_MASK;
> +               shft = TLMMV3_GP_PULL_SHFT;
> +               break;
> +       case PIN_CONFIG_DRIVE_STRENGTH:
> +               mask = TLMMV3_GP_DRV_MASK;
> +               shft = TLMMV3_GP_DRV_SHFT;
> +               break;
> +       case PIN_CONFIG_OUTPUT:
> +               mask = TLMMV3_GP_DIR_MASK;
> +               shft = TLMMV3_GP_DIR_SHFT;
> +               break;
> +       default:
> +               return -EINVAL;
> +       };
> +
> +       val = readl_relaxed(cfg_reg);
> +       if (write) {
> +               data = pinconf_to_config_argument(*config);
> +               if (id == PIN_CONFIG_OUTPUT) {
> +                       if (data == TLMMV3_GP_OUT) {
> +                               inout_reg = TLMMV3_GP_INOUT(reg_base, pin_no);
> +                               writel_relaxed(TLMMV3_GP_OUT, inout_reg);
> +                       }
> +                       if (data > TLMMV3_GP_IN)
> +                               data = TLMMV3_GP_OUT;
> +               }
> +               val &= ~(mask << shft);
> +               val |= (data << shft);

Again I don't like how the argument is propagated directly into
the registers like this, treat each case in the switch clause and
handle any specific register bit flipping there on a per-config-option
basis.

(...)
> diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
(...)
> +static int msm_pinconf_parse_dt(struct device_node *cfg_np,
> +                               unsigned long **configs, unsigned int *cnt,
> +                               struct msm_pintype_info *pinfo)
> +{
> +       struct msm_tlmm_cfg_params const *cfg_params;
> +       unsigned int num_cfg_params, idx = 0, cfg_cnt = 0;
> +       unsigned long *cfg = NULL;
> +       unsigned int val = 0;
> +
> +       cfg_params = pinfo->tlmm_cfg_param;
> +       num_cfg_params = pinfo->num_cfg_params;
> +
> +       for (idx = 0; idx < num_cfg_params; idx++) {
> +               if (!of_find_property(cfg_np, cfg_params[idx].name, NULL))
> +                       continue;
> +               cfg_cnt++;
> +       }
> +       if (!cfg_cnt)
> +               return -EINVAL;
> +       /* Allocate memory to hold configs */
> +       cfg = kzalloc(sizeof(*cfg) * cfg_cnt, GFP_KERNEL);
> +       if (!cfg)
> +               return -ENOMEM;
> +       /* read cfg property values from cfg device tree node */
> +       for (idx = 0, cfg_cnt = 0; idx < num_cfg_params; idx++) {
> +               if (!of_find_property(cfg_np, cfg_params[idx].name, NULL))
> +                       continue;
> +               of_property_read_u32(cfg_np, cfg_params[idx].name, &val);
> +               cfg[cfg_cnt++] = pinfo->pack_cfg(val, &cfg_params[idx]);
> +       }
> +       *cnt = cfg_cnt;
> +       *configs = cfg;
> +       return 0;
> +}

What is this? As far as I can see you're not using any non-standard
configs yet so don't implement code for it.

> +       /*
> +        * If no pin type specifc config parameters are specified
> +        * use general puropse pin config parsing
> +        */
> +       if (!pinfo->tlmm_cfg_param)
> +               ret = pinconf_generic_parse_dt_config(cfg_np, &cfg,
> +                                                               &cfg_cnt);
> +
> +        else
> +               ret = msm_pinconf_parse_dt(cfg_np, &cfg, &cfg_cnt, pinfo);

This looks like *either* generic *or* custom pin configuration,
but in the previous mail you mentioned using *both*
simultaneously. I don't see how this could work?

> +/**
> + * struct msm_tlmm_cfgs: represent config properties of a pin type.
> + * @name: name of config.
> + * @id: id of the config.
> + */
> +
> +struct msm_tlmm_cfg_params {
> +       const char *name;
> +       unsigned int id;
> +};

Since these have no device tree bindings, don't implement them.
This looks like a free pass to encode just anything in here...

Yours,
Linus Walleij
