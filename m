Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3GOJPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 05:15:47 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15116 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab3GOJPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 05:15:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 15 Jul 2013 02:14:00 -0700
Message-ID: <51E3BD5F.6060806@nvidia.com>
Date: Mon, 15 Jul 2013 17:14:07 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>
CC: Guenter Roeck <linux@roeck-us.net>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] hwmon: (lm90) split set&show temp as common codes
References: <1373615287-18502-1-git-send-email-wni@nvidia.com> <1373615287-18502-2-git-send-email-wni@nvidia.com> <20130712152615.23464a6b@endymion.delvare> <20130712135000.GA3386@roeck-us.net> <20130712163034.1fc1cd66@endymion.delvare> <20130712144011.GC3629@roeck-us.net>	<51E395D9.6070000@nvidia.com> <20130715092415.6d082aa2@endymion.delvare>
In-Reply-To: <20130715092415.6d082aa2@endymion.delvare>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 03:24 PM, Jean Delvare wrote:
> On Mon, 15 Jul 2013 14:25:29 +0800, Wei Ni wrote:
>> On 07/12/2013 10:40 PM, Guenter Roeck wrote:
>>> On Fri, Jul 12, 2013 at 04:30:34PM +0200, Jean Delvare wrote:
>>>> If that means that for example the ACPI thermal zone is no longer
>>>> displayed by "sensors", then I strongly object - unless it is
>>>> explicitly registered as a separate hwmon device from now on, of course.
>>>
>>> If I recall correctly that was the idea. Of course, in practice that will mean
>>> that devices will _not_ get exposed as hwmon devices, as implementers won't
>>> bother doing both.
>>>
>>>> My idea was to make the bridge optional - you decide when you register
>>>> a thermal device if it should be exposed as hwmon or not.
>>>
>>> Yes, that would be a much better solution.
>>
>> I think we can decide it in the DT, we can add a dt property in the lm90
>> device node, such as:
>> sys-interface = SYS_HWMON;
>> or
>> sys-interface = SYS_THERMAL;
>> So we register it as the hwmon or thermal device
> 
> This is an option, but please keep in mind that DT is not the only way
> to instantiate LM90-like devices, and we should not expose duplicate
> inputs by default. It is fine with me if the default is to create only a
> HWMON device (as the lm90 driver was doing so far), and only
> DT-instantiated devices have the choice.

Yes, we should not expose duplicate inputs, we may have tree permutation:
1. only hwmon device:
for this items, we just need to call hwmon_device_register().
2. only thermal device + virtual hwmon device:
for this items, we just need to call thermal_zone_device_register().

We can set #1 as the default, and if use DT, we provide option to choice
#1 or #2.

3. hwmon device + thermal device:
for this items, we doesn't need the virtual hwmon which registered by
the thermal fw, how to handle this one? Add flag when register as
thermal device to indicate if want virtual hwmon device or not,
something like your below another option.

> 
> Another option, as discussed before, would be that the thermal devices
> registered by lm90 are specifically tagged as "do not expose as hwmon".
> This would avoid the duplicate hwmon inputs in all cases.

It seems in current thermal fw, it can't be tagged as "do not expose as
hwmon", we need to add flag when register thermal device.

Rui, what do you think for it?

> 
> Again - no strong opinion on the implementation, as long as it does the
> right thing.

I'm working on the Tegra platform, we uses nct1008 as the temperature
sensor, and we want to register it as thermal device, so that we can run
the throttle function. So I prepared these patches to enhance this driver.

> 
> Oh, and we'll have to be careful with the Kconfig dependencies. I do
> not want the lm90 driver to depend on the thermal framework.

Yes, absolutely agree, lm90 should be independent.
Indeed, the thermal folks is trying to restructure the thermal fw, and
in this new fw, it's more easy to add the generic sensors to the thermal
fw. If you interest it, please refer
http://thread.gmane.org/gmane.linux.power-management.general/30692.

Thanks.
Wei.

> 

