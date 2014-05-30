Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbaE3CUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 22:20:24 -0400
Received: from g5t1625.atlanta.hp.com ([15.192.137.8]:27379 "EHLO
	g5t1625.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaE3CUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 22:20:23 -0400
Message-ID: <1401416415.2618.14.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/5] mm: i_mmap_mutex to rwsem
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org
Cc: mingo@kernel.org, peterz@infradead.org, riel@redhat.com, mgorman@suse.de,
        aswin@hp.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 29 May 2014 19:20:15 -0700
In-Reply-To: <1400816006-3083-1-git-send-email-davidlohr@hp.com>
References: <1400816006-3083-1-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping? Andrew any chance of getting this in -next?

On Thu, 2014-05-22 at 20:33 -0700, Davidlohr Bueso wrote:
> This patchset extends the work started by Ingo Molnar in late 2012,
> optimizing the anon-vma mutex lock, converting it from a exclusive mutex
> to a rwsem, and sharing the lock for read-only paths when walking the
> the vma-interval tree. More specifically commits 5a505085 and 4fc3f1d6.
> 
> The i_mmap_mutex has similar responsibilities with the anon-vma, protecting
> file backed pages. Therefore we can use similar locking techniques: covert
> the mutex to a rwsem and share the lock when possible.
> 
> With the new optimistic spinning property we have in rwsems, we no longer
> take a hit in performance when using this lock, and we can therefore
> safely do the conversion. Tests show no throughput regressions in aim7 or
> pgbench runs, and we can see gains from sharing the lock, in disk workloads
> ~+15% for over 1000 users on a 8-socket Westmere system.
> 
> This patchset applies on linux-next-20140522.
> 
> Thanks!
> 
> Davidlohr Bueso (5):
>   mm,fs: introduce helpers around i_mmap_mutex
>   mm: use new helper functions around the i_mmap_mutex
>   mm: convert i_mmap_mutex to rwsem
>   mm/rmap: share the i_mmap_rwsem
>   mm: rename leftover i_mmap_mutex
> 
>  fs/hugetlbfs/inode.c         | 14 +++++++-------
>  fs/inode.c                   |  2 +-
>  include/linux/fs.h           | 23 ++++++++++++++++++++++-
>  include/linux/mmu_notifier.h |  2 +-
>  kernel/events/uprobes.c      |  6 +++---
>  kernel/fork.c                |  4 ++--
>  mm/filemap.c                 | 10 +++++-----
>  mm/filemap_xip.c             |  4 ++--
>  mm/hugetlb.c                 | 22 +++++++++++-----------
>  mm/memory-failure.c          |  4 ++--
>  mm/memory.c                  |  8 ++++----
>  mm/mmap.c                    | 22 +++++++++++-----------
>  mm/mremap.c                  |  6 +++---
>  mm/nommu.c                   | 14 +++++++-------
>  mm/rmap.c                    | 10 +++++-----
>  15 files changed, 86 insertions(+), 65 deletions(-)
> 


