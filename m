Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534Ab3FCWSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:18:40 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57882 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759054Ab3FCWS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:18:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
References: <20130603190705.GA11517@redhat.com>
Date: Mon, 03 Jun 2013 15:18:06 -0700
In-Reply-To: <20130603190705.GA11517@redhat.com> (Oleg Nesterov's message of
	"Mon, 3 Jun 2013 21:07:05 +0200")
Message-ID: <877giarg81.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19cLlUECtaMVM8W6GiiAEFM+1ZHBPMuabw=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0176]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_05 8+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2 4/4] proc: avoid ->f_pos overflows in proc_task_readdir() paths
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> 1. proc_task_readdir() truncates f_pos to long, this can lead
>    to wrong result on 32bit.
>
> 2. first_tid() truncates f_pos to int, this is wrong even on
>    64bit.
>
>    We could check that f_pos < PID_MAX or even INT_MAX in
>    proc_task_readdir(), but this patch simply checks the
>    potential overflow in first_tid(), this check is nop on
>    64bit. We do not care if it was negative and the new
>    unsigned value is huge, all we need to ensure is that we
>    never wrongly return !NULL.
>
> 3. Remove the 2nd "nr != 0" check before get_nr_threads(),
>    nr_threads == 0 is not distinguishable from !pid_task()
>    above.

This won't compile on some 32bit architectures like x86-32.

switch(unsigned long long) requires helpers that the kernel does not
included.  Or at least the kernel has not included because such code
is a problem.  In fact that is the reason Linus put the case to
unsigned long in there.

There is another bug in here as well that we may return really crazy
things in the case of seek simultaneous with readdir.

I do like your overflow check, but unfortunately I think it is
susceptible to races with lseek.

Simply to avoid lseek non-sense I think we really need to put f_pos
in a local variable.  If the code continues to evolve our heads
will like to explode trying to think about what happens when someone
modifies f_pos while we are reading it/modifying it.

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  fs/proc/base.c |   16 ++++++++++------
>  1 files changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 5e0e02f..5598cfa 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -3178,10 +3178,14 @@ out_no_task:
>   * In the case of a seek we start with the leader and walk nr
>   * threads past it.
>   */
> -static struct task_struct *first_tid(struct pid *pid, int tid,
> -					int nr, struct pid_namespace *ns)
> +static struct task_struct *first_tid(struct pid *pid, int tid, loff_t f_pos,
> +					struct pid_namespace *ns)
>  {
>  	struct task_struct *pos, *task;
> +	unsigned long nr = f_pos;
> +
> +	if (nr != f_pos)	/* 32bit overflow? */
> +		return NULL;
>  
>  	rcu_read_lock();
>  	task = pid_task(pid, PIDTYPE_PID);
> @@ -3189,14 +3193,14 @@ static struct task_struct *first_tid(struct pid *pid, int tid,
>  		goto fail;
>  
>  	/* Attempt to start with the tid of a thread */
> -	if (tid && (nr > 0)) {
> +	if (tid && nr) {
>  		pos = find_task_by_pid_ns(tid, ns);
>  		if (pos && same_thread_group(pos, task))
>  			goto found;
>  	}
>  
>  	/* If nr exceeds the number of threads there is nothing todo */
> -	if (nr && nr >= get_nr_threads(task))
> +	if (nr >= get_nr_threads(task))
>  		goto fail;
>  
>  	/* If we haven't found our starting place yet start
> @@ -3204,7 +3208,7 @@ static struct task_struct *first_tid(struct pid *pid, int tid,
>  	 */
>  	pos = task = task->group_leader;
>  	do {
> -		if (nr-- <= 0)
> +		if (!nr--)
>  			goto found;
>  	} while_each_thread(task, pos);
>  fail:
> @@ -3261,7 +3265,7 @@ static int proc_task_readdir(struct file * filp, void * dirent, filldir_t filldi
>  	if (proc_inode_is_dead(inode))
>  		return -ENOENT;
>  
> -	switch ((unsigned long)filp->f_pos) {
> +	switch (filp->f_pos) {
>  	case 0:
>  		ino = inode->i_ino;
>  		if (filldir(dirent, ".", 1, filp->f_pos, ino, DT_DIR) < 0)
