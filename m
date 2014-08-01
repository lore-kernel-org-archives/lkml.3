Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaHAFH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 01:07:59 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35004 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbaHAFH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 01:07:57 -0400
Date: Thu, 31 Jul 2014 22:06:16 -0700 (PDT)
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
Subject: Re: [PATCH 5/5] mm, shmem: Show location of non-resident shmem pages
 in smaps
In-Reply-To: <1406036632-26552-6-git-send-email-jmarchan@redhat.com>
Message-ID: <alpine.LSU.2.11.1407312205170.3912@eggly.anvils>
References: <1406036632-26552-1-git-send-email-jmarchan@redhat.com> <1406036632-26552-6-git-send-email-jmarchan@redhat.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014, Jerome Marchand wrote:

> Adds ShmOther, ShmOrphan, ShmSwapCache and ShmSwap lines to
> /proc/<pid>/smaps for shmem mappings.
> 
> ShmOther: amount of memory that is currently resident in memory, not
> present in the page table of this process but present in the page
> table of an other process.
> ShmOrphan: amount of memory that is currently resident in memory but
> not present in any process page table. This can happens when a process
> unmaps a shared mapping it has accessed before or exits. Despite being
> resident, this memory is not currently accounted to any process.
> ShmSwapcache: amount of memory currently in swap cache
> ShmSwap: amount of memory that is paged out on disk.
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>

You will have to do a much better job of persuading me that these
numbers are of any interest.  Okay, maybe not me, I'm not that keen
on /proc/<pid>/smaps at the best of times.  But you will need to show
plausible cases where having these numbers available would have made
a real difference, and drum up support for their inclusion from
/proc/<pid>/smaps devotees.

Do you have a customer, who has underprovisioned with swap,
and wants these numbers to work out how much more is needed?

As it is, they appear to be numbers that you found you could provide,
and so you're adding them into /proc/<pid>/smaps, but having great
difficulty in finding good names to describe them - which is itself
an indicator that they're probably not the most useful statistics
a sysadmin is wanting.

(Google is a /proc/<pid>/smaps user: let's take a look to see if
we have been driven to add in stats of this kind: no, not at all.)

The more numbers we add to /proc/<pid>/smaps, the longer it will take to
print, the longer mmap_sem will be held, and the more it will interfere
with proper system operation - that's the concern I more often see.

> ---
>  Documentation/filesystems/proc.txt | 11 ++++++++
>  fs/proc/task_mmu.c                 | 56 +++++++++++++++++++++++++++++++++++++-
>  2 files changed, 66 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index 1a15c56..a65ab59 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -422,6 +422,10 @@ Swap:                  0 kB
>  KernelPageSize:        4 kB
>  MMUPageSize:           4 kB
>  Locked:              374 kB
> +ShmOther:            124 kB
> +ShmOrphan:             0 kB
> +ShmSwapCache:         12 kB
> +ShmSwap:              36 kB
>  VmFlags: rd ex mr mw me de
>  
>  the first of these lines shows the same information as is displayed for the
> @@ -437,6 +441,13 @@ a mapping associated with a file may contain anonymous pages: when MAP_PRIVATE
>  and a page is modified, the file page is replaced by a private anonymous copy.
>  "Swap" shows how much would-be-anonymous memory is also used, but out on
>  swap.
> +The ShmXXX lines only appears for shmem mapping. They show the amount of memory
> +from the mapping that is currently:
> + - resident in RAM, not present in the page table of this process but present
> + in the page table of an other process (ShmOther)

We don't show that for files of any other filesystem, why for shmem?
Perhaps you are too focussed on SysV SHM, and I am too focussed on tmpfs.

It is a very specialized statistic, and therefore hard to name: I don't
think ShmOther is a good name, but doubt any would do.  ShmOtherMapped?

> + - resident in RAM but not present in the page table of any process (ShmOrphan)

We don't show that for files of any other filesystem, why for shmem?

Orphan?  We do use the word "orphan" to describe pages which have been
truncated off a file, but somehow not yet removed from pagecache.  We
don't use the the word "orphan" to describe pagecache pages which are
not mapped into userspace - they are known as "pagecache pages which
are not mapped into userspace".  ShmNotMapped?

> + - in swap cache (ShmSwapCache)

Is this interesting?  It's a transitional state: either memory pressure
has forced the page to swapcache, but not yet freed it from memory; or
swapin_readahead has brought this page back in when bringing in a nearby
page of swap.

I can understand that we might want better stats on the behaviour of
swapin_readahead; better stats on shmem objects and swap; better stats
on duplication between pagecache and swap; but I'm not convinced that
/proc/<pid>/smaps is the right place for those.

Against all that, of course, we do have mincore() showing these pages
as incore, where /proc/<pid>/smaps does not.  But I think that is
justified by mincore()'s mission to show what's incore.

> + - paged out on swap (ShmSwap).

This one has the best case for inclusion: we do show Swap for the anon
pages which are out on swap, but not for the shmem areas, where swap
entry does not go into page table.  But there is good reason for that:
this is shared memory, files, objects commonly shared between
processes, so it's a poor fit then to account them by processes.

(We have "df" and "du" showing the occupancy of mounted tmpfs
filesystems: it would be nice if we had something like those,
which showed also the swap occupancy, and for the non-user-mounts.)

I need much more convincing on this patch: I expect you will drop
some of the numbers, and provide an argument for others.

Hugh
