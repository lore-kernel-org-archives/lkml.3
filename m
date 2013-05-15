Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab3EOEqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 00:46:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:4438 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753919Ab3EOEqu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 00:46:50 -0400
X-IronPort-AV: E=Sophos;i="4.87,675,1363104000"; 
   d="scan'208";a="7272853"
Message-ID: <519312A7.9050309@cn.fujitsu.com>
Date: Wed, 15 May 2013 12:44:23 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mm: Remove unnecessary assignment for max_pfn_mapped
References: <518CB758.4000101@cn.fujitsu.com> <CAE9FiQVpbDJT2Ma6MHkB5aF9PUuGCia_QaLc_LjYCLJb4nKebg@mail.gmail.com> <518CCBB2.5010308@cn.fujitsu.com> <CAE9FiQWcKAJ0DP833urozcECkZNpbCks_vLVBf8UhaXTRSEWzA@mail.gmail.com>
In-Reply-To: <CAE9FiQWcKAJ0DP833urozcECkZNpbCks_vLVBf8UhaXTRSEWzA@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/15 12:45:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/15 12:45:37
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年05月10日 22:57, Yinghai Lu 写道:
> On Fri, May 10, 2013 at 3:28 AM, Zhang Yanfei
> <zhangyanfei@cn.fujitsu.com> wrote:
>> 于 2013年05月10日 17:27, Yinghai Lu 写道:
>>> On Fri, May 10, 2013 at 2:01 AM, Zhang Yanfei
>>> <zhangyanfei@cn.fujitsu.com> wrote:
>>>> init_memory_mapping will set max_pfn_mapped:
>>>> int_memory_mapping
>>>>   --> add_pfn_range_mapped
>>>>     --> max_pfn_mapped = max(max_pfn_mapped, end_pfn)
>>>>
>>>> In init_mem_mapping, before we set max_pfn_mapped to 0, we
>>>> have already called init_memory_mapping to setup pagetable
>>>> for [0, ISA_END_ADDRESS], and that sets max_pfn_mapped. So
>>>> the assignment to 0 is not necessary, remove it.
>>>
>>> NAK.
>>>
>>> for 32bit or Xen, max_pfn_mapped is set way before in head_32.S and
>>> xen-enlighen.
>>
>> Hi Yinghai
>>
>> I might be wrong, but just from the code in init_mem_mapping only:
>>
>>  410         /* the ISA range is always mapped regardless of memory holes */
>>  411         init_memory_mapping(0, ISA_END_ADDRESS);
>>  412
>>  413         /* xen has big range in reserved near end of ram, skip it at first.*/
>>  414         addr = memblock_find_in_range(ISA_END_ADDRESS, end, PMD_SIZE, PMD_SIZE);
>>  415         real_end = addr + PMD_SIZE;
>>  416
>>  417         /* step_size need to be small so pgt_buf from BRK could cover it */
>>  418         step_size = PMD_SIZE;
>>  419         max_pfn_mapped = 0; /* will get exact value next */
>>
>> Line 411 set max_pfn_mapped, and then line 419 set it to zero again, so
>> why keep the later assignment?
> 
> the comment says: /* will get exact value next */
> 
> For x86 32bit path, and xen set bigger max_pfn_mapped before.
> 

Hello Yinghai,

I kindly understand what you mean now. But I think we can put the reset of
max_pfn_mapped at the beginning of init_mem_mapping. That looks more logical.

See patch below, please.

Thanks
Zhang

------
>From dbd213301d800299d256c5da65a1d598902ed826 Mon Sep 17 00:00:00 2001
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Date: Wed, 15 May 2013 11:48:19 +0800
Subject: [PATCH] x86, mm: Reset max_pfn_mapped before we create direct mappings

We use init_mem_mapping to create direct mappings from scratch. But
in 32bit or xen, we may have already set max_pfn_mapped before in
head_32.S and or xen-enlighten. So put the reset at beginning not
in the middle of init_mem_mapping seems more logical.

Also add comments to explain the reset.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/mm/init.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index fdc5dca..f2e5d28 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -407,6 +407,14 @@ void __init init_mem_mapping(void)
 	end = max_low_pfn << PAGE_SHIFT;
 #endif
 
+	/*
+	 * In 32bit or xen, max_pfn_mapped has been set way before in
+	 * head_32.S or xen-enlighten. So here we reset it since we will
+	 * create direct mappings from scratch. And it will get its finally
+	 * exact value after we finish the direct mapping in this function.
+	 */
+	max_pfn_mapped = 0;
+
 	/* the ISA range is always mapped regardless of memory holes */
 	init_memory_mapping(0, ISA_END_ADDRESS);
 
@@ -416,7 +424,6 @@ void __init init_mem_mapping(void)
 
 	/* step_size need to be small so pgt_buf from BRK could cover it */
 	step_size = PMD_SIZE;
-	max_pfn_mapped = 0; /* will get exact value next */
 	min_pfn_mapped = real_end >> PAGE_SHIFT;
 	last_start = start = real_end;
 	while (last_start > ISA_END_ADDRESS) {
-- 
1.7.1
