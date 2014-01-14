Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaANCyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 21:54:06 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19440 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaANCyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 21:54:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 13 Jan 2014 18:53:49 -0800
Message-ID: <52D4A6DF.806@nvidia.com>
Date: Tue, 14 Jan 2014 10:54:23 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv9 02/20] thermal: introduce device tree parser
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com>
 <1384285582-16933-3-git-send-email-eduardo.valentin@ti.com>
 <52C4D612.2090808@nvidia.com> <52C5A6CE.5060904@nvidia.com>
 <20140106135145.GD21906@e106331-lin.cambridge.arm.com>
 <52CAC3AF.9020401@ti.com> <52CB69FA.9080903@nvidia.com>
 <52D45AC8.1010607@ti.com>
In-Reply-To: <52D45AC8.1010607@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 05:29 AM, Eduardo Valentin wrote:
> * PGP Signed by an unknown key
> 
> Wei,
> 
> On 06-01-2014 22:44, Wei Ni wrote:
>> On 01/06/2014 10:54 PM, Eduardo Valentin wrote:
>>>> Old Signed by an unknown key
>>>
>>> On 06-01-2014 09:51, Mark Rutland wrote:
>>>> On Thu, Jan 02, 2014 at 05:50:06PM +0000, Matthew Longnecker wrote:
>>>>>
>>>>>> I think the platform driver may set governor for the thermal zone,
>>>>>> so how about to add a property named as "governor",
>>>>>> and parse it to tzp->governor_name,
>>>>>> something like:
>>>>>>                  ret = of_property_read_string(child, "governor", &str);
>>>>>>                  if (ret == 0)
>>>>>>                          if (strlen(str) < THERMAL_NAME_LENGTH)
>>>>>>                                  strcpy(tzp->governor_name, str);
>>>>>>
>>>>>> Thanks.
>>>>>> Wei.
>>>>>
>>>>> DT is supposed to describe the hardware, right? The governor isn't 
>>>>> hardware -- it's a software control policy. On the other hand, that 
>>>>> control policy must be tuned according to the behaviors of the platform 
>>>>> hardware otherwise the system will be unstable.
>>>>>
>>>>> Is it appropriate to be naming the governor in DT? If so, is it equally 
>>>>> appropriate to describe any governor-specific parameters in DT (even 
>>>>> though they are pure software constructs)?
>>>>
>>>> The dt should be relatively static -- if the hardware doesn't change the
>>>> dt shouldn't have to.
>>>>
>>>> The governers are not static. We can introduce new ones and throw away
>>>> old ones at any time. Tuning parameters can also change at any time.
>>>>
>>>> I'd prefer to not have governer details described in the dt, and the
>>>> choice of governer and configuration of its tuning parameters should be
>>>> made at runtime somehow.
>>>
>>> Agreed.
>>
>> Yes, I think so, but the of-thermal driver handle the
>> thermal_zone_device_register, and pass the "tzp" without governor_name,
> 
> In fact, it will fall into the default governor, which is step_wise, by
> default config.

In the thermal_zone_device_register(), it has following codes:
    if (tz->tzp)
            tz->governor = __find_governor(tz->tzp->governor_name);
    else
            tz->governor = __find_governor(DEFAULT_THERMAL_GOVERNOR);

It mean if the tz->tzp is not NULL, and the governor_name is NULL, then
the __find_governor() will return NULL, so the tz->governor is NULL, it
can't fall into the default governor. And in the of-thermal driver, it
call the thermal_zone_device_register(), and pass the "tzp" without
governor_name.
I think if we want to change the governor in user space, we need to fix
this first.

> 
>> so the created thermal_zone's governor will be NULL, then it can't run
>> into the governor->throttle() if needed. And currently there have no
> 
> Actually, no, the tz will be set to default governor, and its throttle
> call will be called.
> 
>> interface to support updating governor and configuration at runtime.
>> I think it's better to initialize the governor_name when register the
>> thermal zone device in the of-thermal driver.
> 
> Still, why would you need to change the governor from a in kernel
> decision? There is an ABI to change the thermal zone policy based on
> user(land) request. If you need to change the policy from within the
> kernel, which seams to be what you are trying to propose, you need to
> explain why you need it, say, by giving at least one user of this API or
> explaining its use case.

The thermal_zone_device_register() support to set the governor which you
want, but with the of-thermal framework, it only support to set to
default governor, if fix above issue. I think the driver which use the
of-thermal should be able to set to any governors which it want, in its
initialization. So I add the function thermal_update_governor().

> 
>>
>> Thanks.
>>
>>>
>>>>
>>>> Thanks,
>>>> Mark.
>>>>
>>>>
>>>
>>>
>>
>>
>>
> 
> 

