Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762929Ab3ECJNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:13:16 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:55304 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762733Ab3ECJNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:13:13 -0400
MIME-Version: 1.0
In-Reply-To: <517A6B01.5000708@imgtec.com>
References: <1366727607-27444-1-git-send-email-james.hogan@imgtec.com>
	<1366727607-27444-6-git-send-email-james.hogan@imgtec.com>
	<CACRpkdbYwDvF=gNurLzc+wE0BYpoqog7sPdRTY59BGS7yn3n9Q@mail.gmail.com>
	<517A6B01.5000708@imgtec.com>
Date: Fri, 3 May 2013 11:13:12 +0200
Message-ID: <CACRpkdYooPNgJuA-fZOiGJV03R_783uAOmR=QgYOahYdHcad9w@mail.gmail.com>
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

On Fri, Apr 26, 2013 at 1:54 PM, James Hogan <james.hogan@imgtec.com> wrote:
> On 25/04/13 23:39, Linus Walleij wrote:
>> On Tue, Apr 23, 2013 at 4:33 PM, James Hogan <james.hogan@imgtec.com> wrote:
>> (...)
>>> +/* Pin names */
>>> +
>>> +static const struct pinctrl_pin_desc tz1090_pins[] = {
>>> +       /* Normal GPIOs */
>>> +       PINCTRL_PIN(TZ1090_PIN_SDIO_CLK,        "sdio_clk"),
>>> +       PINCTRL_PIN(TZ1090_PIN_SDIO_CMD,        "sdio_cmd"),
>>
>> Are these actually the names from the datasheet? Usually these
>> have geographical names, like D1, A7... but just checking.
>
> Yes, these are the ball names in the datasheet, also the names of the
> corresponding gpios, and used on board schematics to refer to the SoC
> connections, although the corresponding ball indexes are also provided
> in one place in $letter$number form. I suspect it's done this way
> because many of the pins can only mux to a single peripheral (or gpio).

OK I'll live with it...

>> (...)
>>> +/* Sub muxes */
>>
>> Can you describe here briefly what a sub mux is and how it is
>> deployed in this system? It's getting complicated at this point
>> so some help would be appreciated.
>
> Sure. The TZ1090 doesn't have a lot of muxing capabilities (about 10
> bits devoted to muxing if you ignore debug signals and gpios), but the
> largest one (the TFT pins) has a 2 level mux. Here are the register fields:
>
> CR_PADS_TFT_CTL
>         TFT pad mux control
>         0 - TFT display
>         1 - Ext DAC
>         2 - TS Out 1
>         3 - Meta2 Trace
>         4 - Phyway IF
>
> CR_PADS_AFE_DIR_CTL
>         Control how the TFT pad direction is driven when CR_PADS_TFT_CTL = 1
>         0 - Pads are output to DAC
>         1 - not aqadc_stb
>         2 - iqdac_stb
>
> so the submux is an internal thing that allows the tft pins to appear to
> have all the above functions, and if any of the last 3 are chosen the
> first level mux is set to 1.

OK! Please put that whole block above in a

/*
 * Multi-line comment in the driver so it will be obvious information
 * to the poor souls that will later have to understand the code.
 */

>>> +/**
>>> + * struct tz1090_pmx - Private pinctrl data
>>> + * @dev:       Platform device
>>> + * @pctl:      Pin control device
>>> + * @regs:      Register region
>>> + * @lock:      Lock protecting coherency of pin_en, gpio_en, select_en, and
>>> + *             SELECT regs
>>> + * @pin_en:    Pins that have been enabled (32 pins packed into each element)
>>> + * @gpio_en:   GPIOs that have been enabled (32 pins packed into each element)
>>> + * @select_en: Pins that have been force seleced by pinconf (32 pins packed
>>> + *             into each element)
>>> + */
>>> +struct tz1090_pmx {
>>> +       struct device           *dev;
>>> +       struct pinctrl_dev      *pctl;
>>> +       void __iomem            *regs;
>>> +       spinlock_t              lock;
>>> +       u32                     pin_en[3];
>>> +       u32                     gpio_en[3];
>>> +       u32                     select_en[3];
>>> +};
>>
>> This looks real nice! :-)
>
> Thanks. Is the behaviour w.r.t. gpios correct/acceptable btw?...
> The pins default to "gpio mode" (SELECT=1, where the normal SoC
> peripheral cannot mess with it), so these last 3 fields basically allow
> a pin to be put in gpio mode iff:
>
> * gpio_en: gpio is requested by gpio driver
>
> * OR !pin_en: pin hasn't had a specific mux function enabled (where each
> pin can be individually muxed to "default" to take it out of gpio mode).
>
> * OR select_en: pin is force selected (pinconf select=1) in DT e.g. pin
> is part of a mux but isn't wired up to the normal thing, e.g. a TFT pin
> that's wired to a button.
>
> I.e. the gpio driver can always take control of a pin even if it's been
> muxed (e.g. allowing a driver to do a gpio bitbang bus reset).

Yes this is the case with most combined drivers.

