Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751034AbaBWLBr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 06:01:47 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:37384 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaBWLBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 06:01:41 -0500
Message-ID: <5309D536.9020404@kernel.org>
Date: Sun, 23 Feb 2014 11:02:14 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@debian.org>
CC: Marek Belisko <marek@goldelico.com>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [RFCv1 4/4] mfd: twl4030-madc: Move driver to drivers/iio/adc
References: <20140214174040.GB26969@earth.universe> <1392403586-30540-1-git-send-email-sre@debian.org> <1392403586-30540-4-git-send-email-sre@debian.org> <53089C47.5050404@kernel.org> <20140223003504.GA28154@earth.universe>
In-Reply-To: <20140223003504.GA28154@earth.universe>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/02/14 00:35, Sebastian Reichel wrote:
> On Sat, Feb 22, 2014 at 12:47:03PM +0000, Jonathan Cameron wrote:
>> On 14/02/14 18:46, Sebastian Reichel wrote:
>>> This is a driver for an A/D converter, which belongs into
>>> drivers/iio/adc.
>>>
>>> Signed-off-by: Sebastian Reichel <sre@debian.org>
>>
>> Being inherently lazy I'm going to review this patch as it gives the complete
>> driver rather than taking on the conversion patch directly!
>
> OK.
>
>> It's a long shot, but are there any docs freely available for this part?
>
> There is documentation on Texas Instrument's website for TPS65950,
> which is supposed to be very similar to the TWL4030 and contains a
> section about the MADC module:
>
> http://www.ti.com/lit/gpn/tps65950
I had a look at that and to put it lightly the docs aren't particularly
informative. Ah well, such is life.
>
>> Obviously that may well mean that some of my comments apply to the driver
>> in general rather than the changes you've made.  Please feel free to
>> pick and choose!
>
> Having skipped over your comments I guess 70% are about the driver
> in general, but I can add another patch to the patchset, which fixes
> the driver style.
That would be great thanks!
>
>> I'd like ideally to see a little more generic tidying up in this driver.
>> As you'll notice inline I get irritated at having lots and lots of error
>> messages.  Still that's personal preference but I felt a lot more justified
>> in moaning after finding one that was incorrect ;)
>>
>> There is also a bit of functionality in here that I'm not sure is ever
>> used (the request callback functions).  It complicates the code so if no
>> using it I'd be tempted to drop it.
>
> I think the optimal workflow is:
>
> 1. convert madc driver to IIO
> 2. convert twl4030-madc-battery driver to IIO API
> 3. convert rx51-battery to IIO API
> 4. convert twl4030-madc-hwmon to IIO API / deprecate it
> 5. remove old in-kernel ABI from madc
> 6. cleanup/simplify madc
>
> I guess its much simpler to do the driver cleanup/simplification
> once we can get rid of the old API.

Perhaps.  I guess it depends on your planned schedule.  If you are intending
to plough through the above in the near future then fair enough.  If the
chances are it'll take a while, I'd be inclined to fix some of the more
glarringly hideous bits now (such as error code reporting) and then
visit your list above over time.

Note that to my mind it is converted drivers like this that sneak some
nasty code into an a subsystem I look after.  We have a lot of 'interesting'
code out in staging still, but for new submissions we are being increasingly
fussy about little bits.  So I hope I don't come across as being too mean
about this driver.  I'm glad you are putting in the work to convert
it over.  There are a quite a few similar drivers sculking through the tree
so it's nice that someone has gotten started on bringing one over to IIO.


