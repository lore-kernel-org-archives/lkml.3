Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab3JMVMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 17:12:48 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:43200 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab3JMVMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 17:12:47 -0400
MIME-Version: 1.0
Date: Mon, 14 Oct 2013 01:12:47 +0400
Message-ID: <CAMo8BfKqWPbDCMwCoH6BO6uXyYwr0Z1=AaMJDRLQt66FLb7LAg@mail.gmail.com>
Subject: CONFIG_SLUB/USE_SPLIT_PTLOCKS compatibility
From: Max Filippov <jcmvbkbc@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm reliably getting kernel crash on xtensa when CONFIG_SLUB
is selected and USE_SPLIT_PTLOCKS appears to be true (SMP=y,
NR_CPUS=4, DEBUG_SPINLOCK=n, DEBUG_LOCK_ALLOC=n).
This happens because spinlock_t ptl and struct page *first_page overlap
in the struct page. The following call chain makes allocation of order
3 and initializes first_page pointer in its 7 tail pages:

 do_page_fault
  handle_mm_fault
   __pte_alloc
    kmem_cache_alloc
     __slab_alloc
      new_slab
       __alloc_pages_nodemask
        get_page_from_freelist
         prep_compound_page

Later pte_offset_map_lock is called with one of these tail pages
overwriting its first_page pointer:

 do_fork
  copy_process
   dup_mm
    copy_page_range
     copy_pte_range
      pte_alloc_map_lock
       pte_offset_map_lock

Finally kmem_cache_free is called for that tail page, which calls
slab_free(s, virt_to_head_page(x),... but virt_to_head_page here
returns NULL, because the page's first_page pointer was overwritten
earlier:

exit_mmap
 free_pgtables
  free_pgd_range
   free_pud_range
    free_pmd_range
     free_pte_range
      pte_free
       kmem_cache_free
        slab_free
         __slab_free

__slab_free touches NULL struct page, that's it.

Changing allocator to SLAB or enabling DEBUG_SPINLOCK
fixes that crash.

My question is, is CONFIG_SLUB supposed to work with
USE_SPLIT_PTLOCKS (and if yes what's wrong in my case)?

-- 
Thanks.
-- Max