(Maybe the framework isn't always as helpful as it could be,
improvements welcome.)

>>> +static const char *tz1090_pinctrl_get_group_name(struct pinctrl_dev *pctldev,
>>> +                                                unsigned group)
>>> +{
>>> +       if (group < ARRAY_SIZE(tz1090_groups)) {
>>> +               /* normal pingroup */
>>> +               return tz1090_groups[group].name;
>>> +       } else {
>>> +               /* individual gpio pin pseudo-pingroup */
>>> +               unsigned int pin = group - ARRAY_SIZE(tz1090_groups);
>>> +               return tz1090_pins[pin].name;
>>
>> At this point it is pretty important that the pin has a meaningful
>> name, that is why recycling the function names for pin names
>> is not good. "spi1_dout" doesn't make very much sense for a pin
>> that is now used as GPIO, so it better be named exactly like that.
>
> I think if the pin's actual name is "spi1_dout", and board schematics
> always refer to that pin name, e.g. having an LED connected to
> "spi1_dout", then it does make sense for the pin (and pingroup
> containing only that pin) to be referred to by that name, whether it's
> in gpio mode or doing it's normal job.

Yes this is OK just checking.

>> That a pin named "D7" is sometimes used with function "spi1"
>> and sometimes with some conjured function like "GPIO17" makes
>> much more sense.
>
> Are you suggesting having a function for each GPIO number that is
> enabled by muxing?

No, in your case the current scheme which matches to the
actual pin names is much better.

>> (...)
>>> +static const struct cfg_param {
>>> +       const char *property;
>>> +       enum tz1090_pinconf_param param;
>>> +} cfg_params[] = {
>>> +       {"select",              TZ1090_PINCONF_PARAM_SELECT},
>>> +       {"pull",                TZ1090_PINCONF_PARAM_PULL},
>>> +       {"schmitt",             TZ1090_PINCONF_PARAM_SCHMITT},
>>> +       {"slew-rate",           TZ1090_PINCONF_PARAM_SLEW_RATE},
>>> +       {"drive-strength",      TZ1090_PINCONF_PARAM_DRIVE_STRENGTH},
>>> +};
>>
>> Almost all exist in <linux/pinctrl/pinconf-generic.h>.
>>
>> What is "select"? If you need another config parameter
>> we can just add it, but explain what it is and we can tell
>> if it fits.
>
> select refers to the registers CR_PADS_GPIO_SELECT{0,1,2} with
> descriptions like this:
> Reset values: 0x3fffffc0, 0x3fffffff, 0x3fffffff
> 29:0    CR_PADS_GPIO_SEL0       GPIO select (1 bit per GPIO pin)
>                                 0 = serial interface
>                                 1 = GPIO interface
>                                 [29] SCB1_SCLK
>                                 (etc)
>
> PARAM_GPIO may be a better name (select seems to have just stuck from
> when the original gpio driver was written 3 years ago), although it
> should be noted that the gpio system still has to enable it too, so it's
> really about taking it out of the "serial interface" so that the
> connected SoC peripheral cannot mess with it (1) by default (2) if it's
> not connected to what the peripheral would expect, e.g. controlling
> board power!

The GPIO select should not be visible to the outside like this,
as it is a particular bit that should only be set on request from the
GPIO framework.

If what you need is to set the pin into "GPIO mode" to drive it
to some default state then from pinconf-generic.h you should use
one of the existing defines like PIN_CONFIG_OUTPUT
to actively drive it to high or low as default, or
PIN_CONFIG_BIAS_HIGH_IMPEDANCE for some default
GPIO input mode.

Read the new section named "GPIO mode pitfalls" in
Documentation/pinctrl.txt

>> (...)
>>> +/**
>>> + * tz1090_pinctrl_serial_select() - enable/disable serial interface for a pin
>>> + * @pmx:               Pinmux data
>>> + * @pin:               Pin number
>>> + * @gpio_select:       1 to enable serial interface (devices) when not GPIO,
>>> + *                     0 to leave pin in GPIO mode
>>> + *
>>> + * Records that serial usage is enabled/disabled so that SELECT register can be
>>> + * set appropriately when GPIO is disabled.
>>> + */
>>
>> Serial? Is that to be interpreted as something connected in series
>> with the pin so it means we mux in some other signal
>> than what the GPIO driver stage drives or so?
>
> Something like that. It's from the CR_PADS_GPIO_SELECT0 register
> description where each bit can be:
> "0 = serial interface" (connect pin to the named peripheral signal such
> as SCB1's SCLK (SCB is I2C controller))
> "1 = GPIO interface" (other gpio registers control it).
>
> I've confused more than once over why it's named so confusingly several
> times (it sounds more like it's referring to uart than just "some SoC
> peripheral").

OK I get it, write some smallish blurb about the above in the kerneldoc
right there.

Consider renaming this function like tz1090_pinctrl_mux_pin_to_peripheral()
which sort of tells what it does.

>> (...)
>>> +/**
>>> + * tz1090_pinctrl_force_select() - enable/disable force gpio select for a pin
>>> + * @pmx:               Pinmux data
>>> + * @pin:               Pin number
>>> + * @gpio_select:       1 to force GPIO select,
>>> + *                     0 to unforce GPIO select
>>> + *
>>> + * Records that the GPIO is force selected and serial interface shouldn't be
>>> + * enabled.
>>> + */
>>
>> What is the "force" in this? What is it forcing away?
>
> It's sort of the opposite of tz1090_pinctrl_serial_select and overrides
> it. E.g. as per the gpio behaviour described above, you might have:
> "spi1" pin group (containing "spi1_dout"), mux to function "spi1", which
> automatically calls tz1090_pinctrl_serial_select() for each pin.
> "spi1_dout" pinconf select=1, which calls tz1090_pinctrl_force_select().
>
> We want the pin to be in gpio mode as long as that select=1
> configuration is in place, or the spi controller may mess with it.
>
> The alternative is to explicitly need to pinconf select=0 on any used
> pins. Enabling the function "default" on them instead seemed much nicer
> and told the pinctrl system that the pin was in use.

By the same standards as above consider renaming this function
to tz1090_pinctrl_mux_pin_to_gpio().

>>> +static int tz1090_pinctrl_enable(struct pinctrl_dev *pctldev, unsigned function,
>>> +                                unsigned group)
>>> +{
>>> +       struct tz1090_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
>>> +       const struct tz1090_pingroup *grp;
>>> +       int ret;
>>> +       const unsigned int *pit;
>>> +       unsigned int i, pin;
>>> +
>>> +       if (group >= ARRAY_SIZE(tz1090_groups)) {
>>> +               pin = group - ARRAY_SIZE(tz1090_groups);
>>> +               dev_dbg(pctldev->dev, "%s(func=%u (%s), pin=%u (%s))\n",
>>> +                       __func__,
>>> +                       function, tz1090_functions[function].name,
>>> +                       pin,
>>> +                       tz1090_pins[pin].name);
>>> +
>>> +               /* no muxing necessary */
>>> +               if (function != TZ1090_MUX_DEFAULT)
>>> +                       return -EINVAL;
>>> +               tz1090_pinctrl_serial_select(pmx, pin, 1);
>>> +               return 0;
>>> +       }
>>> +
>>> +       grp = &tz1090_groups[group];
>>> +       dev_dbg(pctldev->dev, "%s(func=%u (%s), group=%u (%s))\n",
>>> +               __func__,
>>> +               function, tz1090_functions[function].name,
>>> +               group, grp->name);
>>> +
>>> +       ret = tz1090_pinctrl_enable_mux(pmx, &grp->mux, function);
>>> +       if (ret)
>>> +               return ret;
>>> +
>>> +       /* set up each pin in group to serial interface */
>>> +       for (i = 0, pit = grp->pins; i < grp->npins; ++i, ++pit)
>>> +               tz1090_pinctrl_serial_select(pmx, *pit, 1);
>>> +
>>> +       return 0;
>>> +}
>>
>> OK now I sort of understand serial too ... so you program the
>> mux to shunt in a certain peripheral and then do serial selection
>> to connect the selected signal in series with the pin. Correct?
>
> Yes, that's how I understand it

By renaming the functions per above, everything becomes much
clearer and less obscure.

>>> +enum tz1090_pinconf_pull {
>>> +       TZ1090_PINCONF_PULL_TRISTATE,
>>> +       TZ1090_PINCONF_PULL_UP,
>>> +       TZ1090_PINCONF_PULL_DOWN,
>>> +       TZ1090_PINCONF_PULL_REPEATER,
>>> +};
>>
>> Compare:
>>  * @PIN_CONFIG_BIAS_HIGH_IMPEDANCE: the pin will be set to a high impedance
>>  *      mode, also know as "third-state" (tristate) or "high-Z" or "floating".
>>  *      On output pins this effectively disconnects the pin, which is useful
>>  *      if for example some other pin is going to drive the signal connected
>>  *      to it for a while. Pins used for input are usually always high
>>  *      impedance.
>>  * @PIN_CONFIG_BIAS_PULL_UP: the pin will be pulled up (usually with high
>>  *      impedance to VDD). If the argument is != 0 pull-up is enabled,
>>  *      if it is 0, pull-up is disabled.
>>  * @PIN_CONFIG_BIAS_PULL_DOWN: the pin will be pulled down (usually with high
>>  *      impedance to GROUND). If the argument is != 0 pull-down is enabled,
>>  *      if it is 0, pull-down is disabled.
>>
>> What is "repeater"?
>
> This is described in the pads datasheet as "Repeater (Bus keeper)", also
> known as a bus holder, which means that it keeps the last value driven
> on a tri-state bus, so if the other end pulls it high and then goes
> tristate it stays high, and same for low.

Hm that's a pretty cool thing! I suggest you add a new #define
in very general terms describing the above to pinconf-generic.h
and use that.

Something like PIN_CONFIG_BIAS_REPEATER right below
HIGH_IMPEDANCE, as it is closely related and obviously
a biasing option.

Yours,
Linus Walleij
