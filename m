Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaCAXIg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 18:08:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23396 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbaCAXIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 18:08:35 -0500
Message-ID: <53126861.7040107@oracle.com>
Date: Sat, 01 Mar 2014 18:08:17 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, akpm@linux-foundation.org
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, riel@redhat.com
Subject: Re: [PATCH v3] mm, hugetlbfs: fix rmapping for anonymous hugepages
 with page_pgoff()
References: <1393475977-3381-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1393475977-3381-3-git-send-email-n-horiguchi@ah.jp.nec.com> <20140227131957.d81cf9a643f4d3fd6b8d8b16@linux-foundation.org> <530fb3ee.03cb0e0a.407a.ffffffbcSMTPIN_ADDED_BROKEN@mx.google.com> <5310ea8b.c425e00a.2cd9.ffffe097SMTPIN_ADDED_BROKEN@mx.google.com> <20140228151427.dd232b07960dcf876112e191@linux-foundation.org> <1393644926-49vw3qw9@n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1393644926-49vw3qw9@n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2014 10:35 PM, Naoya Horiguchi wrote:
> On Fri, Feb 28, 2014 at 03:14:27PM -0800, Andrew Morton wrote:
>> On Fri, 28 Feb 2014 14:59:02 -0500 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
>>
>>> page->index stores pagecache index when the page is mapped into file mapping
>>> region, and the index is in pagecache size unit, so it depends on the page
>>> size. Some of users of reverse mapping obviously assumes that page->index
>>> is in PAGE_CACHE_SHIFT unit, so they don't work for anonymous hugepage.
>>>
>>> For example, consider that we have 3-hugepage vma and try to mbind the 2nd
>>> hugepage to migrate to another node. Then the vma is split and migrate_page()
>>> is called for the 2nd hugepage (belonging to the middle vma.)
>>> In migrate operation, rmap_walk_anon() tries to find the relevant vma to
>>> which the target hugepage belongs, but here we miscalculate pgoff.
>>> So anon_vma_interval_tree_foreach() grabs invalid vma, which fires VM_BUG_ON.
>>>
>>> This patch introduces a new API that is usable both for normal page and
>>> hugepage to get PAGE_SIZE offset from page->index. Users should clearly
>>> distinguish page_index for pagecache index and page_pgoff for page offset.
>>>
>>> ..
>>>
>>> --- a/include/linux/pagemap.h
>>> +++ b/include/linux/pagemap.h
>>> @@ -307,6 +307,22 @@ static inline loff_t page_file_offset(struct page *page)
>>>   	return ((loff_t)page_file_index(page)) << PAGE_CACHE_SHIFT;
>>>   }
>>>   
>>> +static inline unsigned int page_size_order(struct page *page)
>>> +{
>>> +	return unlikely(PageHuge(page)) ?
>>> +		huge_page_size_order(page) :
> 
> I found that we have compound_order(page) for the same purpose, so we don't
> have to define this new function.
> 
>>> +		(PAGE_CACHE_SHIFT - PAGE_SHIFT);
>>> +}
>>
>> Could use some nice documentation, please.  Why it exists, what it
>> does.  Particularly: what sort of pages it can and can't operate on,
>> and why.
> 
> OK.
> 
>> The presence of PAGE_CACHE_SIZE is unfortunate - it at least implies
>> that the page is a pagecache page.  I dunno, maybe just use "0"?
> 
> Yes, PAGE_CACHE_SHIFT makes code messy if PAGE_CACHE_SHIFT is always PAGE_SHIFT.
> But I guess that recently people start to thinking of changing the size of
> pagecache (in the discussion around >4kB sector device.)
> And from readabilitie's perspective, "pagecache size" and "page size" are
> different things, so keeping it is better in a long run.
> 
> Anyway, I revised the patch again, could you take a look?
> 
> Thanks,
> Naoya
> ---
> From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Date: Fri, 28 Feb 2014 21:56:24 -0500
> Subject: [PATCH] mm, hugetlbfs: fix rmapping for anonymous hugepages with
>   page_pgoff()
> 
> page->index stores pagecache index when the page is mapped into file mapping
> region, and the index is in pagecache size unit, so it depends on the page
> size. Some of users of reverse mapping obviously assumes that page->index
> is in PAGE_CACHE_SHIFT unit, so they don't work for anonymous hugepage.
> 
> For example, consider that we have 3-hugepage vma and try to mbind the 2nd
> hugepage to migrate to another node. Then the vma is split and migrate_page()
> is called for the 2nd hugepage (belonging to the middle vma.)
> In migrate operation, rmap_walk_anon() tries to find the relevant vma to
> which the target hugepage belongs, but here we miscalculate pgoff.
> So anon_vma_interval_tree_foreach() grabs invalid vma, which fires VM_BUG_ON.
> 
> This patch introduces a new API that is usable both for normal page and
> hugepage to get PAGE_SIZE offset from page->index. Users should clearly
> distinguish page_index for pagecache index and page_pgoff for page offset.
> 
> ChangeLog v3:
> - add comment on page_size_order()
> - use compound_order(compound_head(page)) instead of huge_page_size_order()
> - use page_pgoff() in rmap_walk_file() too
> - use page_size_order() in kill_proc()
> - fix space indent
> 
> ChangeLog v2:
> - fix wrong shift direction
> - introduce page_size_order() and huge_page_size_order()
> - move the declaration of PageHuge() to include/linux/hugetlb_inline.h
>    to avoid macro definition.
> 
> Reported-by: Sasha Levin <sasha.levin@oracle.com> # if the reported problem is fixed
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: stable@vger.kernel.org # 3.12+

I can confirm that with this patch the lockdep issue is gone. However, the NULL deref in
walk_pte_range() and the BUG at mm/hugemem.c:3580 still appear.


Thanks,
Sasha
