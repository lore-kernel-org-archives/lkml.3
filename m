Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaG3Kbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 06:31:32 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:38350 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaG3Kbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 06:31:31 -0400
Message-ID: <1406716282.9336.16.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [RFC PATCH] mm: Add helpers for locked_vm
From: Davidlohr Bueso <davidlohr@hp.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Graf <agraf@suse.de>,
        Michael Ellerman <michael@ellerman.id.au>
Date: Wed, 30 Jul 2014 03:31:22 -0700
In-Reply-To: <1406712493-9284-1-git-send-email-aik@ozlabs.ru>
References: <1406712493-9284-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-30 at 19:28 +1000, Alexey Kardashevskiy wrote:
> This adds 2 helpers to change the locked_vm counter:
> - try_increase_locked_vm - may fail if new locked_vm value will be greater
> than the RLIMIT_MEMLOCK limit;
> - decrease_locked_vm.
> 
> These will be used by drivers capable of locking memory by userspace
> request. For example, VFIO can use it to check if it can lock DMA memory
> or PPC-KVM can use it to check if it can lock memory for TCE tables.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
>  include/linux/mm.h |  3 +++
>  mm/mlock.c         | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 52 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index e03dd29..1cb219d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2113,5 +2113,8 @@ void __init setup_nr_node_ids(void);
>  static inline void setup_nr_node_ids(void) {}
>  #endif
>  
> +extern long try_increment_locked_vm(long npages);
> +extern void decrement_locked_vm(long npages);
> +
>  #endif /* __KERNEL__ */
>  #endif /* _LINUX_MM_H */
> diff --git a/mm/mlock.c b/mm/mlock.c
> index b1eb536..39e4b55 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -864,3 +864,52 @@ void user_shm_unlock(size_t size, struct user_struct *user)
>  	spin_unlock(&shmlock_user_lock);
>  	free_uid(user);
>  }
> +
> +/**
> + * try_increment_locked_vm() - checks if new locked_vm value is going to
> + * be less than RLIMIT_MEMLOCK and increments it by npages if it is.
> + *
> + * @npages: the number of pages to add to locked_vm.
> + *
> + * Returns 0 if succeeded or negative value if failed.
> + */
> +long try_increment_locked_vm(long npages)

mlock calls work at an address granularity...

> +{
> +	long ret = 0, locked, lock_limit;
> +
> +	if (!current || !current->mm)
> +		return -ESRCH; /* process exited */

It doesn't strike me that this is the place for this. It would seem that
it would be the caller's responsibility to make sure of this (and not
sure how !current can happen...).

> +
> +	down_write(&current->mm->mmap_sem);
> +	locked = current->mm->locked_vm + npages;
> +	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;

nit: please set locked and lock_limit before taking the mmap_sem.

> +	if (locked > lock_limit && !capable(CAP_IPC_LOCK)) {
> +		pr_warn("RLIMIT_MEMLOCK (%ld) exceeded\n",
> +				rlimit(RLIMIT_MEMLOCK));
> +		ret = -ENOMEM;
> +	} else {

It would be nicer to have it the other way around, leave the #else for
ENOMEM. It reads better, imho.

> +		current->mm->locked_vm += npages;

More importantly just setting locked_vm is not enough. You'll need to
call do_mlock() here (again, addr granularity ;). This also applies to
your decrement_locked_vm().

Thanks,
Davidlohr

