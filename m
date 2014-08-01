Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbaHAFDD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 01:03:03 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:56197 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHAFDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 01:03:01 -0400
Date: Thu, 31 Jul 2014 22:01:14 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Jerome Marchand <jmarchan@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-doc@vger.kernel.org,
        Hugh Dickins <hughd@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux390@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 1/5] mm, shmem: Add shmem resident memory accounting
In-Reply-To: <1406036632-26552-2-git-send-email-jmarchan@redhat.com>
Message-ID: <alpine.LSU.2.11.1407312159180.3912@eggly.anvils>
References: <1406036632-26552-1-git-send-email-jmarchan@redhat.com> <1406036632-26552-2-git-send-email-jmarchan@redhat.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014, Jerome Marchand wrote:

> Currently looking at /proc/<pid>/status or statm, there is no way to
> distinguish shmem pages from pages mapped to a regular file (shmem
> pages are mapped to /dev/zero), even though their implication in
> actual memory use is quite different.
> This patch adds MM_SHMEMPAGES counter to mm_rss_stat. It keeps track of
> resident shmem memory size. Its value is exposed in the new VmShm line
> of /proc/<pid>/status.

I like adding this info to /proc/<pid>/status - thank you -
but I think you can make the patch much better in a couple of ways.

> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  Documentation/filesystems/proc.txt |  2 ++
>  arch/s390/mm/pgtable.c             |  2 +-
>  fs/proc/task_mmu.c                 |  9 ++++++---
>  include/linux/mm.h                 |  7 +++++++
>  include/linux/mm_types.h           |  7 ++++---
>  kernel/events/uprobes.c            |  2 +-
>  mm/filemap_xip.c                   |  2 +-
>  mm/memory.c                        | 37 +++++++++++++++++++++++++++++++------
>  mm/rmap.c                          |  8 ++++----
>  9 files changed, 57 insertions(+), 19 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index ddc531a..1c49957 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -171,6 +171,7 @@ read the file /proc/PID/status:
>    VmLib:      1412 kB
>    VmPTE:        20 kb
>    VmSwap:        0 kB
> +  VmShm:         0 kB
>    Threads:        1
>    SigQ:   0/28578
>    SigPnd: 0000000000000000
> @@ -228,6 +229,7 @@ Table 1-2: Contents of the status files (as of 2.6.30-rc7)
>   VmLib                       size of shared library code
>   VmPTE                       size of page table entries
>   VmSwap                      size of swap usage (the number of referred swapents)
> + VmShm	                      size of resident shmem memory

Needs to say that includes mappings of tmpfs, and needs to say that
it's a subset of VmRSS.  Better placed immediately after VmRSS...

...but now that I look through what's in /proc/<pid>/status, it appears
that we have to defer to /proc/<pid>/statm to see MM_FILEPAGES (third
field) and MM_ANONPAGES (subtract third field from second field).

That's not a very friendly interface.  If you're going to help by
exposing MM_SHMPAGES separately, please help even more by exposing
VmFile and VmAnon here in /proc/<pid>/status too.

VmRSS, VmAnon, VmShm, VmFile?  I'm not sure what's the best order:
here I'm thinking that anon comes before file in /proc/meminfo, and
shm should be halfway between anon and file.  You may have another idea.

And of course the VmFile count here should exclude VmShm: I think it
will work out least confusingly if you account MM_FILEPAGES separately
from MM_SHMPAGES, but add them together where needed e.g. for statm.

>   Threads                     number of threads
>   SigQ                        number of signals queued/max. number for queue
>   SigPnd                      bitmap of pending signals for the thread
> diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
> index 37b8241..9fe31b0 100644
> --- a/arch/s390/mm/pgtable.c
> +++ b/arch/s390/mm/pgtable.c
> @@ -612,7 +612,7 @@ static void gmap_zap_swap_entry(swp_entry_t entry, struct mm_struct *mm)
>  		if (PageAnon(page))
>  			dec_mm_counter(mm, MM_ANONPAGES);
>  		else
> -			dec_mm_counter(mm, MM_FILEPAGES);
> +			dec_mm_file_counters(mm, page);
>  	}

That is a recurring pattern: please try putting

static inline int mm_counter(struct page *page)
{
	if (PageAnon(page))
		return MM_ANONPAGES;
	if (PageSwapBacked(page))
		return MM_SHMPAGES;
	return MM_FILEPAGES;
}

in include/linux/mm.h.

Then dec_mm_counter(mm, mm_counter(page)) here, and wherever you can,
use mm_counter(page) to simplify the code throughout.

I say "try" because I think factoring out mm_counter() will simplify
the most code, given the profusion of different accessors, particularly
in mm/memory.c.  But I'm not sure how much bloat having it as an inline
function will add, versus how much overhead it would add if not inline.

Hugh
