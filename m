Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329AbaFRBcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 21:32:31 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60592 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309AbaFRBc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 21:32:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Cc: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>,
        Gotou Yasunori <y-goto@jp.fujitsu.com>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>
In-Reply-To: <1403000496-10094-1-git-send-email-chenhanxiao@cn.fujitsu.com>
	(Chen Hanxiao's message of "Tue, 17 Jun 2014 18:21:36 +0800")
References: <1403000496-10094-1-git-send-email-chenhanxiao@cn.fujitsu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Tue, 17 Jun 2014 18:31:15 -0700
Message-ID: <87fvj3ngv0.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/kQrK1XE0JTdOEIxORQUe0tC1+47MfIlo=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] ns: introduce getnspid syscall
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Hanxiao <chenhanxiao@cn.fujitsu.com> writes:

> We need a direct method of getting the pid inside containers.
> If some issues occurred inside container guest, host user
> could not know which process is in trouble just by guest pid:
> the users of container guest only knew the pid inside containers.
> This will bring obstacle for trouble shooting.

There is also some ongoing work to export this information via a proc
file which seems more appropriate for solving your problem.  Certainly
for debugging something easily human discoverable is needed.

> int getnspid(pid_t pid, int fd1, int fd2, int pidtype);

The pidtype is nonsense.  The translation of a pid does not depend upon
type.  Using that kind of nonsense will lead you and others into confusion.

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

Elsewhere we use 0 on pid translation failure.  Why be different here?

Eric


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
>  351	i386	sched_setattr		sys_sched_setattr
>  352	i386	sched_getattr		sys_sched_getattr
>  353	i386	renameat2		sys_renameat2
> +354	i386	getnspid		sys_getnspid
> diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
> index ec255a1..1630a8a 100644
> --- a/arch/x86/syscalls/syscall_64.tbl
> +++ b/arch/x86/syscalls/syscall_64.tbl
> @@ -323,6 +323,7 @@
>  314	common	sched_setattr		sys_sched_setattr
>  315	common	sched_getattr		sys_sched_getattr
>  316	common	renameat2		sys_renameat2
> +317	common	getnspid		sys_getnspid
>  
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index b0881a0..271c7b1 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -866,4 +866,5 @@ asmlinkage long sys_process_vm_writev(pid_t pid,
>  asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
>  			 unsigned long idx1, unsigned long idx2);
>  asmlinkage long sys_finit_module(int fd, const char __user *uargs, int flags);
> +asmlinkage long sys_getpidns(pid_t pid, int fd1, int fd2, int pidtype);
>  #endif
> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index 8e78110..3eda90a 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -261,6 +261,66 @@ out:
>  	return err;
>  }
>  
> +SYSCALL_DEFINE4(getnspid, pid_t, pid, int, fd1, int, fd2, int, pidtype)
> +{
> +	struct file *file1 = NULL, *file2 = NULL;
> +	struct task_struct *task;
> +	struct pid_namespace *ns1, *ns2;
> +	struct proc_ns *ei;
> +	int ret = -1;
> +
> +	if (pidtype >= PIDTYPE_MAX)
> +		return -EINVAL;
> +
> +	file1 = proc_ns_fget(fd1);
> +	if (IS_ERR(file1))
> +		return PTR_ERR(file1);
> +	ei = get_proc_ns(file_inode(file1));
> +	ns1 = (struct pid_namespace *)ei->ns;
> +
> +	/* fd == -2 for current pid ns */
> +	if (fd2 == -2) {
> +		ns2 = task_active_pid_ns(current);
> +	} else {
> +		file2 = proc_ns_fget(fd2);
> +		if (IS_ERR(file2)) {
> +			fput(file1);
> +			return PTR_ERR(file2);
> +		}
> +		ei = get_proc_ns(file_inode(file2));
> +		ns2 = (struct pid_namespace *)ei->ns;
> +	}
> +
> +	rcu_read_lock();
> +	task = find_task_by_pid_ns(pid, ns1);

The functions you want to be using here are:
find_pid_ns and pid_nr_ns.

> +	rcu_read_unlock();
> +	if (!task) {
> +		ret = -ESRCH;
> +		goto out;
> +	}
> +
> +	switch (pidtype) {
> +	case PIDTYPE_PID:
> +		ret = task_pid_nr_ns(task, ns2);
> +		break;
> +	case PIDTYPE_PGID:
> +		ret = task_pgrp_nr_ns(task, ns2);
> +		break;
> +	case PIDTYPE_SID:
> +		ret = task_session_nr_ns(task, ns2);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +	ret = (ret == 0) ? -ESRCH : ret;
> +
> +out:
> +	fput(file1);
> +	if (file2)
> +		fput(file2);
> +	return ret;
> +}
> +
>  int __init nsproxy_cache_init(void)
>  {
>  	nsproxy_cachep = KMEM_CACHE(nsproxy, SLAB_PANIC);
