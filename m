Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab3LLFES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 00:04:18 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46623 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab3LLFER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 00:04:17 -0500
Message-ID: <52A943BC.2090001@oracle.com>
Date: Thu, 12 Dec 2013 13:03:56 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, joern@logfs.org,
        mgorman@suse.de, Michel Lespinasse <walken@google.com>,
        riel@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: kernel BUG in munlock_vma_pages_range
References: <52A3D0C3.1080504@oracle.com> <52A58E8A.3050401@suse.cz> <52A5F83F.4000207@oracle.com> <52A5F9EE.4010605@suse.cz> <52A6275F.4040007@oracle.com> <52A8EE38.2060004@suse.cz> <52A92A8D.20603@oracle.com>
In-Reply-To: <52A92A8D.20603@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/12/2013 11:16 AM, Sasha Levin wrote:
> On 12/11/2013 05:59 PM, Vlastimil Babka wrote:
>> On 12/09/2013 09:26 PM, Sasha Levin wrote:
>>> On 12/09/2013 12:12 PM, Vlastimil Babka wrote:
>>>> On 12/09/2013 06:05 PM, Sasha Levin wrote:
>>>>> On 12/09/2013 04:34 AM, Vlastimil Babka wrote:
>>>>>> Hello, I will look at it, thanks.
>>>>>> Do you have specific reproduction instructions?
>>>>>
>>>>> Not really, the fuzzer hit it once and I've been unable to trigger
>>>>> it again. Looking at
>>>>> the piece of code involved it might have had something to do with
>>>>> hugetlbfs, so I'll crank
>>>>> up testing on that part.
>>>>
>>>> Thanks. Do you have trinity log and the .config file? I'm currently
>>>> unable to even boot linux-next
>>>> with my config/setup due to a GPF.
>>>> Looking at code I wouldn't expect that it could encounter a tail
>>>> page, without first encountering a
>>>> head page and skipping the whole huge page. At least in THP case, as
>>>> TLB pages should be split when
>>>> a vma is split. As for hugetlbfs, it should be skipped for
>>>> mlock/munlock operations completely. One
>>>> of these assumptions is probably failing here...
>>>
>>> If it helps, I've added a dump_page() in case we hit a tail page
>>> there and got:
>>>
>>> [  980.172299] page:ffffea003e5e8040 count:0 mapcount:1
>>> mapping:          (null) index:0
>>> x0
>>> [  980.173412] page flags: 0x2fffff80008000(tail)
>>>
>>> I can also add anything else in there to get other debug output if
>>> you think of something else useful.
>>
>> Please try the following. Thanks in advance.
> 
> [  428.499889] page:ffffea003e5c0040 count:0 mapcount:4
> mapping:          (null) index:0x0
> [  428.499889] page flags: 0x2fffff80008000(tail)
> [  428.499889] start=140117131923456 pfn=16347137
> orig_start=140117130543104 page_increm
> =1 vm_start=140117130543104 vm_end=140117134688256 vm_flags=135266419
> [  428.499889] first_page pfn=16347136
> [  428.499889] page:ffffea003e5c0000 count:204 mapcount:44
> mapping:ffff880fb5c466c1 inde
> x:0x7f6f8fe00
> [  428.499889] page flags:
> 0x2fffff80084068(uptodate|lru|active|head|swapbacked)

>From this print, it looks like the page is still a huge page.
One situation I guess is a huge page which isn't PageMlocked and passed
to munlock_vma_page(). I'm not sure whether this will happen.
Please take a try this patch.

Thanks,
-Bob

diff --git a/mm/mlock.c b/mm/mlock.c
index d480cd6..f7066d2 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -466,6 +466,22 @@ void munlock_vma_pages_range(struct vm_area_struct
*vma,
 				 * the page_mask here.
 				 */
 				page_mask = munlock_vma_page(page);
+
+				/*
+				 * There are two possibilities when munlock_vma_page() return 0.
+				 * 1. The THP page was split.
+				 * 2. The THP page was not PageMlocked before and
+				 *    it didn't get split.
+				 *
+				 * In case 2 we have to reset page_mask to
+				 * 'HPAGE_PMD_NR - 1' becuase this page is still
+				 * huge page, else PageTransHuge may receive a
+				 * tail page and trigger VM_BUG_ON on next loop.
+				 */
+				if (!page_mask)
+					if (PageTransHuge(page))
+						page_mask = HPAGE_PMD_NR - 1;
+
 				unlock_page(page);
 				put_page(page); /* follow_page_mask() */
 			} else {

