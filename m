Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaLCVaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 16:30:15 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbaLCVaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 16:30:13 -0500
Message-ID: <547F80E0.3020001@nod.at>
Date: Wed, 03 Dec 2014 22:30:08 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Harald Geyer <harald@ccbib.org>
CC: jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] iio: dht11: Logging updates
References: <1417563176-31972-1-git-send-email-richard@nod.at> <1417563176-31972-4-git-send-email-richard@nod.at> <E1Xw9W8-0001Db-9a@stardust.g4.wien.funkfeuer.at> <547F0BE5.2050808@nod.at> <E1XwAQO-0001HP-9x@stardust.g4.wien.funkfeuer.at>
In-Reply-To: <E1XwAQO-0001HP-9x@stardust.g4.wien.funkfeuer.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.12.2014 um 14:56 schrieb Harald Geyer:
> Richard Weinberger writes:
>> Am 03.12.2014 um 13:58 schrieb Harald Geyer:
>>> Richard Weinberger writes:
>>>> Currently the driver uses pr_* and dev_* functions.
>>>> Change all logging functions to dev_* style to be consistent
>>>> and have the correct device prefix in all messages.
>>>
>>> Yes, actually this was on purpose:
>>> The dev_ messages are really about something wrong with the device.
>>> Ie if something goes wrong with one device but could perfectly work
>>> with some other device.
>>> The pr_ messages OTOH are about something wrong with clock resolution,
>>> etc that would affect any DHT11 sensor on the system. Ideally we would
>>> notice these things during probe() and just return with an error there.
>>> Right now we aren't as clever as that, so we just log an error message
>>> about the driver, when actually we are reading the device.
>>>
>>> That said, I don't have strong feelings about this. If you want to
>>> change this, I won't object. However if you really want to fix this,
>>> then the proper thing would be to check for this conditions in
>>> probe().
>>
>> Currently we get log messages of style:
>> "iio iio:deviceX: foo bar"
>> and:
>> "dht11 <name in DT>: foo bar"
>>
>> I really favorite "dht11 <name in DT".
>> In my device tree every senor has a sane name and log messages look like:
>> "dht11 toiletten sensor: invalid checksum"
> 
> I think I ACKed the one with "iio iio:deviceX: foo bar"? 

No, my patch turns all logs to "dht11 <name in DT>: foo bar".

>>>> This change set also adds new messages to diagnose issues.
>>>
>>> Comment below.
>>>
>>>> Signed-off-by: Richard Weinberger <richard@nod.at>
>>>> ---
>>>>  drivers/iio/humidity/dht11.c | 16 ++++++++++------
>>>>  1 file changed, 10 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/drivers/iio/humidity/dht11.c b/drivers/iio/humidity/dht11.c
>>>> index 0023699..fbcd7cb 100644
>>>> --- a/drivers/iio/humidity/dht11.c
>>>> +++ b/drivers/iio/humidity/dht11.c
>>>> @@ -96,20 +96,22 @@ static int dht11_decode(struct dht11 *dht11, int offset)
>>>>  			timeres = t;
>>>>  	}
>>>>  	if (2*timeres > DHT11_DATA_BIT_HIGH) {
>>>> -		pr_err("dht11: timeresolution %d too bad for decoding\n",
>>>> +		dev_err(dht11->dev, "timeresolution %d too bad for decoding\n",
>>>>  			timeres);
>>>>  		return -EIO;
>>>>  	}
>>>>  	threshold = DHT11_DATA_BIT_HIGH / timeres;
>>>>  	if (DHT11_DATA_BIT_LOW/timeres + 1 >= threshold)
>>>> -		pr_err("dht11: WARNING: decoding ambiguous\n");
>>>> +		dev_err(dht11->dev, "decoding ambiguous\n");
>>>>  
>>>>  	/* scale down with timeres and check validity */
>>>>  	for (i = 0; i < DHT11_BITS_PER_READ; ++i) {
>>>>  		t = dht11->edges[offset + 2*i + 2].ts -
>>>>  			dht11->edges[offset + 2*i + 1].ts;
>>>> -		if (!dht11->edges[offset + 2*i + 1].value)
>>>> -			return -EIO;  /* lost synchronisation */
>>>> +		if (!dht11->edges[offset + 2*i + 1].value) {
>>>> +			dev_err(dht11->dev, "lost synchronisation\n");
>>>> +			return -EIO;
>>>> +		}
>>>
>>> Are you sure this warrants a log message? I don't think this provides
>>> much information. The userspace application should just try reading
>>> the sensor again.
>>>
>>> We could do someting smart and try to recover from such errors, but
>>> ultimately userspace will need to deal with failed sensor communication
>>> anyway, so I don't see the point.
>>
>> The sensors are rather flaky and if they go nuts the user/developer
>> maybe wants to know why.
>> From a plain EIO she has no chance to find out. He'll have to add
>> printk()s by hand to find out.
>> With a log message one can start digging into the issue.
> 
> I think any log messages that are caused by wiring problems are
> in place already. Also you should get an ETIMEDOUT not an EIO in
> these cases. In these cases the number of edges received is reported,
> which actually tells you a lot about the type of wiring problem.
> 
> BTW when I originally submitted the driver, it contained the following
> code that got rejected:
> /*
>  * dht11_edges_print: show the data as actually received by the
>  *                    driver.
>  * This is dead code, keeping it for now just in case somebody needs
>  * it for porting the driver to new sensor HW, etc.
>  *
> static void dht11_edges_print(struct dht11_gpio *dht11)
> {
>         int i;
> 
>         pr_err("dht11: transfer timed out:\n");
>         for (i = 1; i < dht11->num_edges; ++i) {
>                 pr_err("dht11: %d: %lld ns %s\n", i,
>                         dht11->edges[i].ts - dht11->edges[i-1].ts,
>                         dht11->edges[i-1].value ? "high" : "low");
>         }
> }
> */
> 
> which I used to call on errors to debug the decoder and the quirks
> necessary to support different sensors. Maybe someting like this would
> get accepted if it integrated properly with the debugging frameworks
> of the kernel instead of flooding the log?
> 
> I think the EIO errors are all really of the type:
> "Some noise injection into the data line caused an hiccup, just try again."
> 
> I wouldn't object to changing some of the EIOs to EAGAINs or something,
> but I doubt we get this through review.
> 
> JFTR: I don't object strongly to additional logging. Just telling you
> 1) This has been considered when writing the driver.
> 2) I probably won't ACK it, so Jonathan will have to decide wether this
> is a valuable addition.

Okay. Let's see what Jonathan's opinion is.
IMHO a driver should use only one logging style not two.

Enough logging style bikeshedded, back to real work. :)

Thanks,
//richard
