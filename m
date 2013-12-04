Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab3LDMof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:44:35 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43436 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754872Ab3LDMod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:44:33 -0500
Message-ID: <529F2391.8070202@ti.com>
Date: Wed, 4 Dec 2013 18:14:01 +0530
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: <nm@ti.com>, Tony Lindgren <tony@atomide.com>
CC: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: OMAP2+: omap_device: add fail hook for runtime_pm
 when bad data is detected
References: <1386121153-32351-1-git-send-email-nm@ti.com> <529EE305.70001@ti.com> <529F12F4.70304@ti.com>
In-Reply-To: <529F12F4.70304@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 05:03 PM, Nishanth Menon wrote:
> On 12/04/2013 02:08 AM, Joel Fernandes wrote:
>> On 12/04/2013 07:09 AM, Nishanth Menon wrote:
>>> Due to the cross dependencies between hwmod for automanaged device
>>> information for OMAP and dts node definitions, we can run into scenarios
>>> where the dts node is defined, however it's hwmod entry is yet to be
>>> added. In these cases:
>>> a) omap_device does not register a pm_domain (since it cannot find
>>>     hwmod entry).
>>> b) driver does not know about (a), does a pm_runtime_get_sync which
>>>     never fails
>>> c) It then tries to do some operation on the device (such as read the
>>>    revision register (as part of probe) without clock or adequate OMAP
>>>    generic PM operation performed for enabling the module.
>>>
>>> This causes a crash such as that reported in:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=66441
>>>
>>> When 'ti,hwmod' is provided in dt node, it is expected that the device
>>> will not function without the OMAP's power automanagement. Hence, when
>>> we hit a fail condition (due to hwmod entries not present or other
>>> similar scenario), fail at pm_domain level due to lack of data, provide
>>> enough information for it to be fixed, however, it allows for the driver
>>> to take appropriate measures to prevent crash.
>>>
>>> Reported-by: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
>>> Signed-off-by: Nishanth Menon <nm@ti.com>
>>> ---
>>>   arch/arm/mach-omap2/omap_device.c |   24 ++++++++++++++++++++++++
>>>   arch/arm/mach-omap2/omap_device.h |    1 +
>>>   2 files changed, 25 insertions(+)
>>>
>>> diff --git a/arch/arm/mach-omap2/omap_device.c
>>> b/arch/arm/mach-omap2/omap_device.c
>>> index 53f0735..e0a398c 100644
>>> --- a/arch/arm/mach-omap2/omap_device.c
>>> +++ b/arch/arm/mach-omap2/omap_device.c
>>> @@ -183,6 +183,10 @@ static int omap_device_build_from_dt(struct
>>> platform_device *pdev)
>>>   odbfd_exit1:
>>>       kfree(hwmods);
>>>   odbfd_exit:
>>> +    /* if data/we are at fault.. load up a fail handler */
>>> +    if (ret)
>>> +        pdev->dev.pm_domain = &omap_device_fail_pm_domain;
>>> +
>>>       return ret;
>>>   }
>>>
>>
>> Just wondering, can't we just print the warning here instead of registering new
>> pm_domain callbacks?
>>
> 
> I suggest you might want to read the commit message again.. but lets try once
> again:

I know what your patch does and what the problem you're trying to solve is.. Was
just trying to see if there's a better way of doing what you're trying to do..

>>> b) driver does not know about (a), does a pm_runtime_get_sync which
>>>     never fails"
> 
> A device node stated it will have hwmod to adequately control it, but in
> reality, as in this case, it does not. how does printing a warning alone help
> the driver which is not aware of these? The driver's attempt at pm_runtime_sync
> should fail, as that is what "ti,hwmod" property controls.

Why not do the following?

Assign pm_domain as omap_device_pm_domain always regardless of error or not.

Then in the _od_runtime_resume, check if the od or hwmods exists. If not, print
the warning. That way you don't need to register additional special callbacks
just to print a warning and will prolly be fewer LoC fwiw.

That may be harder to do and may require additional checks in omap_device_enable
etc, not sure. In that case, your approach is certainly the next best way. Just
thought its worth looking into :)

regards,

-Joel

