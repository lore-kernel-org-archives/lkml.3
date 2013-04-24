Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab3DXXF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 19:05:26 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40795 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab3DXXFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 19:05:22 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1366841773.1790.7.camel@buesod1.americas.hpqcorp.net>
References: <CA+icZUWXpaXi9GwB37hLaPbZaAi2aOMXez1f79DDtb_22ZY1jQ@mail.gmail.com>
	<CA+icZUXmsvbj2km=PxbAs5K+hoP+zjcXqG_wCdKR9akWF5Eucw@mail.gmail.com>
	<CA+55aFw5J+DFgQjAdhUnhitHw+wHEmspeZP9jbyZowqNE6Nafg@mail.gmail.com>
	<CA+icZUXHkcj_bAuPcfghZMHjRTud2jN91hjpOUiLaXd0yN9diw@mail.gmail.com>
	<1366741069.1802.12.camel@buesod1.americas.hpqcorp.net>
	<1366741394.1802.13.camel@buesod1.americas.hpqcorp.net>
	<CA+icZUV48SZeNt4GRKi8yDKbsO_c7ApUOgb4mRX67=d_ridE8w@mail.gmail.com>
	<CA+55aFxh_-3BSBXrm8j1-3bN_oLLA66ApykRcfFFKRvrb6MDkQ@mail.gmail.com>
	<1366841773.1790.7.camel@buesod1.americas.hpqcorp.net>
Date: Thu, 25 Apr 2013 01:05:20 +0200
Message-ID: <CA+icZUUY1U=gxxT8hbU-JyyuoRgaht=KUwttQT=yh4_Yh32VnQ@mail.gmail.com>
Subject: Re: [PATCH -next] ipc: make refcounter atomic (was Re: linux-next:
 Tree for Apr 23 [ Call-Traces: lib/debugobjects.c | kernel/rcupdate.c |
 kernel/rcutree.c ])
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Paul McKenney <paul.mckenney@linaro.org>,
        Emmanuel Benisty <benisty.e@gmail.com>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 12:16 AM, Davidlohr Bueso
