Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab3E2Ena (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 00:43:30 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41254 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3E2En3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 00:43:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Sergey Dyasly <dserrg@gmail.com>,
        Sha Zhengju <handai.szj@taobao.com>, linux-kernel@vger.kernel.org
References: <20130527202822.GA19288@redhat.com>
Date: Tue, 28 May 2013 21:42:59 -0700
In-Reply-To: <20130527202822.GA19288@redhat.com> (Oleg Nesterov's message of
	"Mon, 27 May 2013 22:28:22 +0200")
Message-ID: <87ppwa1jn0.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18LTnIRSc88kojKvwRYtx4T8iUe1EB2p/Q=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4833]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 3/3] proc: simplify proc_task_readdir/first_tid paths
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> proc_task_readdir() does not really need "leader", first_tid()
> has to revalidate it anyway. Just pass proc_pid(inode) to
> first_tid() instead, it can do pid_task(PIDTYPE_PID) itself
> and read ->group_leader only if necessary.
>
> Note: I am not sure proc_task_readdir() really needs the initial
> -ENOENT check, but this is what the current code does.

This looks like a nice cleanup.

We would need either -ENOENT or a return of 0 and an empty directory at
the least.  We need the check so that empty directories don't have "."
and ".." entries.

Eric


> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  fs/proc/base.c |   46 ++++++++++++++++------------------------------
>  1 files changed, 16 insertions(+), 30 deletions(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index bed1096..dbc4dae 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -3173,34 +3173,35 @@ out_no_task:
>   * In the case of a seek we start with the leader and walk nr
>   * threads past it.
>   */
> -static struct task_struct *first_tid(struct task_struct *leader,
> -		int tid, int nr, struct pid_namespace *ns)
> +static struct task_struct *first_tid(struct pid *pid, int tid,
> +					int nr, struct pid_namespace *ns)
>  {
> -	struct task_struct *pos;
> +	struct task_struct *pos, *task;
>  
>  	rcu_read_lock();
> -	/* Attempt to start with the pid of a thread */
> +	task = pid_task(pid, PIDTYPE_PID);
Elegant.  If we can from the task from the pid the task is hashed
and still alive when we are in the rcu critical section.

> +	if (!task)
> +		goto fail;
> +
> +	/* Attempt to start with the tid of a thread */
>  	if (tid && (nr > 0)) {
>  		pos = find_task_by_pid_ns(tid, ns);
> -		if (pos && (pos->group_leader == leader))
> +		if (pos && same_thread_group(pos, task))

Sigh this reminds me we need to figure out how to kill task->pid and
task->tgid, which I assume means fixing same_thread_group.

>  			goto found;
>  	}
>  
>  	/* If nr exceeds the number of threads there is nothing todo */
> -	if (nr && nr >= get_nr_threads(leader))
> -		goto fail;
> -	/* It could be unhashed before we take rcu lock */
> -	if (!pid_alive(leader))
> +	if (nr && nr >= get_nr_threads(task))
>  		goto fail;

>  	/* If we haven't found our starting place yet start
>  	 * with the leader and walk nr threads forward.
>  	 */
> -	pos = leader;
> +	pos = task = task->group_leader;
>  	do {
>  		if (nr-- <= 0)
>  			goto found;
> -	} while_each_thread(leader, pos);
> +	} while_each_thread(task, pos);
>  fail:
>  	pos = NULL;
>  	goto out;
> @@ -3247,26 +3248,13 @@ static int proc_task_readdir(struct file * filp, void * dirent, filldir_t filldi
>  {
>  	struct dentry *dentry = filp->f_path.dentry;
>  	struct inode *inode = dentry->d_inode;
> -	struct task_struct *leader = NULL;
>  	struct task_struct *task;
> -	int retval = -ENOENT;
>  	ino_t ino;
>  	int tid;
>  	struct pid_namespace *ns;
>  
> -	task = get_proc_task(inode);
> -	if (!task)
> -		goto out_no_task;
> -	rcu_read_lock();
> -	if (pid_alive(task)) {
> -		leader = task->group_leader;
> -		get_task_struct(leader);
> -	}
> -	rcu_read_unlock();
> -	put_task_struct(task);
> -	if (!leader)
> -		goto out_no_task;
> -	retval = 0;


> +	if (!pid_task(proc_pid(inode), PIDTYPE_PID))
> +		return -ENOENT;

Strictly speaking this call to pid_task needs to be in a rcu critical
section.

>  	switch ((unsigned long)filp->f_pos) {
>  	case 0:
> @@ -3289,7 +3277,7 @@ static int proc_task_readdir(struct file * filp, void * dirent, filldir_t filldi
>  	ns = filp->f_dentry->d_sb->s_fs_info;
>  	tid = (int)filp->f_version;
>  	filp->f_version = 0;
> -	for (task = first_tid(leader, tid, filp->f_pos - 2, ns);
> +	for (task = first_tid(proc_pid(inode), tid, filp->f_pos - 2, ns);
>  	     task;
>  	     task = next_tid(task), filp->f_pos++) {
>  		tid = task_pid_nr_ns(task, ns);
> @@ -3302,9 +3290,7 @@ static int proc_task_readdir(struct file * filp, void * dirent, filldir_t filldi
>  		}
>  	}
>  out:
> -	put_task_struct(leader);
> -out_no_task:
> -	return retval;
> +	return 0;
>  }
>  
>  static int proc_task_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
