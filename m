Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618AbaJWAlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 20:41:16 -0400
Received: from [42.62.48.242] ([42.62.48.242]:29681 "EHLO
	outbound.mxmail.xiaomi.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754359AbaJWAlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 20:41:14 -0400
From: =?gb2312?B?1uy71A==?= <zhuhui@xiaomi.com>
To: Peter Hurley <peter@hurleysoftware.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "riel@redhat.com" <riel@redhat.com>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "hughd@google.com" <hughd@google.com>,
        "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>
CC: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>, "mina86@mina86.com" <mina86@mina86.com>,
        "aneesh.kumar@linux.vnet.ibm.com" <aneesh.kumar@linux.vnet.ibm.com>,
        "iamjoonsoo.kim@lge.com" <iamjoonsoo.kim@lge.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "nasa4836@gmail.com" <nasa4836@gmail.com>,
        "ddstreet@ieee.org" <ddstreet@ieee.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "atomlin@redhat.com" <atomlin@redhat.com>,
        "raistlin@linux.it" <raistlin@linux.it>, "axboe@fb.com" <axboe@fb.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "n-horiguchi@ah.jp.nec.com" <n-horiguchi@ah.jp.nec.com>,
        "k.khlebnikov@samsung.com" <k.khlebnikov@samsung.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "deller@gmx.de" <deller@gmx.de>,
        "tangchen@cn.fujitsu.com" <tangchen@cn.fujitsu.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "sasha.levin@oracle.com" <sasha.levin@oracle.com>,
        "vdavydov@parallels.com" <vdavydov@parallels.com>,
        "suleiman@google.com" <suleiman@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/4] (CMA_AGGRESSIVE) Make CMA memory be more aggressive
 about allocation
Thread-Topic: [PATCH 0/4] (CMA_AGGRESSIVE) Make CMA memory be more
 aggressive about allocation
Thread-Index: AQHP6PJVOSZsZeZKBkSR9KhOfKwh0g==
Date: Thu, 23 Oct 2014 00:40:57 +0000
Message-ID: <04a07ed889c840f1919e220f906af3af@cnbox4.mioffice.cn>
References: <1413430551-22392-1-git-send-email-zhuhui@xiaomi.com>
 <543F8812.2020002@codeaurora.org> <54479CB2.5040408@hurleysoftware.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.37.216.50]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9N0fLid012047



On 10/22/14 20:02, Peter Hurley wrote:
> On 10/16/2014 04:55 AM, Laura Abbott wrote:
>> On 10/15/2014 8:35 PM, Hui Zhu wrote:
>>> In fallbacks of page_alloc.c, MIGRATE_CMA is the fallback of
>>> MIGRATE_MOVABLE.
>>> MIGRATE_MOVABLE will use MIGRATE_CMA when it doesn't have a page in
>>> order that Linux kernel want.
>>>
>>> If a system that has a lot of user space program is running, for
>>> instance, an Android board, most of memory is in MIGRATE_MOVABLE and
>>> allocated.  Before function __rmqueue_fallback get memory from
>>> MIGRATE_CMA, the oom_killer will kill a task to release memory when
>>> kernel want get MIGRATE_UNMOVABLE memory because fallbacks of
>>> MIGRATE_UNMOVABLE are MIGRATE_RECLAIMABLE and MIGRATE_MOVABLE.
>>> This status is odd.  The MIGRATE_CMA has a lot free memory but Linux
>>> kernel kill some tasks to release memory.
>>>
>>> This patch series adds a new function CMA_AGGRESSIVE to make CMA memory
>>> be more aggressive about allocation.
>>> If function CMA_AGGRESSIVE is available, when Linux kernel call function
>>> __rmqueue try to get pages from MIGRATE_MOVABLE and conditions allow,
>>> MIGRATE_CMA will be allocated as MIGRATE_MOVABLE first.  If MIGRATE_CMA
>>> doesn't have enough pages for allocation, go back to allocate memory from
>>> MIGRATE_MOVABLE.
>>> Then the memory of MIGRATE_MOVABLE can be kept for MIGRATE_UNMOVABLE and
>>> MIGRATE_RECLAIMABLE which doesn't have fallback MIGRATE_CMA.
>>>
>>
>> It's good to see another proposal to fix CMA utilization. Do you have
>> any data about the success rate of CMA contiguous allocation after
>> this patch series? I played around with a similar approach of using
>> CMA for MIGRATE_MOVABLE allocations and found that although utilization
>> did increase, contiguous allocations failed at a higher rate and were
>> much slower. I see what this series is trying to do with avoiding
>> allocation from CMA pages when a contiguous allocation is progress.
>> My concern is that there would still be problems with contiguous
>> allocation after all the MIGRATE_MOVABLE fallback has happened.
>
> What impact does this series have on x86 platforms now that CMA is the
> backup allocator for all iommu dma allocations?

They will not affect driver CMA memory allocation.

Thanks,
Hui

>
> Regards,
> Peter Hurley
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
