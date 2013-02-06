Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab3BFJ1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 04:27:45 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:34801 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab3BFJ1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 04:27:42 -0500
MIME-Version: 1.0
X-Originating-IP: [188.156.93.37]
In-Reply-To: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Date: Wed, 6 Feb 2013 10:27:40 +0100
Message-ID: <CAJfpegvJD75ahBViUqAwVTBLuF5yrxOcVvzYHmcsTgwxX+7Oqg@mail.gmail.com>
Subject: Re: [PATCH] fuse: make fuse daemon frozen along with kernel threads
From: Miklos Szeredi <miklos@szeredi.hu>
To: Li Fei <fei.li@intel.com>
Cc: pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com, mingo@redhat.com,
        peterz@infradead.org, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        chuansheng.liu@intel.com, biao.wang@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 2:11 AM, Li Fei <fei.li@intel.com> wrote:
>
> There is well known issue that freezing will fail in case that fuse
> daemon is frozen firstly with some requests not handled, as the fuse
> usage task is waiting for the response from fuse daemon and can't be
> frozen.
>
> To solve the issue above, make fuse daemon frozen after all all user
> space processes frozen and during the kernel threads frozen phase.
> PF_FREEZE_DAEMON flag is added to indicate that the current thread is
> the fuse daemon,

Okay and how do you know which thread, process or processes belong to
the "fuse daemon"?

The only entity which may have a chance of defining the correct answer
to the above question is the fuse daemon itself.

What I mean is that automatically setting PF_FREEZE_DAEMON by the
kernel is the wrong approach. On the other hand an ioctl to set this
flag on a defined task or task group (*) would actually make some
sense.  Add some, possibly optional, inheritence behavior (i.e. a
cloned process would inherit the PF_FREEZE_DAMON flag) and it might
actually take care of most of the cases.

But I think it definitely needs more thought and testing.  Your patch
looks like it won't work on most of the unprivileged fuse filesystems
which use the fusermount(1) helper to perform the actual mounting.

Thanks,
Miklos

(*) setting this flag for other than the current process should, I
think, be a privileged operation, otherwise it might allow misuse.

