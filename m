Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab3GWHAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:00:25 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.17]:45972 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751837Ab3GWHAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:00:23 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-16.tower-28.messagelabs.com!1374562820!24258914!1
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.9.11; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <51EE29FD.5070901@digi.com>
Date: Tue, 23 Jul 2013 09:00:13 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        <michael.hennerich@analog.com>
Subject: Re: [PATCH v3 4/5] iio: mxs-lradc: add scale_available file to channels
References: <1374501843-19651-1-git-send-email-hector.palacios@digi.com> <1374501843-19651-5-git-send-email-hector.palacios@digi.com> <201307230036.42046.marex@denx.de>
In-Reply-To: <201307230036.42046.marex@denx.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Marek,

On 07/23/2013 12:36 AM, Marek Vasut wrote:
> Dear Hector Palacios,
>
>> Adds in_voltageX_scale_available file for every channel to read
>> the different available scales.
>> There are two scales per channel:
>>   [0] = divider_by_two disabled (default)
>>   [1] = divider_by_two enabled
>> The scale is a struct made of integer and nano parts to build
>> a long decimal number.
>>
>> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
>> ---
>
> [...]
>
>> @@ -1008,6 +1098,26 @@ static int mxs_lradc_probe(struct platform_device
>> *pdev) if (ret)
>>   		goto err_trig;
>>
>> +	/* Populate available ADC input ranges */
>> +	for (i = 0; i < LRADC_MAX_TOTAL_CHANS; i++) {
>> +		for (s = 0; s < ARRAY_SIZE(lradc->scale_avail[i]); s++) {
>> +			/*
>> +			 * [s=0] = optional divider by two disabled (default)
>> +			 * [s=1] = optional divider by two enabled
>> +			 *
>> +			 * The scale is calculated by doing:
>> +			 *   Vref >> (realbits - s)
>> +			 * which multiplies by two on the second component
>> +			 * of the array.
>> +			 */
>> +			scale_uv = ((u64)lradc->vref_mv[i] * 100000000) >>
>> +				   (iio->channels[i].scan_type.realbits - s);
>
> Thinking about this, this is basically
>
>              vref_mv[CHANNEL] * 100 000 000
> scale_uv = --------------------------------
>                        2^(12 - s)
>
> Where s can be either 0 or 1.
>
> Why do you multiply it by 100000000 I don't quite understand, but maybe it's
> fully obvious. It should be documented though.

I copied Michael Hennerich in CC who was the author of this math in
  drivers/iio/adc/ad7793.c
  drivers/staging/iio/adc/ad7192.c
which I copied. Maybe he can explain. It looks like it is just a question of having a 
intermediate large enough number to later do the do_div operation, rather than having 
a meaningful figure.

>> +			lradc->scale_avail[i][s].nano =
>> +					do_div(scale_uv, 100000000) * 10;
>
> Are we not loosing precission here?

Yes, but the do_div is modifying the scale_uv parameter with the integer part so I 
guess it might be somewhat justified.
As I said before, I tried to do my own math without success so I just copied what was 
in other drivers.

>
>> +			lradc->scale_avail[i][s].integer = scale_uv;
>> +		}
>> +	}
>> +
>>   	/* Configure the hardware. */
>>   	mxs_lradc_hw_init(lradc);
>
> Best regards,
> Marek Vasut
>


Best regards,
--
Hector Palacios
