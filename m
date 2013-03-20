Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563Ab3CTBJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 21:09:59 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:34973 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226Ab3CTBJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 21:09:56 -0400
Message-ID: <51490C5C.6070000@gmail.com>
Date: Wed, 20 Mar 2013 09:09:48 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2, RFC 00/30] Transparent huge page cache
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,
On 03/15/2013 01:50 AM, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> Here's the second version of the patchset.
>
> The intend of the work is get code ready to enable transparent huge page
> cache for the most simple fs -- ramfs.
>
> We have read()/write()/mmap() functionality now. Still plenty work ahead.

It's a great work. But could you give more explanation how you design to 
implement thp support page cache in order that more developers are easy 
and happy to review your big patchset?

>
> Any feedback is welcome.
>
> Changes since v1:
>   - mmap();
>   - fix add_to_page_cache_locked() and delete_from_page_cache();
>   - introduce mapping_can_have_hugepages();
>   - call split_huge_page() only for head page in filemap_fault();
>   - wait_split_huge_page(): serialize over i_mmap_mutex too;
>   - lru_add_page_tail: avoid PageUnevictable on active/inactive lru lists;
>   - fix off-by-one in zero_huge_user_segment();
>   - THP_WRITE_ALLOC/THP_WRITE_FAILED counters;
>
> TODO:
>   - memcg accounting has not yet evaluated;
>   - collapse;
>   - migration (?);
>   - stats, knobs, etc.;
>   - tmpfs/shmem enabling;
>
>
> Kirill A. Shutemov (30):
>    block: implement add_bdi_stat()
>    mm: implement zero_huge_user_segment and friends
>    mm: drop actor argument of do_generic_file_read()
>    radix-tree: implement preload for multiple contiguous elements
>    thp, mm: avoid PageUnevictable on active/inactive lru lists
>    thp, mm: basic defines for transparent huge page cache
>    thp, mm: introduce mapping_can_have_hugepages() predicate
>    thp, mm: rewrite add_to_page_cache_locked() to support huge pages
>    thp, mm: rewrite delete_from_page_cache() to support huge pages
>    thp, mm: locking tail page is a bug
>    thp, mm: handle tail pages in page_cache_get_speculative()
>    thp, mm: add event counters for huge page alloc on write to a file
>    thp, mm: implement grab_cache_huge_page_write_begin()
>    thp, mm: naive support of thp in generic read/write routines
>    thp, libfs: initial support of thp in
>      simple_read/write_begin/write_end
>    thp: handle file pages in split_huge_page()
>    thp: wait_split_huge_page(): serialize over i_mmap_mutex too
>    thp, mm: truncate support for transparent huge page cache
>    thp, mm: split huge page on mmap file page
>    ramfs: enable transparent huge page cache
>    x86-64, mm: proper alignment mappings with hugepages
>    mm: add huge_fault() callback to vm_operations_struct
>    thp: prepare zap_huge_pmd() to uncharge file pages
>    thp: move maybe_pmd_mkwrite() out of mk_huge_pmd()
>    thp, mm: basic huge_fault implementation for generic_file_vm_ops
>    thp: extract fallback path from do_huge_pmd_anonymous_page() to a
>      function
>    thp: initial implementation of do_huge_linear_fault()
>    thp: handle write-protect exception to file-backed huge pages
>    thp: call __vma_adjust_trans_huge() for file-backed VMA
>    thp: map file-backed huge pages on fault
>
>   arch/x86/kernel/sys_x86_64.c  |   13 +-
>   fs/libfs.c                    |   50 ++++-
>   fs/ramfs/inode.c              |    6 +-
>   include/linux/backing-dev.h   |   10 +
>   include/linux/huge_mm.h       |   36 +++-
>   include/linux/mm.h            |   16 ++
>   include/linux/pagemap.h       |   24 ++-
>   include/linux/radix-tree.h    |    3 +
>   include/linux/vm_event_item.h |    2 +
>   lib/radix-tree.c              |   32 ++-
>   mm/filemap.c                  |  283 +++++++++++++++++++++----
>   mm/huge_memory.c              |  462 ++++++++++++++++++++++++++++++++++-------
>   mm/memory.c                   |   31 ++-
>   mm/swap.c                     |    3 +-
>   mm/truncate.c                 |   12 ++
>   mm/vmstat.c                   |    2 +
>   16 files changed, 842 insertions(+), 143 deletions(-)
>

