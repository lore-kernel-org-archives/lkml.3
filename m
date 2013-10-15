Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994Ab3JOR1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:27:38 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:42105 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759533Ab3JOR1g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:27:36 -0400
MIME-Version: 1.0
In-Reply-To: <20131015100213.A0189E0090@blue.fi.intel.com>
References: <20131015001201.GC3432@hippobay.mtv.corp.google.com> <20131015100213.A0189E0090@blue.fi.intel.com>
From: Ning Qu <quning@google.com>
Date: Tue, 15 Oct 2013 10:27:14 -0700
Message-ID: <CACz4_2er-_Xa8oRo_JJTC+HZtDTAcjJ+cNTjrXLhN0Dm7BtXFQ@mail.gmail.com>
Subject: Re: [PATCH 02/12] mm, thp, tmpfs: support to add huge page into page
 cache for tmpfs
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

Yes, I can try. The code is pretty much similar with some minor difference.

One thing I can do is to move the spin lock part (together with the
corresponding err handling into a common function.

The only problem I can see right now is we need the following
additional line for shm:

__mod_zone_page_state(page_zone(page), NR_SHMEM, nr);

Which means we need to tell if it's coming from shm or not, is that OK
to add additional parameter just for that? Or is there any other
better way we can infer that information? Thanks!
Best wishes,
-- 
Ning Qu (曲宁) | Software Engineer | quning@google.com | +1-408-418-6066


On Tue, Oct 15, 2013 at 3:02 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Ning Qu wrote:
>> For replacing a page inside page cache, we assume the huge page
>> has been splitted before getting here.
>>
>> For adding a new page to page cache, huge page support has been added.
>>
>> Also refactor the shm_add_to_page_cache function.
>>
>> Signed-off-by: Ning Qu <quning@gmail.com>
>> ---
>>  mm/shmem.c | 97 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
>>  1 file changed, 88 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index a857ba8..447bd14 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -277,27 +277,23 @@ static bool shmem_confirm_swap(struct address_space *mapping,
>>  }
>>
>>  /*
>> - * Like add_to_page_cache_locked, but error if expected item has gone.
>> + * Replace the swap entry with page cache entry
>>   */
>> -static int shmem_add_to_page_cache(struct page *page,
>> +static int shmem_replace_page_page_cache(struct page *page,
>>                                  struct address_space *mapping,
>>                                  pgoff_t index, gfp_t gfp, void *expected)
>>  {
>>       int error;
>>
>> -     VM_BUG_ON(!PageLocked(page));
>> -     VM_BUG_ON(!PageSwapBacked(page));
>> +     BUG_ON(PageTransHugeCache(page));
>>
>>       page_cache_get(page);
>>       page->mapping = mapping;
>>       page->index = index;
>>
>>       spin_lock_irq(&mapping->tree_lock);
>> -     if (!expected)
>> -             error = radix_tree_insert(&mapping->page_tree, index, page);
>> -     else
>> -             error = shmem_radix_tree_replace(mapping, index, expected,
>> -                                                              page);
>> +
>> +     error = shmem_radix_tree_replace(mapping, index, expected, page);
>>       if (!error) {
>>               mapping->nrpages++;
>>               __inc_zone_page_state(page, NR_FILE_PAGES);
>> @@ -312,6 +308,87 @@ static int shmem_add_to_page_cache(struct page *page,
>>  }
>>
>>  /*
>> + * Insert new page into with page cache
>> + */
>> +static int shmem_insert_page_page_cache(struct page *page,
>> +                                struct address_space *mapping,
>> +                                pgoff_t index, gfp_t gfp)
>> +{
>
> You copy-paste most of add_to_page_cache_locked() code here. Is there a
> way to share the code? Move common part into __add_to_page_cache_locked()
> or something.
>
> --
>  Kirill A. Shutemov
