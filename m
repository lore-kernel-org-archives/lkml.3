Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab3GONb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 09:31:26 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46213 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756262Ab3GONbY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 09:31:24 -0400
From: "Kozaruk, Oleksandr" <oleksandr.kozaruk@ti.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: "tony@atomide.com" <tony@atomide.com>,
        "benoit.cousson@linaro.org" <benoit.cousson@linaro.org>,
        "Nayak, Rajendra" <rnayak@ti.com>,
        "Ujfalusi, Peter" <peter.ujfalusi@ti.com>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "ch.naveen@samsung.com" <ch.naveen@samsung.com>,
        "poeschel@lemonage.de" <poeschel@lemonage.de>,
        "Kim, Milo" <Milo.Kim@ti.com>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH v3 2/2] iio: twl6030-gpadc: TWL6030, TWL6032 GPADC driver
Thread-Topic: [PATCH v3 2/2] iio: twl6030-gpadc: TWL6030, TWL6032 GPADC
 driver
Thread-Index: AQHOfzfrQz/LbRwjPkm/a2+YYG7+MZllwFMb
Date: Mon, 15 Jul 2013 13:30:25 +0000
Message-ID: <2A7ABDFCE21540479A5AEB0244A684D5E3D0E3@DNCE04.ent.ti.com>
References: <1373613482-28390-1-git-send-email-oleksandr.kozaruk@ti.com>
 <1373613482-28390-3-git-send-email-oleksandr.kozaruk@ti.com>,<51E05C0B.5050009@kernel.org>
In-Reply-To: <51E05C0B.5050009@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.92]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jonathan,
Thanks for the review.

>Couple of things:
>
>1) It looks from the driver that a lot of the channels are not measuring
>voltages but rather temperature or currents etc.  If so then their
>types in the channel mask should be appropriately set.  Also if some
>of the channels are entirely internal test networks, what is the benefit
>of exposing them to userspace as readable channels?
>If channels are merely 'suggested' as being used for temperatures etc
>then it is fine to keep them as voltages.
There are two kinds of channel for measuring temperature: die temperature
and those that measure temperature indirectly measuring voltage on resistive
load(NTC sensor).
die temperature is calculated by some formulas which convert ADC code to
temperature. This is not implemented in the driver.
Channels intended to measure temperature with NTC sensor have inbuilt current
sources. Voltage measured by this channels and specific NTC could be converted
to temperature.
This is the reason they chosen to be voltage channels.
As for test network I'll remove them from exposing to userspace.
[...]

>> +static int twl6030_gpadc_get_raw(struct twl6030_gpadc_data *gpadc,
>> +             int channel, int *res)
>> +{
>> +     u8 reg = gpadc->pdata->channel_to_reg(channel);
>> +     u8 val[2];
>
>le16 val;
>> +     int ret;
>> +
>ret = twl6030_gpadc_read(val, reg);
>(note that (reg, val) ordering of parameters would be a more common choice)
>
>> +     ret = twl6030_gpadc_read(val, reg);
>> +     if (ret) {
>> +             dev_dbg(gpadc->dev, "unable to read register 0x%X\n", reg);
>> +             return ret;
>> +     }
>> +
>res = le16_to_cpup(val);
>
>> +     *res = (val[1] << 8) | val[0];
>> +
>> +     return ret;
>> +}
>> +
You mean something like this:
static int twl6030_gpadc_get_raw(struct twl6030_gpadc_data *gpadc,                                                                                                                                                  
						int channel, int *res)                                                                                                                                                                              
{                                                                                                                                                                                                                   
	u8 reg = gpadc->pdata->channel_to_reg(channel);                                                                                                                                                             
	__le16 val;                                                                                                                                                                                                 
	int ret;                                                                                                                                                                                                    

	ret = twl6030_gpadc_read(reg, (u8 *)&val);                                                                                                                                                                  
	if (ret) {                                                                                                                                                                                                  
		dev_dbg(gpadc->dev, "unable to read register 0x%X\n", reg);                                                                                                                                         
		return ret;                                                                                                                                                                                         
	}                                                                                                                                                                                                           

	*res = le16_to_cpup(&val);                                                                                                                                                                                  

	return ret;                                                                                                                                                                                                 
}
Note, that twl6030_gpadc_read() is just wrapper for twl_i2c_read() which takes
"an array of num_bytes containing data to be read"
I like the original implementation better then this(if I did it correctly)
Do you insist on this change?
[...]

>> +static int twl6030_gpadc_get_processed(struct twl6030_gpadc_data *gpadc,
>> +             int channel, int *val)
>> +{
>> +     int raw_code;
>> +     int corrected_code;
>> +     int channel_value;
>> +     int ret;
>> +
>> +     ret = twl6030_gpadc_get_raw(gpadc, channel, &raw_code);
>> +     if (ret)
>> +             return ret;
>> +
>
>Might first thought on seeing this is that it would be better to return
>raw for all channels and provide the scale and offset info_mask elements
>where possible rather than doing the conversion in the kernel.  Note we

In our custom kernel branch battery driver needs battery voltage and
temperature.  Thus the conversion anyway is done in the kernel, either
in ADC driver or battery driver.

>allow really quite a bit of precision on those values so I doubt it
>will be a problem.
>
>If nothing else it would make everything rather more consistent.
>
[...]

>> +static int twl6032_calibration(struct twl6030_gpadc_data *gpadc)
>> +{
>> +     int chn, d1 = 0, d2 = 0, temp;
>> +     u8 trim_regs[17];
>> +     int ret;
>> +
>> +     ret = twl_i2c_read(TWL6030_MODULE_ID2, trim_regs + 1,
>> +                     TWL6030_GPADC_TRIM1, 16);
>> +     if (ret < 0) {
>> +             dev_err(gpadc->dev, "calibration failed\n");
>> +             return ret;
>> +     }
>> +
>/*
>* Loop
>please for kernel code.
>> +     /* Loop to calculate the value needed for returning voltages from
>> +      * GPADC not values.
>> +      *
>> +      * gain is calculated to 3 decimal places fixed point.
>> +      */
>> +     for (chn = 0; chn < TWL6032_GPADC_MAX_CHANNELS; chn++) {
>> +
>> +             switch (chn) {
>> +             case 0:
>> +             case 1:
>> +             case 2:
>> +             case 3:
>> +             case 4:
>> +             case 5:
>> +             case 6:
>> +             case 11:
>> +             case 12:
>> +             case 13:
>> +             case 14:
>> +                     /* D1 */
>> +                     d1 = (trim_regs[3] & 0x1F) << 2;
>> +                     d1 |= (trim_regs[1] & 0x06) >> 1;
>> +                     if (trim_regs[1] & 0x01)
>> +                             d1 = -d1;
>> +
>> +                     /* D2 */
>> +                     d2 = (trim_regs[4] & 0x3F) << 2;
>> +                     d2 |= (trim_regs[2] & 0x06) >> 1;
>> +                     if (trim_regs[2] & 0x01)
>> +                             d2 = -d2;
>> +                     break;
>> +             case 8:
>No coment on your code, but this is an 'interesting' bit
>of bit packing...
>I did vaguely wonder if this could be mapped to a big lookup table,
>but having tried it I think I end up with something almost as tricky
>to read.. Oh well that was a fun 10 minute diversion ;)
This is inherited code from Graeme - original author of implementation
for twl6032.
[...]

Regards,
OK.
