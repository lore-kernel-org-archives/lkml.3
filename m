Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab3EPBaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 21:30:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:8894 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab3EPBah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 21:30:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,681,1363158000"; 
   d="scan'208";a="338342363"
Message-ID: <519436B7.2050101@linux.intel.com>
Date: Wed, 15 May 2013 18:30:31 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: zhang.yi20@zte.com.cn
CC: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        "'Ingo Molnar'" <mingo@kernel.org>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Thomas Gleixner'" <tglx@linutronix.de>, Zhang Yi <wetpzy@gmail.com>
Subject: Re: [PATCH] futex: bugfix for futex-key conflict when futex use hugepage
References: <000101ce5174$1962bac0$4c283040$@com> <20130515142035.GD11497@suse.de> <OF1450163D.E6FBE6A2-ON48257B6D.00048ADD-48257B6D.00070A58@zte.com.cn>
In-Reply-To: <OF1450163D.E6FBE6A2-ON48257B6D.00048ADD-48257B6D.00070A58@zte.com.cn>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/15/2013 06:16 PM, zhang.yi20@zte.com.cn wrote:
> 
> 
> Mel Gorman <mgorman@suse.de> wrote on 2013/05/15 22:20:35:
> 
> 
>> Re: [PATCH] futex: bugfix for futex-key conflict when futex use hugepage
>>
>> On Wed, May 15, 2013 at 09:57:03PM +0800, Zhang Yi wrote:
>>> The futex-keys of processes share futex determined by page-offset,
>>> mapping-host, and mapping-index of the user space address. User
>>> appications using hugepage for futex may lead to futex-key conflict.
>>>
>>> Assume there are two or more futexes in diffrent normal pages of the
>>> hugepage, and each futex has the same offset in its normal page,
>>> causing all the futexes have the same futex-key.
>>>
>>> This patch adds the normal page index in the compound page into
>>> the pgoff of futex-key.
>>>
>>> Steps to reproduce the bug:
>>> 1. The 1st thread map a file of hugetlbfs, and use the return address
>>> as the 1st mutex's address, and use the return address with PAGE_SIZE
>>> added as the 2nd mutex's address.
>>> 2. The 1st thread initialize the two mutexes with pshared attribute,
>>> and lock the two mutexes.
>>> 3. The 1st thread create the 2nd thread, and the 2nd thread block on
>>> the 1st mutex.
>>> 4. The 1st thread create the 3rd thread, and the 3rd thread block on
>>> the 2nd mutex.
>>> 5. The 1st thread unlock the 2nd mutex, the 3rd thread cannot take
>>> the 2nd mutex, and may block forever.
>>>
>>>
>>> Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>
>>> Tested-by: Ma Chenggong <ma.chenggong@zte.com.cn>
>>> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
>>> Reviewed-by: Darren Hart <dvhart@linux.intel.com>
>>> Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
>>> Reviewed-by: Mel Gorman <mgorman@suse.de>
>>> Reviewed-by: Liu Dong <liu.dong3@zte.com.cn>
>>> Reviewed-by: Cui Yunfeng <cui.yunfeng@zte.com.cn>
>>> Reviewed-by: Lu Zhongjun <lu.zhongjun@zte.com.cn>
>>> Reviewed-by: Jiang Biao <jiang.biao2@zte.com.cn>
>>>
>>
>> Did all these people really review it? I just whinged about the last
> patch
>> and didn't put a Reviewed-by on it. That said, I don't actually have a
>> problem with this patch and I assumed it passed your testing so
>>
> I mistakenly think that I should list all the people here. : )
> Shall I cleanup the name list and send the patch again?
> 
>> Reviewed-by: Mel Gorman <mgorman@suse.de>
>>
>> The others might not agree though.
>>
>> I note the conversion from int offset to long offset in futex_key appears
>> to have gotten lost. Is that in a separate cleanup patch now?

In general, you should not add someone's signature unless they gave it
first or explicitly gave you permission to do so. If you want to
indicate they were contacted, you can use the "Cc:" tag instead of
"Reviewed-by".

> 
> In old patch, I add the compound index into offset, so I make the offset
> from int to long. It is unnecessary for this patch. 

pgoff_t is an unsigned long, and page_to_pfn() returns an unsigned long.
Since compound_idx can be assigned from page_to_pfn() and it is added
with index in the return value, unsigned long seems like a better choice
to me. Is there a specific reason you prefer an int? It might be "fine"
but it is likely to raise eyebrows whenever someone read through it.

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
