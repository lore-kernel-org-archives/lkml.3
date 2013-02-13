Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456Ab3BMN3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 08:29:19 -0500
Received: from smtp-out-082.synserver.de ([212.40.185.82]:1176 "EHLO
	smtp-out-081.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757104Ab3BMN3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 08:29:17 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 313
Message-ID: <511B9575.1050506@metafoo.de>
Date: Wed, 13 Feb 2013 14:30:29 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
CC: Guenter Roeck <linux@roeck-us.net>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        dianders@chromium.org, gregkh@linuxfoundation.org
Subject: Re: iio: adc: add exynos5 adc driver under iio framwork
References: <1358917086-4148-1-git-send-email-ch.naveen@samsung.com> <20130212210732.GA8634@roeck-us.net> <CAHfPSqCwqD2gzB9eiTi1hSQvRgwbsjp9NfEb3RKpy+_+DbdhzQ@mail.gmail.com> <CAHfPSqAJN8C6d6Oa=1UDpJ+hTXbEOGBio4Ob__ZphsKq=Rvppg@mail.gmail.com>
In-Reply-To: <CAHfPSqAJN8C6d6Oa=1UDpJ+hTXbEOGBio4Ob__ZphsKq=Rvppg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 02:16 PM, Naveen Krishna Ch wrote:
> Please ignore the unfinished previous mail.
> 
> 
> 
> On 13 February 2013 08:18, Naveen Krishna Ch <naveenkrishna.ch@gmail.com> wrote:
>> On 13 February 2013 02:37, Guenter Roeck <linux@roeck-us.net> wrote:
>>> On Wed, Jan 23, 2013 at 04:58:06AM -0000, Naveen Krishna Chatradhi wrote:
>>>> This patch add an ADC IP found on EXYNOS5 series socs from Samsung.
>>>> Also adds the Documentation for device tree bindings.
>>>>
>>>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>>>>
>>>> ---
>>>> Changes since v1:
>>>>
>>>> 1. Fixed comments from Lars
>>>> 2. Added support for ADC on EXYNOS5410
>>>>
>>>> Changes since v2:
>>>>
>>>> 1. Changed the instance name for (struct iio_dev *) to indio_dev
>>>> 2. Changed devm_request_irq to request_irq
>>>>
>>>> Few doubts regarding the mappings and child device handling.
>>>> Kindly, suggest me better methods.
>>>>
>>>>  .../bindings/arm/samsung/exynos5-adc.txt           |   37 ++
>>>>  drivers/iio/adc/Kconfig                            |    7 +
>>>>  drivers/iio/adc/Makefile                           |    1 +
>>>>  drivers/iio/adc/exynos5_adc.c                      |  464 ++++++++++++++++++++
>>>>  4 files changed, 509 insertions(+)
>>>>  create mode 100644 Documentation/devicetree/bindings/arm/samsung/exynos5-adc.txt
>>>>  create mode 100644 drivers/iio/adc/exynos5_adc.c
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos5-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos5-adc.txt
>>>> new file mode 100644
>>>> index 0000000..9a5b515
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos5-adc.txt
>>>> @@ -0,0 +1,37 @@
>>>> +Samsung Exynos5 Analog to Digital Converter bindings
>>>> +
>>>> +Required properties:
>>>> +- compatible:                Must be "samsung,exynos5250-adc" for exynos5250 controllers.
>>>> +- reg:                       Contains ADC register address range (base address and
>>>> +                     length).
>>>> +- interrupts:                Contains the interrupt information for the timer. The
>>>> +                     format is being dependent on which interrupt controller
>>>> +                     the Samsung device uses.
>>>> +
>>>> +Note: child nodes can be added for auto probing from device tree.
>>>> +
>>>> +Example: adding device info in dtsi file
>>>> +
>>>> +adc@12D10000 {
>>>> +     compatible = "samsung,exynos5250-adc";
>>>> +     reg = <0x12D10000 0x100>;
>>>> +     interrupts = <0 106 0>;
>>>> +     #address-cells = <1>;
>>>> +     #size-cells = <1>;
>>>> +     ranges;
>>>> +};
>>>> +
>>>> +
>>>> +Example: Adding child nodes in dts file
>>>> +
>>>> +adc@12D10000 {
>>>> +
>>>> +     /* NTC thermistor is a hwmon device */
>>>> +     ncp15wb473@0 {
>>>> +             compatible = "ntc,ncp15wb473";
>>>> +             reg = <0x0>;
>>>> +             pullup-uV = <1800000>;
>>>> +             pullup-ohm = <47000>;
>>>> +             pulldown-ohm = <0>;
>>>> +     };
>>>> +};
>>>
>>> How about:
>>>
>>>         adc: adc@12D10000 {
>>>                 compatible = "samsung,exynos5250-adc";
>>>                 reg = <0x12D10000 0x100>;
>>>                 interrupts = <0 106 0>;
>>>                 #io-channel-cells = <1>;
>>>         };
>>>
>>>         ...
>>>
>>>         ncp15wb473@0 {
>>>                 compatible = "ntc,ncp15wb473";
>>>                 reg = <0x0>; /* is this needed ? */
>>>                 io-channels = <&adc 0>;
>>>                 io-channel-names = "adc";
>>>                 pullup-uV = <1800000>;  /* uV or uv ? */
>>>                 pullup-ohm = <47000>;
>>>                 pulldown-ohm = <0>;
>>>         };
>>>
>>> The ncp15wb473 driver would then use either iio_channel_get_all() to get the iio
>>> channel list or, if it only supports one adc channel per instance, iio_channel_get().
>>>
>>> In that context, it would probably make sense to rework the ntc_thermistor
>>> driver to support both DT as well as direct instantiation using access functions
>>> and platform data (as it does today).
>>>
>>> Also see https://patchwork.kernel.org/patch/2112171/.
> 
> Hello Guenter,
> 
> I've rebase my adc driver on top of your (OF for IIO patch)
> 
> My setup is like the below one. kindly, help me find the right device
> tree node params
> 
> One ADC controller with 8 channels,
>   4 NTC thermistors are connected to channel 3, 4, 5 and 6 of ADC respectively
> 
> ADC ch - 0
> ADC ch - 1
> ADC ch - 2
> ADC ch - 3 ------------------NTC
> ADC ch - 4 ------------------NTC
> ADC ch - 5 ------------------NTC
> ADC ch - 6 ------------------NTC
> ADC ch - 7
> 
> I've started off with something like this.
> 
>         adc0: adc@12D10000 {
>                 compatible = "samsung,exynos5250-adc";
>                 reg = <0x12D10000 0x100>;
>                 interrupts = <0 106 0>;
>                 #io-channel-cells = <1>;
>         };
> 
>         adc0: adc@12D10000 {

This is a copy paste error, right? you only have one dt node for the adc?

>                 vdd-supply = <&buck5_reg>;
> 
>                 ncp15wb473@0 {
>                         compatible = "ntc,ncp15wb473";
>                         io-channels = <&adc0 3>;
>                         io-channel-names = "adc3";
>                         pullup-uV = <1800000>;
>                         pullup-ohm = <47000>;
>                         pulldown-ohm = <0>;
>                         id = <3>;
>                 };
> 
>                 ncp15wb473@1 {
>                         compatible = "ntc,ncp15wb473";
>                         pullup-uV = <1800000>;
>                         pullup-ohm = <47000>;
>                         pulldown-ohm = <0>;
>                         io-channels = <&adc0 4>;
>                         io-channel-names = "adc4";
>                         id = <4>;
>                 };
>                 ncp15wb473@2 {
>                         compatible = "ntc,ncp15wb473";
>                         pullup-uV = <1800000>;
>                         pullup-ohm = <47000>;
>                         pulldown-ohm = <0>;
>                         io-channels = <&adc0 5>;
>                         io-channel-names = "adc5";
>                         id = <5>;
>                 };
>                 ncp15wb473@3 {
>                         compatible = "ntc,ncp15wb473";
>                         pullup-uV = <1800000>;
>                         pullup-ohm = <47000>;
>                         pulldown-ohm = <0>;
>                         io-channels = <&adc0 6>;
>                         io-channel-names = "adc6";
>                         id = <6>;
>                 };
>         };
> 
> ADC driver will use of_platform_populate() to populate the child nodes
> (ntc thermistors in my case)
> 
> I've modified the NTC driver to support DT. in probe
> chan = iio_channel_get(&pdev->dev, "adcX");
> and using "id" field to use respective ADC channel to do the raw_read()

The beauty of the interface is that the consumer doesn't need to know the
number of the channel it is using. This is already fully described in the
io-channels property. Since you only have one channel per consumer just use

	iio_chanel_get(&pdev->dev, NULL)

> 
> Issue:
> 1. I get weird device names for thermistors starting from ncp15wb473.2
> to ncp15wb473.5
> 2. ADC doesn't looks like creating valid channels
> 
> Any clues please
> 
>>>
>>> Thanks,
>>> Guenter
>> Yes Guenter, I will rebase and submit the ADC driver based on your patch set.
>>>
>>>> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
>>>> index fe822a1..33ceabf 100644
>>>> --- a/drivers/iio/adc/Kconfig
>>>> +++ b/drivers/iio/adc/Kconfig
>>>> @@ -91,6 +91,13 @@ config AT91_ADC
>>>>       help
>>>>         Say yes here to build support for Atmel AT91 ADC.
>>>>
>>>> +config EXYNOS5_ADC
>>>> +     bool "Exynos5 ADC driver support"
>>>> +     help
>>>> +       Core support for the ADC block found in the Samsung EXYNOS5 series
>>>> +       of SoCs for drivers such as the touchscreen and hwmon to use to share
>>>> +       this resource.
>>>> +
>>>>  config LP8788_ADC
>>>>       bool "LP8788 ADC driver"
>>>>       depends on MFD_LP8788
>>>> diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
>>>> index 2d5f100..5b4a4f6 100644
>>>> --- a/drivers/iio/adc/Makefile
>>>> +++ b/drivers/iio/adc/Makefile
>>>> @@ -10,6 +10,7 @@ obj-$(CONFIG_AD7791) += ad7791.o
>>>>  obj-$(CONFIG_AD7793) += ad7793.o
>>>>  obj-$(CONFIG_AD7887) += ad7887.o
>>>>  obj-$(CONFIG_AT91_ADC) += at91_adc.o
>>>> +obj-$(CONFIG_EXYNOS5_ADC) += exynos5_adc.o
>>>>  obj-$(CONFIG_LP8788_ADC) += lp8788_adc.o
>>>>  obj-$(CONFIG_MAX1363) += max1363.o
>>>>  obj-$(CONFIG_TI_ADC081C) += ti-adc081c.o
>>>> diff --git a/drivers/iio/adc/exynos5_adc.c b/drivers/iio/adc/exynos5_adc.c
>>>> new file mode 100644
>>>> index 0000000..8982675
>>>> --- /dev/null
>>>> +++ b/drivers/iio/adc/exynos5_adc.c
>>>> @@ -0,0 +1,464 @@
>>>> +/*
>>>> + *  exynos5_adc.c - Support for ADC in EXYNOS5 SoCs
>>>> + *
>>>> + *  8 ~ 10 channel, 10/12-bit ADC
>>>> + *
>>>> + *  Copyright (C) 2013 Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>>>> + *
>>>> + *  This program is free software; you can redistribute it and/or modify
>>>> + *  it under the terms of the GNU General Public License as published by
>>>> + *  the Free Software Foundation; either version 2 of the License, or
>>>> + *  (at your option) any later version.
>>>> + *
>>>> + *  This program is distributed in the hope that it will be useful,
>>>> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> + *  GNU General Public License for more details.
>>>> + *
>>>> + *  You should have received a copy of the GNU General Public License
>>>> + *  along with this program; if not, write to the Free Software
>>>> + *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>>>> + */
>>>> +
>>>> +#include <linux/module.h>
>>>> +#include <linux/platform_device.h>
>>>> +#include <linux/interrupt.h>
>>>> +#include <linux/delay.h>
>>>> +#include <linux/kernel.h>
>>>> +#include <linux/slab.h>
>>>> +#include <linux/io.h>
>>>> +#include <linux/clk.h>
>>>> +#include <linux/completion.h>
>>>> +#include <linux/of.h>
>>>> +#include <linux/of_irq.h>
>>>> +#include <linux/regulator/consumer.h>
>>>> +#include <linux/of_platform.h>
>>>> +
>>>> +#include <linux/iio/iio.h>
>>>> +#include <linux/iio/machine.h>
>>>> +#include <linux/iio/driver.h>
>>>> +
>>>> +enum adc_version {
>>>> +     ADC_V1,
>>>> +     ADC_V2
>>>> +};
>>>> +
>>>> +/* EXYNOS5250 ADC_V1 registers definitions */
>>>> +#define ADC_V1_CON(x)                ((x) + 0x00)
>>>> +#define ADC_V1_DLY(x)                ((x) + 0x08)
>>>> +#define ADC_V1_DATX(x)               ((x) + 0x0C)
>>>> +#define ADC_V1_INTCLR(x)     ((x) + 0x18)
>>>> +#define ADC_V1_MUX(x)                ((x) + 0x1c)
>>>> +
>>>> +/* EXYNOS5410 ADC_V2 registers definitions */
>>>> +#define ADC_V2_CON1(x)               ((x) + 0x00)
>>>> +#define ADC_V2_CON2(x)               ((x) + 0x04)
>>>> +#define ADC_V2_STAT(x)               ((x) + 0x08)
>>>> +#define ADC_V2_INT_EN(x)     ((x) + 0x10)
>>>> +#define ADC_V2_INT_ST(x)     ((x) + 0x14)
>>>> +#define ADC_V2_VER(x)                ((x) + 0x20)
>>>> +
>>>> +/* Bit definitions for ADC_V1 */
>>>> +#define ADC_V1_CON_RES               (1u << 16)
>>>> +#define ADC_V1_CON_PRSCEN    (1u << 14)
>>>> +#define ADC_V1_CON_PRSCLV(x) (((x) & 0xFF) << 6)
>>>> +#define ADC_V1_CON_STANDBY   (1u << 2)
>>>> +
>>>> +/* Bit definitions for ADC_V2 */
>>>> +#define ADC_V2_CON1_SOFT_RESET       (1u << 2)
>>>> +
>>>> +#define ADC_V2_CON2_OSEL     (1u << 10)
>>>> +#define ADC_V2_CON2_ESEL     (1u << 9)
>>>> +#define ADC_V2_CON2_HIGHF    (1u << 8)
>>>> +#define ADC_V2_CON2_C_TIME(x)        (((x) & 7) << 4)
>>>> +#define ADC_V2_CON2_ACH_SEL(x)       (((x) & 0xF) << 0)
>>>> +#define ADC_V2_CON2_ACH_MASK 0xF
>>>> +
>>>> +/* Bit definitions common for ADC_V1 and ADC_V2 */
>>>> +#define ADC_V1_CON_EN_START          (1u << 0)
>>>> +#define ADC_V1_DATX_MASK     0xFFF
>>>> +
>>>> +struct exynos5_adc {
>>>> +     void __iomem            *regs;
>>>> +     struct clk              *clk;
>>>> +     unsigned int            irq;
>>>> +     struct regulator        *vdd;
>>>> +
>>>> +     struct completion       completion;
>>>> +
>>>> +     struct iio_map          *map;
>>>> +     u32                     value;
>>>> +     unsigned int            version;
>>>> +};
>>>> +
>>>> +static const struct of_device_id exynos5_adc_match[] = {
>>>> +     { .compatible = "samsung,exynos5250-adc", .data = (void *)ADC_V1 },
>>>> +     { .compatible = "samsung,exynos5410-adc", .data = (void *)ADC_V2 },
>>>> +     {},
>>>> +};
>>>> +MODULE_DEVICE_TABLE(of, exynos5_adc_match);
>>>> +
>>>> +static inline unsigned int exynos5_adc_get_version(struct platform_device *pdev)
>>>> +{
>>>> +     const struct of_device_id *match;
>>>> +
>>>> +     match = of_match_node(exynos5_adc_match, pdev->dev.of_node);
>>>> +     return (unsigned int)match->data;
>>>> +}
>>>> +
>>>> +/* default maps used by iio consumer (ex: ntc-thermistor driver) */
>>>> +static struct iio_map exynos5_adc_iio_maps[] = {
>>>> +     {
>>>> +             .consumer_dev_name = "0.ncp15wb473",
>>>> +             .consumer_channel = "adc3",
>>>> +             .adc_channel_label = "adc3",
>>>> +     },
>>>> +     {
>>>> +             .consumer_dev_name = "1.ncp15wb473",
>>>> +             .consumer_channel = "adc4",
>>>> +             .adc_channel_label = "adc4",
>>>> +     },
>>>> +     {
>>>> +             .consumer_dev_name = "2.ncp15wb473",
>>>> +             .consumer_channel = "adc5",
>>>> +             .adc_channel_label = "adc5",
>>>> +     },
>>>> +     {
>>>> +             .consumer_dev_name = "3.ncp15wb473",
>>>> +             .consumer_channel = "adc6",
>>>> +             .adc_channel_label = "adc6",
>>>> +     },
>>>> +     {},
>>>> +};
>>>> +
>>>> +static int exynos5_read_raw(struct iio_dev *indio_dev,
>>>> +                             struct iio_chan_spec const *chan,
>>>> +                             int *val,
>>>> +                             int *val2,
>>>> +                             long mask)
>>>> +{
>>>> +     struct exynos5_adc *info = iio_priv(indio_dev);
>>>> +     u32 con1, con2;
>>>> +
>>>> +     if (mask == IIO_CHAN_INFO_RAW) {
>>>> +             mutex_lock(&indio_dev->mlock);
>>>> +
>>>> +             /* Select the channel to be used and Trigger conversion */
>>>> +             if (info->version == ADC_V2) {
>>>> +                     con2 = readl(ADC_V2_CON2(info->regs));
>>>> +                     con2 &= ~ADC_V2_CON2_ACH_MASK;
>>>> +                     con2 |= ADC_V2_CON2_ACH_SEL(chan->address);
>>>> +                     writel(con2, ADC_V2_CON2(info->regs));
>>>> +
>>>> +                     con1 = readl(ADC_V2_CON1(info->regs));
>>>> +                     writel(con1 | ADC_V1_CON_EN_START,
>>>> +                                     ADC_V2_CON1(info->regs));
>>>> +             } else {
>>>> +                     writel(chan->address, ADC_V1_MUX(info->regs));
>>>> +
>>>> +                     con1 = readl(ADC_V1_CON(info->regs));
>>>> +                     writel(con1 | ADC_V1_CON_EN_START,
>>>> +                                     ADC_V1_CON(info->regs));
>>>> +             }
>>>> +
>>>> +             wait_for_completion(&info->completion);
>>>> +             *val = info->value;
>>>> +
>>>> +             mutex_unlock(&indio_dev->mlock);
>>>> +
>>>> +             return IIO_VAL_INT;
>>>> +     }
>>>> +
>>>> +     return -EINVAL;
>>>> +}
>>>> +
>>>> +static irqreturn_t exynos5_adc_isr(int irq, void *dev_id)
>>>> +{
>>>> +     struct exynos5_adc *info = (struct exynos5_adc *)dev_id;
>>>> +
>>>> +     /* Read value */
>>>> +     info->value = readl(ADC_V1_DATX(info->regs)) &
>>>> +                                             ADC_V1_DATX_MASK;
>>>> +     /* clear irq */
>>>> +     if (info->version == ADC_V2)
>>>> +             writel(1, ADC_V2_INT_ST(info->regs));
>>>> +     else
>>>> +             writel(1, ADC_V1_INTCLR(info->regs));
>>>> +
>>>> +     complete(&info->completion);
>>>> +
>>>> +     return IRQ_HANDLED;
>>>> +}
>>>> +
>>>> +static int exynos5_adc_reg_access(struct iio_dev *indio_dev,
>>>> +                           unsigned reg, unsigned writeval,
>>>> +                           unsigned *readval)
>>>> +{
>>>> +     struct exynos5_adc *info = iio_priv(indio_dev);
>>>> +     u32 ret;
>>>> +
>>>> +     mutex_lock(&indio_dev->mlock);
>>>> +
>>>> +     if (readval != NULL) {
>>>> +             ret = readl(info->regs + reg);
>>>> +             *readval = ret;
>>>> +     } else
>>>> +             ret = -EINVAL;
>>>> +
>>>> +     mutex_unlock(&indio_dev->mlock);
>>>> +
>>>> +     return ret;
>>>> +}
>>>> +
>>>> +static const struct iio_info exynos5_adc_iio_info = {
>>>> +     .read_raw = &exynos5_read_raw,
>>>> +     .debugfs_reg_access = &exynos5_adc_reg_access,
>>>> +     .driver_module = THIS_MODULE,
>>>> +};
>>>> +
>>>> +#define ADC_V1_CHANNEL(_index, _id) {                \
>>>> +     .type = IIO_VOLTAGE,                            \
>>>> +     .indexed = 1,                                   \
>>>> +     .channel = _index,                              \
>>>> +     .address = _index,                              \
>>>> +     .info_mask = IIO_CHAN_INFO_RAW_SEPARATE_BIT,    \
>>>> +     .datasheet_name = _id,                          \
>>>> +}
>>>> +
>>>> +/** ADC core in EXYNOS5410 has 10 channels,
>>>> + * ADC core in EXYNOS5250 has 8 channels
>>>> +*/
>>>> +static const struct iio_chan_spec exynos5_adc_iio_channels[] = {
>>>> +     ADC_V1_CHANNEL(0, "adc0"),
>>>> +     ADC_V1_CHANNEL(1, "adc1"),
>>>> +     ADC_V1_CHANNEL(2, "adc2"),
>>>> +     ADC_V1_CHANNEL(3, "adc3"),
>>>> +     ADC_V1_CHANNEL(4, "adc4"),
>>>> +     ADC_V1_CHANNEL(5, "adc5"),
>>>> +     ADC_V1_CHANNEL(6, "adc6"),
>>>> +     ADC_V1_CHANNEL(7, "adc7"),
>>>> +     ADC_V1_CHANNEL(8, "adc8"),
>>>> +     ADC_V1_CHANNEL(9, "adc9"),
>>>> +};
>>>> +
>>>> +static int exynos5_adc_remove_devices(struct device *dev, void *c)
>>>> +{
>>>> +     struct platform_device *pdev = to_platform_device(dev);
>>>> +
>>>> +     platform_device_unregister(pdev);
>>>> +
>>>> +     return 0;
>>>> +}
>>>> +
>>>> +static void exynos5_adc_hw_init(struct exynos5_adc *info)
>>>> +{
>>>> +     u32 con1, con2;
>>>> +
>>>> +     if (info->version == ADC_V2) {
>>>> +             con1 = ADC_V2_CON1_SOFT_RESET;
>>>> +             writel(con1, ADC_V2_CON1(info->regs));
>>>> +
>>>> +             con2 = ADC_V2_CON2_OSEL | ADC_V2_CON2_ESEL |
>>>> +                     ADC_V2_CON2_HIGHF | ADC_V2_CON2_C_TIME(0);
>>>> +             writel(con2, ADC_V2_CON2(info->regs));
>>>> +
>>>> +             /* Enable interrupts */
>>>> +             writel(1, ADC_V2_INT_EN(info->regs));
>>>> +     } else {
>>>> +             /* set default prescaler values and Enable prescaler */
>>>> +             con1 =  ADC_V1_CON_PRSCLV(49) | ADC_V1_CON_PRSCEN;
>>>> +
>>>> +             /* Enable 12-bit ADC resolution */
>>>> +             con1 |= ADC_V1_CON_RES;
>>>> +             writel(con1, ADC_V1_CON(info->regs));
>>>> +     }
>>>> +}
>>>> +
>>>> +static int exynos5_adc_probe(struct platform_device *pdev)
>>>> +{
>>>> +     struct exynos5_adc *info = NULL;
>>>> +     struct device_node *np = pdev->dev.of_node;
>>>> +     struct iio_dev *indio_dev = NULL;
>>>> +     struct resource *mem;
>>>> +     int ret = -ENODEV;
>>>> +     int irq;
>>>> +
>>>> +     if (!np)
>>>> +             return ret;
>>>> +
>>>> +     indio_dev = iio_device_alloc(sizeof(struct exynos5_adc));
>>>> +     if (!indio_dev) {
>>>> +             dev_err(&pdev->dev, "failed allocating iio device\n");
>>>> +             return -ENOMEM;
>>>> +     }
>>>> +
>>>> +     info = iio_priv(indio_dev);
>>>> +
>>>> +     mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>> +
>>>> +     info->regs = devm_request_and_ioremap(&pdev->dev, mem);
>>>> +
>>>> +     irq = platform_get_irq(pdev, 0);
>>>> +     if (irq < 0) {
>>>> +             dev_err(&pdev->dev, "no irq resource?\n");
>>>> +             ret = irq;
>>>> +             goto err_iio;
>>>> +     }
>>>> +
>>>> +     info->irq = irq;
>>>> +
>>>> +     ret = request_irq(info->irq, exynos5_adc_isr,
>>>> +                                     0, dev_name(&pdev->dev), info);
>>>> +     if (ret < 0) {
>>>> +             dev_err(&pdev->dev, "failed requesting irq, irq = %d\n",
>>>> +                                                     info->irq);
>>>> +             goto err_iio;
>>>> +     }
>>>> +
>>>> +     info->clk = devm_clk_get(&pdev->dev, "adc");
>>>> +     if (IS_ERR(info->clk)) {
>>>> +             dev_err(&pdev->dev, "failed getting clock, err = %ld\n",
>>>> +                                                     PTR_ERR(info->clk));
>>>> +             ret = PTR_ERR(info->clk);
>>>> +             goto err_irq;
>>>> +     }
>>>> +
>>>> +     info->vdd = devm_regulator_get(&pdev->dev, "vdd");
>>>> +     if (IS_ERR(info->vdd)) {
>>>> +             dev_err(&pdev->dev, "failed getting regulator, err = %ld\n",
>>>> +                                                     PTR_ERR(info->vdd));
>>>> +             ret = PTR_ERR(info->vdd);
>>>> +             goto err_irq;
>>>> +     }
>>>> +
>>>> +     info->version = exynos5_adc_get_version(pdev);
>>>> +
>>>> +     platform_set_drvdata(pdev, indio_dev);
>>>> +
>>>> +     init_completion(&info->completion);
>>>> +
>>>> +     indio_dev->name = dev_name(&pdev->dev);
>>>> +     indio_dev->dev.parent = &pdev->dev;
>>>> +     indio_dev->dev.of_node = pdev->dev.of_node;
>>>> +     indio_dev->info = &exynos5_adc_iio_info;
>>>> +     indio_dev->modes = INDIO_DIRECT_MODE;
>>>> +     indio_dev->channels = exynos5_adc_iio_channels;
>>>> +     indio_dev->num_channels = ARRAY_SIZE(exynos5_adc_iio_channels);
>>>> +
>>>> +     info->map = exynos5_adc_iio_maps;
>>>> +
>>>> +     ret = iio_map_array_register(indio_dev, info->map);
>>>> +     if (ret) {
>>>> +             dev_err(&indio_dev->dev, "failed mapping iio, err: %d\n", ret);
>>>> +             goto err_irq;
>>>> +     }
>>>> +
>>>> +     ret = iio_device_register(indio_dev);
>>>> +     if (ret)
>>>> +             goto err_map;
>>>> +
>>>> +     ret = regulator_enable(info->vdd);
>>>> +     if (ret)
>>>> +             goto err_iio_dev;
>>>> +
>>>> +     clk_prepare_enable(info->clk);
>>>> +
>>>> +     exynos5_adc_hw_init(info);
>>>> +
>>>> +     ret = of_platform_populate(np, exynos5_adc_match, NULL, &pdev->dev);
>>>> +     if (ret < 0) {
>>>> +             dev_err(&pdev->dev, "failed adding child nodes\n");
>>>> +             goto err_of_populate;
>>>> +     }
>>>> +
>>>> +     return 0;
>>>> +
>>>> +err_of_populate:
>>>> +     device_for_each_child(&pdev->dev, NULL, exynos5_adc_remove_devices);
>>>> +err_iio_dev:
>>>> +     iio_device_unregister(indio_dev);
>>>> +err_map:
>>>> +     iio_map_array_unregister(indio_dev, info->map);
>>>> +err_irq:
>>>> +     free_irq(info->irq, info);
>>>> +err_iio:
>>>> +     iio_device_free(indio_dev);
>>>> +     return ret;
>>>> +}
>>>> +
>>>> +static int exynos5_adc_remove(struct platform_device *pdev)
>>>> +{
>>>> +     struct iio_dev *indio_dev = platform_get_drvdata(pdev);
>>>> +     struct exynos5_adc *info = iio_priv(indio_dev);
>>>> +
>>>> +     iio_device_unregister(indio_dev);
>>>> +     iio_map_array_unregister(indio_dev, info->map);
>>>> +     free_irq(info->irq, info);
>>>> +     iio_device_free(indio_dev);
>>>> +
>>>> +     return 0;
>>>> +}
>>>> +
>>>> +#ifdef CONFIG_PM_SLEEP
>>>> +static int exynos5_adc_suspend(struct device *dev)
>>>> +{
>>>> +     struct exynos5_adc *info = dev_get_data(dev);
>>>> +     u32 con;
>>>> +
>>>> +     if (info->version == ADC_V2) {
>>>> +             con = readl(ADC_V2_CON1(info->regs));
>>>> +             con &= ~ADC_V1_CON_EN_START;
>>>> +             writel(con, ADC_V2_CON1(info->regs));
>>>> +     } else {
>>>> +             con = readl(ADC_V1_CON(info->regs));
>>>> +             con |= ADC_V1_CON_STANDBY;
>>>> +             writel(con, ADC_V1_CON(info->regs));
>>>> +     }
>>>> +
>>>> +     clk_unprepare_disable(info->clk);
>>>> +     regulator_disable(info->vdd);
>>>> +
>>>> +     return 0;
>>>> +}
>>>> +
>>>> +static int exynos5_adc_resume(struct device *dev)
>>>> +{
>>>> +     struct exynos5_adc *info = dev_get_data(dev);
>>>> +     int ret;
>>>> +
>>>> +     ret = regulator_enable(info->vdd);
>>>> +     if (ret)
>>>> +             return ret;
>>>> +
>>>> +     clk_prepare_enable(info->clk);
>>>> +
>>>> +     exynos5_adc_hw_init(info);
>>>> +
>>>> +     return 0;
>>>> +}
>>>> +
>>>> +#else
>>>> +#define exynos5_adc_suspend NULL
>>>> +#define exynos5_adc_resume NULL
>>>> +#endif
>>>> +
>>>> +static SIMPLE_DEV_PM_OPS(exynos5_adc_pm_ops,
>>>> +                     exynos5_adc_suspend,
>>>> +                     exynos5_adc_resume);
>>>> +
>>>> +static struct platform_driver exynos5_adc_driver = {
>>>> +     .probe          = exynos5_adc_probe,
>>>> +     .remove         = exynos5_adc_remove,
>>>> +     .driver         = {
>>>> +             .name   = "exynos5-adc",
>>>> +             .owner  = THIS_MODULE,
>>>> +             .of_match_table = of_match_ptr(exynos5_adc_match),
>>>> +             .pm     = &exynos5_adc_pm_ops,
>>>> +     },
>>>> +};
>>>> +
>>>> +module_platform_driver(exynos5_adc_driver);
>>>> +
>>>> +MODULE_AUTHOR("Naveen Krishna Chatradhi <ch.naveen@samsung.com>");
>>>> +MODULE_DESCRIPTION("Samsung EXYNOS5 ADC driver");
>>>> +MODULE_LICENSE("GPL");
>>
>>
>>
>> --
>> Shine bright,
>> (: Nav :)
> 
> 
> 
> --
> Shine bright,
> (: Nav :)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