>
>> It's nice in a way that the driver before your conversion provided only
>> a very limited and in kernel interface given we don't have to hang on to
>> any old ABI elements.
>>
>>> ---
>>>   drivers/iio/adc/Kconfig        |  10 +
>>>   drivers/iio/adc/Makefile       |   1 +
>>>   drivers/iio/adc/twl4030-madc.c | 922 +++++++++++++++++++++++++++++++++++++++++
>>>   drivers/mfd/Kconfig            |  10 -
>>>   drivers/mfd/Makefile           |   1 -
>>>   drivers/mfd/twl4030-madc.c     | 922 -----------------------------------------
>>>   6 files changed, 933 insertions(+), 933 deletions(-)
>>>   create mode 100644 drivers/iio/adc/twl4030-madc.c
>>>   delete mode 100644 drivers/mfd/twl4030-madc.c
>>>
>>> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
>>> index 2209f28..427f75c 100644
>>> --- a/drivers/iio/adc/Kconfig
>>> +++ b/drivers/iio/adc/Kconfig
>>> @@ -183,6 +183,16 @@ config TI_AM335X_ADC
>>>   	  Say yes here to build support for Texas Instruments ADC
>>>   	  driver which is also a MFD client.
>>>
>>> +config TWL4030_MADC
>>> +	tristate "TWL4030 MADC (Monitoring A/D Converter)"
>>> +	depends on TWL4030_CORE
>>> +	help
>>> +	This driver provides support for Triton TWL4030-MADC. The
>>> +	driver supports both RT and SW conversion methods.
>>> +
>>> +	This driver can also be built as a module. If so, the module will be
>>> +	called twl4030-madc.
>>> +
>>>   config TWL6030_GPADC
>>>   	tristate "TWL6030 GPADC (General Purpose A/D Converter) Support"
>>>   	depends on TWL4030_CORE
>>> diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
>>> index ba9a10a..9acf2df 100644
>>> --- a/drivers/iio/adc/Makefile
>>> +++ b/drivers/iio/adc/Makefile
>>> @@ -20,5 +20,6 @@ obj-$(CONFIG_MCP3422) += mcp3422.o
>>>   obj-$(CONFIG_NAU7802) += nau7802.o
>>>   obj-$(CONFIG_TI_ADC081C) += ti-adc081c.o
>>>   obj-$(CONFIG_TI_AM335X_ADC) += ti_am335x_adc.o
>>> +obj-$(CONFIG_TWL4030_MADC) += twl4030-madc.o
>>>   obj-$(CONFIG_TWL6030_GPADC) += twl6030-gpadc.o
>>>   obj-$(CONFIG_VIPERBOARD_ADC) += viperboard_adc.o
>>> diff --git a/drivers/iio/adc/twl4030-madc.c b/drivers/iio/adc/twl4030-madc.c
>>> new file mode 100644
>>> index 0000000..4da61c4
>>> --- /dev/null
>>> +++ b/drivers/iio/adc/twl4030-madc.c
>>> @@ -0,0 +1,922 @@
>>> +/*
>>> + *
>>> + * TWL4030 MADC module driver-This driver monitors the real time
>>> + * conversion of analog signals like battery temperature,
>>> + * battery type, battery level etc.
>>> + *
>>> + * Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com/
>>> + * J Keerthy <j-keerthy@ti.com>
>>> + *
>>> + * Based on twl4030-madc.c
>>> + * Copyright (C) 2008 Nokia Corporation
>>> + * Mikko Ylinen <mikko.k.ylinen@nokia.com>
>>> + *
>>> + * Amit Kucheria <amit.kucheria@canonical.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or
>>> + * modify it under the terms of the GNU General Public License
>>> + * version 2 as published by the Free Software Foundation.
>>> + *
>>> + * This program is distributed in the hope that it will be useful, but
>>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>>> + * General Public License for more details.
>>> + *
>>> + * You should have received a copy of the GNU General Public License
>>> + * along with this program; if not, write to the Free Software
>>> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
>>> + * 02110-1301 USA
>>> + *
>>> + */
>>> +
>>> +#include <linux/init.h>
>>> +#include <linux/device.h>
>>> +#include <linux/interrupt.h>
>>> +#include <linux/kernel.h>
>>> +#include <linux/delay.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/slab.h>
>>> +#include <linux/i2c/twl.h>
>>> +#include <linux/i2c/twl4030-madc.h>
>>> +#include <linux/module.h>
>>> +#include <linux/stddef.h>
>>> +#include <linux/mutex.h>
>>> +#include <linux/bitops.h>
>>> +#include <linux/jiffies.h>
>>> +#include <linux/types.h>
>>> +#include <linux/gfp.h>
>>> +#include <linux/err.h>
>>> +
>>> +#include <linux/iio/iio.h>
>> Why include machine.h or driver.h. You aren't currently using the
>> mapping coding anyway that these provide.
>
> My bad. I copied that over from another driver without checking if
> it is actually needed.
>
>>> +#include <linux/iio/machine.h>
>>> +#include <linux/iio/driver.h>
>>> +
>>> +/*
>>> + * struct twl4030_madc_data - a container for madc info
>>> + * @dev - pointer to device structure for madc
>>> + * @lock - mutex protecting this data structure
>>> + * @requests - Array of request struct corresponding to SW1, SW2 and RT
>>> + * @imr - Interrupt mask register of MADC
>>> + * @isr - Interrupt status register of MADC
>>> + */
>>> +struct twl4030_madc_data {
>>> +	struct device *dev;
>>> +	struct mutex lock;	/* mutex protecting this data structure */
>>> +	struct twl4030_madc_request requests[TWL4030_MADC_NUM_METHODS];
>>> +	bool use_second_irq;
>>
>> These are 32 bit signed values?
>
> These were already defined as int in the original driver. I will
> change these to u8 in an additional patch.
>
>>> +	int imr;
>>> +	int isr;
>>> +};
>>> +
>>> +static int twl4030_madc_read(struct iio_dev *iio_dev,
>>> +			     const struct iio_chan_spec *chan,
>>> +			     int *val, int *val2, long mask)
>>> +{
>>> +	struct twl4030_madc_data *madc = iio_priv(iio_dev);
>>> +	struct twl4030_madc_request req;
>>> +	int channel = chan->channel;
>>> +	int ret;
>>> +
>>> +	req.method = madc->use_second_irq ? TWL4030_MADC_SW2 : TWL4030_MADC_SW1;
>>> +
>>> +	req.channels = BIT(channel);
>>> +	req.active = 0;
>>> +	req.func_cb = NULL;
>> req.raw = !(mask & IIO_CHAN_INFO_PROCESSED);
>> req.do_avg = !!(mask & IIO_CHAN_INFO_AVERAGE_RAW);
>
> Right.
>
>>> +	req.raw = (mask & IIO_CHAN_INFO_PROCESSED) ? false : true;
>>> +	req.do_avg = (mask & IIO_CHAN_INFO_AVERAGE_RAW) ? true : false;
>>> +
>>> +	ret = twl4030_madc_conversion(&req);
>>> +	if (ret < 0)
>>> +		return ret;
>>> +
>>> +	*val = req.rbuf[channel];
>>> +
>>> +	return IIO_VAL_INT;
>>> +}
>>> +
>>> +static const struct iio_info twl4030_madc_iio_info = {
>>> +	.read_raw = &twl4030_madc_read,
>>> +	.driver_module = THIS_MODULE,
>>> +};
>>> +
>> Please give this a prefixed name.  Chances of ADC_CHANNEL
>> turning up in an IIO header is a little too high to do this
>> without!  e.g. #define TWL4030_ADC_CHANNEL
>
> Probably drivers/iio/adc/exynos_adc.c should also be fixed.
Sounds like it.  Patches always welcome ;)  Like any other reviewer
I'm not known for absolute consistency.
>
>>> +#define ADC_CHANNEL(_channel, _type, _name, _mask) {	\
>>> +	.type = _type,					\
>> I don't think you use scan_type anywhere so don't bother specifying it.
>> here.
>
> ok.
>
>>> +	.scan_type = IIO_ST('u', 10, 16, 0),		\
>>> +	.channel = _channel,				\
>>> +	.info_mask_separate = _mask,			\
>>> +	.datasheet_name = _name,			\
>>> +	.indexed = 1,					\
>>> +}
>>> +
>>
>> Is the average have an adjustable number of samples?
>
> The TWL supports reading a value directly (1 sample) or reading
> the average of 4 samples.
>
>> If not I'd be tempted to use the more common option of IIO_CHAN_INFO_RAW
>> rather than the average version (tends only to be used in fairly obscure
>> cases where both a raw access and an averaged one are available).
>
> currently some drivers use the averaged read and some use the direct
> read.
>

In that case I'd expose both the 1 sample and averaged versions via the
IIO interfaces.  If you want to pick 1 then do IIO_CHAN_INFO_RAW not the
averaged version.
  
>>> +static const struct iio_chan_spec twl4030_madc_iio_channels[] = {
>>> +	ADC_CHANNEL(0, IIO_VOLTAGE, "ADCIN0", BIT(IIO_CHAN_INFO_AVERAGE_RAW)),
>>> +	ADC_CHANNEL(1, IIO_TEMP, "ADCIN1", BIT(IIO_CHAN_INFO_PROCESSED) |
>>> +					   BIT(IIO_CHAN_INFO_AVERAGE_RAW)),
>>> +	ADC_CHANNEL(2, IIO_VOLTAGE, "ADCIN2", BIT(IIO_CHAN_INFO_AVERAGE_RAW)),
>>> +	ADC_CHANNEL(3, IIO_VOLTAGE, "ADCIN3", BIT(IIO_CHAN_INFO_AVERAGE_RAW)),
>>> +	ADC_CHANNEL(4, IIO_VOLTAGE, "ADCIN4", BIT(IIO_CHAN_INFO_AVERAGE_RAW)),
>>> +	ADC_CHANNEL(5, IIO_VOLTAGE, "ADCIN5", BIT(IIO_CHAN_INFO_AVERAGE_RAW)),
>>> +	ADC_CHANNEL(6, IIO_VOLTAGE, "ADCIN6", BIT(IIO_CHAN_INFO_AVERAGE_RAW)),
>>> +	ADC_CHANNEL(7, IIO_VOLTAGE, "ADCIN7", BIT(IIO_CHAN_INFO_AVERAGE_RAW)),
>>> +	ADC_CHANNEL(8, IIO_VOLTAGE, "ADCIN8", BIT(IIO_CHAN_INFO_AVERAGE_RAW)),
>>> +	ADC_CHANNEL(9, IIO_VOLTAGE, "ADCIN9", BIT(IIO_CHAN_INFO_AVERAGE_RAW)),
>>> +	ADC_CHANNEL(10, IIO_CURRENT, "ADCIN10", BIT(IIO_CHAN_INFO_PROCESSED) |
>>> +						BIT(IIO_CHAN_INFO_AVERAGE_RAW)),
>>> +	ADC_CHANNEL(11, IIO_VOLTAGE, "ADCIN11", BIT(IIO_CHAN_INFO_AVERAGE_RAW)),
>>> +	ADC_CHANNEL(12, IIO_VOLTAGE, "ADCIN12", BIT(IIO_CHAN_INFO_AVERAGE_RAW)),
>>> +	ADC_CHANNEL(13, IIO_VOLTAGE, "ADCIN13", BIT(IIO_CHAN_INFO_AVERAGE_RAW)),
>>> +	ADC_CHANNEL(14, IIO_VOLTAGE, "ADCIN14", BIT(IIO_CHAN_INFO_AVERAGE_RAW)),
>>> +	ADC_CHANNEL(15, IIO_VOLTAGE, "ADCIN15", BIT(IIO_CHAN_INFO_AVERAGE_RAW)),
>>> +};
>>> +
>> Why the artificial limitation of one of these devices?  I guess this is to
>> allow the exported function to work without needing to be associated with
>> any particular device...  Hmm.
>
> Artificial limitation? The madc is a ADC, which has some special
> functions defined for some pins in the datasheet:
>
> ADC0 = Battery Voltage
> ADC1 = Battery Temperature
> ADC10 = Battery Current
>
> Nokia misused some of those pins on the Nokia N900, though. For
> example they have their own conversion tables for the temperature,
> which is not compatible with the generic one for the madc module.

