Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331Ab3DYWjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 18:39:13 -0400
Received: from mail-ia0-f179.google.com ([209.85.210.179]:33190 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933314Ab3DYWjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 18:39:11 -0400
MIME-Version: 1.0
In-Reply-To: <1366727607-27444-6-git-send-email-james.hogan@imgtec.com>
References: <1366727607-27444-1-git-send-email-james.hogan@imgtec.com>
	<1366727607-27444-6-git-send-email-james.hogan@imgtec.com>
Date: Fri, 26 Apr 2013 00:39:10 +0200
Message-ID: <CACRpkdbYwDvF=gNurLzc+wE0BYpoqog7sPdRTY59BGS7yn3n9Q@mail.gmail.com>
Subject: Re: [PATCH 5/8] pinctrl-tz1090: add TZ1090 pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 4:33 PM, James Hogan <james.hogan@imgtec.com> wrote:

> Add a pin control driver for the main pins on the TZ1090 SoC. This
> doesn't include the low-power pins as they're controlled separately via
> the Powerdown Controller (PDC) registers.
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: linux-doc@vger.kernel.org

(...)
> +++ b/drivers/pinctrl/Kconfig
> @@ -196,6 +196,12 @@ config PINCTRL_TEGRA114
>         bool
>         select PINCTRL_TEGRA
>
> +config PINCTRL_TZ1090
> +       bool "Toumaz Xenif TZ1090 pin control driver"
> +       depends on SOC_TZ1090
> +       select PINMUX
> +       select PINCONF

Why are you not using GENERIC_PINCONF?

It doesn't seem like this pin controller is using something
that isn't covered by that library.

This way you get rid of TZ1090_PINCONF_PACK() etc
and can use the standard packing.

> +#include <asm/soc-tz1090/gpio.h>

As mentioned I want the pin definintions from the arch to be in this
subsystem as well.

If the GPIO driver is also using the, then move the GPIO driver
into drivers/pinctrl, that is recommended in such cases.

> + * @drv:       Drive control supported, 0 if unsupported.
> + *             This means Schmitt, Slew, and Drive strength.
> + * @slw_bit:   Slew register bit. 0 if unsupported.
> + *             The same bit is used for Schmitt, and Drive (*2).
(...)
> +       u32                     drv:1;

So what about you use a bool for that?

> +       u32                     slw_bit:5;
> +};