>  set on connection, and clear on disconnection.
> It works as all fuse requests are handled during user space processes
> frozen, there will no further fuse request, and it's safe to continue
> to freeze fuse daemon together with kernel freezable tasks.
>
> Signed-off-by: Wang Biao <biao.wang@intel.com>
> Signed-off-by: Liu Chuansheng <chuansheng.liu@intel.com>
> Signed-off-by: Li Fei <fei.li@intel.com>
> ---
>  fs/fuse/inode.c         |    9 +++++++++
>  include/linux/freezer.h |    4 ++++
>  include/linux/sched.h   |    2 ++
>  kernel/freezer.c        |   33 ++++++++++++++++++++++++++++++++-
>  kernel/power/process.c  |    2 +-
>  5 files changed, 48 insertions(+), 2 deletions(-)
>
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 73ca6b7..fe476e8 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -20,6 +20,7 @@
>  #include <linux/random.h>
>  #include <linux/sched.h>
>  #include <linux/exportfs.h>
> +#include <linux/freezer.h>
>
>  MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
>  MODULE_DESCRIPTION("Filesystem in Userspace");
> @@ -367,6 +368,10 @@ void fuse_conn_kill(struct fuse_conn *fc)
>         wake_up_all(&fc->waitq);
>         wake_up_all(&fc->blocked_waitq);
>         wake_up_all(&fc->reserved_req_waitq);
> +
> +       /* Clear daemon flag after disconnection */
> +       clear_freeze_daemon_flag();
> +
>  }
>  EXPORT_SYMBOL_GPL(fuse_conn_kill);
>
> @@ -1054,6 +1059,10 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
>                 goto err_unlock;
>
>         list_add_tail(&fc->entry, &fuse_conn_list);
> +
> +       /* Set daemon flag just before connection */
> +       set_freeze_daemon_flag();
> +
>         sb->s_root = root_dentry;
>         fc->connected = 1;
>         file->private_data = fuse_conn_get(fc);
> diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> index e4238ce..9f0d0cf 100644
> --- a/include/linux/freezer.h
> +++ b/include/linux/freezer.h
> @@ -51,6 +51,8 @@ static inline bool try_to_freeze(void)
>
>  extern bool freeze_task(struct task_struct *p);
>  extern bool set_freezable(void);
> +extern bool set_freeze_daemon_flag(void);
> +extern bool clear_freeze_daemon_flag(void);
>
>  #ifdef CONFIG_CGROUP_FREEZER
>  extern bool cgroup_freezing(struct task_struct *task);
> @@ -217,6 +219,8 @@ static inline void freezer_do_not_count(void) {}
>  static inline void freezer_count(void) {}
>  static inline int freezer_should_skip(struct task_struct *p) { return 0; }
>  static inline void set_freezable(void) {}
> +static inline void set_freeze_daemon_flag(void) {}
> +static inline void clear_freeze_daemon_flag(void) {}
>
>  #define freezable_schedule()  schedule()
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index d211247..6cdc969 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1826,6 +1826,8 @@ extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut,
>  #define PF_MEMPOLICY   0x10000000      /* Non-default NUMA mempolicy */
>  #define PF_MUTEX_TESTER        0x20000000      /* Thread belongs to the rt mutex tester */
>  #define PF_FREEZER_SKIP        0x40000000      /* Freezer should not count it as freezable */
> +/* Daemon threads to be frozen along with kernel threads */
> +#define PF_FREEZER_DAEMON 0x80000000
>
>  /*
>   * Only the _current_ task can read/write to tsk->flags, but other
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index c38893b..eff9440 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -39,7 +39,8 @@ bool freezing_slow_path(struct task_struct *p)
>         if (pm_nosig_freezing || cgroup_freezing(p))
>                 return true;
>
> -       if (pm_freezing && !(p->flags & PF_KTHREAD))
> +       if (pm_freezing && !(p->flags & PF_KTHREAD) &&
> +                               !(p->flags & PF_FREEZE_DAEMON))
>                 return true;
>
>         return false;
> @@ -162,3 +163,33 @@ bool set_freezable(void)
>         return try_to_freeze();
>  }
>  EXPORT_SYMBOL(set_freezable);
> +
> +/**
> + * set_freeze_daemon_flag - make %current as daemon
> + *
> + * Make %current being frozen by freezer along with kernel threads
> + */
> +bool set_freeze_daemon_flag(void)
> +{
> +       spin_lock_irq(&freezer_lock);
> +       current->flags |= PF_FREEZE_DAEMON;
> +       spin_unlock_irq(&freezer_lock);
> +
> +       return try_to_freeze();
> +}
> +EXPORT_SYMBOL(set_freeze_daemon_flag);
> +
> +/**
> + * clear_freeze_daemon_flag - make %current as usual user space process
> + *
> + * Make %current being frozen by freezer along with user space processes
> + */
> +bool clear_freeze_daemon_flag(void)
> +{
> +       spin_lock_irq(&freezer_lock);
> +       current->flags &= ~PF_FREEZE_DAEMON;
> +       spin_unlock_irq(&freezer_lock);
> +
> +       return try_to_freeze();
> +}
> +EXPORT_SYMBOL(clear_freeze_daemon_flag);
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index d5a258b..a4489ae 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -199,7 +199,7 @@ void thaw_kernel_threads(void)
>
>         read_lock(&tasklist_lock);
>         do_each_thread(g, p) {
> -               if (p->flags & (PF_KTHREAD | PF_WQ_WORKER))
> +               if (p->flags & (PF_KTHREAD | PF_WQ_WORKER | PF_FREEZE_DAEMON))
>                         __thaw_task(p);
>         } while_each_thread(g, p);
>         read_unlock(&tasklist_lock);
> --
> 1.7.4.1
>
>
>
>
