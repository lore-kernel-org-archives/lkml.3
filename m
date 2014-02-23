Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaBWOnZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 09:43:25 -0500
Received: from mail.active-venture.com ([67.228.131.205]:59767 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaBWOnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 09:43:24 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <530A0909.50101@roeck-us.net>
Date: Sun, 23 Feb 2014 06:43:21 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alejandro Cabrera <acabrera@udio.cujae.edu.cu>
CC: Wim Van Sebroeck <wim@iguana.be>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, monstr@monstr.eu,
        linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 07/11] watchdog: xilinx: Use of_property_read_u32
References: <cover.1392212059.git.michal.simek@xilinx.com> <7cbb10853a343c9d488346596f604909ab0668b9.1392212059.git.michal.simek@xilinx.com> <20140212171509.GB20012@roeck-us.net> <20140222184604.GB21504@spo001.leaseweb.com> <53094A15.1080708@udio.cujae.edu.cu> <53093038.6000604@roeck-us.net> <53097091.50204@udio.cujae.edu.cu> <530950A1.40302@roeck-us.net> <530991AA.9040201@udio.cujae.edu.cu> <53096E8D.50202@roeck-us.net> <530A20ED.3070505@udio.cujae.edu.cu>
In-Reply-To: <530A20ED.3070505@udio.cujae.edu.cu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2014 08:25 AM, Alejandro Cabrera wrote:
> On 22/2/2014 7:44 PM, Guenter Roeck wrote:
>> On 02/22/2014 10:14 PM, Alejandro Cabrera wrote:
>>> On 22/2/2014 5:36 PM, Guenter Roeck wrote:
>>>> On 02/22/2014 07:52 PM, Alejandro Cabrera wrote:
>>>>> On 22/2/2014 3:18 PM, Guenter Roeck wrote:
>>>>>> On 02/22/2014 05:08 PM, Alejandro Cabrera wrote:
>>>>>>> On 22/2/2014 10:46 AM, Wim Van Sebroeck wrote:
>>>>>>>> Hi All,
>>>>>>>>
>>>>>>>>> Hi Michal,
>>>>>>>>>
>>>>>>>>> On Wed, Feb 12, 2014 at 02:41:21PM +0100, Michal Simek wrote:
>>>>>>>>>> Use of_property_read_u32 functions to clean probe function.
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Michal Simek<michal.simek@xilinx.com>
>>>>>>>>>> Reviewed-by: Guenter Roeck<linux@roeck-us.net>
>>>>>>>>>> ---
>>>>>>>>>>
>>>>>>>>>> Changes in v3:
>>>>>>>>>> - Remove one if checking and use variable directly
>>>>>>>>>>
>>>>>>>>> Looks good.
>>>>>>>>>
>>>>>>>>> Another comment/remark.
>>>>>>>>>
>>>>>>>>>> -    pfreq = (u32 *)of_get_property(pdev->dev.of_node,
>>>>>>>>>> -                    "clock-frequency", NULL);
>>>>>>>>>> -
>>>>>>>>>> -    if (pfreq == NULL) {
>>>>>>>>>> +    rc = of_property_read_u32(pdev->dev.of_node, "clock-frequency",&pfreq);
>>>>>>>>>> +    if (rc) {
>>>>>>>>>>           dev_warn(&pdev->dev,
>>>>>>>>>>                "The watchdog clock frequency cannot be obtained\n");
>>>>>>>>>>           no_timeout = true;
>>>>>>>>>>       }
>>>>>>>>>>
>>>>>>>>>> -    tmptr = (u32 *)of_get_property(pdev->dev.of_node,
>>>>>>>>>> -                    "xlnx,wdt-interval", NULL);
>>>>>>>>>> -    if (tmptr == NULL) {
>>>>>>>>>> +    rc = of_property_read_u32(pdev->dev.of_node, "xlnx,wdt-interval",
>>>>>>>>>> + &xdev->wdt_interval);
>>>>>>>>>> +    if (rc) {
>>>>>>>>>>           dev_warn(&pdev->dev,
>>>>>>>>>>                "Parameter \"xlnx,wdt-interval\" not found\n");
>>>>>>>>>>           no_timeout = true;
>>>>>>>>>> -    } else {
>>>>>>>>>> -        xdev->wdt_interval = *tmptr;
>>>>>>>>>>       }
>>>>>>>>>>
>>>>>>>>>> -    tmptr = (u32 *)of_get_property(pdev->dev.of_node,
>>>>>>>>>> -                    "xlnx,wdt-enable-once", NULL);
>>>>>>>>>> -    if (tmptr == NULL) {
>>>>>>>>>> +    rc = of_property_read_u32(pdev->dev.of_node, "xlnx,wdt-enable-once",
>>>>>>>>>> + &enable_once);
>>>>>>>>>> +    if (rc)
>>>>>>>>>>           dev_warn(&pdev->dev,
>>>>>>>>>>                "Parameter \"xlnx,wdt-enable-once\" not found\n");
>>>>>>>>>> -        watchdog_set_nowayout(xilinx_wdt_wdd, true);
>>>>>>>>>> -    }
>>>>>>>>> All the above properties are optional. Is a warning really
>>>>>>>>> warranted in this case ? I usually associate a warning with
>>>>>>>>> something that is wrong, which is not the case here.
>>>>>>>>>
>>>>>>>>> I would encourage you to drop those warnings, but that should be
>>>>>>>>> a separate patch.
>>>>>>>> I agree with Guenter: these are not really warnings. Seperate patch is thus welcome.
>>>>>>> Hi
>>>>>>>
>>>>>>> I support Michal intention, I think it is a warning because device tree blob must have the "xlnx,wdt-enable-once" property specified in order to allow the system to be sure of the real value of this property. In addition to, this warning can be helpful to detect a wrong device tree specification.
>>>>>>>
>>>>>>
>>>>>> The dt documentation states that the properties are optional.
>>>>>>
>>>>>> Optional properties:
>>>>>> - clock-frequency       : Frequency of clock in Hz
>>>>>> - xlnx,wdt-enable-once  : 0 - Watchdog can be restarted
>>>>>>                           1 - Watchdog can be enabled just once
>>>>>> - xlnx,wdt-interval     : Watchdog timeout interval in 2^<val> clock cycles,
>>>>>> <val> is integer from 8 to 31.
>>>>>>
>>>>>> This clearly conflicts with your statement. An optional property
>>>>>> is just that, optional. If it warrants a warning, it must
>>>>>> not be optional. If you claim that not providing the properties
>>>>>> would be "wrong", why are they defined as optional ?
>>>>> Hi Guenter
>>>>>
>>>>> I didn't know that these properties was classified as optional...
>>>>> I think that they should not be, because all xilinx watchog devices (at least for microblaze processor)
>>>>> have these properties defined in theirs MPD files and theirs values can be obtained during the
>>>>> hardware specification to device tree conversion.
>>>>>> What is your definition of "wrong" and "must have" ?
>>>>> what I mean for "must have" is: if these properties can be obtained
>>>>> for all xilinx watchdog devices they must be present in the device tree because they allows
>>>>> the system (linux/user) to know exactly how a watchdog device is configured.
>>>>> Because these properties always can be obtained from hardware design there is no
>>>>> reason to leave them out from the device tree. This is why I consider that a device tree without
>>>>> these properties should be considered as "wrong" device tree.
>>>>>> How do you expect anyone to know that omitting those
>>>>>> "optional" properties is by some definition "wrong" ?
>>>>> I'm agree with you.
>>>>> Maybe these properties shouldn't be optional.
>>>>> For example suppose that "xlnx,wdt-enable-once" is missing in the device tree,
>>>>> when a watchdog daemon ask for this property what is the obtained value ?
>>>>> Independently of this value, why do not warn the user about this missing property
>>>>> when it can always be in the device tree ?
>>>>>
>>>>
>>>> Really, this line of argument doesn't make any sense to me.
>>>> "xlnx,wdt-enable-once", for example, is a boolean and means
>>>> that the watchdog, when enabled, can not be stopped. It defaults
>>>> to false, and thus is inherently optional. Making it mandatory
>>>> doesn't really add any value.
>>>>
>>>
>>> If the device has been configured with wdt-enable-once=true
>>> and the device tree doesn't have this property then a watchdog daemon
>>> would see it as "false" because it is the default making the system to misbehave...
>>> A warning during driver loading could help user to identify the problem.
>>>
>>
>> All this would give you is a false sense of safety. The property could
>> just as well be there and be wrong (eg be configured as = <0> when it
>> should be 1, or with a wrong frequency.
> These issues "cannot" be detected but the missing properties yes.
>> Following your logic, every driver
>> would need to warn about everything, just to be sure.
> Every driver should warn about anything that it considers weird and let the user to decide if it matters or not.
> I think that an example of weird could be the lack of an expected property.
>

I don't think it makes sense to continue this discussion.
We have fundamental differences in opinion which we won't
resolve by repeating our arguments over and over.

Wim, I'll let you decide how to handle this. My recommendation
is to request the author to decide if the properties are optional
or not before accepting this patch set. Either the properties
are optional, and there should be no warnings, or they are
mandatory and the driver should bail out if they are missing.

Guenter

