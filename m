Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbaBEXKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 18:10:42 -0500
Received: from relay3.sgi.com ([192.48.152.1]:43696 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750941AbaBEXKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 18:10:40 -0500
Message-ID: <52F2C4F0.6080608@sgi.com>
Date: Wed, 5 Feb 2014 17:10:40 -0600
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Xishi Qiu <qiuxishi@huawei.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiang Liu <liuj97@gmail.com>, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>
Subject: Re: [RFC] Move the memory_notifier out of the memory_hotplug lock
References: <1391617743-150518-1-git-send-email-nzimmer@sgi.com> <alpine.DEB.2.02.1402051217520.5616@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1402051217520.5616@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.123]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 02:29 PM, David Rientjes wrote:
> On Wed, 5 Feb 2014, Nathan Zimmer wrote:
>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 62a0cd1..a3cbd14 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -985,12 +985,12 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_typ
>>   		if (need_zonelists_rebuild)
>>   			zone_pcp_reset(zone);
>>   		mutex_unlock(&zonelists_mutex);
>> +		unlock_memory_hotplug();
>>   		printk(KERN_DEBUG "online_pages [mem %#010llx-%#010llx] failed\n",
>>   		       (unsigned long long) pfn << PAGE_SHIFT,
>>   		       (((unsigned long long) pfn + nr_pages)
>>   			    << PAGE_SHIFT) - 1);
>>   		memory_notify(MEM_CANCEL_ONLINE, &arg);
>> -		unlock_memory_hotplug();
>>   		return ret;
>>   	}
>>   
>> @@ -1016,9 +1016,10 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_typ
>>   
>>   	writeback_set_ratelimit();
>>   
>> +	unlock_memory_hotplug();
>> +
>>   	if (onlined_pages)
>>   		memory_notify(MEM_ONLINE, &arg);
>> -	unlock_memory_hotplug();
>>   
>>   	return 0;
>>   }
> That looks a little problematic, what happens if a nid is being brought
> online and a registered callback does something like allocate resources
> for the arg->status_change_nid and the above two hunks of this patch end
> up racing?
>
> Before, a registered callback would be guaranteed to see either a
> MEMORY_CANCEL_ONLINE or MEMORY_ONLINE after it has already done
> MEMORY_GOING_ONLINE.
>
> With your patch, we could race and see one cpu doing MEMORY_GOING_ONLINE,
> another cpu doing MEMORY_GOING_ONLINE, and then MEMORY_ONLINE and
> MEMORY_CANCEL_ONLINE in either order.
>
> So I think this patch will break most registered callbacks that actually
> depend on lock_memory_hotplug(), it's a coarse lock for that reason.

Since the argument being passed in is the pfn and size it would be an issue
only if two threads attepted to online the same piece of memory. Right?

That seems very unlikely but if it can happen it needs to be protected against.

Nate



