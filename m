Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999Ab3GSIfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:35:46 -0400
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:49672 "EHLO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab3GSIfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:35:42 -0400
MIME-Version: 1.0
In-Reply-To: <51E7B9DA.9040803@metafoo.de>
References: <1374059564-6872-1-git-send-email-oleksandr.kozaruk@ti.com>
	<1374059564-6872-3-git-send-email-oleksandr.kozaruk@ti.com>
	<51E6DCB5.3070302@metafoo.de>
	<CAPb7_muAzO-jRqgcm89fcKT-hTLq38Aj2p0WAWjGjN9DoQUwPg@mail.gmail.com>
	<51E7B9DA.9040803@metafoo.de>
Date: Fri, 19 Jul 2013 11:35:41 +0300
Message-ID: <CAPb7_ms36YnT2VVkhngCEonwihtgHSMWO0uQQxsr58rUCgRPLA@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] iio: twl6030-gpadc: TWL6030, TWL6032 GPADC driver
From: Oleksandr Kozaruk <oleksandr.kozaruk@globallogic.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: tony@atomide.com, benoit.cousson@linaro.org, rnayak@ti.com,
        peter.ujfalusi@ti.com, kishon@ti.com, jic23@cam.ac.uk,
        grant.likely@linaro.org, rob.herring@calxeda.com,
        sameo@linux.intel.com, ch.naveen@samsung.com, poeschel@lemonage.de,
        milo.kim@ti.com, balajitk@ti.com, gg@slimlogic.co.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lars,

