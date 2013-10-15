Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373Ab3JOStD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 14:49:03 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:56379 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758936Ab3JOStB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 14:49:01 -0400
MIME-Version: 1.0
In-Reply-To: <20131015110146.7E8BEE0090@blue.fi.intel.com>
References: <20131015001304.GH3432@hippobay.mtv.corp.google.com> <20131015110146.7E8BEE0090@blue.fi.intel.com>
From: Ning Qu <quning@google.com>
Date: Tue, 15 Oct 2013 11:48:40 -0700
Message-ID: <CACz4_2fiF+vaAbFixgGF+Uxn0av4H8y-aMQdyi3yYs5pdS2WBA@mail.gmail.com>
Subject: Re: [PATCH 07/12] mm, thp, tmpfs: handle huge page in
 shmem_undo_range for truncate
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Best wishes,
-- 
Ning Qu (曲宁) | Software Engineer | quning@google.com | +1-408-418-6066


On Tue, Oct 15, 2013 at 4:01 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Ning Qu wrote:
>> When comes to truncate file, add support to handle huge page in the
>> truncate range.
>>
>> Signed-off-by: Ning Qu <quning@gmail.com>
>> ---
>>  mm/shmem.c | 97 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
>>  1 file changed, 86 insertions(+), 11 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 0a423a9..90f2e0e 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -559,6 +559,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
>>       struct shmem_inode_info *info = SHMEM_I(inode);
>>       pgoff_t start = (lstart + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
>>       pgoff_t end = (lend + 1) >> PAGE_CACHE_SHIFT;
>> +     /* Whether we have to do partial truncate */
>>       unsigned int partial_start = lstart & (PAGE_CACHE_SIZE - 1);
>>       unsigned int partial_end = (lend + 1) & (PAGE_CACHE_SIZE - 1);
>>       struct pagevec pvec;
>> @@ -570,12 +571,16 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
>>       if (lend == -1)
>>               end = -1;       /* unsigned, so actually very big */
>>
>> +     i_split_down_read(inode);
>>       pagevec_init(&pvec, 0);
>>       index = start;
>>       while (index < end) {
>> +             bool thp = false;
>> +
>>               pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
>>                               min(end - index, (pgoff_t)PAGEVEC_SIZE),
>>                                                       pvec.pages, indices);
>> +
>>               if (!pvec.nr)
>>                       break;
>>               mem_cgroup_uncharge_start();
>> @@ -586,6 +591,25 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
>>                       if (index >= end)
>>                               break;
>>
>> +                     thp = PageTransHugeCache(page);
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE_PAGECACHE
>
> Again. Here and below ifdef is redundant: PageTransHugeCache() is zero
> compile-time and  thp case will be optimize out.

The problem is actually from HPAGE_CACHE_INDEX_MASK, it is marked as
build bug when CONFIG_TRANSPARENT_HUGEPAGE_PAGECACHE is false. So we
either wrap some logic inside a inline function, or we have to be like
this .. Or we don't treat the HPAGE_CACHE_INDEX_MASK as a build bug?

>
> And do we really need a copy of truncate logic here? Is there a way to
> share code?
>
The truncate between tmpfs and general one is similar but not exactly
the same (no readahead), so share the whole function might not be a
good choice from the perspective of tmpfs? Anyway, there are other
similar functions in tmpfs, e.g. the one you mentioned for
shmem_add_to_page_cache. It is possible to share the code, I am just
worried it will make the logic more complicated?

Maybe Hugh is in better position to judge on this? Thanks!

> --
>  Kirill A. Shutemov