*laughs*.  If someone documents a pin as having a particular purpose
but it isn't wired inside a package. Someone will always think they know
better.  Basic principal is to never limit ourselves to one instance of
a chip because the chances of someone deciding to do something interesting
with multiple chips is way to high.

>
> I planned to convert the rx51-battery driver to simply read the raw
> values. All other users can use the processed information.
Makes sense.
>
>>> +static struct twl4030_madc_data *twl4030_madc;
>>> +
>>> +struct twl4030_prescale_divider_ratios {
>>> +	s16 numerator;
>>> +	s16 denominator;
>>> +};
>>> +
>>> +static const struct twl4030_prescale_divider_ratios
>>> +twl4030_divider_ratios[16] = {
>>> +	{1, 1},		/* CHANNEL 0 No Prescaler */
>>> +	{1, 1},		/* CHANNEL 1 No Prescaler */
>>> +	{6, 10},	/* CHANNEL 2 */
>>> +	{6, 10},	/* CHANNEL 3 */
>>> +	{6, 10},	/* CHANNEL 4 */
>>> +	{6, 10},	/* CHANNEL 5 */
>>> +	{6, 10},	/* CHANNEL 6 */
>>> +	{6, 10},	/* CHANNEL 7 */
>>> +	{3, 14},	/* CHANNEL 8 */
>>> +	{1, 3},		/* CHANNEL 9 */
>>> +	{1, 1},		/* CHANNEL 10 No Prescaler */
>>> +	{15, 100},	/* CHANNEL 11 */
>>> +	{1, 4},		/* CHANNEL 12 */
>>> +	{1, 1},		/* CHANNEL 13 Reserved channels */
>>> +	{1, 1},		/* CHANNEL 14 Reseved channels */
>>> +	{5, 11},	/* CHANNEL 15 */
>>> +};
>>> +
>>> +
>>> +/*
>>> + * Conversion table from -3 to 55 degree Celcius
>>> + */
>>> +static int therm_tbl[] = {
>>> +30800,	29500,	28300,	27100,
>>> +26000,	24900,	23900,	22900,	22000,	21100,	20300,	19400,	18700,	17900,
>>> +17200,	16500,	15900,	15300,	14700,	14100,	13600,	13100,	12600,	12100,
>>> +11600,	11200,	10800,	10400,	10000,	9630,	9280,	8950,	8620,	8310,
>>> +8020,	7730,	7460,	7200,	6950,	6710,	6470,	6250,	6040,	5830,
>>> +5640,	5450,	5260,	5090,	4920,	4760,	4600,	4450,	4310,	4170,
>>> +4040,	3910,	3790,	3670,	3550
>>> +};
>>> +
>>> +/*
>>> + * Structure containing the registers
>>> + * of different conversion methods supported by MADC.
>>> + * Hardware or RT real time conversion request initiated by external host
>>> + * processor for RT Signal conversions.
>>> + * External host processors can also request for non RT conversions
>>> + * SW1 and SW2 software conversions also called asynchronous or GPC request.
>>> + */
>>> +static
>>> +const struct twl4030_madc_conversion_method twl4030_conversion_methods[] = {
>>> +	[TWL4030_MADC_RT] = {
>>> +			     .sel = TWL4030_MADC_RTSELECT_LSB,
>>> +			     .avg = TWL4030_MADC_RTAVERAGE_LSB,
>>> +			     .rbase = TWL4030_MADC_RTCH0_LSB,
>>> +			     },
>>> +	[TWL4030_MADC_SW1] = {
>>> +			      .sel = TWL4030_MADC_SW1SELECT_LSB,
>>> +			      .avg = TWL4030_MADC_SW1AVERAGE_LSB,
>>> +			      .rbase = TWL4030_MADC_GPCH0_LSB,
>>> +			      .ctrl = TWL4030_MADC_CTRL_SW1,
>>> +			      },
>>> +	[TWL4030_MADC_SW2] = {
>>> +			      .sel = TWL4030_MADC_SW2SELECT_LSB,
>>> +			      .avg = TWL4030_MADC_SW2AVERAGE_LSB,
>>> +			      .rbase = TWL4030_MADC_GPCH0_LSB,
>>> +			      .ctrl = TWL4030_MADC_CTRL_SW2,
>>> +			      },
>>> +};
>>> +
>>> +/*
>>> + * Function to read a particular channel value.
>>> + * @madc - pointer to struct twl4030_madc_data
>>> + * @reg - lsb of ADC Channel
>>> + * If the i2c read fails it returns an error else returns 0.
>>> + */
>>> +static int twl4030_madc_channel_raw_read(struct twl4030_madc_data *madc, u8 reg)
>>> +{
>>> +	u8 msb, lsb;
>>> +	int ret;
>>> +	/*
>>> +	 * For each ADC channel, we have MSB and LSB register pair. MSB address
>>> +	 * is always LSB address+1. reg parameter is the address of LSB register
>>> +	 */
>>> +	ret = twl_i2c_read_u8(TWL4030_MODULE_MADC, &msb, reg + 1);
>>> +	if (ret) {
>>> +		dev_err(madc->dev, "unable to read MSB register 0x%X\n",
>>> +			reg + 1);
>>> +		return ret;
>>> +	}
>>> +	ret = twl_i2c_read_u8(TWL4030_MODULE_MADC, &lsb, reg);
>>> +	if (ret) {
>>> +		dev_err(madc->dev, "unable to read LSB register 0x%X\n", reg);
>>> +		return ret;
>>> +	}
>>> +
>>> +	return (int)(((msb << 8) | lsb) >> 6);
>>> +}
>>> +
>>> +/*
>>> + * Return battery temperature
>>> + * Or < 0 on failure.
>>> + */
>>> +static int twl4030battery_temperature(int raw_volt)
>>> +{
>>> +	u8 val;
>>> +	int temp, curr, volt, res, ret;
>>> +
>>> +	volt = (raw_volt * TEMP_STEP_SIZE) / TEMP_PSR_R;
>>> +	/* Getting and calculating the supply current in micro ampers */
>>> +	ret = twl_i2c_read_u8(TWL_MODULE_MAIN_CHARGE, &val,
>>> +		REG_BCICTL2);
>>> +	if (ret < 0)
>>> +		return ret;
>> blank line here and after similar error cases makes it a little easier to
>> read.
>>
>>> +	curr = ((val & TWL4030_BCI_ITHEN) + 1) * 10;
>>> +	/* Getting and calculating the thermistor resistance in ohms */
>>> +	res = volt * 1000 / curr;
>>> +	/* calculating temperature */
>>> +	for (temp = 58; temp >= 0; temp--) {
>>> +		int actual = therm_tbl[temp];
>>> +
>> No blank line here.
>
> I added the newline to the style fix patch, since these lines were
> not touched by me before.
>
>>> +		if ((actual - res) >= 0)
>>> +			break;
>>> +	}
>>> +
>>> +	return temp + 1;
>>> +}
>>> +
>>> +static int twl4030battery_current(int raw_volt)
>>> +{
>>> +	int ret;
>>> +	u8 val;
>>> +
>>> +	ret = twl_i2c_read_u8(TWL_MODULE_MAIN_CHARGE, &val,
>>> +		TWL4030_BCI_BCICTL1);
>>> +	if (ret)
>>> +		return ret;
>>> +	if (val & TWL4030_BCI_CGAIN) /* slope of 0.44 mV/mA */
>>> +		return (raw_volt * CURR_STEP_SIZE) / CURR_PSR_R1;
>>> +	else /* slope of 0.88 mV/mA */
>>> +		return (raw_volt * CURR_STEP_SIZE) / CURR_PSR_R2;
>>> +}
>> blank line here please.
>
> Also added to the style fix patch.
>
>> Various comments on this in the next function:
>> This would be much simpler if any error immediately resulted in an
>> exit with error code.  If it's gone wrong enough to issue a dev_err
>> then don't try to muddle through.  Given there is nothing to clear
>> up in here, just error out directly on the first problem.
>
> I guess this should be fixed once the old API is removed.
>
>>> +/*
>>> + * Function to read channel values
>>> + * @madc - pointer to twl4030_madc_data struct
>>> + * @reg_base - Base address of the first channel
>>> + * @Channels - 16 bit bitmap. If the bit is set, channel value is read
>>> + * @buf - The channel values are stored here. if read fails error
>>> + * @raw - Return raw values without conversion
>>> + * value is stored
>>> + * Returns the number of successfully read channels.
>>> + */
>>> +static int twl4030_madc_read_channels(struct twl4030_madc_data *madc,
>>> +				      u8 reg_base, unsigned
>>> +				      long channels, int *buf,
>>> +				      bool raw)
>>> +{
>>> +	int count = 0, count_req = 0, i;
>>> +	u8 reg;
>>> +
>>> +	for_each_set_bit(i, &channels, TWL4030_MADC_MAX_CHANNELS) {
>> Skip the temporary for reg.  Yes, it gets used twice, but easier to read
>> inline.
>
> Also fixed in the style patch.
>
>>> +		reg = reg_base + 2 * i;
>>> +		buf[i] = twl4030_madc_channel_raw_read(madc, reg);
>>> +		if (buf[i] < 0) {
>>> +			dev_err(madc->dev,
>>> +				"Unable to read register 0x%X\n", reg);
>>> +			count_req++;
>>> +			continue;
>>> +		}
>> I'd prefer this as
>> if (raw) {
>>    count ++;
>> } else {
>>    switch (i) {
>> ..
>> }
>
> That increases the code indention by another level. I don't think
> that's a good idea.
For clarity I'd do it anyway, but if the count is brought out of the
statements then the flow will be more obvious anyway.
>
>> Also near as I can tell count gets incremented unless there is an error
>> anyway. So just increment it outside and allow this function to return the
>> error code.
>> Returning error codes would change the existing API. I would prefer
> to do this change after the old API is removed.
This function isn't exported directly and I suspect a quick look would show
no one relying on the successfully reading some subset of drivers.  It might
make sense to eat the error at the exported interface and return a length
of 0.

>
>>> +		if (raw) {
>>> +			count++;
>>> +			continue;
>>> +		}
>>> +		switch (i) {
>> These cases could do with a suitable #define to give them a name.
>
> TWL4030_MADC_ADCIN10 is already in use for (1 << 10). I guess this
> can be simplified more easily once the old API is removed.
>
>>> +		case 10:
>>> +			buf[i] = twl4030battery_current(buf[i]);
>>> +			if (buf[i] < 0) {
>>> +				dev_err(madc->dev, "err reading current\n");
>>> +				count_req++;
>>> +			} else {
>>> +				count++;
>>> +				buf[i] = buf[i] - 750;
>>> +			}
>>> +			break;
>>> +		case 1:
>>> +			buf[i] = twl4030battery_temperature(buf[i]);
>>> +			if (buf[i] < 0) {
>>> +				dev_err(madc->dev, "err reading temperature\n");
>>> +				count_req++;
>>> +			} else {
>>> +				buf[i] -= 3;
>>> +				count++;
>>> +			}
>>> +			break;
>>> +		default:
>>> +			count++;
>>> +			/* Analog Input (V) = conv_result * step_size / R
>>> +			 * conv_result = decimal value of 10-bit conversion
>>> +			 *		 result
>>> +			 * step size = 1.5 / (2 ^ 10 -1)
>>> +			 * R = Prescaler ratio for input channels.
>>> +			 * Result given in mV hence multiplied by 1000.
>>> +			 */
>>> +			buf[i] = (buf[i] * 3 * 1000 *
>>> +				 twl4030_divider_ratios[i].denominator)
>>> +				/ (2 * 1023 *
>>> +				twl4030_divider_ratios[i].numerator);
>>> +		}
>>> +	}
>> This is already apparant from the errors emmited earlier. I'd drop this
>> and the count_req counter in general.
>> Personally I'd error out in those cases anyway rather than carrying on
>> with the rest of the channels. If it's worth of a dev_err it's worthy
>> of getting out as fast as possible rather than trying to muddle on.
>
> I also think this should be postponed until the old API is removed.
I'd prefer to see standalone cleanups and fixes integrated first as I suspect
it may be a little while before we manage to fully drop the old API.
>
>>> +	if (count_req)
>>> +		dev_err(madc->dev, "%d channel conversion failed\n", count_req);
>>> +
>>> +	return count;
>>> +}
>>> +
>>> +/*
>>> + * Enables irq.
>>> + * @madc - pointer to twl4030_madc_data struct
>>> + * @id - irq number to be enabled
>>> + * can take one of TWL4030_MADC_RT, TWL4030_MADC_SW1, TWL4030_MADC_SW2
>>> + * corresponding to RT, SW1, SW2 conversion requests.
>>> + * If the i2c read fails it returns an error else returns 0.
>>> + */
>>> +static int twl4030_madc_enable_irq(struct twl4030_madc_data *madc, u8 id)
>>> +{
>>> +	u8 val;
>>> +	int ret;
>>> +
>>> +	ret = twl_i2c_read_u8(TWL4030_MODULE_MADC, &val, madc->imr);
>>> +	if (ret) {
>>> +		dev_err(madc->dev, "unable to read imr register 0x%X\n",
>>> +			madc->imr);
>>> +		return ret;
>>> +	}
>> A blank line here and in similar cases would slight aid readability.
>
>
>
>>> +	val &= ~(1 << id);
>>> +	ret = twl_i2c_write_u8(TWL4030_MODULE_MADC, val, madc->imr);
>>> +	if (ret) {
>>> +		dev_err(madc->dev,
>>> +			"unable to write imr register 0x%X\n", madc->imr);
>>> +		return ret;
>>> +
>> Loose blank line here.
>
> both fixed in the style patch.
>
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +/*
>>> + * Disables irq.
>>> + * @madc - pointer to twl4030_madc_data struct
>>> + * @id - irq number to be disabled
>>> + * can take one of TWL4030_MADC_RT, TWL4030_MADC_SW1, TWL4030_MADC_SW2
>>> + * corresponding to RT, SW1, SW2 conversion requests.
>>> + * Returns error if i2c read/write fails.
>>> + */
>>> +static int twl4030_madc_disable_irq(struct twl4030_madc_data *madc, u8 id)
>>> +{
>>> +	u8 val;
>>> +	int ret;
>>> +
>>> +	ret = twl_i2c_read_u8(TWL4030_MODULE_MADC, &val, madc->imr);
>>> +	if (ret) {
>>> +		dev_err(madc->dev, "unable to read imr register 0x%X\n",
>>> +			madc->imr);
>>> +		return ret;
>>> +	}
>>> +	val |= (1 << id);
>>> +	ret = twl_i2c_write_u8(TWL4030_MODULE_MADC, val, madc->imr);
>>> +	if (ret) {
>>> +		dev_err(madc->dev,
>>> +			"unable to write imr register 0x%X\n", madc->imr);
>>> +		return ret;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static irqreturn_t twl4030_madc_threaded_irq_handler(int irq, void *_madc)
>>> +{
>>> +	struct twl4030_madc_data *madc = _madc;
>>> +	const struct twl4030_madc_conversion_method *method;
>>> +	u8 isr_val, imr_val;
>>> +	int i, len, ret;
>>> +	struct twl4030_madc_request *r;
>>> +
>>> +	mutex_lock(&madc->lock);
>>> +	ret = twl_i2c_read_u8(TWL4030_MODULE_MADC, &isr_val, madc->isr);
>>> +	if (ret) {
>>> +		dev_err(madc->dev, "unable to read isr register 0x%X\n",
>>> +			madc->isr);
>>> +		goto err_i2c;
>>> +	}
>>> +	ret = twl_i2c_read_u8(TWL4030_MODULE_MADC, &imr_val, madc->imr);
>>> +	if (ret) {
>>> +		dev_err(madc->dev, "unable to read imr register 0x%X\n",
>>> +			madc->imr);
>>> +		goto err_i2c;
>>> +	}
>>> +	isr_val &= ~imr_val;
>>> +	for (i = 0; i < TWL4030_MADC_NUM_METHODS; i++) {
>>> +		if (!(isr_val & (1 << i)))
>>> +			continue;
>>> +		ret = twl4030_madc_disable_irq(madc, i);
>>> +		if (ret < 0)
>>> +			dev_dbg(madc->dev, "Disable interrupt failed%d\n", i);
>>> +		madc->requests[i].result_pending = 1;
>>> +	}
>> Can this and the previous loop not be combined thus simplifying some tests?
>
> It probably can be, but I think this can wait until the old API is
> removed.
Hmm. As I state below, if this is moving over to IIO (which is sensible) it
becomes my problem so I reserve the right to be fussy about less than optimal
code.  If it was coming in clean as a new driver I'd push back hard on a lot
of this stuff before merging it.  I have plenty of slightly uggly drivers
in staging to look after as it is!
>
>>> +	for (i = 0; i < TWL4030_MADC_NUM_METHODS; i++) {
>>> +		r = &madc->requests[i];
>>> +		/* No pending results for this method, move to next one */
>>> +		if (!r->result_pending)
>>> +			continue;
>>> +		method = &twl4030_conversion_methods[r->method];
>>> +		/* Read results */
>>> +		len = twl4030_madc_read_channels(madc, method->rbase,
>>> +						 r->channels, r->rbuf, r->raw);
>>> +		/* Return results to caller */
>>> +		if (r->func_cb != NULL) {
>>> +			r->func_cb(len, r->channels, r->rbuf);
>>> +			r->func_cb = NULL;
>>> +		}
>>> +		/* Free request */
>>> +		r->result_pending = 0;
>>> +		r->active = 0;
>>> +	}
>>> +	mutex_unlock(&madc->lock);
>>> +
>>> +	return IRQ_HANDLED;
>>> +
>>> +err_i2c:
>>> +	/*
>>> +	 * In case of error check whichever request is active
>>> +	 * and service the same.
>>> +	 */
>>> +	for (i = 0; i < TWL4030_MADC_NUM_METHODS; i++) {
>>> +		r = &madc->requests[i];
>>> +		if (r->active == 0)
>>> +			continue;
>>> +		method = &twl4030_conversion_methods[r->method];
>>> +		/* Read results */
>>> +		len = twl4030_madc_read_channels(madc, method->rbase,
>>> +						 r->channels, r->rbuf, r->raw);
>>> +		/* Return results to caller */
>>> +		if (r->func_cb != NULL) {
>>> +			r->func_cb(len, r->channels, r->rbuf);
>>> +			r->func_cb = NULL;
>>> +		}
>>> +		/* Free request */
>>> +		r->result_pending = 0;
>>> +		r->active = 0;
>>> +	}
>>> +	mutex_unlock(&madc->lock);
>>> +
>>> +	return IRQ_HANDLED;
>>> +}
>>> +
>> This structure does seem a little complex.  I'd have been more tempted
>> by using a completion and having the calling function wait on it.  How
>> often does an actual callback make sense?
>
> This is part of the old API, so let's convert all consumers to the
> IIO API and deprecate the callback stuff.
>
>>> +static int twl4030_madc_set_irq(struct twl4030_madc_data *madc,
>>> +				struct twl4030_madc_request *req)
>>> +{
>>> +	struct twl4030_madc_request *p;
>>> +	int ret;
>>> +
>>> +	p = &madc->requests[req->method];
>>> +	memcpy(p, req, sizeof(*req));
>>> +	ret = twl4030_madc_enable_irq(madc, req->method);
>>> +	if (ret < 0) {
>>> +		dev_err(madc->dev, "enable irq failed!!\n");
>>> +		return ret;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +/*
>>> + * Function which enables the madc conversion
>>> + * by writing to the control register.
>>> + * @madc - pointer to twl4030_madc_data struct
>>> + * @conv_method - can be TWL4030_MADC_RT, TWL4030_MADC_SW2, TWL4030_MADC_SW1
>>> + * corresponding to RT SW1 or SW2 conversion methods.
>>> + * Returns 0 if succeeds else a negative error value
>>> + */
>>> +static int twl4030_madc_start_conversion(struct twl4030_madc_data *madc,
>>> +					 int conv_method)
>>> +{
>>> +	const struct twl4030_madc_conversion_method *method;
>>> +	int ret = 0;
>>> +	method = &twl4030_conversion_methods[conv_method];
>>> +	switch (conv_method) {
>> Can we get here via any paths where these aren't the methods set?
>
> conv_method is set from outside of the driver, so it's probably
> safer to check. This can be simplified once the old API is removed.
Then we should be returning an error if it's not one of these.
>
>>> +	case TWL4030_MADC_SW1:
>>> +	case TWL4030_MADC_SW2:
>>> +		ret = twl_i2c_write_u8(TWL4030_MODULE_MADC,
>>> +				       TWL4030_MADC_SW_START, method->ctrl);
>>> +		if (ret) {
>>> +			dev_err(madc->dev,
>>> +				"unable to write ctrl register 0x%X\n",
>>> +				method->ctrl);
>>> +			return ret;
>>> +		}
>>> +		break;
>>> +	default:
>>> +		break;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>> Could we fix up the kernel doc in this file in general. It's so nearly
>> there but not quite!
>
> I assume, that the driver will get a huge cleanup once all consumers
> of the old API are converted. Maybe a deprecation flag should be
> added together with this patchset?
Probably not worth bothering for an inkernel interface that seems to have
relatively few users.  How many out of tree users will be moving to
new kernels and using this device?
>
>>> +/*
>>> + * Function that waits for conversion to be ready
>>> + * @madc - pointer to twl4030_madc_data struct
>>> + * @timeout_ms - timeout value in milliseconds
>>> + * @status_reg - ctrl register
>>> + * returns 0 if succeeds else a negative error value
>>> + */
>>> +static int twl4030_madc_wait_conversion_ready(struct twl4030_madc_data *madc,
>>> +					      unsigned int timeout_ms,
>>> +					      u8 status_reg)
>>> +{
>>> +	unsigned long timeout;
>>> +	int ret;
>>> +
>>> +	timeout = jiffies + msecs_to_jiffies(timeout_ms);
>>> +	do {
>>> +		u8 reg;
>>> +
>>> +		ret = twl_i2c_read_u8(TWL4030_MODULE_MADC, &reg, status_reg);
>>> +		if (ret) {
>>> +			dev_err(madc->dev,
>>> +				"unable to read status register 0x%X\n",
>>> +				status_reg);
>>> +			return ret;
>>> +		}
>>> +		if (!(reg & TWL4030_MADC_BUSY) && (reg & TWL4030_MADC_EOC_SW))
>>> +			return 0;
>>> +		usleep_range(500, 2000);
>>> +	} while (!time_after(jiffies, timeout));
>>> +	dev_err(madc->dev, "conversion timeout!\n");
>>> +
>>> +	return -EAGAIN;
>>> +}
>>> +
>>
>>> +/*
>>> + * An exported function which can be called from other kernel drivers.
>> What uses this currently?  Ideally we'd do this through the standard IIO paths
>> for in kernel users.  Right now the device tree mappings for that are less
>> than ideal (ask Mark Rutland if you want some choice comments ;)  Perhaps
>> we take the view this can be cleaned up later. There are some elements in here
>> we haven't yet looked at supporting for client drivers.  Will have to think
>> about that.
>>
>> It would be particularly nice if possible to use a generic battery driver
>> for the two cases that seem to be using this functionality at the moment.
>
> Currently there are 3 consumer drivers using this:
>
> * twl4030-madc-battery
> * rx51-battery
> * twl4030-madc-hwmon
>
> I guess the first two can be updated to use the IIO API and the last
> one can be replaced by the IIO hwmon driver. Since it's an
> in-kernel-api there should be no problems to simply remove the API
> afterwards.
Yes that sounds like a good paln.
>
>>> + * @req twl4030_madc_request structure
>>> + * req->rbuf will be filled with read values of channels based on the
>>> + * channel index. If a particular channel reading fails there will
>>> + * be a negative error value in the corresponding array element.
>>> + * returns 0 if succeeds else error value
>>> + */
>>> +int twl4030_madc_conversion(struct twl4030_madc_request *req)
>>> +{
>>> +	const struct twl4030_madc_conversion_method *method;
>>> +	u8 ch_msb, ch_lsb;
>>> +	int ret;
>>> +
>>> +	if (!req || !twl4030_madc)
>>> +		return -EINVAL;
>>> +
>>> +	mutex_lock(&twl4030_madc->lock);
>>> +	if (req->method < TWL4030_MADC_RT || req->method > TWL4030_MADC_SW2) {
>>> +		ret = -EINVAL;
>>> +		goto out;
>>> +	}
>>> +	/* Do we have a conversion request ongoing */
>>> +	if (twl4030_madc->requests[req->method].active) {
>>> +		ret = -EBUSY;
>>> +		goto out;
>>> +	}
>>> +	ch_msb = (req->channels >> 8) & 0xff;
>>> +	ch_lsb = req->channels & 0xff;
>>> +	method = &twl4030_conversion_methods[req->method];
>>> +	/* Select channels to be converted */
>>> +	ret = twl_i2c_write_u8(TWL4030_MODULE_MADC, ch_msb, method->sel + 1);
>>> +	if (ret) {
>>> +		dev_err(twl4030_madc->dev,
>>> +			"unable to write sel register 0x%X\n", method->sel + 1);
>>> +		goto out;
>>> +	}
>>> +	ret = twl_i2c_write_u8(TWL4030_MODULE_MADC, ch_lsb, method->sel);
>>> +	if (ret) {
>>> +		dev_err(twl4030_madc->dev,
>>> +			"unable to write sel register 0x%X\n", method->sel + 1);
>>> +		goto out;
>>> +	}
>>> +	/* Select averaging for all channels if do_avg is set */
>>> +	if (req->do_avg) {
>>> +		ret = twl_i2c_write_u8(TWL4030_MODULE_MADC,
>>> +				       ch_msb, method->avg + 1);
>>> +		if (ret) {
>>> +			dev_err(twl4030_madc->dev,
>>> +				"unable to write avg register 0x%X\n",
>>> +				method->avg + 1);
>>> +			goto out;
>>> +		}
>>> +		ret = twl_i2c_write_u8(TWL4030_MODULE_MADC,
>>> +				       ch_lsb, method->avg);
>>> +		if (ret) {
>>> +			dev_err(twl4030_madc->dev,
>> Excesive error messages are sometimes irritating as they break up code
>> flow.  They are really irritating when incorrect ;)
>
> Added to the fixes patch.
>
>>> +				"unable to write sel reg 0x%X\n",
>>> +				method->sel + 1);
>>> +			goto out;
>>> +		}
>>> +	}
>>> +	if (req->type == TWL4030_MADC_IRQ_ONESHOT && req->func_cb != NULL) {
>>> +		ret = twl4030_madc_set_irq(twl4030_madc, req);
>>> +		if (ret < 0)
>>> +			goto out;
>>> +		ret = twl4030_madc_start_conversion(twl4030_madc, req->method);
>>> +		if (ret < 0)
>>> +			goto out;
>>> +		twl4030_madc->requests[req->method].active = 1;
>>> +		ret = 0;
>>> +		goto out;
>>> +	}
>> Is it possible to get here?  This comment suggests not. If so, why have
>> the test?
>
> I guess it's an additional safety check. This function can be
> simplified a lot once the old API is removed, so I guess this
> can also be postponed.
>
>>> +	/* With RT method we should not be here anymore */
>>> +	if (req->method == TWL4030_MADC_RT) {
>>> +		ret = -EINVAL;
>>> +		goto out;
>>> +	}
>>> +	ret = twl4030_madc_start_conversion(twl4030_madc, req->method);
>>> +	if (ret < 0)
>>> +		goto out;
>>> +	twl4030_madc->requests[req->method].active = 1;
>>> +	/* Wait until conversion is ready (ctrl register returns EOC) */
>> So no interrupts in this case?
>>> +	ret = twl4030_madc_wait_conversion_ready(twl4030_madc, 5, method->ctrl);
>>> +	if (ret) {
>>> +		twl4030_madc->requests[req->method].active = 0;
>>> +		goto out;
>>> +	}
>>> +	ret = twl4030_madc_read_channels(twl4030_madc, method->rbase,
>>> +					 req->channels, req->rbuf, req->raw);
>>> +	twl4030_madc->requests[req->method].active = 0;
>>> +
>>> +out:
>>> +	mutex_unlock(&twl4030_madc->lock);
>>> +
>>> +	return ret;
>>> +}
>>> +EXPORT_SYMBOL_GPL(twl4030_madc_conversion);
>>> +
>>> +/*
>> Proper kerneldoc would be nice here.  Otherwise the comment doesn't
>> really add anything so I'd be tempted to drop it ;)
>
> removed in fixes patch.
>
>>> + * Return channel value
>>> + * Or < 0 on failure.
>>> + */
>>> +int twl4030_get_madc_conversion(int channel_no)
>>> +{
>>> +	struct twl4030_madc_request req;
>>> +	int temp = 0;
>>> +	int ret;
>>> +
>>> +	req.channels = (1 << channel_no);
>>> +	req.method = TWL4030_MADC_SW2;
>>> +	req.active = 0;
>>> +	req.func_cb = NULL;
>>> +	ret = twl4030_madc_conversion(&req);
>>> +	if (ret < 0)
>>> +		return ret;
>>> +	if (req.rbuf[channel_no] > 0)
>>> +		temp = req.rbuf[channel_no];
>>> +
>>> +	return temp;
>>> +}
>>> +EXPORT_SYMBOL_GPL(twl4030_get_madc_conversion);
>>> +
>>> +/*
>>> + * Function to enable or disable bias current for
>>> + * main battery type reading or temperature sensing
>>> + * @madc - pointer to twl4030_madc_data struct
>>> + * @chan - can be one of the two values
>> What is a battery type reading?  Voltage? Current? Charge?
>
> It's used for battery type identification.
Ah the comment really did mean what it said!
>
>>> + * TWL4030_BCI_ITHEN - Enables bias current for main battery type reading
>>> + * TWL4030_BCI_TYPEN - Enables bias current for main battery temperature
>> These constants have rather incomprehensible names. Whilst I gues they
>> are straight off the data sheet, seems to me that we could make them a little
>> longer and easier to follow!  The comment here helps, but sensible names
>> would be better!
>
> The names come from the datasheet. I think we should fix this after
> the old API is removed, since the constants are exposed for the API.
Fair enough.
>
>>> + * sensing
>>> + * @on - enable or disable chan.
>>> + */
>>> +static int twl4030_madc_set_current_generator(struct twl4030_madc_data *madc,
>>> +					      int chan, int on)
>>> +{
>>> +	int ret;
>>> +	u8 regval;
>>> +
>>> +	ret = twl_i2c_read_u8(TWL_MODULE_MAIN_CHARGE,
>>> +			      &regval, TWL4030_BCI_BCICTL1);
>>> +	if (ret) {
>>> +		dev_err(madc->dev, "unable to read BCICTL1 reg 0x%X",
>>> +			TWL4030_BCI_BCICTL1);
>>> +		return ret;
>>> +	}
>> Introduce an intermediate variable and this could be nice and easy to read
>> Say
>>
>> int regmask;
>> if (chan == 0)
>>     regmask = TWL4030_BCI_TYPEN;
>> else
>>     regmask = TWL4030_BFI_ITHEN;
>>
>> if (on)
>>     regval |= regmask;
>> else
>>     regval &= ~regmask;
>>
>> It's longer but doesn't give me a headache.
>
> I added this to the fixes patch:
>
>      int regmask;
> 	regmask = (chan == 0) ? TWL4030_BCI_TYPEN : TWL4030_BFI_ITHEN;
> 	if (on)
> 		regval |= regmask;
> 	else
> 		regval &= ~regmask;
>
>>> +	if (on)
>>> +		regval |= chan ? TWL4030_BCI_ITHEN : TWL4030_BCI_TYPEN;
>>> +	else
>>> +		regval &= chan ? ~TWL4030_BCI_ITHEN : ~TWL4030_BCI_TYPEN;
>>> +	ret = twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE,
>>> +			       regval, TWL4030_BCI_BCICTL1);
>>> +	if (ret) {
>>> +		dev_err(madc->dev, "unable to write BCICTL1 reg 0x%X\n",
>>> +			TWL4030_BCI_BCICTL1);
>>> +		return ret;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +/*
>>> + * Function that sets MADC software power on bit to enable MADC
>>> + * @madc - pointer to twl4030_madc_data struct
>>> + * @on - Enable or disable MADC software powen on bit.
>>> + * returns error if i2c read/write fails else 0
>>> + */
>>> +static int twl4030_madc_set_power(struct twl4030_madc_data *madc, int on)
>>> +{
>>> +	u8 regval;
>>> +	int ret;
>>> +
>>> +	ret = twl_i2c_read_u8(TWL_MODULE_MAIN_CHARGE,
>>> +			      &regval, TWL4030_MADC_CTRL1);
>>> +	if (ret) {
>>> +		dev_err(madc->dev, "unable to read madc ctrl1 reg 0x%X\n",
>>> +			TWL4030_MADC_CTRL1);
>>> +		return ret;
>>> +	}
>>> +	if (on)
>>> +		regval |= TWL4030_MADC_MADCON;
>>> +	else
>>> +		regval &= ~TWL4030_MADC_MADCON;
>>> +	ret = twl_i2c_write_u8(TWL4030_MODULE_MADC, regval, TWL4030_MADC_CTRL1);
>>> +	if (ret) {
>>> +		dev_err(madc->dev, "unable to write madc ctrl1 reg 0x%X\n",
>>> +			TWL4030_MADC_CTRL1);
>>> +		return ret;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +/*
>>> + * Initialize MADC and request for threaded irq
>>> + */
>>> +static int twl4030_madc_probe(struct platform_device *pdev)
>>> +{
>>> +	struct twl4030_madc_data *madc;
>>> +	struct twl4030_madc_platform_data *pdata = dev_get_platdata(&pdev->dev);
>>> +	struct device_node *np = pdev->dev.of_node;
>>> +	int irq, ret;
>>> +	u8 regval;
>>> +	struct iio_dev *iio_dev = NULL;
>>> +
>>> +	if (!pdata && !np) {
>>> +		dev_err(&pdev->dev, "platform_data not available\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	iio_dev = devm_iio_device_alloc(&pdev->dev,
>>> +					sizeof(struct twl4030_madc_data));
>>> +	if (!iio_dev) {
>>> +		dev_err(&pdev->dev, "failed allocating iio device\n");
>>> +		return -ENOMEM;
>>> +	}
>>> +
>>> +	madc = iio_priv(iio_dev);
>>> +	madc->dev = &pdev->dev;
>>> +
>>> +	iio_dev->name = dev_name(&pdev->dev);
>>> +	iio_dev->dev.parent = &pdev->dev;
>>> +	iio_dev->dev.of_node = pdev->dev.of_node;
>>> +	iio_dev->info = &twl4030_madc_iio_info;
>>> +	iio_dev->modes = INDIO_DIRECT_MODE;
>>> +	iio_dev->channels = twl4030_madc_iio_channels;
>>> +	iio_dev->num_channels = 16;
>>> +
>>> +	/*
>>> +	 * Phoenix provides 2 interrupt lines. The first one is connected to
>>> +	 * the OMAP. The other one can be connected to the other processor such
>>> +	 * as modem. Hence two separate ISR and IMR registers.
>>> +	 */
>>> +	if (pdata)
>>> +		madc->use_second_irq = pdata->irq_line != 1;
>>> +	else
>>> +		madc->use_second_irq = false;
>>> +
>>> +	madc->imr = (madc->use_second_irq == 1) ?
>>> +	    TWL4030_MADC_IMR1 : TWL4030_MADC_IMR2;
>>> +	madc->isr = (madc->use_second_irq == 1) ?
>>> +	    TWL4030_MADC_ISR1 : TWL4030_MADC_ISR2;
>>> +
>>> +	ret = twl4030_madc_set_power(madc, 1);
>>> +	if (ret < 0)
>>> +		return ret;
>>> +	ret = twl4030_madc_set_current_generator(madc, 0, 1);
>>> +	if (ret < 0)
>>> +		goto err_current_generator;
>>> +
>>> +	ret = twl_i2c_read_u8(TWL_MODULE_MAIN_CHARGE,
>>> +			      &regval, TWL4030_BCI_BCICTL1);
>>> +	if (ret) {
>>> +		dev_err(&pdev->dev, "unable to read reg BCI CTL1 0x%X\n",
>>> +			TWL4030_BCI_BCICTL1);
>>> +		goto err_i2c;
>>> +	}
>>> +	regval |= TWL4030_BCI_MESBAT;
>>> +	ret = twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE,
>>> +			       regval, TWL4030_BCI_BCICTL1);
>>> +	if (ret) {
>>> +		dev_err(&pdev->dev, "unable to write reg BCI Ctl1 0x%X\n",
>>> +			TWL4030_BCI_BCICTL1);
>>> +		goto err_i2c;
>>> +	}
>>> +
>>> +	/* Check that MADC clock is on */
>>> +	ret = twl_i2c_read_u8(TWL4030_MODULE_INTBR, &regval, TWL4030_REG_GPBR1);
>>> +	if (ret) {
>> Personally I'd rank the driver as rather to vebose on read error messages
>> given they are pretty unusual.  Ah well I guess each to their own.
>
> All of this is not written by me.
Sure.  Doesn't stop me moaning :)  At the end of the day you are proposing moving
this driver into a place where it becomes at least partly my problem.  As such
I'm keen on any tidying / cleaning occuring ASAP.
>
>>> +		dev_err(&pdev->dev, "unable to read reg GPBR1 0x%X\n",
>>> +				TWL4030_REG_GPBR1);
>>> +		goto err_i2c;
>>> +	}
>>> +
>>> +	/* If MADC clk is not on, turn it on */
>>> +	if (!(regval & TWL4030_GPBR1_MADC_HFCLK_EN)) {
>>> +		dev_info(&pdev->dev, "clk disabled, enabling\n");
>>> +		regval |= TWL4030_GPBR1_MADC_HFCLK_EN;
>>> +		ret = twl_i2c_write_u8(TWL4030_MODULE_INTBR, regval,
>>> +				       TWL4030_REG_GPBR1);
>>> +		if (ret) {
>>> +			dev_err(&pdev->dev, "unable to write reg GPBR1 0x%X\n",
>>> +					TWL4030_REG_GPBR1);
>>> +			goto err_i2c;
>>> +		}
>>> +	}
>>> +
>>> +	platform_set_drvdata(pdev, iio_dev);
>>> +	mutex_init(&madc->lock);
>>> +
>>> +	irq = platform_get_irq(pdev, 0);
>>
>> As ever using devm for a irq request makes for a bit of a review
>> nightmare as we have to be very careful that nothing has been removed
>> that this might use before the devm cleanup occurs (at end of remove).
>> In this case the fact that the current generator is off and the adc unit
>> is disabled sounds to me like it might cause interesting results in the
>> interrupt handler?
>>
>> It's one of those things that will probably never happen but I find it
>> hard to convince myself 'can't happen'
>>
>>> +	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
>>> +				   twl4030_madc_threaded_irq_handler,
>>> +				   IRQF_TRIGGER_RISING, "twl4030_madc", madc);
>>> +	if (ret) {
>>> +		dev_dbg(&pdev->dev, "could not request irq\n");
>>> +		goto err_i2c;
>>> +	}
>>
>> Err, where is this defined?  Ah, found it above.  I'm not keen on
>> preventing multiple instances of a device like this.  It is so easy
>> to not do this I'd prefer to see the driver fixed to remove this.
>
> This concept has also not introduced by me of course. I think we
> should fix this after removal of the old API, since the old API does
> not have an device parameter.
Fair enough.
>
>>> +	twl4030_madc = madc;
>>> +
>>> +	ret = iio_device_register(iio_dev);
>>> +	if (ret) {
>>> +		dev_dbg(&pdev->dev, "could not register iio device\n");
>>> +		goto err_i2c;
>>> +	}
>>> +
>>> +	return 0;
>>> +
>>> +err_i2c:
>>> +	twl4030_madc_set_current_generator(madc, 0, 0);
>>> +err_current_generator:
>>> +	twl4030_madc_set_power(madc, 0);
>>> +	return ret;
>>> +}
>>> +
>>> +static int twl4030_madc_remove(struct platform_device *pdev)
>>> +{
>>> +	struct iio_dev *iio_dev = platform_get_drvdata(pdev);
>>> +	struct twl4030_madc_data *madc = iio_priv(iio_dev);
>>> +
>>> +	twl4030_madc_set_current_generator(madc, 0, 0);
>>> +	twl4030_madc_set_power(madc, 0);
>>> +
>>> +	iio_device_unregister(iio_dev);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +#ifdef CONFIG_OF
>>> +static const struct of_device_id twl_madc_of_match[] = {
>>> +	{.compatible = "ti,twl4030-madc", },
>>> +	{ },
>>> +};
>>> +MODULE_DEVICE_TABLE(of, twl_madc_of_match);
>>> +#endif
>>> +
>>> +static struct platform_driver twl4030_madc_driver = {
>>> +	.probe = twl4030_madc_probe,
>>> +	.remove = twl4030_madc_remove,
>>> +	.driver = {
>>> +		   .name = "twl4030_madc",
>>> +		   .owner = THIS_MODULE,
>>> +		   .of_match_table = of_match_ptr(twl_madc_of_match),
>>> +		   },
>>> +};
>>> +
>>> +module_platform_driver(twl4030_madc_driver);
>>> +
>>> +MODULE_DESCRIPTION("TWL4030 ADC driver");
>>> +MODULE_LICENSE("GPL");
>>> +MODULE_AUTHOR("J Keerthy");
>>> +MODULE_ALIAS("platform:twl4030_madc");
>>
>> Rest of patch was removal of code so no comments!
>
> FYI: For me it was a bit odd to see inline comments about code lines
> coming after the inline comment. Normally I receive patch reviews
> with comments after the referenced code, which makes more sense imho.
I never claimed to be consistent ;)  Tend to review backwards that means
that sometimes comments end up in fairly random places.
>
> -- Sebastian
>

