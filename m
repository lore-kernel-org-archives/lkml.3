Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581Ab3JOStl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 14:49:41 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:50002 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933521Ab3JOSti convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 14:49:38 -0400
MIME-Version: 1.0
In-Reply-To: <20131015103744.A0BD3E0090@blue.fi.intel.com>
References: <20131015001242.GF3432@hippobay.mtv.corp.google.com> <20131015103744.A0BD3E0090@blue.fi.intel.com>
From: Ning Qu <quning@google.com>
Date: Tue, 15 Oct 2013 11:49:17 -0700
Message-ID: <CACz4_2c6+EgTLrybF=bFsK_ra-nNgb46PFuXZA4CT1AfKFf=ug@mail.gmail.com>
Subject: Re: [PATCH 05/12] mm, thp, tmpfs: request huge page in shm_fault when needed
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

Will fix this.
Best wishes,
-- 
Ning Qu (曲宁) | Software Engineer | quning@google.com | +1-408-418-6066


On Tue, Oct 15, 2013 at 3:37 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Ning Qu wrote:
>> Add the function to request huge page in shm_fault when needed.
>> And it will fall back to regular page if huge page can't be
>> satisfied or allocated.
>>
>> If small page requested but huge page is found, the huge page will
>> be splitted.
>>
>> Signed-off-by: Ning Qu <quning@gmail.com>
>> ---
>>  mm/shmem.c | 32 +++++++++++++++++++++++++++++---
>>  1 file changed, 29 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 68a0e1d..2fc450d 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1472,19 +1472,45 @@ unlock:
>>  static int shmem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>>  {
>>       struct inode *inode = file_inode(vma->vm_file);
>> +     struct page *page = NULL;
>>       int error;
>>       int ret = VM_FAULT_LOCKED;
>>       gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
>> -
>> -     error = shmem_getpage(inode, vmf->pgoff, &vmf->page, SGP_CACHE, gfp,
>> -                             0, &ret);
>> +     bool must_use_thp = vmf->flags & FAULT_FLAG_TRANSHUGE;
>> +     int flags = 0;
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE_PAGECACHE
>> +     flags |= AOP_FLAG_TRANSHUGE;
>> +#endif
>
> ifdef is not needed: shmem_getpage will ignore AOP_FLAG_TRANSHUGE if
> CONFIG_TRANSPARENT_HUGEPAGE_PAGECACHE is not defined.
>
> --
>  Kirill A. Shutemov
