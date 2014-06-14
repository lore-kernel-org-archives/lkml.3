Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaFNN4n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 09:56:43 -0400
Received: from mail.kernel.org ([198.145.19.201]:42893 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591AbaFNN4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 09:56:40 -0400
Message-ID: <539C550A.4030604@kernel.org>
Date: Sat, 14 Jun 2014 14:58:34 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>, Robert Hodaszi <robert.hodaszi@digi.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, alexandre.belloni@free-electrons.com,
        jbe@pengutronix.de, hector.palacios@digi.com,
        fabio.estevam@freescale.com, lars@metafoo.de
Subject: Re: [PATCH 2/2] iio: mxs-lradc: add ADC channel 9 as a copy of channel
 8
References: <1402407695-2984-1-git-send-email-robert.hodaszi@digi.com> <1402407695-2984-3-git-send-email-robert.hodaszi@digi.com> <201406110051.34455.marex@denx.de>
In-Reply-To: <201406110051.34455.marex@denx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/14 23:51, Marek Vasut wrote:
> On Tuesday, June 10, 2014 at 03:41:35 PM, Robert Hodaszi wrote:
>> Commit c8231a9af8147f8a401fc55931ec44abfb937660 ("iio: mxs-lradc: compute
>> temperature from channel 8 and 9") merged channel 8 and channel 9 to create
>> an IIO_TEMP channel. It changed the number of LRADC channels, which could
>> cause incompatibility with previous device-tree declarations, and also
>> makes it illogical (e.g. channel 15 is <&lradc 14>).

The binding is current just against an index of available channels.  If the
device does something faintly crazy with its numbering then holes will occur.

Anyhow, suggestion below on how to create a 'gap' in the channel index.

Honestly the binding is pretty hideous, but we'll have to maintain it
for a long time when someone (i.e. not me ;) comes up with a better binding
for iio consumer channels.  The non device tree one is much nicer in that
everything is done by name rather than artificial indexes.

>>
>> Add channel 9 as a copy of channel 8. Reading channel 9 has the same output
>> as reading channel 8.
>>
>> Signed-off-by: Robert Hodaszi <robert.hodaszi@digi.com>
>> ---
>
> [...]
>
>>   static const struct iio_chan_spec mxs_lradc_chan_spec[] = {
>> -	MXS_ADC_CHAN(0, IIO_VOLTAGE),
>> -	MXS_ADC_CHAN(1, IIO_VOLTAGE),
>> -	MXS_ADC_CHAN(2, IIO_VOLTAGE),
>> -	MXS_ADC_CHAN(3, IIO_VOLTAGE),
>> -	MXS_ADC_CHAN(4, IIO_VOLTAGE),
>> -	MXS_ADC_CHAN(5, IIO_VOLTAGE),
>> -	MXS_ADC_CHAN(6, IIO_VOLTAGE),
>> -	MXS_ADC_CHAN(7, IIO_VOLTAGE),	/* VBATT */
>> +	MXS_ADC_VOLTAGE_CHAN(0),
>> +	MXS_ADC_VOLTAGE_CHAN(1),
>> +	MXS_ADC_VOLTAGE_CHAN(2),
>> +	MXS_ADC_VOLTAGE_CHAN(3),
>> +	MXS_ADC_VOLTAGE_CHAN(4),
>> +	MXS_ADC_VOLTAGE_CHAN(5),
>> +	MXS_ADC_VOLTAGE_CHAN(6),
>> +	MXS_ADC_VOLTAGE_CHAN(7),	/* VBATT */
>>   	/* Combined Temperature sensors */
>> -	{
>> -		.type = IIO_TEMP,
>> -		.indexed = 1,
>> -		.scan_index = 8,
>> -		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
>> -				      BIT(IIO_CHAN_INFO_OFFSET) |
>> -				      BIT(IIO_CHAN_INFO_SCALE),
>> -		.channel = 8,
>> -		.scan_type = {.sign = 'u', .realbits = 18, .storagebits = 32,},
>> -	},
>
> I wonder, shouldn't the IIO framework handle this kind of a "hole" in the
> iio_chan_spec structure, where one entry has .channel = N and the subsequent one
> has .channel = N + 2 somehow ?
Hmm. This binding isn't all that heavily used as yet so this is the first time I've come across
anyone wanting to jump a channel.  Anyhow, simply having a channel with scan_index = -1
(not available for buffered capture) and nothing in any of the info_mask elements should
instantiate a channel with no actual interfaces or apparent existence.
(not that I've actually tested both of these being true as we only have
either channels that are not buffered, or devices with channels that are only buffered using
these two bits of functionality).

I'd rather this solution than adding an artificial bonus channel.

>
>> -	MXS_ADC_CHAN(10, IIO_VOLTAGE),	/* VDDIO */
>> -	MXS_ADC_CHAN(11, IIO_VOLTAGE),	/* VTH */
>> -	MXS_ADC_CHAN(12, IIO_VOLTAGE),	/* VDDA */
>> -	MXS_ADC_CHAN(13, IIO_VOLTAGE),	/* VDDD */
>> -	MXS_ADC_CHAN(14, IIO_VOLTAGE),	/* VBG */
>> -	MXS_ADC_CHAN(15, IIO_VOLTAGE),	/* VDD5V */
>
> [...]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

