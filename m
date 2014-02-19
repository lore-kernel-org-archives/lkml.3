Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaBSJ0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:26:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52825 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbaBSJ0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:26:36 -0500
Message-ID: <530478C7.9020104@suse.cz>
Date: Wed, 19 Feb 2014 10:26:31 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Daniel Borkmann <dborkman@redhat.com>, akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        John David Anglin <dave.anglin@bell.net>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Carsten Otte <cotte@de.ibm.com>, Jared Hulbert <jaredeh@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, stable@vger.kernel.org,
        "[3.11.x+]"@suse.de
Subject: Re: [PATCH akpm] mm: include VM_MIXEDMAP flag in the VM_SPECIAL list
 to avoid m(un)locking
References: <1392562785-15790-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1392562785-15790-1-git-send-email-dborkman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2014 03:59 PM, Daniel Borkmann wrote:
> From: Vlastimil Babka <vbabka@suse.cz>
>
> [ 4366.519657] ------------[ cut here ]------------
> [ 4366.519709] kernel BUG at mm/mlock.c:528!
> [ 4366.519742] invalid opcode: 0000 [#1] SMP
> [ 4366.519782] Modules linked in: ccm arc4 iwldvm [...]
> [ 4366.520488]  video
> [ 4366.520501] CPU: 3 PID: 2266 Comm: netsniff-ng Not tainted 3.14.0-rc2+ #8
> [ 4366.520551] Hardware name: LENOVO 2429BP3/2429BP3, BIOS G4ET37WW (1.12 ) 05/29/2012
> [ 4366.520608] task: ffff8801f87f9820 ti: ffff88002cb44000 task.ti: ffff88002cb44000
> [ 4366.520662] RIP: 0010:[<ffffffff81171ad0>]  [<ffffffff81171ad0>] munlock_vma_pages_range+0x2e0/0x2f0
> [ 4366.520738] RSP: 0018:ffff88002cb45e00  EFLAGS: 00010206
> [ 4366.520777] RAX: 00000000000001ff RBX: ffff8801f5e75d10 RCX: 000000000000107d
> [ 4366.520829] RDX: 00000007f133345f RSI: ffffea0007d76000 RDI: ffffea0007d76000
> [ 4366.520881] RBP: ffff88002cb45ed8 R08: 0000000000000000 R09: a8001f5d80000000
> [ 4366.520932] R10: 57ffcaa287d76000 R11: 0000000000000246 R12: ffffea0007d76000
> [ 4366.520983] R13: 00007f133745f000 R14: 00007f133345f000 R15: ffff8801f5e75a50
> [ 4366.521036] FS:  00007f133745f740(0000) GS:ffff88021e2c0000(0000) knlGS:0000000000000000
> [ 4366.521094] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 4366.521137] CR2: 000000000062ead0 CR3: 00000000c688d000 CR4: 00000000001407e0
> [ 4366.521188] Stack:
> [ 4366.521205]  ffffffff8116b085 00007f133745efff 00007f133327d000 00007f133745f000
> [ 4366.521269]  000001ff81172793 ffff8800c6baa6e0 0000000000000000 0000000000000000
> [ 4366.521333]  00007f1333336000 ffffea0004a7ab40 ffff88002cb45e58 0000000000000000
> [ 4366.521397] Call Trace:
> [ 4366.521422]  [<ffffffff8116b085>] ? tlb_finish_mmu+0x35/0x60
> [ 4366.521468]  [<ffffffff8117486f>] do_munmap+0x18f/0x3b0
> [ 4366.521511]  [<ffffffff8163e84b>] ? packet_getsockopt+0xfb/0x310
> [ 4366.521558]  [<ffffffff81174ad1>] vm_munmap+0x41/0x60
> [ 4366.521598]  [<ffffffff811759b2>] SyS_munmap+0x22/0x30
> [ 4366.521639]  [<ffffffff81666616>] system_call_fastpath+0x1a/0x1f
> [ 4366.521683] Code: ff ff e8 c4 07 fe ff 84 c0 48 8b 95 28 ff ff ff 0f 85 52 ff ff
>                       ff e9 3e ff ff ff 48 89 d7 e8 bf 32 4e 00 4c 89 e7 e8 aa 32 4e
>                       00 <0f> 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44
>                       00 00
> [ 4366.522004] RIP  [<ffffffff81171ad0>] munlock_vma_pages_range+0x2e0/0x2f0
> [ 4366.522059]  RSP <ffff88002cb45e00>
> [ 4366.539269] ---[ end trace a0088dcf07ae10f2 ]---
>
> Daniel Borkmann reported a bug (stack trace above) with VM_BUG_ON
> assertions failing where munlock_vma_pages_range() thinks it's
> unexpectedly in the middle of a THP page. This can be reproduced
> with default config since 3.11 kernels. A reproducer can be found
> in the kernel's selftest directory for networking by running
> ./psock_tpacket.
>
> The problem is that an order=2 compound page (allocated by
> alloc_one_pg_vec_page() is part of the munlocked VM_MIXEDMAP
> vma (mapped by packet_mmap()) and mistaken for a THP page and
> assumed to be order=9.
>
> The checks for THP in munlock came with commit ff6a6da60b89 ("mm:
> accelerate munlock() treatment of THP pages"), i.e. since 3.9,
> but did not trigger a bug. It just makes munlock_vma_pages_range()
> skip such compound pages until the next 512-pages-aligned page,
> when it encounters a head page. This is however not a problem
> for vma's where mlocking has no effect anyway, but it can distort
> the accounting.
>
> Since commit 7225522bb ("mm: munlock: batch non-THP page isolation
> and munlock+putback using pagevec") this can trigger a VM_BUG_ON
> in PageTransHuge() check.
>
> This patch fixes the issue by adding VM_MIXEDMAP flag to VM_SPECIAL,
> a list of flags that make vma's non-mlockable and non-mergeable.
> The reasoning is that VM_MIXEDMAP vma's are similar to VM_PFNMAP,
> which is already on the VM_SPECIAL list, and both are intended
> for non-LRU pages where mlocking makes no sense anyway. Related
> Lkml discussion can be found in [2].
>
>   [1] tools/testing/selftests/net/psock_tpacket
>   [2] https://lkml.org/lkml/2014/1/10/427
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reported-by: Daniel Borkmann <dborkman@redhat.com>
> Tested-by: Daniel Borkmann <dborkman@redhat.com>
> Cc: Thomas Hellstrom <thellstrom@vmware.com>
> Cc: John David Anglin <dave.anglin@bell.net>
> Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: Carsten Otte <cotte@de.ibm.com>
> Cc: Jared Hulbert <jaredeh@gmail.com>
> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: <stable@vger.kernel.org> [3.11.x+]
> ---
>   Took the liberty to resubmit it, as people hit that on distribution
>   kernels; tested and it looks to fix the issue.

Thanks for resubmitting and improving the changelog. I've been away last 
week.

Vlastimil

>   include/linux/mm.h | 2 +-
>   mm/huge_memory.c   | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index f28f46e..f9b04ac 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -175,7 +175,7 @@ extern unsigned int kobjsize(const void *objp);
>    * Special vmas that are non-mergable, non-mlock()able.
>    * Note: mm/huge_memory.c VM_NO_THP depends on this definition.
>    */
> -#define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP)
> +#define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
>
>   /*
>    * mapping from the currently active vm_flags protection bits (the
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 82166bf..1387969 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1963,7 +1963,7 @@ out:
>   	return ret;
>   }
>
> -#define VM_NO_THP (VM_SPECIAL|VM_MIXEDMAP|VM_HUGETLB|VM_SHARED|VM_MAYSHARE)
> +#define VM_NO_THP (VM_SPECIAL | VM_HUGETLB | VM_SHARED | VM_MAYSHARE)
>
>   int hugepage_madvise(struct vm_area_struct *vma,
>   		     unsigned long *vm_flags, int advice)
>

