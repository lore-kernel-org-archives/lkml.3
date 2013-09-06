Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727Ab3IFBfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 21:35:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:19288 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab3IFBfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 21:35:39 -0400
X-IronPort-AV: E=Sophos;i="4.90,850,1371052800"; 
   d="scan'208";a="8430714"
Message-ID: <52293118.8080707@cn.fujitsu.com>
Date: Fri, 06 Sep 2013 09:34:16 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 10/11] x86, mem-hotplug: Support initialize page tables
 from low to high.
References: <1377596268-31552-1-git-send-email-tangchen@cn.fujitsu.com> <1377596268-31552-11-git-send-email-tangchen@cn.fujitsu.com> <20130905133027.GA23038@hacker.(null)>
In-Reply-To: <20130905133027.GA23038@hacker.(null)>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/06 09:33:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/06 09:33:19,
	Serialize complete at 2013/09/06 09:33:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wanpeng,

Thank you for reviewing. See below, please.

On 09/05/2013 09:30 PM, Wanpeng Li wrote:
......
>> +#ifdef CONFIG_MOVABLE_NODE
>> +	unsigned long kernel_end;
>> +
>> +	if (movablenode_enable_srat&&
>> +	    memblock.current_order == MEMBLOCK_ORDER_LOW_TO_HIGH) {
>
> I think memblock.current_order == MEMBLOCK_ORDER_LOW_TO_HIGH is always
> true if config MOVABLE_NODE and movablenode_enable_srat == true if PATCH
> 11/11 is applied.

memblock.current_order == MEMBLOCK_ORDER_LOW_TO_HIGH is true here if 
MOVABLE_NODE
is configured, and it will be reset after SRAT is parsed. But 
movablenode_enable_srat
could only be true when users specify movablenode boot option in the 
kernel commandline.

Please refer to patch 9/11.

>
>> +		kernel_end = round_up(__pa_symbol(_end), PMD_SIZE);
>> +
>> +		memory_map_from_low(kernel_end, end);
>> +		memory_map_from_low(ISA_END_ADDRESS, kernel_end);
>
> Why split ISA_END_ADDRESS ~ end?

The first 5 pages for the page tables are from brk, please refer to 
alloc_low_pages().
They are able to map about 2MB memory. And this 2MB memory will be used 
to store
page tables for the next mapped pages.

Here, we split [ISA_END_ADDRESS, end) into [ISA_END_ADDRESS, _end) and 
[_end, end),
and map [_end, end) first. This is because memory in [ISA_END_ADDRESS, 
_end) may be
used, then we have not enough memory for the next coming page tables. We 
should map
[_end, end) first because this memory is highly likely unused.

>
......
>
> I think the variables sorted by address is:
> ISA_END_ADDRESS ->  _end ->  real_end ->  end

Yes.

>
>> +	memory_map_from_high(ISA_END_ADDRESS, real_end);
>
> If this is overlap with work done between #ifdef CONFIG_MOVABLE_NODE and
> #endif?
>

I don't think so. Seeing from my code, if work between #ifdef 
CONFIG_MOVABLE_NODE and
#endif is done, it will goto out, right ?

Thanks.

