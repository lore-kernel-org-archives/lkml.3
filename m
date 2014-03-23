Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaCWF5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 01:57:12 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:54924 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaCWF5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 01:57:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140321110719.43a6b017@gandalf.local.home>
References: <20140319151252.16ed3ac6@gandalf.local.home>
	<20140320152833.216d81a0@tlielax.poochiereds.net>
	<20140320165703.522c7c5c@gandalf.local.home>
	<20140320170239.51d20a0e@tlielax.poochiereds.net>
	<20140320222343.4faaa137@gandalf.local.home>
	<CAKywueT4xRHZGomoPvnA9rob3FpzkPYuuUPe+vEDiOFvTbUiGA@mail.gmail.com>
	<20140321081706.271e390c@gandalf.local.home>
	<20140321084128.3f499e5c@tlielax.poochiereds.net>
	<20140321110719.43a6b017@gandalf.local.home>
Date: Sun, 23 Mar 2014 00:57:07 -0500
Message-ID: <CADT32eJqh3EN=SdQ0CtLEmbnXFi-3=-MsddUv0CatKmGHL_7hw@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: Fix possible deadlock with cifs and work queues
From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jeff Layton <jlayton@redhat.com>, Pavel Shilovsky <piastry@etersoft.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        uobergfe@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a thought, although leasing code does not cause such deadlocks with rwsems,
perhaps leasing and oplock code can reside on one workqueue!


