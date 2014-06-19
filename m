Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbaFSGtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 02:49:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:25202 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266AbaFSGtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 02:49:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,505,1400050800"; 
   d="scan'208";a="557788797"
Message-ID: <53A287A9.7000203@intel.com>
Date: Thu, 19 Jun 2014 14:48:09 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: David Rientjes <rientjes@google.com>, lenb@kernel.org, naszar@ya.ru,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] ACPI/Battery: Retry to get Battery information if
 failed during probing
References: <1402988994-27067-1-git-send-email-tianyu.lan@intel.com> <1474004.fDjayHqHT9@vostro.rjw.lan> <alpine.DEB.2.02.1406181515160.21927@chino.kir.corp.google.com> <2223803.V8Foed99uq@vostro.rjw.lan>
In-Reply-To: <2223803.V8Foed99uq@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年06月19日 07:00, Rafael J. Wysocki wrote:
> On Wednesday, June 18, 2014 03:15:47 PM David Rientjes wrote:
>> On Tue, 17 Jun 2014, Rafael J. Wysocki wrote:
>>
>>>> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
>>>> index e48fc98..8ed93a3 100644
>>>> --- a/drivers/acpi/battery.c
>>>> +++ b/drivers/acpi/battery.c
>>>> @@ -34,6 +34,7 @@
>>>>  #include <linux/dmi.h>
>>>>  #include <linux/slab.h>
>>>>  #include <linux/suspend.h>
>>>> +#include <linux/delay.h>
>>>>  #include <asm/unaligned.h>
>>>>  
>>>>  #ifdef CONFIG_ACPI_PROCFS_POWER
>>>> @@ -1119,7 +1120,7 @@ static struct dmi_system_id bat_dmi_table[] = {
>>>>  
>>>>  static int acpi_battery_add(struct acpi_device *device)
>>>>  {
>>>> -	int result = 0;
>>>> +	int result = 0, retry = 5;
>>>>  	struct acpi_battery *battery = NULL;
>>>>  
>>>>  	if (!device)
>>>> @@ -1135,9 +1136,20 @@ static int acpi_battery_add(struct acpi_device *device)
>>>>  	mutex_init(&battery->sysfs_lock);
>>>>  	if (acpi_has_method(battery->device->handle, "_BIX"))
>>>>  		set_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags);
>>>> -	result = acpi_battery_update(battery, false);
>>>> +
>>>> +	/*
>>>> +	 * Some machines'(E,G Lenovo Z480) ECs are not stable
>>>> +	 * during boot up and this causes battery driver fails to be
>>>> +	 * probed due to failure of getting battery information
>>>> +	 * from EC sometimes. After several retries, the operation
>>>> +	 * may work. So add retry code here and 20ms sleep between
>>>> +	 * every retries.
>>>> +	 */
>>>> +	while ((result = acpi_battery_update(battery, false)) && retry--)
>>>> +		msleep(20);
>>>>  	if (result)
>>>>  		goto fail;
>>>
>>> Why not to write this as
>>>
>>> 	for (;;) {
>>> 		result = acpi_battery_update(battery, false);
>>> 		if (!result)
>>> 			break;
>>> 		else if (!--retry)
>>> 			goto fail;
>>>
>>> 		msleep(20);
>>> 	}
>>>
>>
>> I suggested a similar for loop earlier, I think it's cleaner.
> 
> Precisely.  And it would be even more clean to introduce
> 
> static bool acpi_battery_update_retry(struct acpi_battery *battery)
> {
> 	int retry, ret;
> 
> 	for (retry = 5; retry; retry--) {
> 		ret = acpi_battery_update(battery, false);
> 		if (!ret)
> 			break;
> 
> 		msleep(20);
> 	}
> 	return ret;
> }
> 
> and use that instead of the open-coded loop.

Ok. I will update patch like this.

> 
> Rafael
> 


-- 
Best regards
Tianyu Lan
