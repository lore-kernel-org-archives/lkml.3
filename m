Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab3FNFeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 01:34:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:48939 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab3FNFeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 01:34:11 -0400
X-IronPort-AV: E=Sophos;i="4.87,863,1363104000"; 
   d="scan'208";a="7544347"
Message-ID: <51BAAC01.7010709@cn.fujitsu.com>
Date: Fri, 14 Jun 2013 13:37:05 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de,
        minchan@kernel.org, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [Part3 PATCH v2 1/4] bootmem, mem-hotplug: Register local pagetable
 pages with LOCAL_NODE_DATA when freeing bootmem.
References: <1371128636-9027-1-git-send-email-tangchen@cn.fujitsu.com> <1371128636-9027-2-git-send-email-tangchen@cn.fujitsu.com> <xa1tli6ef63p.fsf@mina86.com>
In-Reply-To: <xa1tli6ef63p.fsf@mina86.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/14 13:32:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/14 13:32:13,
	Serialize complete at 2013/06/14 13:32:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Please see below.

On 06/13/2013 10:16 PM, Michal Nazarewicz wrote:
......
>> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
>> index a85ced9..8a38eef 100644
>> --- a/include/linux/memblock.h
>> +++ b/include/linux/memblock.h
>> @@ -131,6 +131,28 @@ void __next_free_mem_range_rev(u64 *idx, int nid, phys_addr_t *out_start,
>>   	     i != (u64)ULLONG_MAX;					\
>>   	     __next_free_mem_range_rev(&i, nid, p_start, p_end, p_nid))
>>
>> +void __next_local_node_mem_range(int *idx, int nid, phys_addr_t *out_start,
>> +				 phys_addr_t *out_end, int *out_nid);
>
> Why not make it return int?

The same reason below.

>
>> +
>> +/**
>> + * for_each_local_node_mem_range - iterate memblock areas storing local node
>> + *                                 data
>> + * @i: int used as loop variable
>> + * @nid: node selector, %MAX_NUMNODES for all nodes
>> + * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
>> + * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
>> + * @p_nid: ptr to int for nid of the range, can be %NULL
>> + *
>> + * Walks over memblock areas storing local node data. Since all the local node
>> + * areas will be reserved by memblock, this iterator will only iterate
>> + * memblock.reserve. Available as soon as memblock is initialized.
>> + */
>> +#define for_each_local_node_mem_range(i, nid, p_start, p_end, p_nid)	    \
>> +	for (i = -1,							    \
>> +	     __next_local_node_mem_range(&i, nid, p_start, p_end, p_nid);   \
>> +	     i != -1;							    \
>> +	     __next_local_node_mem_range(&i, nid, p_start, p_end, p_nid))
>> +
>
> If __next_local_node_mem_range() returned int, this would be easier:
>
> +#define for_each_local_node_mem_range(i, nid, p_start, p_end, p_nid)	      \
> +	for (i = -1;
> +	     (i = __next_local_node_mem_range(i, nid, p_start, p_end, p_nid)) != -1; )

Yes, we can do it like this.

But I tried to do something similar to for_each_free_mem_range and
for_each_free_mem_range_reverse to keep the code coincident.

How do you think to change all this similar functions into your way ?

>
......
>> +void __init_memblock __next_local_node_mem_range(int *idx, int nid,
>> +					phys_addr_t *out_start,
>> +					phys_addr_t *out_end, int *out_nid)
>> +{
>> +	__next_flag_mem_range(idx, nid, MEMBLK_LOCAL_NODE,
>> +			      out_start, out_end, out_nid);
>> +}
>
> static inline in a header file perhaps?

OK, will put it in a header file in the next version.

Thanks. :)

