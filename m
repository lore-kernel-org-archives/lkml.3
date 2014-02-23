Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260AbaBWNFo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 08:05:44 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:34684 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaBWNFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 08:05:42 -0500
Message-ID: <5309F1F8.6040006@oracle.com>
Date: Sun, 23 Feb 2014 08:04:56 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-mm@kvack.org, akpm@linux-foundation.org, mpm@selenic.com,
        cpw@sgi.com, kosaki.motohiro@jp.fujitsu.com, hannes@cmpxchg.org,
        kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz,
        aneesh.kumar@linux.vnet.ibm.com, xemul@parallels.com, riel@redhat.com,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/11] mempolicy: apply page table walker on queue_pages_range()
References: <1392068676-30627-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1392068676-30627-12-git-send-email-n-horiguchi@ah.jp.nec.com> <5306F29D.8070600@gmail.com> <530785b2.d55c8c0a.3868.ffffa4e1SMTPIN_ADDED_BROKEN@mx.google.com> <53078A53.9030302@oracle.com> <1393003512-qjyhnu0@n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1393003512-qjyhnu0@n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2014 12:25 PM, Naoya Horiguchi wrote:
> On Fri, Feb 21, 2014 at 12:18:11PM -0500, Sasha Levin wrote:
>> On 02/21/2014 11:58 AM, Naoya Horiguchi wrote:
>>> On Fri, Feb 21, 2014 at 01:30:53AM -0500, Sasha Levin wrote:
>>>> On 02/10/2014 04:44 PM, Naoya Horiguchi wrote:
>>>>> queue_pages_range() does page table walking in its own way now,
>>>>> so this patch rewrites it with walk_page_range().
>>>>> One difficulty was that queue_pages_range() needed to check vmas
>>>>> to determine whether we queue pages from a given vma or skip it.
>>>>> Now we have test_walk() callback in mm_walk for that purpose,
>>>>> so we can do the replacement cleanly. queue_pages_test_walk()
>>>>> depends on not only the current vma but also the previous one,
>>>>> so we use queue_pages->prev to keep it.
>>>>>
>>>>> ChangeLog v2:
>>>>> - rebase onto mmots
>>>>> - add VM_PFNMAP check on queue_pages_test_walk()
>>>>>
>>>>> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>>>>> ---
>>>>
>>>> Hi Naoya,
>>>>
>>>> I'm seeing another spew in today's -next, and it seems to be related
>>>> to this patch. Here's the spew (with line numbers instead of kernel
>>>> addresses):
>>>
>>> Thanks. (line numbers translation is very helpful.)
>>>
>>> This bug looks strange to me.
>>> "kernel BUG at mm/hugetlb.c:3580" means we try to do isolate_huge_page()
>>> for !PageHead page. But the caller queue_pages_hugetlb() gets the page
>>> with "page = pte_page(huge_ptep_get(pte))", so it should be the head page!
>>>
>>> mm/hugetlb.c:3580 is VM_BUG_ON_PAGE(!PageHead(page), page), so we expect to
>>> have dump_page output at this point, is that in your kernel log?
>>
>> This is usually a sign of a race between that code and thp splitting, see
>> https://lkml.org/lkml/2013/12/23/457 for example.
> 
> queue_pages_hugetlb() is for hugetlbfs, not for thp, so I don't think that
> it's related to thp splitting, but I agree it's a race.
> 
>> I forgot to add the dump_page output to my extraction process and the complete logs all long gone.
>> I'll grab it when it happens again.
> 
> Thank you. It'll be useful.

And here it is:

[  755.524966] page:ffffea0000000000 count:0 mapcount:1 mapping:          (null) index:0x0
[  755.526067] page flags: 0x0()

Followed by the same stack trace as before.


Thanks,
Sasha

