Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab3GVJMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 05:12:16 -0400
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:40647 "EHLO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146Ab3GVJMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 05:12:13 -0400
MIME-Version: 1.0
In-Reply-To: <51EA69DE.4080908@kernel.org>
References: <1374226039-16943-1-git-send-email-oleksandr.kozaruk@ti.com>
	<1374226039-16943-3-git-send-email-oleksandr.kozaruk@ti.com>
	<51EA69DE.4080908@kernel.org>
Date: Mon, 22 Jul 2013 12:12:07 +0300
X-Google-Sender-Auth: aT6OQ97WBfYwLnjxj9j-7IYCVYY
Message-ID: <CAPb7_mskrx9uKtYFi2sJiZu-r0Jb_JEm19e05ZmmjWTJ7Qnc+g@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] iio: twl6030-gpadc: TWL6030, TWL6032 GPADC driver
From: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: tony@atomide.com, benoit.cousson@linaro.org, rnayak@ti.com,
        peter.ujfalusi@ti.com, kishon@ti.com, jic23@cam.ac.uk,
        grant.likely@linaro.org, rob.herring@calxeda.com, lars@metafoo.de,
        sameo@linux.intel.com, ch.naveen@samsung.com, poeschel@lemonage.de,
        milo.kim@ti.com, balajitk@ti.com, gg@slimlogic.co.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On Sat, Jul 20, 2013 at 1:43 PM, Jonathan Cameron <jic23@kernel.org> wrote:
> On 07/19/2013 10:27 AM, Oleksandr Kozaruk wrote:
>> The GPADC is general purpose ADC found on TWL6030, and TWL6032 PMIC,
>> known also as Phoenix and PhoenixLite.
>>
>> The TWL6030 and TWL6032 have GPADC with 17 and 19 channels
>> respectively. Some channels have current source and are used for
>> measuring voltage drop on resistive load for detecting battery ID
>> resistance, or measuring voltage drop on NTC resistors for external
>> temperature measurements. Some channels measure voltage, (i.e. battery
>> voltage), and have voltage dividers, thus, capable to scale voltage.
>> Some channels are dedicated for measuring die temperature.
>>
>> Some channels are calibrated in 2 points, having offsets from ideal
>> values kept in trim registers. This is used to correct measurements.
>>
>> The differences between GPADC in TWL6030 and TWL6032:
>> - 10 bit vs 12 bit ADC;
>> - 17 vs 19 channels;
>> - channels have different purpose(i.e. battery voltage
>>   channel 8 vs channel 18);
>> - trim values are interpreted differently.
>>
>> Based on the driver patched from Balaji TK, Graeme Gregory, Ambresh K,
>> Girish S Ghongdemath.
>>
>> Signed-off-by: Balaji T K <balajitk@ti.com>
>> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
>> Signed-off-by: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
> A few little bits and bobs inline.
>
> My only major query is about the lack of info for the temperature
> channels.  How do you convert these to useful real world units?

If I get your question right: the ADC channels 1, 4 are dedicated for
measuring resistive value.
The temperature measurement will depend on:
1) the ADC code(provided by the driver);
2) value of the NTC resistor, its characteristics, the way it is
plugged in the circuit,
and may be some calibration data(platform dependent); How the driver can the
drive take care of these?
[...]

>> +static int twl6030_gpadc_read_raw(struct iio_dev *indio_dev,
>> +                          const struct iio_chan_spec *chan,
>> +                          int *val, int *val2, long mask)
>> +{
>> +     struct twl6030_gpadc_data *gpadc = iio_priv(indio_dev);
>> +     int ret = -EINVAL;
> I'm suprised you didn't get a warning about the assigment above
> being pointless as you overwrite ret just below.
Indeed, ret is overwritten, though, there is no warning from make C=2
and checkpatch is silent.
I'll remove the initialization.
[...]

>> +
>> +#define TWL6030_GPADC_CHAN(chn, _type, chan_info) {  \
>> +     .type = _type,                                  \
>> +     .channel = chn,                                 \
>> +     .info_mask_separate = BIT(chan_info),           \
>> +     .indexed = 1,                                   \
>> +}
>> +
>
>
> Why list these at all?  I see they are no longer visible from
> userspace, but they are still taking up memory etc without I
> think ever being used?
I've kept it because for twl6032 there is a gap if I drop channels 15, 16,
as channels 17, 18 are used.

>> +/* internal test network channel */
>> +#define TWL6030_GPADC_TEST_CHAN(chn, chan_info) {    \
>> +     .type = IIO_VOLTAGE,                            \
>> +     .channel = chn,                                 \
>> +     .indexed = 1,                                   \
>> +}
>> +
>> +static const struct iio_chan_spec twl6030_gpadc_iio_channels[] = {
>> +     TWL6030_GPADC_CHAN(0, IIO_VOLTAGE, IIO_CHAN_INFO_PROCESSED),
>> +     TWL6030_GPADC_CHAN(1, IIO_TEMP, IIO_CHAN_INFO_RAW),
> So we have no other information about the temp channels other than
> raw adc counts?  If so, how are these useful?  I guess you might
> be intending to use iio-hwmon to get these into hwmon the use
> lm-sensors config files to convert to something useful.
> Otherwise, you probably want to get the board specific info on
> the calibration of these in here to make the data available to userspace
> in a useful format...

Hmm, it seems that info on the NTC type is board specific. And we
should get it from device tree?
I thought the driver just gives the ADC code, and consumer will know
what to do with the ADC data.
So, calculation for converting to temperature should be done in this driver?
I don't know how yet.
[...]

>> +MODULE_AUTHOR("Texas Instruments Inc.");
>
> I would normally expect an actual person for
> the module author.  Is this TI policy or simply a case of no clear single
> author?  Note I believe there is no problem with having multiple
> MODULE_AUTHOR lines so that everyone who made a major contribution is
> included.

Yes, this is because of having multiple authors. I will change it for
Balaji, Graeme and myself.

Regards,
OK.
