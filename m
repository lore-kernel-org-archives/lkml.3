Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015Ab3JOI6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 04:58:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:24018 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab3JOI6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 04:58:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,497,1378882800"; 
   d="scan'208";a="419287601"
Message-ID: <525D03B4.8050709@intel.com>
Date: Tue, 15 Oct 2013 16:58:28 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI/Power: Check physical device's runtime pm status
 before requesting to resume it
References: <1381479385-1614-1-git-send-email-tianyu.lan@intel.com> <1761658.DWcBvZSdOl@vostro.rjw.lan>
In-Reply-To: <1761658.DWcBvZSdOl@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年10月11日 19:19, Rafael J. Wysocki wrote:
> On Friday, October 11, 2013 04:16:25 PM tianyu.lan@intel.com wrote:
>> From: Lan Tianyu <tianyu.lan@intel.com>
>>
>> Currently, when one power resource is turned on, devices owning it
>> will be requested to resume regardless of their runtime pm status.
>> ACPI power resource maybe turn on in some devices' runtime pm
>> resume callback(E.G, usb port) while turning on the power resource
>> will trigger one new resume request of the device. It causes
>> infinite loop between resume and suspend. This has happened on
>> clearing usb port's PM Qos NO_POWER_OFF flag twice. This patch is
>> to add check of physical device's runtime pm status and request resume
>> if the device is suspended.
>>
>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>> ---
>>  drivers/acpi/power.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
>> index 0dbe5cd..228c138 100644
>> --- a/drivers/acpi/power.c
>> +++ b/drivers/acpi/power.c
>> @@ -250,8 +250,10 @@ static void acpi_power_resume_dependent(struct work_struct *work)
>>
>>  	mutex_lock(&adev->physical_node_lock);
>>
>> -	list_for_each_entry(pn, &adev->physical_node_list, node)
>> -		pm_request_resume(pn->dev);
>> +	list_for_each_entry(pn, &adev->physical_node_list, node) {
>> +		if (pm_runtime_suspended(pn->dev))
>> +			pm_request_resume(pn->dev);
>> +	}
>
> This is racy, because the status may change right after you check it and before
> you call pm_request_resume().

Yes, the runtime status may be changed just after the check.

>
> Besides, pm_request_resume() checks the status of the device and won't
> try to resume it if it is not suspended.
>

For this issue, usb port is in the RPM_SUSPENDING state when
pm_request_resume() is called. The deferred_resume will be set to true
during this procedure and trigger resume after finishing suspend. USB
port runtime resume callback will turn on its power resource again and
the work of acpi_power_resume_dependent() is scheduled. Because the usb
port's usage count remains zero, it's to be suspended soon. When
pm_request_resume() of acpi_power_resume_dependent() is called, the usb
port is always in the PRM_SUSPENDING. Fall in the loop of suspend and
resume.

How about running acpi_power_dependent when turning on power resource 
rather than scheduling a work to run it?  After this, 
pm_request_resume() can check device's right status just after turning 
on power resource. Furthermore, pm_request_resume() is async resume and 
this change will not consume much time.

>>
>>  	list_for_each_entry(pn, &adev->power_dependent, node)
>>  		pm_request_resume(pn->dev);
>
> Thanks!
>


-- 
Best regards
Tianyu Lan
