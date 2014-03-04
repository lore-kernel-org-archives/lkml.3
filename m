Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbaCDRp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 12:45:56 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39667 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbaCDRpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 12:45:55 -0500
Message-ID: <53161116.9050109@oracle.com>
Date: Tue, 04 Mar 2014 10:44:54 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, venki@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <20140304135624.GA6846@redhat.com>
In-Reply-To: <20140304135624.GA6846@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review. Please see my comments inline below.

On 03/04/2014 06:56 AM, Oleg Nesterov wrote:
> On 03/03, Khalid Aziz wrote:
>>   kernel/sched/preempt_delay.c                    |  39 ++++++
>
> Why? This can go into proc/ as well.
>

Sure. No strong reason to keep these functions in separate file. These 
functions can go into proc/fs/base.c.

>> +static void
>> +close_preempt_delay_vmops(struct vm_area_struct *vma)
>> +{
>> +	struct preemp_delay_mmap_state *state;
>> +
>> +	state = (struct preemp_delay_mmap_state *) vma->vm_private_data;
>> +	BUG_ON(!state || !state->task);
>> +
>> +	state->page->mapping = NULL;
>> +	/* point delay request flag pointer back to old flag in task_struct */
>> +	state->task->sched_preempt_delay.delay_req =
>> +			&state->task->sched_preempt_delay.delay_flag;
>> +	state->task->sched_preempt_delay.mmap_state = NULL;
>> +	vfree(state->kaddr);
>> +	kfree(state);
>> +	vma->vm_private_data = NULL;
>> +}
>
> Suppose that state->task != current. Then this can race with do_exit()
> which cleanups ->mmap_state too. OTOH do_exit() unmaps this region, it
> is not clear why it can't rely in vm_ops->close().
>
> Hmm. In fact I think do_exit() should crash after munmap? ->mmap_state
> should be NULL ?? Perhaps I misread this patch completely...

do_exit() unmaps mmap_state->uaddr, and frees up mmap_state->kaddr and 
mmap_state. mmap_state should not be NULL after unmap. vfree() and 
kfree() are tolerant of pointers that have already been freed. On the 
other hand mmap_state can be NULL in do_exit() if do_exit() and 
close_preempt_delay_vmops() were to race since 
close_preempt_delay_vmops() sets mmap_state to NULL just before it frees 
it up. Could they indeed race, because the thread happens to be killed 
just as it had called munmap()? I can protect against that with a 
refcount in mmap_state. Do you feel this is necessary/helpful to do?

>
>> +static int
>> +tid_preempt_delay_mmap(struct file *file, struct vm_area_struct *vma)
>> +{
>> +	int retval = 0;
>> +	void *kaddr = NULL;
>> +	struct preemp_delay_mmap_state *state = NULL;
>> +	struct inode *inode = file_inode(file);
>> +	struct task_struct *task;
>> +	struct page *page;
>> +
>> +	/*
>> +	 * Validate args:
>> +	 * - Only offset 0 support for now
>> +	 * - size should be PAGE_SIZE
>> +	 */
>> +	if (vma->vm_pgoff != 0 || (vma->vm_end - vma->vm_start) != PAGE_SIZE) {
>> +		retval = -EINVAL;
>> +		goto error;
>> +	}
>> +
>> +	/*
>> +	 * Only one mmap allowed at a time
>> +	 */
>> +	if (current->sched_preempt_delay.mmap_state != NULL) {
>> +		retval = -EEXIST;
>> +		goto error;
>
> This assumes that we are going to setup current->sched_preempt_delay.mmap_state,
> but what if the task opens /proc/random_tid/sched_preempt_delay ?

Good point. A thread should not be allowed to request preemption delay 
for another thread. I would recommend leaving this code alone and adding 
following code before this:

if (get_proc_task(inode) != current) {
	retval = -EPERM;
	goto error;
}

Sounds reasonable?

>
>> +	state = kzalloc(sizeof(struct preemp_delay_mmap_state), GFP_KERNEL);
>> +	kaddr = vmalloc_user(PAGE_SIZE);
>
> Why vmalloc() ? We only need a single page?
>

Makes sense. I will switch to get_zeroed_page().

>> +	task = get_proc_task(inode);
>
> And it seems that nobody does put_task_struct(state->task);

Good catch. I had caught the other two instances of get_proc_task() but 
missed this one.

>
>> +	state->page = page;
>> +	state->kaddr = kaddr;
>> +	state->uaddr = (void *)vma->vm_start;
>
> This is used by do_exit(). But ->vm_start can be changed by mremap() ?
>
>
> Hmm. And mremap() can do vm_ops->close() too. But the new vma will
> have the same vm_ops/vm_private_data, so exit_mmap() will try to do
> this again... Perhaps I missed something, but I bet this all can't be
> right.

Would you say sys_munmap() of mmap_state->uaddr is not even needed since 
exit_mm() will do this any way further down in do_exit()? If I were to 
remove this sys_munmap(), that could simplify the race issues as well.

>
>> +	state->task = task;
>> +
>> +	/* Clear the current delay request flag */
>> +	task->sched_preempt_delay.delay_flag = 0;
>> +
>> +	/* Point delay request flag pointer to the newly allocated memory */
>> +	task->sched_preempt_delay.delay_req = (unsigned char *)kaddr;
>> +
>> +	task->sched_preempt_delay.mmap_state = state;
>> +	vma->vm_private_data = state;
>> +	vma->vm_ops = &preempt_delay_vmops;
>> +	vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND | VM_SHARED | VM_WRITE;
>
> This probably also needs VM_IO, to protect from madvise(MADV_DOFORK).

Yes, you are right. I will add that.

> VM_SHARED/VM_WRITE doesn't look right.

VM_SHARED is wrong but VM_WRITE is needed I think since the thread will 
write to the mmap'd page to signal to request preemption delay.

>
> Oleg.
>

I appreciate your taking the time to review this code. Thank you very much.

--
Khalid
