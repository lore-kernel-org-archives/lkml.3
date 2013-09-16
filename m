Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab3IPB2p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 21:28:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:36019 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755089Ab3IPB2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 21:28:43 -0400
X-IronPort-AV: E=Sophos;i="4.90,911,1371052800"; 
   d="scan'208";a="8533209"
Message-ID: <52365EA3.8000103@cn.fujitsu.com>
Date: Mon, 16 Sep 2013 09:28:03 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: Tang Chen <tangchen@cn.fujitsu.com>, rjw@sisk.pl, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, liwanp@linux.vnet.ibm.com,
        trenn@suse.de, yinghai@kernel.org, jiang.liu@huawei.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 2/5] memblock: Improve memblock to support allocation
 from lower address.
References: <1379064655-20874-1-git-send-email-tangchen@cn.fujitsu.com>  <1379064655-20874-3-git-send-email-tangchen@cn.fujitsu.com> <1379109208.13477.16.camel@misato.fc.hp.com>
In-Reply-To: <1379109208.13477.16.camel@misato.fc.hp.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/16 09:27:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/16 09:27:13,
	Serialize complete at 2013/09/16 09:27:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello toshi-san,

On 09/14/2013 05:53 AM, Toshi Kani wrote:
> On Fri, 2013-09-13 at 17:30 +0800, Tang Chen wrote:
>  :
>> @@ -100,8 +180,7 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
>>  					phys_addr_t end, phys_addr_t size,
>>  					phys_addr_t align, int nid)
>>  {
>> -	phys_addr_t this_start, this_end, cand;
>> -	u64 i;
>> +	phys_addr_t ret;
>>  
>>  	/* pump up @end */
>>  	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
>> @@ -111,18 +190,22 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
>>  	start = max_t(phys_addr_t, start, PAGE_SIZE);
>>  	end = max(start, end);
>>  
>> -	for_each_free_mem_range_reverse(i, nid, &this_start, &this_end, NULL) {
>> -		this_start = clamp(this_start, start, end);
>> -		this_end = clamp(this_end, start, end);
>> +	if (memblock_direction_bottom_up()) {
>> +		/*
>> +		 * MEMBLOCK_ALLOC_ACCESSIBLE is 0, which is less than the end
>> +		 * of kernel image. So callers specify MEMBLOCK_ALLOC_ACCESSIBLE
>> +		 * as @start is OK.
>> +		 */
>> +		start =	max(start, __pa_symbol(_end)); /* End of kernel image. */
>>  
>> -		if (this_end < size)
>> -			continue;
>> +		ret = __memblock_find_range(start, end, size, align, nid);
>> +		if (ret)
>> +			return ret;
>>  
>> -		cand = round_down(this_end - size, align);
>> -		if (cand >= this_start)
>> -			return cand;
>> +		pr_warn("memblock: Failed to allocate memory in bottom up direction. Now try top down direction.\n");
> 
> Is there any chance that this retry will succeed given that start and
> end are still the same?

Thanks for pointing this. We've made a mistake here. If the original start
is less than __pa_symbol(_end), and if the bottom up search fails, then
the top down search deserves a try with the original start argument.

> 
> Thanks,
> -Toshi
> 
> 
>>  	}
>> -	return 0;
>> +
>> +	return __memblock_find_range_rev(start, end, size, align, nid);
>>  }
>>  
>>  /**
> 
> 
> 


-- 
Thanks.
Zhang Yanfei
