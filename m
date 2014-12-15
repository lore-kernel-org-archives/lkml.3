Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaLOBh5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 20:37:57 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:2623 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaLOBhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 20:37:47 -0500
Message-ID: <548E3B5E.6050805@huawei.com>
Date: Mon, 15 Dec 2014 09:37:34 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <m.szyprowski@samsung.com>,
        <aneesh.kumar@linux.vnet.ibm.com>, <iamjoonsoo.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH] CMA: add the amount of cma memory in meminfo
References: <547FCCE9.2020600@huawei.com> <xa1ty4qm9eq7.fsf@mina86.com>
In-Reply-To: <xa1ty4qm9eq7.fsf@mina86.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A010204.548E3B66.0194,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 197117483506bb982b23242041fb9583
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/6 1:41, Michal Nazarewicz wrote:

> On Thu, Dec 04 2014, Xishi Qiu <qiuxishi@huawei.com> wrote:
>> Add the amount of cma memory in the following meminfo.
>> /proc/meminfo
>> /sys/devices/system/node/nodeXX/meminfo
>>
>> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> 
> No second look:
> 
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> 
>> ---
>>  drivers/base/node.c | 16 ++++++++++------
>>  fs/proc/meminfo.c   | 12 +++++++++---
>>  2 files changed, 19 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/base/node.c b/drivers/base/node.c
>> index 472168c..a27e4e0 100644
>> --- a/drivers/base/node.c
>> +++ b/drivers/base/node.c
>> @@ -120,6 +120,9 @@ static ssize_t node_read_meminfo(struct device *dev,
>>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>  		       "Node %d AnonHugePages:  %8lu kB\n"
>>  #endif
>> +#ifdef CONFIG_CMA
>> +		       "Node %d FreeCMAPages:   %8lu kB\n"
>> +#endif
>>  			,
>>  		       nid, K(node_page_state(nid, NR_FILE_DIRTY)),
>>  		       nid, K(node_page_state(nid, NR_WRITEBACK)),
>> @@ -136,14 +139,15 @@ static ssize_t node_read_meminfo(struct device *dev,
>>  		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE) +
>>  				node_page_state(nid, NR_SLAB_UNRECLAIMABLE)),
>>  		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE)),
>> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>  		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE))
>> -			, nid,
>> -			K(node_page_state(nid, NR_ANON_TRANSPARENT_HUGEPAGES) *
>> -			HPAGE_PMD_NR));
>> -#else
>> -		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE)));
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +		       , nid, K(node_page_state(nid,
>> +				NR_ANON_TRANSPARENT_HUGEPAGES) * HPAGE_PMD_NR)

Hi Michal，

The "mere white-space change" you said a few days ago，how about change like this
", nid, K(...)" -> ",nid, K(xxx)"?

Thanks,
Xishi Qiu

>> +#endif
>> +#ifdef CONFIG_CMA
>> +		       , nid, K(node_page_state(nid, NR_FREE_CMA_PAGES))
>>  #endif
>> +			);
>>  	n += hugetlb_report_node_meminfo(nid, buf + n);
>>  	return n;
>>  }
>> diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
>> index aa1eee0..d42e082 100644
>> --- a/fs/proc/meminfo.c
>> +++ b/fs/proc/meminfo.c
>> @@ -138,6 +138,9 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>  		"AnonHugePages:  %8lu kB\n"
>>  #endif
>> +#ifdef CONFIG_CMA
>> +		"FreeCMAPages:   %8lu kB\n"
>> +#endif
>>  		,
>>  		K(i.totalram),
>>  		K(i.freeram),
>> @@ -187,11 +190,14 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>>  		vmi.used >> 10,
>>  		vmi.largest_chunk >> 10
>>  #ifdef CONFIG_MEMORY_FAILURE
>> -		,atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 10)
>> +		, atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 10)
>>  #endif
>>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> -		,K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
>> -		   HPAGE_PMD_NR)
>> +		, K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
>> +				HPAGE_PMD_NR)
>> +#endif
>> +#ifdef CONFIG_CMA
>> +		, K(global_page_state(NR_FREE_CMA_PAGES))
>>  #endif
>>  		);
>>  
>> -- 
>> 2.0.0
>>
>>
> 



