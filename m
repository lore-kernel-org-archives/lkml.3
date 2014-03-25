Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbaCYRoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:44:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642AbaCYRoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:44:07 -0400
Date: Tue, 25 Mar 2014 10:44:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        andi.kleen@intel.com, rob@landley.net, viro@zeniv.linux.org.uk,
        oleg@redhat.com, gnomes@lxorguk.ukuu.org.uk, riel@redhat.com,
        snorcht@gmail.com, dhowells@redhat.com, luto@amacapital.net,
        daeseok.youn@gmail.com, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] Pre-emption control for userspace
Message-Id: <20140325104410.25e06c4d.akpm@linux-foundation.org>
In-Reply-To: <1395767870-28053-1-git-send-email-khalid.aziz@oracle.com>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
	<1395767870-28053-1-git-send-email-khalid.aziz@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2014 11:17:50 -0600 Khalid Aziz <khalid.aziz@oracle.com> wrote:

> 
> This patch adds a way for a thread to request additional timeslice from
> the scheduler if it is about to be preempted, so it could complete any
> critical task it is in the middle of. This functionality helps with
> performance on databases and has been used for many years on other OSs
> by the databases. This functionality helps in situation where a thread
> acquires a lock before performing a critical operation on the database,
> happens to get preempted before it completes its task and releases the
> lock.  This lock causes all other threads that also acquire the same
> lock to perform their critical operation on the database to start
> queueing up and causing large number of context switches. This queueing
> problem can be avoided if the thread that acquires lock first could
> request scheduler to grant it an additional timeslice once it enters its
> critical section and hence allow it to complete its critical sectiona
> without causing queueing problem. If critical section completes before
> the thread is due for preemption, the thread can simply desassert its
> request. A thread sends the scheduler this request by setting a flag in
> a memory location it has shared with the kernel.  Kernel uses bytes in
> the same memory location to let the thread know when its request for
> amnesty from preemption has been granted. Thread should yield the
> processor at the end of its critical section if it was granted amnesty
> to play nice with other threads. If thread fails to yield processor, it
> gets penalized by having its next amnesty request turned down by
> scheduler.  Documentation file included in this patch contains further
> details on how to use this functionality and conditions associated with
> its use. This patch also adds a new field in scheduler statistics which
> keeps track of how many times was a thread granted amnesty from
> preemption. This feature and its usage are documented in
> Documentation/scheduler/sched-preempt-delay.txt and this patch includes
> a test for this feature under tools/testing/selftests/preempt-delay

What a long paragraph ;)

The feature makes sense and sounds useful, but I'd like to see some
real world performance testing results so we can understand what the
benefit will be to our users?

