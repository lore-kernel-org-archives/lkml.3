Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab3LNQdc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 11:33:32 -0500
Received: from mail.active-venture.com ([67.228.131.205]:53154 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab3LNQd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 11:33:29 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52AC8857.8070504@roeck-us.net>
Date: Sat, 14 Dec 2013 08:33:27 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        =?UTF-8?B?U8O2cmVuIEJyaW5rbWFu?= =?UTF-8?B?bg==?= 
	<soren.brinkmann@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hyun Kwon <hyunk@xilinx.com>
Subject: Re: [PATCH v5] clk: si570: Add a driver for SI570 oscillators
References: <1379806839-13762-1-git-send-email-soren.brinkmann@xilinx.com> <b625092b-682c-4072-85a6-9f9d7f378ec0@VA3EHSMHS043.ehs.local> <20131002231751.4343.81234@quantum>
In-Reply-To: <20131002231751.4343.81234@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 04:17 PM, Mike Turquette wrote:
> Quoting Sören Brinkmann (2013-10-02 10:20:38)
>> Hi Mike,
>>
>> could you please comment on this/apply it to clk-next?
>
> It looks good and is in the queue. Will show up in clk-next in a few
> days.
>
Hi Mike,

trying again ... what happened with this driver ? Any reason for not pushing it after all ?

Thanks,
Guenter

> Thanks,
> Mike
>
>>
>>          Thanks,
>>          Sören
>>
>> On Sat, Sep 21, 2013 at 04:40:39PM -0700, Soren Brinkmann wrote:
>>> Add a driver for SILabs 570, 571, 598, 599 programmable oscillators.
>>> The devices generate low-jitter clock signals and are reprogrammable via
>>> an I2C interface.
>>>
>>> Cc: Guenter Roeck <linux@roeck-us.net>
>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>>> ---
>>> v5:
>>>   - fix typo in bindings documentation
>>>   - mention the unit for the 'temperature-stability' property
>>>   - remove calls to clk_unregister() (the device managed code takes care
>>>     of it)
>>>
>>> v4:
>>>   - actually check and handle error on clk_set_rate() call
>>>
>>> v3:
>>>   - add delay in the path for small frequency changes, which can take up
>>>     to 100us according to the data sheet
>>>   - use real range for usleep_range() argument
>>>   - use dev_err() over dev_warn() in set_rate()
>>>   - add list of applicable devices for 7ppm DT prop
>>>   - remove comments regarding platform data
>>>   - ignore 7ppm DT prop for incompatible devices
>>>   - replace raw numbers with #defines
>>>   - convert DT prop 'temperature-stability' from boolean to u32
>>>   - make 'temperature-stability' DT prop required (actually not fully
>>>     true, for 59x it is ignored and the driver does not require its
>>>     presence)
>>>
>>> v2:
>>>   - document clock-output-names in bindings documentation
>>>   - don't use wildcards in compatibility string
>>>   - change Kconfig entry to "... 570 and compatible devices"
>>>   - change some indentation flaws
>>>   - use 10000 as MIN and MAX value in usleep_range
>>>   - fail probe() if 'factory-fout' is not provided in DT
>>>     - default factory fout #defines removed
>>>   - use i2c driver_data instead of OF data
>>>     - remove some related structs and data
>>>   - rename DT property 'initial-fout' => 'clock-frequency' (like si5351
>>>     driver)
>>>   - add some more details regarding the 'factory-fout' DT property
>>> ---
>>>   .../devicetree/bindings/clock/silabs,si570.txt     |  39 ++
>>>   drivers/clk/Kconfig                                |  10 +
>>>   drivers/clk/Makefile                               |   1 +
>>>   drivers/clk/clk-si570.c                            | 531 +++++++++++++++++++++
>>>   4 files changed, 581 insertions(+)
>>>   create mode 100644 Documentation/devicetree/bindings/clock/silabs,si570.txt
>>>   create mode 100644 drivers/clk/clk-si570.c
>>>
>>> diff --git a/Documentation/devicetree/bindings/clock/silabs,si570.txt b/Documentation/devicetree/bindings/clock/silabs,si570.txt
>>> new file mode 100644
>>> index 0000000..c09f21e
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/clock/silabs,si570.txt
>>> @@ -0,0 +1,39 @@
>>> +Binding for Silicon Labs 570, 571, 598 and 599 programmable
>>> +I2C clock generators.
>>> +
>>> +Reference
>>> +This binding uses the common clock binding[1]. Details about the devices can be
>>> +found in the data sheets[2][3].
>>> +
>>> +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
>>> +[2] Si570/571 Data Sheet
>>> +    http://www.silabs.com/Support%20Documents/TechnicalDocs/si570.pdf
>>> +[3] Si598/599 Data Sheet
>>> +    http://www.silabs.com/Support%20Documents/TechnicalDocs/si598-99.pdf
>>> +
>>> +Required properties:
>>> + - compatible: Shall be one of "silabs,si570", "silabs,si571",
>>> +                            "silabs,si598", "silabs,si599"
>>> + - reg: I2C device address.
>>> + - #clock-cells: From common clock bindings: Shall be 0.
>>> + - factory-fout: Factory set default frequency. This frequency is part specific.
>>> +              The correct frequency for the part used has to be provided in
>>> +              order to generate the correct output frequencies. For more
>>> +              details, please refer to the data sheet.
>>> + - temperature-stability: Temperature stability of the device in PPM. Should be
>>> +                       one of: 7, 20, 50 or 100.
>>> +
>>> +Optional properties:
>>> + - clock-output-names: From common clock bindings. Recommended to be "si570".
>>> + - clock-frequency: Output frequency to generate. This defines the output
>>> +                 frequency set during boot. It can be reprogrammed during
>>> +                 runtime through the common clock framework.
>>> +
>>> +Example:
>>> +     si570: clock-generator@5d {
>>> +             #clock-cells = <0>;
>>> +             compatible = "silabs,si570";
>>> +             temperature-stability = <50>;
>>> +             reg = <0x5d>;
>>> +             factory-fout = <156250000>;
>>> +     };
>>> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
>>> index 279407a..349b88a 100644
>>> --- a/drivers/clk/Kconfig
>>> +++ b/drivers/clk/Kconfig
>>> @@ -64,6 +64,16 @@ config COMMON_CLK_SI5351
>>>          This driver supports Silicon Labs 5351A/B/C programmable clock
>>>          generators.
>>>
>>> +config COMMON_CLK_SI570
>>> +     tristate "Clock driver for SiLabs 570 and compatible devices"
>>> +     depends on I2C
>>> +     depends on OF
>>> +     select REGMAP_I2C
>>> +     help
>>> +     ---help---
>>> +       This driver supports Silicon Labs 570/571/598/599 programmable
>>> +       clock generators.
>>> +
>>>   config COMMON_CLK_S2MPS11
>>>        tristate "Clock driver for S2MPS11 MFD"
>>>        depends on MFD_SEC_CORE
>>> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
>>> index 7b11106..c0e94b3 100644
>>> --- a/drivers/clk/Makefile
>>> +++ b/drivers/clk/Makefile
>>> @@ -40,6 +40,7 @@ obj-$(CONFIG_COMMON_CLK_AXI_CLKGEN) += clk-axi-clkgen.o
>>>   obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
>>>   obj-$(CONFIG_COMMON_CLK_MAX77686) += clk-max77686.o
>>>   obj-$(CONFIG_COMMON_CLK_SI5351) += clk-si5351.o
>>> +obj-$(CONFIG_COMMON_CLK_SI570) += clk-si570.o
>>>   obj-$(CONFIG_COMMON_CLK_S2MPS11) += clk-s2mps11.o
>>>   obj-$(CONFIG_CLK_TWL6040)    += clk-twl6040.o
>>>   obj-$(CONFIG_CLK_PPC_CORENET)        += clk-ppc-corenet.o
>>> diff --git a/drivers/clk/clk-si570.c b/drivers/clk/clk-si570.c
>>> new file mode 100644
>>> index 0000000..5d0ac9f
>>> --- /dev/null
>>> +++ b/drivers/clk/clk-si570.c
>>> @@ -0,0 +1,531 @@
>>> +/*
>>> + * Driver for Silicon Labs Si570/Si571 Programmable XO/VCXO
>>> + *
>>> + * Copyright (C) 2010, 2011 Ericsson AB.
>>> + * Copyright (C) 2011 Guenter Roeck.
>>> + * Copyright (C) 2011 - 2013 Xilinx Inc.
>>> + *
>>> + * Author: Guenter Roeck <guenter.roeck@ericsson.com>
>>> + *      Sören Brinkmann <soren.brinkmann@xilinx.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License as published by
>>> + * the Free Software Foundation; either version 2 of the License, or
>>> + * (at your option) any later version.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + */
>>> +
>>> +#include <linux/clk-provider.h>
>>> +#include <linux/delay.h>
>>> +#include <linux/module.h>
>>> +#include <linux/i2c.h>
>>> +#include <linux/regmap.h>
>>> +#include <linux/slab.h>
>>> +
>>> +/* Si570 registers */
>>> +#define SI570_REG_HS_N1              7
>>> +#define SI570_REG_N1_RFREQ0  8
>>> +#define SI570_REG_RFREQ1     9
>>> +#define SI570_REG_RFREQ2     10
>>> +#define SI570_REG_RFREQ3     11
>>> +#define SI570_REG_RFREQ4     12
>>> +#define SI570_REG_CONTROL    135
>>> +#define SI570_REG_FREEZE_DCO 137
>>> +#define SI570_DIV_OFFSET_7PPM        6
>>> +
>>> +#define HS_DIV_SHIFT         5
>>> +#define HS_DIV_MASK          0xe0
>>> +#define HS_DIV_OFFSET                4
>>> +#define N1_6_2_MASK          0x1f
>>> +#define N1_1_0_MASK          0xc0
>>> +#define RFREQ_37_32_MASK     0x3f
>>> +
>>> +#define SI570_MIN_FREQ               10000000L
>>> +#define SI570_MAX_FREQ               1417500000L
>>> +#define SI598_MAX_FREQ               525000000L
>>> +
>>> +#define FDCO_MIN             4850000000LL
>>> +#define FDCO_MAX             5670000000LL
>>> +
>>> +#define SI570_CNTRL_RECALL   (1 << 0)
>>> +#define SI570_CNTRL_FREEZE_M (1 << 5)
>>> +#define SI570_CNTRL_NEWFREQ  (1 << 6)
>>> +
>>> +#define SI570_FREEZE_DCO     (1 << 4)
>>> +
>>> +/**
>>> + * struct clk_si570:
>>> + * @hw:      Clock hw struct
>>> + * @regmap:  Device's regmap
>>> + * @div_offset:      Rgister offset for dividers
>>> + * @max_freq:        Maximum frequency for this device
>>> + * @fxtal:   Factory xtal frequency
>>> + * @n1:              Clock divider N1
>>> + * @hs_div:  Clock divider HSDIV
>>> + * @rfreq:   Clock multiplier RFREQ
>>> + * @frequency:       Current output frequency
>>> + * @i2c_client:      I2C client pointer
>>> + */
>>> +struct clk_si570 {
>>> +     struct clk_hw hw;
>>> +     struct regmap *regmap;
>>> +     unsigned int div_offset;
>>> +     u64 max_freq;
>>> +     u64 fxtal;
>>> +     unsigned int n1;
>>> +     unsigned int hs_div;
>>> +     u64 rfreq;
>>> +     u64 frequency;
>>> +     struct i2c_client *i2c_client;
>>> +};
>>> +#define to_clk_si570(_hw)    container_of(_hw, struct clk_si570, hw)
>>> +
>>> +enum clk_si570_variant {
>>> +     si57x,
>>> +     si59x
>>> +};
>>> +
>>> +/**
>>> + * si570_get_divs() - Read clock dividers from HW
>>> + * @data:    Pointer to struct clk_si570
>>> + * @rfreq:   Fractional multiplier (output)
>>> + * @n1:              Divider N1 (output)
>>> + * @hs_div:  Divider HSDIV (output)
>>> + * Returns 0 on success, negative errno otherwise.
>>> + *
>>> + * Retrieve clock dividers and multipliers from the HW.
>>> + */
>>> +static int si570_get_divs(struct clk_si570 *data, u64 *rfreq,
>>> +             unsigned int *n1, unsigned int *hs_div)
>>> +{
>>> +     int err;
>>> +     u8 reg[6];
>>> +     u64 tmp;
>>> +
>>> +     err = regmap_bulk_read(data->regmap, SI570_REG_HS_N1 + data->div_offset,
>>> +                     reg, ARRAY_SIZE(reg));
>>> +     if (err)
>>> +             return err;
>>> +
>>> +     *hs_div = ((reg[0] & HS_DIV_MASK) >> HS_DIV_SHIFT) + HS_DIV_OFFSET;
>>> +     *n1 = ((reg[0] & N1_6_2_MASK) << 2) + ((reg[1] & N1_1_0_MASK) >> 6) + 1;
>>> +     /* Handle invalid cases */
>>> +     if (*n1 > 1)
>>> +             *n1 &= ~1;
>>> +
>>> +     tmp = reg[1] & RFREQ_37_32_MASK;
>>> +     tmp = (tmp << 8) + reg[2];
>>> +     tmp = (tmp << 8) + reg[3];
>>> +     tmp = (tmp << 8) + reg[4];
>>> +     tmp = (tmp << 8) + reg[5];
>>> +     *rfreq = tmp;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +/**
>>> + * si570_get_defaults() - Get default values
>>> + * @data:    Driver data structure
>>> + * @fout:    Factory frequency output
>>> + * Returns 0 on success, negative errno otherwise.
>>> + */
>>> +static int si570_get_defaults(struct clk_si570 *data, u64 fout)
>>> +{
>>> +     int err;
>>> +     u64 fdco;
>>> +
>>> +     regmap_write(data->regmap, SI570_REG_CONTROL, SI570_CNTRL_RECALL);
>>> +
>>> +     err = si570_get_divs(data, &data->rfreq, &data->n1, &data->hs_div);
>>> +     if (err)
>>> +             return err;
>>> +
>>> +     /*
>>> +      * Accept optional precision loss to avoid arithmetic overflows.
>>> +      * Acceptable per Silicon Labs Application Note AN334.
>>> +      */
>>> +     fdco = fout * data->n1 * data->hs_div;
>>> +     if (fdco >= (1LL << 36))
>>> +             data->fxtal = div64_u64(fdco << 24, data->rfreq >> 4);
>>> +     else
>>> +             data->fxtal = div64_u64(fdco << 28, data->rfreq);
>>> +
>>> +     data->frequency = fout;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +/**
>>> + * si570_update_rfreq() - Update clock multiplier
>>> + * @data:    Driver data structure
>>> + * Passes on regmap_bulk_write() return value.
>>> + */
>>> +static int si570_update_rfreq(struct clk_si570 *data)
>>> +{
>>> +     u8 reg[5];
>>> +
>>> +     reg[0] = ((data->n1 - 1) << 6) |
>>> +             ((data->rfreq >> 32) & RFREQ_37_32_MASK);
>>> +     reg[1] = (data->rfreq >> 24) & 0xff;
>>> +     reg[2] = (data->rfreq >> 16) & 0xff;
>>> +     reg[3] = (data->rfreq >> 8) & 0xff;
>>> +     reg[4] = data->rfreq & 0xff;
>>> +
>>> +     return regmap_bulk_write(data->regmap, SI570_REG_N1_RFREQ0 +
>>> +                     data->div_offset, reg, ARRAY_SIZE(reg));
>>> +}
>>> +
>>> +/**
>>> + * si570_calc_divs() - Caluclate clock dividers
>>> + * @frequency:       Target frequency
>>> + * @data:    Driver data structure
>>> + * @out_rfreq:       RFREG fractional multiplier (output)
>>> + * @out_n1:  Clock divider N1 (output)
>>> + * @out_hs_div:      Clock divider HSDIV (output)
>>> + * Returns 0 on success, negative errno otherwise.
>>> + *
>>> + * Calculate the clock dividers (@out_hs_div, @out_n1) and clock multiplier
>>> + * (@out_rfreq) for a given target @frequency.
>>> + */
>>> +static int si570_calc_divs(unsigned long frequency, struct clk_si570 *data,
>>> +             u64 *out_rfreq, unsigned int *out_n1, unsigned int *out_hs_div)
>>> +{
>>> +     int i;
>>> +     unsigned int n1, hs_div;
>>> +     u64 fdco, best_fdco = ULLONG_MAX;
>>> +     static const uint8_t si570_hs_div_values[] = { 11, 9, 7, 6, 5, 4 };
>>> +
>>> +     for (i = 0; i < ARRAY_SIZE(si570_hs_div_values); i++) {
>>> +             hs_div = si570_hs_div_values[i];
>>> +             /* Calculate lowest possible value for n1 */
>>> +             n1 = div_u64(div_u64(FDCO_MIN, hs_div), frequency);
>>> +             if (!n1 || (n1 & 1))
>>> +                     n1++;
>>> +             while (n1 <= 128) {
>>> +                     fdco = (u64)frequency * (u64)hs_div * (u64)n1;
>>> +                     if (fdco > FDCO_MAX)
>>> +                             break;
>>> +                     if (fdco >= FDCO_MIN && fdco < best_fdco) {
>>> +                             *out_n1 = n1;
>>> +                             *out_hs_div = hs_div;
>>> +                             *out_rfreq = div64_u64(fdco << 28, data->fxtal);
>>> +                             best_fdco = fdco;
>>> +                     }
>>> +                     n1 += (n1 == 1 ? 1 : 2);
>>> +             }
>>> +     }
>>> +
>>> +     if (best_fdco == ULLONG_MAX)
>>> +             return -EINVAL;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static unsigned long si570_recalc_rate(struct clk_hw *hw,
>>> +             unsigned long parent_rate)
>>> +{
>>> +     int err;
>>> +     u64 rfreq, rate;
>>> +     unsigned int n1, hs_div;
>>> +     struct clk_si570 *data = to_clk_si570(hw);
>>> +
>>> +     err = si570_get_divs(data, &rfreq, &n1, &hs_div);
>>> +     if (err) {
>>> +             dev_err(&data->i2c_client->dev, "unable to recalc rate\n");
>>> +             return data->frequency;
>>> +     }
>>> +
>>> +     rfreq = div_u64(rfreq, hs_div * n1);
>>> +     rate = (data->fxtal * rfreq) >> 28;
>>> +
>>> +     return rate;
>>> +}
>>> +
>>> +static long si570_round_rate(struct clk_hw *hw, unsigned long rate,
>>> +             unsigned long *parent_rate)
>>> +{
>>> +     int err;
>>> +     u64 rfreq;
>>> +     unsigned int n1, hs_div;
>>> +     struct clk_si570 *data = to_clk_si570(hw);
>>> +
>>> +     if (!rate)
>>> +             return 0;
>>> +
>>> +     if (div64_u64(abs(rate - data->frequency) * 10000LL,
>>> +                             data->frequency) < 35) {
>>> +             rfreq = div64_u64((data->rfreq * rate) +
>>> +                             div64_u64(data->frequency, 2), data->frequency);
>>> +             n1 = data->n1;
>>> +             hs_div = data->hs_div;
>>> +
>>> +     } else {
>>> +             err = si570_calc_divs(rate, data, &rfreq, &n1, &hs_div);
>>> +             if (err) {
>>> +                     dev_err(&data->i2c_client->dev,
>>> +                                     "unable to round rate\n");
>>> +                     return 0;
>>> +             }
>>> +     }
>>> +
>>> +     return rate;
>>> +}
>>> +
>>> +/**
>>> + * si570_set_frequency() - Adjust output frequency
>>> + * @data:    Driver data structure
>>> + * @frequency:       Target frequency
>>> + * Returns 0 on success.
>>> + *
>>> + * Update output frequency for big frequency changes (> 3,500 ppm).
>>> + */
>>> +static int si570_set_frequency(struct clk_si570 *data, unsigned long frequency)
>>> +{
>>> +     int err;
>>> +
>>> +     err = si570_calc_divs(frequency, data, &data->rfreq, &data->n1,
>>> +                     &data->hs_div);
>>> +     if (err)
>>> +             return err;
>>> +
>>> +     /*
>>> +      * The DCO reg should be accessed with a read-modify-write operation
>>> +      * per AN334
>>> +      */
>>> +     regmap_write(data->regmap, SI570_REG_FREEZE_DCO, SI570_FREEZE_DCO);
>>> +     regmap_write(data->regmap, SI570_REG_HS_N1 + data->div_offset,
>>> +                     ((data->hs_div - HS_DIV_OFFSET) << HS_DIV_SHIFT) |
>>> +                     (((data->n1 - 1) >> 2) & N1_6_2_MASK));
>>> +     si570_update_rfreq(data);
>>> +     regmap_write(data->regmap, SI570_REG_FREEZE_DCO, 0);
>>> +     regmap_write(data->regmap, SI570_REG_CONTROL, SI570_CNTRL_NEWFREQ);
>>> +
>>> +     /* Applying a new frequency can take up to 10ms */
>>> +     usleep_range(10000, 12000);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +/**
>>> + * si570_set_frequency_small() - Adjust output frequency
>>> + * @data:    Driver data structure
>>> + * @frequency:       Target frequency
>>> + * Returns 0 on success.
>>> + *
>>> + * Update output frequency for small frequency changes (< 3,500 ppm).
>>> + */
>>> +static int si570_set_frequency_small(struct clk_si570 *data,
>>> +                                  unsigned long frequency)
>>> +{
>>> +     /*
>>> +      * This is a re-implementation of DIV_ROUND_CLOSEST
>>> +      * using the div64_u64 function lieu of letting the compiler
>>> +      * insert EABI calls
>>> +      */
>>> +     data->rfreq = div64_u64((data->rfreq * frequency) +
>>> +                     div_u64(data->frequency, 2), data->frequency);
>>> +     regmap_write(data->regmap, SI570_REG_CONTROL, SI570_CNTRL_FREEZE_M);
>>> +     si570_update_rfreq(data);
>>> +     regmap_write(data->regmap, SI570_REG_CONTROL, 0);
>>> +
>>> +     /* Applying a new frequency (small change) can take up to 100us */
>>> +     usleep_range(100, 200);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int si570_set_rate(struct clk_hw *hw, unsigned long rate,
>>> +             unsigned long parent_rate)
>>> +{
>>> +     struct clk_si570 *data = to_clk_si570(hw);
>>> +     struct i2c_client *client = data->i2c_client;
>>> +     int err;
>>> +
>>> +     if (rate < SI570_MIN_FREQ || rate > data->max_freq) {
>>> +             dev_err(&client->dev,
>>> +                     "requested frequency %lu Hz is out of range\n", rate);
>>> +             return -EINVAL;
>>> +     }
>>> +
>>> +     if (div64_u64(abs(rate - data->frequency) * 10000LL,
>>> +                             data->frequency) < 35)
>>> +             err = si570_set_frequency_small(data, rate);
>>> +     else
>>> +             err = si570_set_frequency(data, rate);
>>> +
>>> +     if (err)
>>> +             return err;
>>> +
>>> +     data->frequency = rate;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static const struct clk_ops si570_clk_ops = {
>>> +     .recalc_rate = si570_recalc_rate,
>>> +     .round_rate = si570_round_rate,
>>> +     .set_rate = si570_set_rate,
>>> +};
>>> +
>>> +static bool si570_regmap_is_volatile(struct device *dev, unsigned int reg)
>>> +{
>>> +     switch (reg) {
>>> +     case SI570_REG_CONTROL:
>>> +             return true;
>>> +     default:
>>> +             return false;
>>> +     }
>>> +}
>>> +
>>> +static bool si570_regmap_is_writeable(struct device *dev, unsigned int reg)
>>> +{
>>> +     switch (reg) {
>>> +     case SI570_REG_HS_N1 ... (SI570_REG_RFREQ4 + SI570_DIV_OFFSET_7PPM):
>>> +     case SI570_REG_CONTROL:
>>> +     case SI570_REG_FREEZE_DCO:
>>> +             return true;
>>> +     default:
>>> +             return false;
>>> +     }
>>> +}
>>> +
>>> +static struct regmap_config si570_regmap_config = {
>>> +     .reg_bits = 8,
>>> +     .val_bits = 8,
>>> +     .cache_type = REGCACHE_RBTREE,
>>> +     .max_register = 137,
>>> +     .writeable_reg = si570_regmap_is_writeable,
>>> +     .volatile_reg = si570_regmap_is_volatile,
>>> +};
>>> +
>>> +static int si570_probe(struct i2c_client *client,
>>> +             const struct i2c_device_id *id)
>>> +{
>>> +     struct clk_si570 *data;
>>> +     struct clk_init_data init;
>>> +     struct clk *clk;
>>> +     u32 initial_fout, factory_fout, stability;
>>> +     int err;
>>> +     enum clk_si570_variant variant = id->driver_data;
>>> +
>>> +     data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
>>> +     if (!data)
>>> +             return -ENOMEM;
>>> +
>>> +     init.ops = &si570_clk_ops;
>>> +     init.flags = CLK_IS_ROOT;
>>> +     init.num_parents = 0;
>>> +     data->hw.init = &init;
>>> +     data->i2c_client = client;
>>> +
>>> +     if (variant == si57x) {
>>> +             err = of_property_read_u32(client->dev.of_node,
>>> +                             "temperature-stability", &stability);
>>> +             if (err) {
>>> +                     dev_err(&client->dev,
>>> +                               "'temperature-stability' property missing\n");
>>> +                     return err;
>>> +             }
>>> +             /* adjust register offsets for 7ppm devices */
>>> +             if (stability == 7)
>>> +                     data->div_offset = SI570_DIV_OFFSET_7PPM;
>>> +
>>> +             data->max_freq = SI570_MAX_FREQ;
>>> +     } else {
>>> +             data->max_freq = SI598_MAX_FREQ;
>>> +     }
>>> +
>>> +     if (of_property_read_string(client->dev.of_node, "clock-output-names",
>>> +                     &init.name))
>>> +             init.name = client->dev.of_node->name;
>>> +
>>> +     err = of_property_read_u32(client->dev.of_node, "factory-fout",
>>> +                     &factory_fout);
>>> +     if (err) {
>>> +             dev_err(&client->dev, "'factory-fout' property missing\n");
>>> +             return err;
>>> +     }
>>> +
>>> +     data->regmap = devm_regmap_init_i2c(client, &si570_regmap_config);
>>> +     if (IS_ERR(data->regmap)) {
>>> +             dev_err(&client->dev, "failed to allocate register map\n");
>>> +             return PTR_ERR(data->regmap);
>>> +     }
>>> +
>>> +     i2c_set_clientdata(client, data);
>>> +     err = si570_get_defaults(data, factory_fout);
>>> +     if (err)
>>> +             return err;
>>> +
>>> +     clk = devm_clk_register(&client->dev, &data->hw);
>>> +     if (IS_ERR(clk)) {
>>> +             dev_err(&client->dev, "clock registration failed\n");
>>> +             return PTR_ERR(clk);
>>> +     }
>>> +     err = of_clk_add_provider(client->dev.of_node, of_clk_src_simple_get,
>>> +                     clk);
>>> +     if (err) {
>>> +             dev_err(&client->dev, "unable to add clk provider\n");
>>> +             return err;
>>> +     }
>>> +
>>> +     /* Read the requested initial output frequency from device tree */
>>> +     if (!of_property_read_u32(client->dev.of_node, "clock-frequency",
>>> +                             &initial_fout)) {
>>> +             err = clk_set_rate(clk, initial_fout);
>>> +             if (err) {
>>> +                     of_clk_del_provider(client->dev.of_node);
>>> +                     return err;
>>> +             }
>>> +     }
>>> +
>>> +     /* Display a message indicating that we've successfully registered */
>>> +     dev_info(&client->dev, "registered, current frequency %llu Hz\n",
>>> +                     data->frequency);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int si570_remove(struct i2c_client *client)
>>> +{
>>> +     of_clk_del_provider(client->dev.of_node);
>>> +     return 0;
>>> +}
>>> +
>>> +static const struct i2c_device_id si570_id[] = {
>>> +     { "si570", si57x },
>>> +     { "si571", si57x },
>>> +     { "si598", si59x },
>>> +     { "si599", si59x },
>>> +     { }
>>> +};
>>> +MODULE_DEVICE_TABLE(i2c, si570_id);
>>> +
>>> +static const struct of_device_id clk_si570_of_match[] = {
>>> +     { .compatible = "silabs,si570" },
>>> +     { .compatible = "silabs,si571" },
>>> +     { .compatible = "silabs,si598" },
>>> +     { .compatible = "silabs,si599" },
>>> +     { },
>>> +};
>>> +MODULE_DEVICE_TABLE(of, clk_si570_of_match);
>>> +
>>> +static struct i2c_driver si570_driver = {
>>> +     .driver = {
>>> +             .name = "si570",
>>> +             .of_match_table = of_match_ptr(clk_si570_of_match),
>>> +     },
>>> +     .probe          = si570_probe,
>>> +     .remove         = si570_remove,
>>> +     .id_table       = si570_id,
>>> +};
>>> +module_i2c_driver(si570_driver);
>>> +
>>> +MODULE_AUTHOR("Guenter Roeck <guenter.roeck@ericsson.com>");
>>> +MODULE_AUTHOR("Soeren Brinkmann <soren.brinkmann@xilinx.com");
>>> +MODULE_DESCRIPTION("Si570 driver");
>>> +MODULE_LICENSE("GPL");
>>> --
>>> 1.8.4
>>>
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
>