On Thu, Jul 18, 2013 at 12:48 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 07/18/2013 10:36 AM, Oleksandr Kozaruk wrote:
>> Hello Lars,
>>
>> On Wed, Jul 17, 2013 at 9:04 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>>>> +static int twl6032_calibration(struct twl6030_gpadc_data *gpadc)
>>>> +{
>>>> +     int chn, d1 = 0, d2 = 0, temp;
>>>> +     u8 trim_regs[17];
>>>> +     int ret;
>>>> +
>>>> +     ret = twl_i2c_read(TWL6030_MODULE_ID2, trim_regs + 1,
>>>> +                     TWL6030_GPADC_TRIM1, 16);
>>>> +     if (ret < 0) {
>>>> +             dev_err(gpadc->dev, "calibration failed\n");
>>>> +             return ret;
>>>> +     }
>>>> +
>>>> +     /*
>>>> +      * Loop to calculate the value needed for returning voltages from
>>>> +      * GPADC not values.
>>>> +      *
>>>> +      * gain is calculated to 3 decimal places fixed point.
>>>> +      */
>>>> +     for (chn = 0; chn < TWL6032_GPADC_MAX_CHANNELS; chn++) {
>>>> +
>>>> +             switch (chn) {
>>>> +             case 0:
>>>> +             case 1:
>>>> +             case 2:
>>>> +             case 3:
>>>> +             case 4:
>>>> +             case 5:
>>>> +             case 6:
>>>> +             case 11:
>>>> +             case 12:
>>>> +             case 13:
>>>> +             case 14:
>>>> +                     /* D1 */
>>>> +                     d1 = (trim_regs[3] & 0x1F) << 2;
>>>> +                     d1 |= (trim_regs[1] & 0x06) >> 1;
>>>> +                     if (trim_regs[1] & 0x01)
>>>> +                             d1 = -d1;
>>>> +
>>>> +                     /* D2 */
>>>> +                     d2 = (trim_regs[4] & 0x3F) << 2;
>>>> +                     d2 |= (trim_regs[2] & 0x06) >> 1;
>>>> +                     if (trim_regs[2] & 0x01)
>>>> +                             d2 = -d2;
>>>> +                     break;
>>>> +             case 8:
>>>> +                     /* D1 */
>>>> +                     temp = (trim_regs[3] & 0x1F) << 2;
>>>> +                     temp |= (trim_regs[1] & 0x06) >> 1;
>>>> +                     if (trim_regs[1] & 0x01)
>>>> +                             temp = -temp;
>>>> +
>>>> +                     d1 = (trim_regs[8] & 0x18) << 1;
>>>> +                     d1 |= (trim_regs[7] & 0x1E) >> 1;
>>>> +                     if (trim_regs[7] & 0x01)
>>>> +                             d1 = -d1;
>>>> +
>>>> +                     d1 += temp;
>>>> +
>>>> +                     /* D2 */
>>>> +                     temp = (trim_regs[4] & 0x3F) << 2;
>>>> +                     temp |= (trim_regs[2] & 0x06) >> 1;
>>>> +                     if (trim_regs[2] & 0x01)
>>>> +                             temp = -temp;
>>>> +
>>>> +                     d2 = (trim_regs[10] & 0x1F) << 2;
>>>> +                     d2 |= (trim_regs[8] & 0x06) >> 1;
>>>> +                     if (trim_regs[8] & 0x01)
>>>> +                             d2 = -d2;
>>>> +
>>>> +                     d2 += temp;
>>>> +                     break;
>>>> +             case 9:
>>>> +                     /* D1 */
>>>> +                     temp = (trim_regs[3] & 0x1F) << 2;
>>>> +                     temp |= (trim_regs[1] & 0x06) >> 1;
>>>> +                     if (trim_regs[1] & 0x01)
>>>> +                             temp = -temp;
>>>> +
>>>> +                     d1 = (trim_regs[14] & 0x18) << 1;
>>>> +                     d1 |= (trim_regs[12] & 0x1E) >> 1;
>>>> +                     if (trim_regs[12] & 0x01)
>>>> +                             d1 = -d1;
>>>> +
>>>> +                     d1 += temp;
>>>> +
>>>> +                     /* D2 */
>>>> +                     temp = (trim_regs[4] & 0x3F) << 2;
>>>> +                     temp |= (trim_regs[2] & 0x06) >> 1;
>>>> +                     if (trim_regs[2] & 0x01)
>>>> +                             temp = -temp;
>>>> +
>>>> +                     d2 = (trim_regs[16] & 0x1F) << 2;
>>>> +                     d2 |= (trim_regs[14] & 0x06) >> 1;
>>>> +                     if (trim_regs[14] & 0x01)
>>>> +                             d2 = -d2;
>>>> +
>>>> +                     d2 += temp;
>>>> +             case 10:
>>>> +                     /* D1 */
>>>> +                     d1 = (trim_regs[11] & 0x0F) << 3;
>>>> +                     d1 |= (trim_regs[9] & 0x0E) >> 1;
>>>> +                     if (trim_regs[9] & 0x01)
>>>> +                             d1 = -d1;
>>>> +
>>>> +                     /* D2 */
>>>> +                     d2 = (trim_regs[15] & 0x0F) << 3;
>>>> +                     d2 |= (trim_regs[13] & 0x0E) >> 1;
>>>> +                     if (trim_regs[13] & 0x01)
>>>> +                             d2 = -d2;
>>>> +                     break;
>>>> +             case 7:
>>>> +             case 18:
>>>> +                     /* D1 */
>>>> +                     temp = (trim_regs[3] & 0x1F) << 2;
>>>> +                     temp |= (trim_regs[1] & 0x06) >> 1;
>>>> +                     if (trim_regs[1] & 0x01)
>>>> +                             temp = -temp;
>>>> +
>>>> +                     d1 = (trim_regs[5] & 0x7E) >> 1;
>>>> +                     if (trim_regs[5] & 0x01)
>>>> +                             d1 = -d1;
>>>> +.
>>>> +                     d1 += temp;
>>>> +
>>>> +                     /* D2 */
>>>> +                     temp = (trim_regs[4] & 0x3F) << 2;
>>>> +                     temp |= (trim_regs[2] & 0x06) >> 1;
>>>> +                     if (trim_regs[2] & 0x01)
>>>> +                             temp = -temp;
>>>> +
>>>> +                     d2 = (trim_regs[6] & 0xFE) >> 1;
>>>> +                     if (trim_regs[6] & 0x01)
>>>> +                             d2 = -d2;
>>>> +
>>>> +                     d2 += temp;
>>>> +                     break;
>>>
>>>
>>> There is quite a bit of copy paste in here. Putting the bit swizziling into
>>> a helper function should also improbe legibility.
>>
>> Trimming bits are scattered randomly between registers and in
>> different bit positions.
>> I don't see any commonalities, that could be generalized. as Graeme
>> said about it "it's a bane of my life".
>
> The pattern is pretty regular though, how about:
>
>
> int twl6032_get_trim_value(u8 *trim_regs, unsigned int reg0,
>         unsigned int reg1, unsigned int mask0, unsigned int mask1,
>         unsigned int shift0)
> {
>         int val;
>
>         val = (trim_regs[reg0] & mask0) << shift0;
>         val |= (trim_regs[reg1] & mask1) >> 1;
>         if (trim_regs[reg1] & 0x01)
>                 val = -val;
>
>         return val;
> }
>
> and then
>
>         d1 = twl6032_get_trim_value(trim_regs, 3, 1, 0x1f, 0x06, 2);
>         d2 = twl6032_get_trim_value(trim_regs, 4, 2, 0x3f, 0x06, 2);
>
> and so on.

Thank you. I think legibility is better now, I even found a bug - in
case 9 'break' was missing.
Though it is not without special case for channels 7, 18:
	for (chn = 0; chn < TWL6032_GPADC_MAX_CHANNELS; chn++) {

		switch (chn) {
		case 0:
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 6:
		case 11:
		case 12:
		case 13:
		case 14:
			d1 = twl6032_get_trim_value(trim_regs, 3, 1, 0x1f, 0x06, 2);
			d2 = twl6032_get_trim_value(trim_regs, 4, 2, 0x3f, 0x06, 2);
			break;
		case 8:
			temp = twl6032_get_trim_value(trim_regs, 3, 1, 0x1f, 0x06, 2);
			d1 = temp + twl6032_get_trim_value(trim_regs, 8, 7, 0x18, 0x1E, 1);

			temp = twl6032_get_trim_value(trim_regs, 4, 2, 0x3F, 0x06, 2);
			d2 = temp + twl6032_get_trim_value(trim_regs, 10, 8, 0x1F, 0x06, 2);
			break;
		case 9:
			temp = twl6032_get_trim_value(trim_regs, 3, 1, 0x1f, 0x06, 2);
			d1 = temp + twl6032_get_trim_value(trim_regs, 14, 12, 0x18, 0x1E, 1);

			temp = twl6032_get_trim_value(trim_regs, 4, 2, 0x3f, 0x06, 2);
			d2 = temp + twl6032_get_trim_value(trim_regs, 16, 14, 0x1F, 0x06, 1);
			break;
		case 10:
			d1 = twl6032_get_trim_value(trim_regs, 11, 9, 0x0f, 0x0E, 3);
			d2 = twl6032_get_trim_value(trim_regs, 15, 13, 0x0f, 0x0E, 3);
			break;
		case 7:
		case 18:
			temp = twl6032_get_trim_value(trim_regs, 3, 1, 0x1f, 0x06, 2);

			d1 = (trim_regs[5] & 0x7E) >> 1;
			if (trim_regs[5] & 0x01)
				d1 = -d1;
			d1 += temp;

			temp = twl6032_get_trim_value(trim_regs, 4, 2, 0x3f, 0x06, 2);

			d2 = (trim_regs[6] & 0xFE) >> 1;
			if (trim_regs[6] & 0x01)
				d2 = -d2;

			d2 += temp;
			break;
		default:
			/* No data for other channels */
			continue;
		}

-- 
Regards,
Oleksandr Kozaruk