On Fri, Mar 21, 2014 at 10:07 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> We just had a customer report a deadlock in their 3.8-rt kernel.
> Looking into this, it is very possible to have the same deadlock in
> mainline in Linus's tree as it stands today.
>
> It is much easier to deadlock in the -rt kernel because reader locks
> are serialized, where a down_read() can block another down_read(). But
> because rwsems are fair locks, if a writer is waiting, a new reader
> will then block. This means that if it is possible for a reader to
> deadlock another reader, this can happen if a write comes along and
> blocks on a current reader. That will prevent another reader from
> running, and if that new reader requires to wake up a reader that owns
> the lock, you have your deadlock.
>
> Here's the situation with CIFS and workqueues:
>
> The cifs system has several workqueues used in file.c and other places.
> One of them is used for completion of a read and to release the
> page_lock which wakes up the reader. There are several other workqueues
> that do various other tasks.
>
> A holder of the reader lock can sleep on a page_lock() and expect the
> reader workqueue to wake it up (page_unlock()). The reader workqueue
> takes no locks so this does not seem to be a problem (but it is).
>
> The other workqueues can take the rwsem for read or for write. But our
> issue that we tripped over was that it grabs it for read (remember in
> -rt readers are serialized). But this can also happen if a separate
> writer is waiting on the lock as that would cause a reader to block on
> another reader too.
>
> All the workqueue callbacks are executed on the same workqueue:
>
>         queue_work(cifsiod_wq, &rdata->work);
>         [...]
>         queue_work(cifsiod_wq, &cfile->oplock_break);
>
> Now if the reader workqueue callback is queued after one of these
> workqueues that can take the rwsem, we can hit a deadlock. The
> workqueue code looks to be able to prevent deadlocks of these kinds,
> but I do not totally understand the workqueue scheduled work structure
> and perhaps if the kworker thread structure blocks hard it wont move
> works around.
>
> Here's what we see:
>
>         rdata->work is scheduled after cfile->oplock_break
>
>         CPU0                                            CPU1
>         ----                                            ----
>
>   do_sync_read()
>     cifs_strict_readv()
>       down_read(cinode->lock_sem);
>       generic_file_aio_read()
>         __lock_page_killable()
>           __wait_on_bit_lock()
>
>        * BLOCKED *
>
>                                                 process_one_work()
>                                                   cifs_oplock_break()
>                                                     cifs_has_mand_locks()
>                                                       down_read(cinode->lock_sem);
>
>                                                    * BLOCKED *
>
>                                               [ note, cifs_oplock_break() can
>                                                 also call cifs_push_locks which takes
>                                                 the lock with down_write() ]
>
> The key to remember is that the work to wake up the lock owner is queued
> behind the oplock work which is blocked on the same lock.
>
> We noticed that the rdata->work was queued to run under the same
> workqueue task and this work is to wake up the owner of the semaphore.
> But because the workqueue task is blocked waiting on that lock, it will
> never wake it up.
>
> By adding another workqueue that runs all the work that might take a mutex
> we should be able to avoid this deadlock.
>
> Link: http://lkml.kernel.org/r/20140319151252.16ed3ac6@gandalf.local.home
>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  fs/cifs/cifsfs.c   | 17 ++++++++++++++++-
>  fs/cifs/cifsglob.h |  1 +
>  fs/cifs/misc.c     |  2 +-
>  fs/cifs/smb2misc.c |  6 +++---
>  4 files changed, 21 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 849f613..b0761c8 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -86,6 +86,12 @@ extern mempool_t *cifs_req_poolp;
>  extern mempool_t *cifs_mid_poolp;
>
>  struct workqueue_struct        *cifsiod_wq;
> +/*
> + * The oplock workqueue must be separate to prevent it from blocking
> + * other work that is queued. Work that requires to grab mutex locks
> + * must use the 'l' version.
> + */
> +struct workqueue_struct        *cifsiold_wq;
>
>  #ifdef CONFIG_CIFS_SMB2
>  __u8 cifs_client_guid[SMB2_CLIENT_GUID_SIZE];
> @@ -1199,9 +1205,15 @@ init_cifs(void)
>                 goto out_clean_proc;
>         }
>
> +       cifsiold_wq = alloc_workqueue("cifsiold", WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
> +       if (!cifsiold_wq) {
> +               rc = -ENOMEM;
> +               goto out_destroy_wq;
> +       }
> +
>         rc = cifs_fscache_register();
>         if (rc)
> -               goto out_destroy_wq;
> +               goto out_destroy_rwq;
>
>         rc = cifs_init_inodecache();
>         if (rc)
> @@ -1249,6 +1261,8 @@ out_destroy_inodecache:
>         cifs_destroy_inodecache();
>  out_unreg_fscache:
>         cifs_fscache_unregister();
> +out_destroy_rwq:
> +       destroy_workqueue(cifsiold_wq);
>  out_destroy_wq:
>         destroy_workqueue(cifsiod_wq);
>  out_clean_proc:
> @@ -1273,6 +1287,7 @@ exit_cifs(void)
>         cifs_destroy_inodecache();
>         cifs_fscache_unregister();
>         destroy_workqueue(cifsiod_wq);
> +       destroy_workqueue(cifsiold_wq);
>         cifs_proc_clean();
>  }
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index c0f3718..6c2b5c8 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1561,6 +1561,7 @@ void cifs_oplock_break(struct work_struct *work);
>
>  extern const struct slow_work_ops cifs_oplock_break_ops;
>  extern struct workqueue_struct *cifsiod_wq;
> +extern struct workqueue_struct *cifsiold_wq;
>
>  extern mempool_t *cifs_mid_poolp;
>
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 2f9f379..1bc94e9 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -468,7 +468,7 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
>
>                                 cifs_set_oplock_level(pCifsInode,
>                                         pSMB->OplockLevel ? OPLOCK_READ : 0);
> -                               queue_work(cifsiod_wq,
> +                               queue_work(cifsiold_wq,
>                                            &netfile->oplock_break);
>                                 netfile->oplock_break_cancelled = false;
>
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index fb39662..ffea93f 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -447,7 +447,7 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
>                 else
>                         cfile->oplock_break_cancelled = true;
>
> -               queue_work(cifsiod_wq, &cfile->oplock_break);
> +               queue_work(cifsiold_wq, &cfile->oplock_break);
>                 kfree(lw);
>                 return true;
>         }
> @@ -463,7 +463,7 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
>                         memcpy(lw->lease_key, open->lease_key,
>                                SMB2_LEASE_KEY_SIZE);
>                         lw->tlink = cifs_get_tlink(open->tlink);
> -                       queue_work(cifsiod_wq, &lw->lease_break);
> +                       queue_work(cifsiold_wq, &lw->lease_break);
>                 }
>
>                 cifs_dbg(FYI, "found in the pending open list\n");
> @@ -579,7 +579,7 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
>                                   rsp->OplockLevel ? SMB2_OPLOCK_LEVEL_II : 0,
>                                   0, NULL);
>
> -                               queue_work(cifsiod_wq, &cfile->oplock_break);
> +                               queue_work(cifsiold_wq, &cfile->oplock_break);
>
>                                 spin_unlock(&cifs_file_list_lock);
>                                 spin_unlock(&cifs_tcp_ses_lock);
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
