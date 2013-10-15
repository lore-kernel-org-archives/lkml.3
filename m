Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594Ab3JOS6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 14:58:32 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:49374 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002Ab3JOS6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 14:58:30 -0400
MIME-Version: 1.0
In-Reply-To: <20131015102912.2BC99E0090@blue.fi.intel.com>
References: <20131015001214.GD3432@hippobay.mtv.corp.google.com> <20131015102912.2BC99E0090@blue.fi.intel.com>
From: Ning Qu <quning@google.com>
Date: Tue, 15 Oct 2013 11:58:09 -0700
Message-ID: <CACz4_2eh3F2An9F0GxSvw8kSmn2VZbqbdRVGXA2B=gvPFCChUw@mail.gmail.com>
Subject: Re: [PATCH 03/12] mm, thp, tmpfs: handle huge page cases in shmem_getpage_gfp
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


On Tue, Oct 15, 2013 at 3:29 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Ning Qu wrote:
>> We don't support huge page when page is moved from page cache to swap.
>> So in this function, we enable huge page handling in two case:
>>
>> 1) when a huge page is found in the page cache,
>> 2) or we need to alloc a huge page for page cache
>>
>> We have to refactor all the calls to shmem_getpages to simplify the job
>> of caller. Right now shmem_getpage does:
>>
>> 1) simply request a page, default as a small page
>> 2) or caller specify a flag to request either a huge page or a small page,
>> then leave the caller to decide how to use it
>>
>> Signed-off-by: Ning Qu <quning@gmail.com>
>> ---
>>  mm/shmem.c | 139 +++++++++++++++++++++++++++++++++++++++++++++++--------------
>>  1 file changed, 108 insertions(+), 31 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 447bd14..8fe17dd 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -115,15 +115,43 @@ static unsigned long shmem_default_max_inodes(void)
>>  static bool shmem_should_replace_page(struct page *page, gfp_t gfp);
>>  static int shmem_replace_page(struct page **pagep, gfp_t gfp,
>>                               struct shmem_inode_info *info, pgoff_t index);
>> +
>>  static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
>> -     struct page **pagep, enum sgp_type sgp, gfp_t gfp, int *fault_type);
>> +     struct page **pagep, enum sgp_type sgp, gfp_t gfp, int flags,
>> +     int *fault_type);
>> +
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE_PAGECACHE
>> +static inline int shmem_getpage(struct inode *inode, pgoff_t index,
>> +     struct page **pagep, enum sgp_type sgp, gfp_t gfp, int flags,
>> +     int *fault_type)
>> +{
>> +     int ret = 0;
>> +     struct page *page = NULL;
>>
>> +     if ((flags & AOP_FLAG_TRANSHUGE) &&
>> +         mapping_can_have_hugepages(inode->i_mapping)) {
>
> I don't think we need ifdef here. mapping_can_have_hugepages() will be 0
> compile-time, if CONFIG_TRANSPARENT_HUGEPAGE_PAGECACHE is not defined and
> compiler should optimize out thp case.

The same problem since HPAGE_CACHE_INDEX_MASK is build bug?

>
>> @@ -1298,27 +1348,37 @@ repeat:
>>                               error = -ENOSPC;
>>                               goto unacct;
>>                       }
>> -                     percpu_counter_inc(&sbinfo->used_blocks);
>>               }
>>
>> -             page = shmem_alloc_page(gfp, info, index);
>> +             if (must_use_thp) {
>> +                     page = shmem_alloc_hugepage(gfp, info, index);
>> +                     if (page) {
>> +                             count_vm_event(THP_WRITE_ALLOC);
>> +                             nr = hpagecache_nr_pages(page);
>
> nr = hpagecache_nr_pages(page) can be moved below if (must_use_thp).
> hpagecache_nr_pages(page) evaluates to 0 for small pages.
>
you mean something like this? If so, then fixed.

               if (must_use_thp) {
                        page = shmem_alloc_hugepage(gfp, info, index);
                        if (page) {
                                count_vm_event(THP_WRITE_ALLOC);
                        } else
                                count_vm_event(THP_WRITE_ALLOC_FAILED);
                } else {
                        page = shmem_alloc_page(gfp, info, index);
                }

                if (!page) {
                        error = -ENOMEM;
                        goto unacct;
                }
                nr = hpagecache_nr_pages(page);


>
> --
>  Kirill A. Shutemov
