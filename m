Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaJVFd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 01:33:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35877 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaJVFdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 01:33:25 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <5447416C.5080106@jp.fujitsu.com>
Date: Wed, 22 Oct 2014 14:32:28 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <zhenzhang.zhang@huawei.com>,
        <wangnan0@huawei.com>, <tangchen@cn.fujitsu.com>,
        <dave.hansen@intel.com>, <rientjes@google.com>
Subject: Re: [PATCH] memory-hotplug: Clear pgdat which is allocated by bootmem
 in try_offline_node()
References: <5444DE75.6010206@jp.fujitsu.com> <1413910581.12798.25.camel@misato.fc.hp.com>
In-Reply-To: <1413910581.12798.25.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/22 1:56), Toshi Kani wrote:
> On Mon, 2014-10-20 at 19:05 +0900, Yasuaki Ishimatsu wrote:
>   :
>> When hot removing memory, pgdat is set to 0 in try_offline_node().
>> But if the pgdat is allocated by bootmem allocator, the clearing
>> step is skipped. And when hot adding the same memory, the uninitialized
>> pgdat is reused. But free_area_init_node() chacks wether pgdat is set
>

> s/chacks/checks

I'll update it.

>
>
>> to zero. As a result, free_area_init_node() hits WARN_ON().
>>
>> This patch clears pgdat which is allocated by bootmem allocator
>> in try_offline_node().
>>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> CC: Zhang Zhen <zhenzhang.zhang@huawei.com>
>> CC: Wang Nan <wangnan0@huawei.com>
>> CC: Tang Chen <tangchen@cn.fujitsu.com>
>> CC: Toshi Kani <toshi.kani@hp.com>
>> CC: Dave Hansen <dave.hansen@intel.com>
>> CC: David Rientjes <rientjes@google.com>
>>
>> ---
>>   mm/memory_hotplug.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 29d8693..7649f7c 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -1943,7 +1943,7 @@ void try_offline_node(int nid)
>>
>>   	if (!PageSlab(pgdat_page) && !PageCompound(pgdat_page))
>>   		/* node data is allocated from boot memory */
>> -		return;
>> +		goto out;
>

> Do we still need this if-statement?  That is, do we have to skip the
> for-loop below even though it checks with is_vmalloc_addr()?

You are right. The if-statement is not necessary. So the issue can be
fixed by just removing the if-statement.

I'll post updated patch soon.

Thanks,
Yasuaki Ishimatsu

>
> Thanks,
> -Toshi
>
>
>>   	/* free waittable in each zone */
>>   	for (i = 0; i < MAX_NR_ZONES; i++) {
>> @@ -1957,6 +1957,7 @@ void try_offline_node(int nid)
>>   			vfree(zone->wait_table);
>>   	}
>>
>> +out:
>>   	/*
>>   	 * Since there is no way to guarentee the address of pgdat/zone is not
>>   	 * on stack of any kernel threads or used by other kernel objects
>
>


