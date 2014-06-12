Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbaFLIPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:15:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:11128 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbaFLIO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:14:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,463,1400050800"; 
   d="scan'208";a="554286894"
Message-ID: <53996152.2000407@intel.com>
Date: Thu, 12 Jun 2014 16:14:10 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: rjw@rjwysocki.net, lenb@kernel.org, naszar@ya.ru,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ACPI/Battery: Retry to get Battery information if failed
 during probing
References: <1402552946-14704-1-git-send-email-tianyu.lan@intel.com> <alpine.DEB.2.02.1406112354070.23724@chino.kir.corp.google.com> <53995488.20308@intel.com> <alpine.DEB.2.02.1406120025050.23724@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406120025050.23724@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年06月12日 15:26, David Rientjes wrote:
> On Thu, 12 Jun 2014, Lan Tianyu wrote:
> 
>>>> Some machines'(E,G Lenovo Z480) ECs are not stable during boot up
>>>> and causes battery driver fails to be probed due to failure of getting
>>>> battery information from EC sometimes. After several retries, the
>>>> operation will work. This patch is to retry to get battery information 5
>>>> times if the first try fails.
>>>>
>>>> Reported-and-tested-by: naszar <naszar@ya.ru>
>>>> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=75581
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>>>> ---
>>>>  drivers/acpi/battery.c | 12 +++++++++++-
>>>>  1 file changed, 11 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
>>>> index e48fc98..485009d 100644
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
>>>> @@ -1135,7 +1136,16 @@ static int acpi_battery_add(struct acpi_device *device)
>>>>  	mutex_init(&battery->sysfs_lock);
>>>>  	if (acpi_has_method(battery->device->handle, "_BIX"))
>>>>  		set_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags);
>>>> +
>>>> +retry_get_info:
>>>>  	result = acpi_battery_update(battery, false);
>>>> +
>>>> +	if (result && retry) {
>>>> +		msleep(20);
>>>
>>
>> Hi David:
>> 	Thanks for review.
>>
>>> We're really going to wait up to 20 * 5 = 100ms for acpi_battery_update() 
>>> to succeed?
>>
>> No, this depends which retry acpi_battery_update() will succeed. For
>> most machines, there will be no delay.
>>
> 
> Right, but you're willing to wait up to 100ms for it to succeed?  You're 
> implementing x retries with y ms sleep in between, I'm asking how it is 
> determined that the optimal values are x = 5 and y = 20. More directly:
> is it possible to succeed at 101ms?

The retry time is set by randomly and not accurate because don't know
when EC will work normally. Set the retry time to 5 just in order to
make sure battery driver probing sucessfully every time,

>  Is it really likely to succeed after 
> the first 20ms?
> 

Yes, it's possible.
>From naszar's test log, acpi_battery_update() failed only once. But not
sure that this happens every time, treat it conservatively and set the
retry time to 5.
https://bugzilla.kernel.org/attachment.cgi?id=139081&action=edit

-- 
Best regards
Tianyu Lan
