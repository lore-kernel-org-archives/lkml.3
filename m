Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116AbaFQS10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 14:27:26 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:41342 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbaFQS1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 14:27:24 -0400
MIME-Version: 1.0
In-Reply-To: <1403000496-10094-1-git-send-email-chenhanxiao@cn.fujitsu.com>
References: <1403000496-10094-1-git-send-email-chenhanxiao@cn.fujitsu.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Tue, 17 Jun 2014 20:27:03 +0200
X-Google-Sender-Auth: MhuGvVyGRm7cb5leJYrq9NoVB_w
Message-ID: <CAHO5Pa0SHZXsbT14adxnMYGg6dG0DaMabNoreWAO-JDCCUKmWA@mail.gmail.com>
Subject: Re: [PATCH] ns: introduce getnspid syscall
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Cc: containers <containers@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Chen Hanxiao

On Tue, Jun 17, 2014 at 12:21 PM, Chen Hanxiao
<chenhanxiao@cn.fujitsu.com> wrote:
> We need a direct method of getting the pid inside containers.
> If some issues occurred inside container guest, host user
> could not know which process is in trouble just by guest pid:
> the users of container guest only knew the pid inside containers.
> This will bring obstacle for trouble shooting.
>
> int getnspid(pid_t pid, int fd1, int fd2, int pidtype);

Please CC linux-api@vger.kernel.org on all patches that change the API
that the kernel presents to user space. See
https://www.kernel.org/doc/man-pages/linux-api-ml.html

Thanks,

Michael


> pid: the pid number need to be translated.
>
> fd: a file descriptor referring to one of
>     the namespace entries in a /proc/[pid]/ns/pid.
>     fd1 for destination ns(ns1), where the pid came from.
>     fd2 for reference ns(ns2), while fd2 = -2 means for current ns.
>
> pidtype: 0 PIDTYPE_PID; 1 PIDTYPE_PGID; 2 PIDTYPE_SID.
>
> return value:
>     >0: translated pid in ns1(fd1) seen from ns2(fd2).
>     <0: on failure.
>
> Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
> ---
>  arch/x86/syscalls/syscall_32.tbl |  1 +
>  arch/x86/syscalls/syscall_64.tbl |  1 +
>  include/linux/syscalls.h         |  1 +
>  kernel/nsproxy.c                 | 60 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 63 insertions(+)
>
> diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
> index d6b8679..9de0b32 100644
> --- a/arch/x86/syscalls/syscall_32.tbl
> +++ b/arch/x86/syscalls/syscall_32.tbl
> @@ -360,3 +360,4 @@
>  351    i386    sched_setattr           sys_sched_setattr
>  352    i386    sched_getattr           sys_sched_getattr
>  353    i386    renameat2               sys_renameat2
> +354    i386    getnspid                sys_getnspid
> diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
> index ec255a1..1630a8a 100644
> --- a/arch/x86/syscalls/syscall_64.tbl
> +++ b/arch/x86/syscalls/syscall_64.tbl
> @@ -323,6 +323,7 @@
>  314    common  sched_setattr           sys_sched_setattr
>  315    common  sched_getattr           sys_sched_getattr
>  316    common  renameat2               sys_renameat2
> +317    common  getnspid                sys_getnspid
>
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index b0881a0..271c7b1 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -866,4 +866,5 @@ asmlinkage long sys_process_vm_writev(pid_t pid,
>  asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
>                          unsigned long idx1, unsigned long idx2);
>  asmlinkage long sys_finit_module(int fd, const char __user *uargs, int flags);
> +asmlinkage long sys_getpidns(pid_t pid, int fd1, int fd2, int pidtype);
>  #endif
> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index 8e78110..3eda90a 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -261,6 +261,66 @@ out:
>         return err;
>  }
>
> +SYSCALL_DEFINE4(getnspid, pid_t, pid, int, fd1, int, fd2, int, pidtype)
> +{
> +       struct file *file1 = NULL, *file2 = NULL;
> +       struct task_struct *task;
> +       struct pid_namespace *ns1, *ns2;
> +       struct proc_ns *ei;
> +       int ret = -1;
> +
> +       if (pidtype >= PIDTYPE_MAX)
> +               return -EINVAL;
> +
> +       file1 = proc_ns_fget(fd1);
> +       if (IS_ERR(file1))
> +               return PTR_ERR(file1);
> +       ei = get_proc_ns(file_inode(file1));
> +       ns1 = (struct pid_namespace *)ei->ns;
> +
> +       /* fd == -2 for current pid ns */
> +       if (fd2 == -2) {
> +               ns2 = task_active_pid_ns(current);
> +       } else {
> +               file2 = proc_ns_fget(fd2);
> +               if (IS_ERR(file2)) {
> +                       fput(file1);
> +                       return PTR_ERR(file2);
> +               }
> +               ei = get_proc_ns(file_inode(file2));
> +               ns2 = (struct pid_namespace *)ei->ns;
> +       }
> +
> +       rcu_read_lock();
> +       task = find_task_by_pid_ns(pid, ns1);
> +       rcu_read_unlock();
> +       if (!task) {
> +               ret = -ESRCH;
> +               goto out;
> +       }
> +
> +       switch (pidtype) {
> +       case PIDTYPE_PID:
> +               ret = task_pid_nr_ns(task, ns2);
> +               break;
> +       case PIDTYPE_PGID:
> +               ret = task_pgrp_nr_ns(task, ns2);
> +               break;
> +       case PIDTYPE_SID:
> +               ret = task_session_nr_ns(task, ns2);
> +               break;
> +       default:
> +               ret = -EINVAL;
> +       }
> +       ret = (ret == 0) ? -ESRCH : ret;
> +
> +out:
> +       fput(file1);
> +       if (file2)
> +               fput(file2);
> +       return ret;
> +}
> +
>  int __init nsproxy_cache_init(void)
>  {
>         nsproxy_cachep = KMEM_CACHE(nsproxy, SLAB_PANIC);
> --
> 1.9.0
>
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
