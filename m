Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbaLIBnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 20:43:32 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38831 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbaLIBnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 20:43:31 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <54864F27.8010008@jp.fujitsu.com>
Date: Tue, 9 Dec 2014 10:23:51 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>, "K. Y. Srinivasan" <kys@microsoft.com>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <devel@linuxdriverproject.org>, <olaf@aepfle.de>, <apw@canonical.com>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] Drivers: hv: balloon: Fix the deadlock issue in the
 memory hot-add code
References: <1417826471-21131-1-git-send-email-kys@microsoft.com> <1417826498-21172-1-git-send-email-kys@microsoft.com> <1417826498-21172-2-git-send-email-kys@microsoft.com> <20141208150445.GB29102@dhcp22.suse.cz>
In-Reply-To: <20141208150445.GB29102@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/09 0:04), Michal Hocko wrote:
> On Fri 05-12-14 16:41:38, K. Y. Srinivasan wrote:
>> Andy Whitcroft <apw@canonical.com> initially saw this deadlock. We
>> have seen this as well. Here is the original description of the
>> problem (and a potential solution) from Andy:
>>
>> https://lkml.org/lkml/2014/3/14/451
>>
>> Here is an excerpt from that mail:
>>
>> "We are seeing machines lockup with what appears to be an ABBA
>> deadlock in the memory hotplug system.  These are from the 3.13.6 based Ubuntu kernels.
>> The hv_balloon driver is adding memory using add_memory() which takes
>> the hotplug lock
>
> Do you mean mem_hotplug_begin?
>

>> and then emits a udev event, and then attempts to
>> lock the sysfs device.  In response to the udev event udev opens the
>> sysfs device and locks it, then attempts to grab the hotplug lock to online the memory.
>
> Cannot we simply teach online_pages to fail with EBUSY when the memory
> hotplug is on the way.  We shouldn't try to online something that is not
> initialized yet, no?

Yes. Memory online shouldn't try before initializing it. Then memory online
should wait for initializing it, not easily fails. Generally, kernel sends
memory ONLINE event to userland by kobject_uevent() during initializing memory
and udev makes memory online after catching the event. Onlining memory by
udev almost run during initializing memory. So if memory online easily
fails, onlining memory by udev almost fails.

> The memory hotplug log is global so we can get
> false positives but that should be easier to deal with than exporting
> lock_device_hotplug and adding yet another lock dependency.
>
>> This seems to be inverted nesting in the two cases, leading to the hangs below:
>>
>> [  240.608612] INFO: task kworker/0:2:861 blocked for more than 120 seconds.
>> [  240.608705] INFO: task systemd-udevd:1906 blocked for more than 120 seconds.
>>
>> I note that the device hotplug locking allows complete retries (via
>> ERESTARTSYS) and if we could detect this at the online stage it could
>> be used to get us out.
>
> I am not sure I understand this but it suggests EBUSY above?
>
>> But before I go down this road I wanted to
>> make sure I am reading this right.  Or indeed if the hv_balloon driver
>> is just doing this wrong."
>>
>> This patch is based on the suggestion from
>> Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>
> This changelog doesn't explain us much. And boy this whole thing is so
> convoluted. E.g. I have hard time to see why ACPI hotplug is working
> correctly. My trail got lost at acpi_memory_device_add level which is
> a callback while acpi_device_hotplug is holding lock_device_hotplug but
> then again the rest is hidden by callbacks.

Commit 0f1cfe9d0d06 (mm/hotplug: remove stop_machine() from try_offline_node()) said:

   ---
     lock_device_hotplug() serializes hotplug & online/offline operations.  The
     lock is held in common sysfs online/offline interfaces and ACPI hotplug
     code paths.

     And here are the code paths:

     - CPU & Mem online/offline via sysfs online
         store_online()->lock_device_hotplug()

     - Mem online via sysfs state:
         store_mem_state()->lock_device_hotplug()

     - ACPI CPU & Mem hot-add:
         acpi_scan_bus_device_check()->lock_device_hotplug()

     - ACPI CPU & Mem hot-delete:
         acpi_scan_hot_remove()->lock_device_hotplug()
   ---

CPU & Memory online/offline/hotplug are serialized by lock_device_hotplug().

> I cannot seem to find any
> documentation which would explain all the locking here.

Yes. I need the documentation.

Thanks,
Yasuaki Ishimatsu

>
> So why other callers of add_memory don't need the same treatment and if
> they do then why don't we use the lock at add_memory level?
>
>> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
>
> Nak to this without proper explanation and I really think that it should
> be the onlining code which should deal with the parallel add_memory and
> back off until the full initialization is done.
>
>> ---
>>   drivers/hv/hv_balloon.c |    4 ++++
>>   1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
>> index afdb0d5..f525a62 100644
>> --- a/drivers/hv/hv_balloon.c
>> +++ b/drivers/hv/hv_balloon.c
>> @@ -22,6 +22,7 @@
>>   #include <linux/jiffies.h>
>>   #include <linux/mman.h>
>>   #include <linux/delay.h>
>> +#include <linux/device.h>
>>   #include <linux/init.h>
>>   #include <linux/module.h>
>>   #include <linux/slab.h>
>> @@ -649,8 +650,11 @@ static void hv_mem_hot_add(unsigned long start, unsigned long size,
>>
>>   		release_region_mutex(false);
>>   		nid = memory_add_physaddr_to_nid(PFN_PHYS(start_pfn));
>> +
>> +		lock_device_hotplug();
>>   		ret = add_memory(nid, PFN_PHYS((start_pfn)),
>>   				(HA_CHUNK << PAGE_SHIFT));
>> +		unlock_device_hotplug();
>>
>>   		if (ret) {
>>   			pr_info("hot_add memory failed error is %d\n", ret);
>> --
>> 1.7.4.1
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>