(...)
> +/* Pin names */
> +
> +static const struct pinctrl_pin_desc tz1090_pins[] = {
> +       /* Normal GPIOs */
> +       PINCTRL_PIN(TZ1090_PIN_SDIO_CLK,        "sdio_clk"),
> +       PINCTRL_PIN(TZ1090_PIN_SDIO_CMD,        "sdio_cmd"),

Are these actually the names from the datasheet? Usually these
have geographical names, like D1, A7... but just checking.

(...)
> +/* Sub muxes */

Can you describe here briefly what a sub mux is and how it is
deployed in this system? It's getting complicated at this point
so some help would be appreciated.

> +/* Pin group with mux control */
> +#define MUX_PG(pg_name, f0, f1, f2, f3, f4,                    \
> +              mux_r, mux_b, mux_w, slw_b)                      \
> +       {                                                       \
> +               .name = #pg_name,                               \
> +               .pins = pg_name##_pins,                         \
> +               .npins = ARRAY_SIZE(pg_name##_pins),            \
> +               .mux = MUX(f0, f1, f2, f3, f4,                  \
> +                          mux_r, mux_b, mux_w),                \
> +               .drv = ((slw_b) >= 0),                          \
> +               .slw_bit = (slw_b),                             \
> +       }
> +
> +#define SIMPLE_PG(pg_name)                                     \
> +       {                                                       \
> +               .name = #pg_name,                               \
> +               .pins = pg_name##_pins,                         \
> +               .npins = ARRAY_SIZE(pg_name##_pins),            \
> +       }
> +
> +#define SIMPLE_DRV_PG(pg_name, slw_b)                          \
> +       {                                                       \
> +               .name = #pg_name,                               \
> +               .pins = pg_name##_pins,                         \
> +               .npins = ARRAY_SIZE(pg_name##_pins),            \
> +               .drv = 1,                                       \
> +               .slw_bit = (slw_b),                             \
> +       }
> +
> +#define DRV_PG(pg_name, slw_b)                                 \
> +       {                                                       \
> +               .name = "drive_"#pg_name,                       \
> +               .pins = drive_##pg_name##_pins,                 \
> +               .npins = ARRAY_SIZE(drive_##pg_name##_pins),    \
> +               .drv = 1,                                       \
> +               .slw_bit = (slw_b),                             \
> +       }
> +
> +/*            name     f0,  f1,            f2,        f3, f4, mux r/b/w */
> +DEFINE_SUBMUX(ext_dac, DAC, NOT_IQADC_STB, IQDAC_STB, NA, NA, IF_CTL, 6, 2);

Again, this is not very easy to understand, so more commenting is warranted.
The macros may need individual documentation for being quite
hard to understand.

> +/**
> + * struct tz1090_pmx - Private pinctrl data
> + * @dev:       Platform device
> + * @pctl:      Pin control device
> + * @regs:      Register region
> + * @lock:      Lock protecting coherency of pin_en, gpio_en, select_en, and
> + *             SELECT regs
> + * @pin_en:    Pins that have been enabled (32 pins packed into each element)
> + * @gpio_en:   GPIOs that have been enabled (32 pins packed into each element)
> + * @select_en: Pins that have been force seleced by pinconf (32 pins packed
> + *             into each element)
> + */
> +struct tz1090_pmx {
> +       struct device           *dev;
> +       struct pinctrl_dev      *pctl;
> +       void __iomem            *regs;
> +       spinlock_t              lock;
> +       u32                     pin_en[3];
> +       u32                     gpio_en[3];
> +       u32                     select_en[3];
> +};

This looks real nice! :-)

(...)
> +/* each GPIO pin has it's own pseudo pingroup containing only itself */
> +
> +static int tz1090_pinctrl_get_groups_count(struct pinctrl_dev *pctldev)
> +{
> +       return ARRAY_SIZE(tz1090_groups) + NUM_GPIOS;
> +}

OK one way to solve it, that works...

> +static const char *tz1090_pinctrl_get_group_name(struct pinctrl_dev *pctldev,
> +                                                unsigned group)
> +{
> +       if (group < ARRAY_SIZE(tz1090_groups)) {
> +               /* normal pingroup */
> +               return tz1090_groups[group].name;
> +       } else {
> +               /* individual gpio pin pseudo-pingroup */
> +               unsigned int pin = group - ARRAY_SIZE(tz1090_groups);
> +               return tz1090_pins[pin].name;

At this point it is pretty important that the pin has a meaningful
name, that is why recycling the function names for pin names
is not good. "spi1_dout" doesn't make very much sense for a pin
that is now used as GPIO, so it better be named exactly like that.

That a pin named "D7" is sometimes used with function "spi1"
and sometimes with some conjured function like "GPIO17" makes
much more sense.

So please check pin names again.

(...)
> +static const struct cfg_param {
> +       const char *property;
> +       enum tz1090_pinconf_param param;
> +} cfg_params[] = {
> +       {"select",              TZ1090_PINCONF_PARAM_SELECT},
> +       {"pull",                TZ1090_PINCONF_PARAM_PULL},
> +       {"schmitt",             TZ1090_PINCONF_PARAM_SCHMITT},
> +       {"slew-rate",           TZ1090_PINCONF_PARAM_SLEW_RATE},
> +       {"drive-strength",      TZ1090_PINCONF_PARAM_DRIVE_STRENGTH},
> +};

Almost all exist in <linux/pinctrl/pinconf-generic.h>.

What is "select"? If you need another config parameter
we can just add it, but explain what it is and we can tell
if it fits.

> +/**
> + * tz1090_pinctrl_select() - update bit in SELECT register
> + * @pmx:               Pinmux data
> + * @pin:               Pin number (must be within GPIO range)
> + */

What is this SELECT thing now...

> +static void tz1090_pinctrl_select(struct tz1090_pmx *pmx,
> +                                 unsigned int pin)
> +{
> +       u32 reg, reg_shift, select, val;
> +       unsigned int pmx_index, pmx_shift;
> +       unsigned long flags;
> +
> +       /* uses base 32 instead of base 30 */
> +       pmx_index = pin >> 5;
> +       pmx_shift = pin & 0x1f;
> +
> +       /* select = !serial || gpio || force */
> +       select = ((~pmx->pin_en[pmx_index] |
> +                  pmx->gpio_en[pmx_index] |
> +                  pmx->select_en[pmx_index]) >> pmx_shift) & 1;
> +
> +       /* find register and bit offset (base 30) */
> +       reg = REG_PINCTRL_SELECT + 4*(pin / 30);
> +       reg_shift = pin % 30;
> +
> +       /* modify gpio select bit */
> +       __global_lock2(flags);
> +       val = pmx_read(pmx, reg);
> +       val &= ~(1 << reg_shift);
> +       val |= select << reg_shift;
> +       pmx_write(pmx, val, reg);
> +       __global_unlock2(flags);
> +}

What is this __global_lock2/__global_unlock2?

It doesn't look good :-/

I guess it's in one of the other patches. I'll figure it out...

(...)
> +/**
> + * tz1090_pinctrl_serial_select() - enable/disable serial interface for a pin
> + * @pmx:               Pinmux data
> + * @pin:               Pin number
> + * @gpio_select:       1 to enable serial interface (devices) when not GPIO,
> + *                     0 to leave pin in GPIO mode
> + *
> + * Records that serial usage is enabled/disabled so that SELECT register can be
> + * set appropriately when GPIO is disabled.
> + */

Serial? Is that to be interpreted as something connected in series
with the pin so it means we mux in some other signal
than what the GPIO driver stage drives or so?

(...)
> +/**
> + * tz1090_pinctrl_force_select() - enable/disable force gpio select for a pin
> + * @pmx:               Pinmux data
> + * @pin:               Pin number
> + * @gpio_select:       1 to force GPIO select,
> + *                     0 to unforce GPIO select
> + *
> + * Records that the GPIO is force selected and serial interface shouldn't be
> + * enabled.
> + */

What is the "force" in this? What is it forcing away?

(...)
> +static int tz1090_pinctrl_enable_mux(struct tz1090_pmx *pmx,
> +                                    const struct tz1090_muxdesc *desc,
> +                                    unsigned int function)
> +{
> +       const int *fit;
> +       unsigned long flags;
> +       int mux;
> +       unsigned int func, ret;
> +       u32 reg, mask;
> +
> +       /* find the mux value for this function, searching recursively */
> +       for (mux = 0, fit = desc->funcs;
> +            mux < ARRAY_SIZE(desc->funcs); ++mux, ++fit) {
> +               func = *fit;
> +               if (func == function)
> +                       goto found_mux;
> +
> +               /* maybe it's a sub-mux */
> +               if (func < ARRAY_SIZE(tz1090_submux) && tz1090_submux[func]) {
> +                       ret = tz1090_pinctrl_enable_mux(pmx,
> +                                                       tz1090_submux[func],
> +                                                       function);
> +                       if (!ret)
> +                               goto found_mux;
> +               }
> +       }

Oh I start to get what the submux is now ... hm, haha quite odd!

> +static int tz1090_pinctrl_enable(struct pinctrl_dev *pctldev, unsigned function,
> +                                unsigned group)
> +{
> +       struct tz1090_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
> +       const struct tz1090_pingroup *grp;
> +       int ret;
> +       const unsigned int *pit;
> +       unsigned int i, pin;
> +
> +       if (group >= ARRAY_SIZE(tz1090_groups)) {
> +               pin = group - ARRAY_SIZE(tz1090_groups);
> +               dev_dbg(pctldev->dev, "%s(func=%u (%s), pin=%u (%s))\n",
> +                       __func__,
> +                       function, tz1090_functions[function].name,
> +                       pin,
> +                       tz1090_pins[pin].name);
> +
> +               /* no muxing necessary */
> +               if (function != TZ1090_MUX_DEFAULT)
> +                       return -EINVAL;
> +               tz1090_pinctrl_serial_select(pmx, pin, 1);
> +               return 0;
> +       }
> +
> +       grp = &tz1090_groups[group];
> +       dev_dbg(pctldev->dev, "%s(func=%u (%s), group=%u (%s))\n",
> +               __func__,
> +               function, tz1090_functions[function].name,
> +               group, grp->name);
> +
> +       ret = tz1090_pinctrl_enable_mux(pmx, &grp->mux, function);
> +       if (ret)
> +               return ret;
> +
> +       /* set up each pin in group to serial interface */
> +       for (i = 0, pit = grp->pins; i < grp->npins; ++i, ++pit)
> +               tz1090_pinctrl_serial_select(pmx, *pit, 1);
> +
> +       return 0;
> +}

OK now I sort of understand serial too ... so you program the
mux to shunt in a certain peripheral and then do serial selection
to connect the selected signal in series with the pin. Correct?

> +static int tz1090_pinctrl_gpio_request_enable(struct pinctrl_dev *pctldev,
> +                                             struct pinctrl_gpio_range *range,
> +                                             unsigned int pin)
> +{
> +       struct tz1090_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
> +       tz1090_pinctrl_gpio_select(pmx, pin, 1);
> +       return 0;
> +}
> +
> +static void tz1090_pinctrl_gpio_disable_free(struct pinctrl_dev *pctldev,
> +                                            struct pinctrl_gpio_range *range,
> +                                            unsigned int pin)
> +{
> +       struct tz1090_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
> +       tz1090_pinctrl_gpio_select(pmx, pin, 0);
> +}

Usually if you define a unique group for every GPIO pin
(as you seem to have done) you do *NOT* define these two
functions. It will instead be handled by the usual groups,
check the code in pinmux.c.

(...)
> +static int tz1090_pinctrl_probe(struct platform_device *pdev)
(...)
> +       pinctrl_add_gpio_range(pmx->pctl, &tz1090_pinctrl_gpio_range);

No. This is deprecated. Do this from the GPIO driver instead,
and since you're using device tree, use the range functionality
already present in drivers/gpio/gpiolib-of.c and the standard way
to represent ranges in device trees.

> +static int tz1090_pinctrl_remove(struct platform_device *pdev)
> +{
> +       struct tz1090_pmx *pmx = platform_get_drvdata(pdev);
> +
> +       pinctrl_unregister(pmx->pctl);
> +
> +       return 0;
> +}

You forgot to remove the GPIO range. But whatever, because it's
going away.

> diff --git a/drivers/pinctrl/pinctrl-tz1090.h b/drivers/pinctrl/pinctrl-tz1090.h
> new file mode 100644
> index 0000000..b2553b0
> --- /dev/null
> +++ b/drivers/pinctrl/pinctrl-tz1090.h
> @@ -0,0 +1,58 @@
> +#ifndef __PINCTRL_TZ1090_H__
> +#define __PINCTRL_TZ1090_H__
> +
> +enum tz1090_pinconf_param {
> +       /* per-gpio parameters */
> +       TZ1090_PINCONF_PARAM_PERGPIO = 0,
> +
> +       /* argument: tz1090_pinconf_select */
> +       TZ1090_PINCONF_PARAM_SELECT,
> +       /* argument: tz1090_pinconf_pull */
> +       TZ1090_PINCONF_PARAM_PULL,
> +
> +
> +       /* grouped drive parameters */
> +       TZ1090_PINCONF_PARAM_GROUPED,
> +
> +       /* argument: tz1090_pinconf_schmitt */
> +       TZ1090_PINCONF_PARAM_SCHMITT,
> +       /* argument: tz1090_pinconf_slew */
> +       TZ1090_PINCONF_PARAM_SLEW_RATE,
> +       /* argument: tz1090_pinconf_drive */
> +       TZ1090_PINCONF_PARAM_DRIVE_STRENGTH,
> +};
> +
> +enum tz1090_pinconf_select {
> +       TZ1090_PINCONF_SELECT_SERIAL,
> +       TZ1090_PINCONF_SELECT_GPIO,
> +};
> +
> +enum tz1090_pinconf_pull {
> +       TZ1090_PINCONF_PULL_TRISTATE,
> +       TZ1090_PINCONF_PULL_UP,
> +       TZ1090_PINCONF_PULL_DOWN,
> +       TZ1090_PINCONF_PULL_REPEATER,
> +};

Compare:
 * @PIN_CONFIG_BIAS_HIGH_IMPEDANCE: the pin will be set to a high impedance
 *      mode, also know as "third-state" (tristate) or "high-Z" or "floating".
 *      On output pins this effectively disconnects the pin, which is useful
 *      if for example some other pin is going to drive the signal connected
 *      to it for a while. Pins used for input are usually always high
 *      impedance.
 * @PIN_CONFIG_BIAS_PULL_UP: the pin will be pulled up (usually with high
 *      impedance to VDD). If the argument is != 0 pull-up is enabled,
 *      if it is 0, pull-up is disabled.
 * @PIN_CONFIG_BIAS_PULL_DOWN: the pin will be pulled down (usually with high
 *      impedance to GROUND). If the argument is != 0 pull-down is enabled,
 *      if it is 0, pull-down is disabled.

What is "repeater"?

> +enum tz1090_pinconf_schmitt {
> +       TZ1090_PINCONF_SCHMITT_OFF,     /* no hysteresis */
> +       TZ1090_PINCONF_SCHMITT_ON,      /* schmitt trigger */
> +};

Compare:
 * @PIN_CONFIG_INPUT_SCHMITT_ENABLE: control schmitt-trigger mode on the pin.
 *      If the argument != 0, schmitt-trigger mode is enabled. If it's 0,
 *      schmitt-trigger mode is disabled.

> +enum tz1090_pinconf_slew {
> +       TZ1090_PINCONF_SLEW_SLOW,       /* half frequency */
> +       TZ1090_PINCONF_SLEW_FAST,
> +};

Compare:
 * @PIN_CONFIG_SLEW_RATE: if the pin can select slew rate, the argument to
 *      this parameter (on a custom format) tells the driver which alternative
 *      slew rate to use.

> +enum tz1090_pinconf_drive {
> +       TZ1090_PINCONF_DRIVE_2mA,
> +       TZ1090_PINCONF_DRIVE_4mA,
> +       TZ1090_PINCONF_DRIVE_8mA,
> +       TZ1090_PINCONF_DRIVE_12mA,
> +};

Compare:
 * @PIN_CONFIG_DRIVE_STRENGTH: the pin will output the current passed as
 *      argument. The argument is in mA.

> +
> +#define TZ1090_PINCONF_PACK(_param_, _arg_)    ((_param_) << 16 | (_arg_))
> +#define TZ1090_PINCONF_UNPACK_PARAM(_conf_)    ((_conf_) >> 16)
> +#define TZ1090_PINCONF_UNPACK_ARG(_conf_)      ((_conf_) & 0xffff)
> +
> +#endif /* __PINCTRL_TZ1090_H__ */


I suggest you get rid of all this. Use pinconf-generic, augment the
pinconf-generic.h file if need be.

Yours,
Linus Walleij
