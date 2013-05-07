Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab3EGKHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 06:07:44 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:52341 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab3EGKHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 06:07:42 -0400
Date: Tue, 7 May 2013 19:07:40 +0900
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: qemu-devel@nongnu.org, linux-kernel@vger.kernel.org,
        Juan Quintela <quintela@redhat.com>,
        Orit Wasserman <owasserm@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 0/4] madvise(MADV_USERFAULT) & sys_remap_anon_pages()
Message-ID: <20130507100740.GC16873@valinux.co.jp>
References: <1367870221-12676-1-git-send-email-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367870221-12676-1-git-send-email-aarcange@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 09:56:57PM +0200, Andrea Arcangeli wrote:
> Hello everyone,
> 
> this is a patchset to implement two new kernel features:
> MADV_USERFAULT and remap_anon_pages.
> 
> The combination of the two features are what I would propose to
> implement postcopy live migration, and in general demand paging of
> remote memory, hosted in different cloud nodes with KSM. It might also
> be used without virt to offload parts of memory to different nodes
> using some userland library and a network memory manager.

Interesting. The API you are proposing handles only user fault.
How do you think about kernel case. I mean that KVM kernel module issues
get_user_pages().
Exit to qemu with dedicated reason?


> Postcopy live migration is currently implemented using a chardevice,
> which remains open for the whole VM lifetime and all virtual memory
> then becomes owned by the chardevice and it's not anonymous anymore.
> 
> http://lists.gnu.org/archive/html/qemu-devel/2012-10/msg05274.html
> 
> The main cons of the chardevice design is that all nice Linux MM
> features (like swapping/THP/KSM/automatic-NUMA-balancing) are disabled
> if the guest physical memory doesn't remain in anonymous memory. This
> is entirely solved by this alternative kernel solution. In fact
> remap_anon_pages will move THP pages natively by just updating two pmd
> pointers if alignment and length permits without any THP split.
> 
> The other bonus is that MADV_USERFAULT and remap_anon_pages are
> implemented in the MM core and remap_anon_pages furthermore provides a
> functionality similar to what is already available for filebacked
> pages with remap_file_pages. That is usually more maintainable than
> having MM parts in a chardevice.
> 
> In addition to asking review of the internals, this also need review
> the user APIs, as both those features are userland visible changes.
> 
> MADV_USERFAULT is only enabled for anonymous mappings so far but it
> could be extended. To be strict, -EINVAL is returned if run on non
> anonymous mappings (where it would currently be a noop).
> 
> The remap_anon_pages syscall API is not vectored, as I expect it used
> for demand paging only (where there can be just one faulting range per
> fault) or for large ranges where vectoring isn't going to provide
> performance advantages.

In case of precopy + postcopy optimization, dirty bitmap is sent after 
precopy phase and then clean pages are populated. In this population phase,
vecotored API can be utilized. I'm not sure how much vectored API will
contribute to shorten VM-switch time, though.


> The current behavior of remap_anon_pages is very strict to avoid any
> chance of memory corruption going unnoticed, and it will return
> -EFAULT at the first sign of something unexpected (like a page already
> mapped in the destination pmd/pte, potentially signaling an userland
> thread race condition with two threads userfaulting on the same
> destination address). mremap is not strict like that: it would drop
> the destination range silently and it would succeed in such a
> condition. So on the API side, I wonder if I should add a flag to
> remap_anon_pages to provide non-strict behavior more similar to
> mremap. OTOH not providing the permissive mremap behavior may actually
> be better to force userland to be strict and be sure it knows what it
> is doing (otherwise it should use mremap in the first place?).

It would be desirable to avoid complex thing in signal handler.
Like sending page request to remote, receiving pages from remote.
So signal handler would just queue requests to those dedicated threads
and wait and requests would be serialized. Such strictness is not 
very critical, I guess. But others might find other use case...

thanks,

> Comments welcome, thanks!
> Andrea
> 
> Andrea Arcangeli (4):
>   mm: madvise MADV_USERFAULT
>   mm: rmap preparation for remap_anon_pages
>   mm: swp_entry_swapcount
>   mm: sys_remap_anon_pages
> 
>  arch/alpha/include/uapi/asm/mman.h     |   3 +
>  arch/mips/include/uapi/asm/mman.h      |   3 +
>  arch/parisc/include/uapi/asm/mman.h    |   3 +
>  arch/x86/syscalls/syscall_32.tbl       |   1 +
>  arch/x86/syscalls/syscall_64.tbl       |   1 +
>  arch/xtensa/include/uapi/asm/mman.h    |   3 +
>  include/linux/huge_mm.h                |   6 +
>  include/linux/mm.h                     |   1 +
>  include/linux/mm_types.h               |   2 +-
>  include/linux/swap.h                   |   6 +
>  include/linux/syscalls.h               |   3 +
>  include/uapi/asm-generic/mman-common.h |   3 +
>  kernel/sys_ni.c                        |   1 +
>  mm/fremap.c                            | 440 +++++++++++++++++++++++++++++++++
>  mm/huge_memory.c                       | 158 ++++++++++--
>  mm/madvise.c                           |  16 ++
>  mm/memory.c                            |  10 +
>  mm/rmap.c                              |   9 +
>  mm/swapfile.c                          |  13 +
>  19 files changed, 667 insertions(+), 15 deletions(-)
> 

-- 
yamahata
