Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbaCDN5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 08:57:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757202AbaCDN5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 08:57:16 -0500
Date: Tue, 4 Mar 2014 14:56:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, venki@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
Message-ID: <20140304135624.GA6846@redhat.com>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03, Khalid Aziz wrote:
>
> This queueing
> and subsequent CPU cycle wastage can be avoided if the locking thread
> could request to be granted an additional timeslice if its current
> timeslice runs out before it gives up the lock.

Well. I am in no position to discuss the changes in sched/fair.c. I have
to admit that I am skeptical about the whole idea/implementation, but I
leave this to sched/ maintainers.

However, at least the proc/mmap changes do not look right. I didn't read
the whole patch, just picked a "random" ->mmap function, see below.

>  kernel/sched/preempt_delay.c                    |  39 ++++++

Why? This can go into proc/ as well.

> +static void
> +close_preempt_delay_vmops(struct vm_area_struct *vma)
> +{
> +	struct preemp_delay_mmap_state *state;
> +
> +	state = (struct preemp_delay_mmap_state *) vma->vm_private_data;
> +	BUG_ON(!state || !state->task);
> +
> +	state->page->mapping = NULL;
> +	/* point delay request flag pointer back to old flag in task_struct */
> +	state->task->sched_preempt_delay.delay_req =
> +			&state->task->sched_preempt_delay.delay_flag;
> +	state->task->sched_preempt_delay.mmap_state = NULL;
> +	vfree(state->kaddr);
> +	kfree(state);
> +	vma->vm_private_data = NULL;
> +}

Suppose that state->task != current. Then this can race with do_exit()
which cleanups ->mmap_state too. OTOH do_exit() unmaps this region, it
is not clear why it can't rely in vm_ops->close().

Hmm. In fact I think do_exit() should crash after munmap? ->mmap_state
should be NULL ?? Perhaps I misread this patch completely...

> +static int
> +tid_preempt_delay_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	int retval = 0;
> +	void *kaddr = NULL;
> +	struct preemp_delay_mmap_state *state = NULL;
> +	struct inode *inode = file_inode(file);
> +	struct task_struct *task;
> +	struct page *page;
> +
> +	/*
> +	 * Validate args:
> +	 * - Only offset 0 support for now
> +	 * - size should be PAGE_SIZE
> +	 */
> +	if (vma->vm_pgoff != 0 || (vma->vm_end - vma->vm_start) != PAGE_SIZE) {
> +		retval = -EINVAL;
> +		goto error;
> +	}
> +
> +	/*
> +	 * Only one mmap allowed at a time
> +	 */
> +	if (current->sched_preempt_delay.mmap_state != NULL) {
> +		retval = -EEXIST;
> +		goto error;

This assumes that we are going to setup current->sched_preempt_delay.mmap_state,
but what if the task opens /proc/random_tid/sched_preempt_delay ?

> +	state = kzalloc(sizeof(struct preemp_delay_mmap_state), GFP_KERNEL);
> +	kaddr = vmalloc_user(PAGE_SIZE);

Why vmalloc() ? We only need a single page?

> +	task = get_proc_task(inode);

And it seems that nobody does put_task_struct(state->task);

> +	state->page = page;
> +	state->kaddr = kaddr;
> +	state->uaddr = (void *)vma->vm_start;

This is used by do_exit(). But ->vm_start can be changed by mremap() ?


Hmm. And mremap() can do vm_ops->close() too. But the new vma will
have the same vm_ops/vm_private_data, so exit_mmap() will try to do
this again... Perhaps I missed something, but I bet this all can't be
right.

> +	state->task = task;
> +
> +	/* Clear the current delay request flag */
> +	task->sched_preempt_delay.delay_flag = 0;
> +
> +	/* Point delay request flag pointer to the newly allocated memory */
> +	task->sched_preempt_delay.delay_req = (unsigned char *)kaddr;
> +
> +	task->sched_preempt_delay.mmap_state = state;
> +	vma->vm_private_data = state;
> +	vma->vm_ops = &preempt_delay_vmops;
> +	vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND | VM_SHARED | VM_WRITE;

This probably also needs VM_IO, to protect from madvise(MADV_DOFORK).
VM_SHARED/VM_WRITE doesn't look right.

Oleg.