>
> ...
>
> +#ifdef CONFIG_SCHED_PREEMPT_DELAY
> +static int
> +tid_preempt_delay_show(struct seq_file *m, void *v)
> +{
> +	struct inode *inode = m->private;
> +	struct task_struct *task = get_proc_task(inode);
> +	unsigned char *delay_req;
> +
> +	if (!task)
> +		return -ENOENT;
> +
> +	delay_req = (unsigned char *)task->sched_preempt_delay.delay_req;
> +	seq_printf(m, "0x%-p\n", delay_req);
> +
> +	put_task_struct(task);
> +	return 0;
> +}
> +
> +static ssize_t
> +tid_preempt_delay_write(struct file *file, const char __user *buf,
> +			  size_t count, loff_t *offset)
> +{
> +	struct inode *inode = file_inode(file);
> +	struct task_struct *task = get_proc_task(inode);
> +	u32 __user *delay_req;
> +	int retval;
> +
> +	if (!task) {
> +		retval = -ENOENT;
> +		goto out;
> +	}
> +
> +	/*
> +	 * A thread can write only to its corresponding preempt_delay
> +	 * proc file
> +	 */
> +	if (current != task) {
> +		retval =  -EPERM;
> +		goto out;
> +	}
> +
> +	delay_req = *(u32 __user **)buf;
> +
> +	/*
> +	 * Do not allow write if pointer is currently set
> +	 */
> +	if (task->sched_preempt_delay.delay_req && (delay_req != NULL)) {
> +		retval = -EINVAL;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Validate the pointer.
> +	 */
> +	if (unlikely(!access_ok(rw, delay_req, sizeof(u32)))) {
> +		retval = -EFAULT;
> +		goto out;
> +	}
> +
> +	task->sched_preempt_delay.delay_req = delay_req;
> +
> +	/* zero out flags */
> +	put_user(0, delay_req);
> +
> +	retval = count;
> +
> +out:
> +	put_task_struct(task);
> +	return retval;
> +}

So the procfs file is written in binary format and is read back in
ascii format.  Seems odd.

Perhaps this should all be done as a new syscall rather than some
procfs thing.

>
> ...
>
> @@ -1250,6 +1251,13 @@ struct task_struct {
>  	/* Revert to default priority/policy when forking */
>  	unsigned sched_reset_on_fork:1;
>  	unsigned sched_contributes_to_load:1;
> +#ifdef CONFIG_SCHED_PREEMPT_DELAY
> +	struct preempt_delay {
> +		u32 __user *delay_req;		/* delay request flag pointer */
> +		unsigned char delay_granted:1;	/* currently in delay */
> +		unsigned char yield_penalty:1;	/* failure to yield penalty */
> +	} sched_preempt_delay;

The problem with bitfields is that a write to one bitfield can corrupt
a concurrent write to the other one.  So it's your responsibility to
provide locking and/or to describe how this race is avoided.  A comment
here in the definition would be a suitable way of addressing this.

> +#endif
>  
>  	pid_t pid;
>  	pid_t tgid;
>
> ...
>
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4055,6 +4055,14 @@ SYSCALL_DEFINE0(sched_yield)
>  {
>  	struct rq *rq = this_rq_lock();
>  
> +#ifdef CONFIG_SCHED_PREEMPT_DELAY
> +	/*
> +	 * Clear the penalty flag for current task to reward it for
> +	 * palying by the rules

"playing"

> +	 */
> +	current->sched_preempt_delay.yield_penalty = 0;
> +#endif
> +
>  	schedstat_inc(rq, yld_count);
>  	current->sched_class->yield_task(rq);
>  
> ...
>
> +static void
> +delay_resched_task(struct task_struct *curr)
> +{
> +	struct sched_entity *se;
> +	int cpu = task_cpu(curr);
> +	u32 __user *delay_req;
> +	unsigned int delay_req_flag;
> +	unsigned char *delay_flag;
> +
> +	/*
> +	 * Check if task is using pre-emption delay feature. If address
> +	 * for preemption delay request flag is not set, this task is
> +	 * not using preemption delay feature, we can reschedule without
> +	 * any delay
> +	 */
> +	delay_req = curr->sched_preempt_delay.delay_req;
> +
> +	if ((delay_req == NULL) || (cpu != smp_processor_id()))

Presumably we don't get "smp_processor_id() used in preemptible code"
warnings here, so called-with-preempt-disabled is a secret prerequisite
for delay_resched_task().

> +		goto resched_now;
> +
> +	/*
> +	 * Pre-emption delay will  be granted only once. If this task
> +	 * has already been granted delay, rechedule now
> +	 */
> +	if (curr->sched_preempt_delay.delay_granted) {
> +		curr->sched_preempt_delay.delay_granted = 0;
> +		goto resched_now;
> +	}
> +
> +	/*
> +	 * Get the value of preemption delay request flag from userspace.
> +	 * Task had already passed us the address where the flag is stored
> +	 * in userspace earlier. This flag is just like the PROCESS_PRIVATE
> +	 * futex, leverage the futex code here to read the flag. If there
> +	 * is a page fault accessing this flag in userspace, that means
> +	 * userspace has not touched this flag recently and we can
> +	 * assume no preemption delay is needed.
> +	 *
> +	 * If task is not requesting additional timeslice, resched now
> +	 */
> +	if (delay_req) {
> +		int ret;
> +
> +		pagefault_disable();
> +		ret = __copy_from_user_inatomic(&delay_req_flag, delay_req,
> +				sizeof(u32));
> +		pagefault_enable();

This all looks rather hacky and unneccesary.  Can't we somehow use
plain old get_user() and avoid such fuss?

> +		delay_flag = &delay_req_flag;
> +		if (ret || !delay_flag[0])
> +			goto resched_now;
> +	} else {
> +		goto resched_now;
> +	}
> +
> +	/*
> +	 * Current thread has requested preemption delay and has not
> +	 * been granted an extension yet. If this thread failed to yield
> +	 * processor after being granted amnesty last time, penalize it
> +	 * by not granting this delay request, otherwise give it an extra
> +	 * timeslice.
> +	 */
> +	if (curr->sched_preempt_delay.yield_penalty) {
> +		curr->sched_preempt_delay.yield_penalty = 0;
> +		goto resched_now;
> +	}
> +
> +	se = &curr->se;
> +	curr->sched_preempt_delay.delay_granted = 1;
> +
> +	/*
> +	 * Set the penalty flag for failing to yield the processor after
> +	 * being granted immunity. This flag will be cleared in
> +	 * sched_yield() if the thread indeed calls sched_yield
> +	 */
> +	curr->sched_preempt_delay.yield_penalty = 1;
> +
> +	/*
> +	 * Let the thread know it got amnesty and it should call
> +	 * sched_yield() when it is done to avoid penalty next time
> +	 * it wants amnesty. We need to write to userspace location.
> +	 * Since we just read from this location, chances are extremley
> +	 * low we might page fault. If we do page fault, we will ignore
> +	 * it and accept the cost of failed write in form of unnecessary
> +	 * penalty for userspace task for not yielding processor.
> +	 * This is a highly unlikely scenario.
> +	 */
> +	delay_flag[0] = 0;
> +	delay_flag[1] = 1;
> +	pagefault_disable();
> +	__copy_to_user_inatomic(delay_req, &delay_req_flag, sizeof(u32));
> +	pagefault_enable();

and put_user() here.

> +	schedstat_inc(curr, se.statistics.nr_preempt_delayed);
> +	return;
> +
> +resched_now:
> +	resched_task(curr);
> +}
> +#else
> +#define delay_resched_task(curr) resched_task(curr)

This could have been implemented in C...

> +#endif /* CONFIG_SCHED_PREEMPT_DELAY */
> +
>
> ...
>