<davidlohr.bueso@hp.com> wrote:
> From: Davidlohr Bueso <davidlohr.bueso@hp.com>
>
> Sedat reported an issue leading to a NULL dereference in update_queue():
>
> [  178.490583] BUG: spinlock bad magic on CPU#1, sh/8066
> [  178.490595]  lock: 0xffff88008b53ea18, .magic: 6b6b6b6b, .owner: make/8068, .owner_cpu: 3
> [  178.490599] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [  178.490608] IP: [<ffffffff812bacd0>] update_queue+0x70/0x210
> [  178.490610] PGD 0
> [  178.490612] Oops: 0000 [#1] SMP
> ...
> [  178.490704] Call Trace:
> [  178.490710]  [<ffffffff812baf51>] do_smart_update+0xe1/0x140
> [  178.490713]  [<ffffffff812bd6e1>] exit_sem+0x2b1/0x350
> [  178.490718]  [<ffffffff8105de80>] do_exit+0x290/0xa70
> [  178.490721]  [<ffffffff8105e6f4>] do_group_exit+0x44/0xa0
> [  178.490724]  [<ffffffff8105e767>] SyS_exit_group+0x17/0x20
> [  178.490728]  [<ffffffff816ce15d>] system_call_fastpath+0x1a/0x1f
>
> Linus pin-pointed the problem to a race in the reference counter. To quote:
>
> "That dmesg spew very much implies that the same RCU head got added twice to the RCU
> freeing list, and the only way that happens is if the refcount goes to
> zero twice. Which implies that either we increment a zero, or we lack
> locking and the coherency of the non-atomic access goes away."
>
> This patch converts the IPC RCU header's reference counter to atomic_t. The return of
> ipc_rcu_getref() is modified to inform the callers if it actually succeeded.
>
> Now all callers return -EIDRM upon failure and abort the current operation. Two exceptions are
> in semaphore code where sem_getref_and_unlock() and sem_getref() trigger a warning but proceed
> to freeing up any held locks.
>
> Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Rik van Riel <riel@surriel.com>
> CC: Paul McKenney <paul.mckenney@linaro.org>
> CC: Sedat Dilek <sedat.dilek@gmail.com>
> CC: Emmanuel Benisty <benisty.e@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>

Missing my Reported-by ...!

I have tested this patch instead of Linus' suggested patch against
Linux-Next (next-20130423) with known missing IPC-SEM patches in
-next.

Davidlohr Bueso (2):
      ipc, sem: do not call sem_lock when bogus sma
      ipc: make refcounter atomic

Rik van Riel (3):
      ipc,sem: untangle RCU locking with find_alloc_undo
      ipc,sem: fix lockdep false positive
      ipc,sem: fix locking in semctl_main

...so please add also my Tested-by!

Thanks to all involved people!

- Sedat -

> ---
>  ipc/msg.c  |  7 ++++++-
>  ipc/sem.c  | 18 ++++++++++++------
>  ipc/util.c | 46 ++++++++++++++++++++++++----------------------
>  ipc/util.h |  2 +-
>  4 files changed, 43 insertions(+), 30 deletions(-)
>
> diff --git a/ipc/msg.c b/ipc/msg.c
> index 9d11955..2978721 100644
> --- a/ipc/msg.c
> +++ b/ipc/msg.c
> @@ -668,7 +668,12 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
>                         goto out_unlock_free;
>                 }
>                 ss_add(msq, &s);
> -               ipc_rcu_getref(msq);
> +
> +               if (!ipc_rcu_getref(msq)) {
> +                       err = -EIDRM;
> +                       goto out_unlock_free;
> +               }
> +
>                 msg_unlock(msq);
>                 schedule();
>
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 92f4d0e..9a71b5a 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -460,7 +460,7 @@ static inline void sem_lock_and_putref(struct sem_array *sma)
>
>  static inline void sem_getref_and_unlock(struct sem_array *sma)
>  {
> -       ipc_rcu_getref(sma);
> +       WARN_ON_ONCE(!ipc_rcu_getref(sma));
>         sem_unlock(sma, -1);
>  }
>
> @@ -476,7 +476,7 @@ static inline void sem_putref(struct sem_array *sma)
>  static inline void sem_getref(struct sem_array *sma)
>  {
>         sem_lock(sma, NULL, -1);
> -       ipc_rcu_getref(sma);
> +       WARN_ON_ONCE(!ipc_rcu_getref(sma));
>         sem_unlock(sma, -1);
>  }
>
> @@ -1275,7 +1275,10 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
>                 int i;
>                 struct sem_undo *un;
>
> -               ipc_rcu_getref(sma);
> +               if (!ipc_rcu_getref(sma)) {
> +                       rcu_read_unlock();
> +                       return -EIDRM;
> +               }
>                 rcu_read_unlock();
>
>                 if(nsems > SEMMSL_FAST) {
> @@ -1544,8 +1547,7 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
>         struct sem_array *sma;
>         struct sem_undo_list *ulp;
>         struct sem_undo *un, *new;
> -       int nsems;
> -       int error;
> +       int nsems, error;
>
>         error = get_undo_list(&ulp);
>         if (error)
> @@ -1567,7 +1569,11 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
>         }
>
>         nsems = sma->sem_nsems;
> -       ipc_rcu_getref(sma);
> +       if (!ipc_rcu_getref(sma)) {
> +               rcu_read_unlock();
> +               un = ERR_PTR(-EIDRM);
> +               goto out;
> +       }
>         rcu_read_unlock();
>
>         /* step 2: allocate new undo structure */
> diff --git a/ipc/util.c b/ipc/util.c
> index 18135bc..5e60ebd 100644
> --- a/ipc/util.c
> +++ b/ipc/util.c
> @@ -439,9 +439,9 @@ void ipc_rmid(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
>   *     NULL is returned if the allocation fails
>   */
>
> -void* ipc_alloc(int size)
> +void *ipc_alloc(int size)
>  {
> -       void* out;
> +       void *out;
>         if(size > PAGE_SIZE)
>                 out = vmalloc(size);
>         else
> @@ -478,7 +478,7 @@ void ipc_free(void* ptr, int size)
>   */
>  struct ipc_rcu_hdr
>  {
> -       int refcount;
> +       atomic_t refcount;
>         int is_vmalloc;
>         void *data[0];
>  };
> @@ -516,39 +516,41 @@ static inline int rcu_use_vmalloc(int size)
>   *     @size: size desired
>   *
>   *     Allocate memory for the rcu header structure +  the object.
> - *     Returns the pointer to the object.
> - *     NULL is returned if the allocation fails.
> + *     Returns the pointer to the object or NULL upon failure.
>   */
> -
> -void* ipc_rcu_alloc(int size)
> +void *ipc_rcu_alloc(int size)
>  {
>         void* out;
> -       /*
> +
> +       /*
>          * We prepend the allocation with the rcu struct, and
> -        * workqueue if necessary (for vmalloc).
> +        * workqueue if necessary (for vmalloc).
>          */
>         if (rcu_use_vmalloc(size)) {
>                 out = vmalloc(HDRLEN_VMALLOC + size);
> -               if (out) {
> -                       out += HDRLEN_VMALLOC;
> -                       container_of(out, struct ipc_rcu_hdr, data)->is_vmalloc = 1;
> -                       container_of(out, struct ipc_rcu_hdr, data)->refcount = 1;
> -               }
> +               if (!out)
> +                       goto done;
> +
> +               out += HDRLEN_VMALLOC;
> +               container_of(out, struct ipc_rcu_hdr, data)->is_vmalloc = 1;
>         } else {
>                 out = kmalloc(HDRLEN_KMALLOC + size, GFP_KERNEL);
> -               if (out) {
> -                       out += HDRLEN_KMALLOC;
> -                       container_of(out, struct ipc_rcu_hdr, data)->is_vmalloc = 0;
> -                       container_of(out, struct ipc_rcu_hdr, data)->refcount = 1;
> -               }
> +               if (!out)
> +                       goto done;
> +
> +               out += HDRLEN_KMALLOC;
> +               container_of(out, struct ipc_rcu_hdr, data)->is_vmalloc = 0;
>         }
>
> +       /* set reference counter no matter what kind of allocation was done */
> +       atomic_set(&container_of(out, struct ipc_rcu_hdr, data)->refcount, 1);
> +done:
>         return out;
>  }
>
> -void ipc_rcu_getref(void *ptr)
> +int ipc_rcu_getref(void *ptr)
>  {
> -       container_of(ptr, struct ipc_rcu_hdr, data)->refcount++;
> +       return atomic_inc_not_zero(&container_of(ptr, struct ipc_rcu_hdr, data)->refcount);
>  }
>
>  static void ipc_do_vfree(struct work_struct *work)
> @@ -578,7 +580,7 @@ static void ipc_schedule_free(struct rcu_head *head)
>
>  void ipc_rcu_putref(void *ptr)
>  {
> -       if (--container_of(ptr, struct ipc_rcu_hdr, data)->refcount > 0)
> +       if (!atomic_dec_and_test(&container_of(ptr, struct ipc_rcu_hdr, data)->refcount))
>                 return;
>
>         if (container_of(ptr, struct ipc_rcu_hdr, data)->is_vmalloc) {
> diff --git a/ipc/util.h b/ipc/util.h
> index c36b997..2b0bdd5 100644
> --- a/ipc/util.h
> +++ b/ipc/util.h
> @@ -119,7 +119,7 @@ void ipc_free(void* ptr, int size);
>   * to 0 schedules the rcu destruction. Caller must guarantee locking.
>   */
>  void* ipc_rcu_alloc(int size);
> -void ipc_rcu_getref(void *ptr);
> +int ipc_rcu_getref(void *ptr);
>  void ipc_rcu_putref(void *ptr);
>
>  struct kern_ipc_perm *ipc_lock(struct ipc_ids *, int);
> --
> 1.7.11.7
>
>
>
