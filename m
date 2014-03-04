Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbaCDT7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:59:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbaCDT7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:59:38 -0500
Date: Tue, 4 Mar 2014 20:03:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, venki@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
Message-ID: <20140304190348.GA22075@redhat.com>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <20140304135624.GA6846@redhat.com> <53161116.9050109@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53161116.9050109@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04, Khalid Aziz wrote:
>
> On 03/04/2014 06:56 AM, Oleg Nesterov wrote:
>> Hmm. In fact I think do_exit() should crash after munmap? ->mmap_state
>> should be NULL ?? Perhaps I misread this patch completely...
>
> do_exit() unmaps mmap_state->uaddr, and frees up mmap_state->kaddr and
> mmap_state. mmap_state should not be NULL after unmap.

Can't understand... do_exit() does:

	+#if CONFIG_SCHED_PREEMPT_DELAY
	+       if (tsk->sched_preempt_delay.mmap_state) {
	+               sys_munmap((unsigned long)
	+                       tsk->sched_preempt_delay.mmap_state->uaddr, PAGE_SIZE);
	+               vfree(tsk->sched_preempt_delay.mmap_state->kaddr);
	+               kfree(tsk->sched_preempt_delay.mmap_state);
	
sys_munmap() (which btw should not be used) obviously unmaps that
vma and vma_ops()->close() should be called.

close_preempt_delay_vmops() does:

	state->task->sched_preempt_delay.mmap_state = NULL;

vfree(tsk->sched_preempt_delay.mmap_state->kaddr) above will try to
dereference .mmap_state == NULL.

IOW, I think that with this patch this trivial program

	int main(void)
	{
		fd = open("/proc/self/task/$TID/sched_preempt_delay", O_RDWR);
		mmap(NULL, 4096, PROT_READ,MAP_SHARED, fd, 0);
		return 0;
	}

should crash the kernel.

>>> +	if (current->sched_preempt_delay.mmap_state != NULL) {
>>> +		retval = -EEXIST;
>>> +		goto error;
>>
>> This assumes that we are going to setup current->sched_preempt_delay.mmap_state,
>> but what if the task opens /proc/random_tid/sched_preempt_delay ?
>
> Good point. A thread should not be allowed to request preemption delay
> for another thread. I would recommend leaving this code alone and adding
> following code before this:
>
> if (get_proc_task(inode) != current) {
> 	retval = -EPERM;
> 	goto error;
> }
>
> Sounds reasonable?

Yes, we should check == current, but this interface looks strange anyway, imho.

>>> +	state->page = page;
>>> +	state->kaddr = kaddr;
>>> +	state->uaddr = (void *)vma->vm_start;
>>
>> This is used by do_exit(). But ->vm_start can be changed by mremap() ?
>>
>>
>> Hmm. And mremap() can do vm_ops->close() too. But the new vma will
>> have the same vm_ops/vm_private_data, so exit_mmap() will try to do
>> this again... Perhaps I missed something, but I bet this all can't be
>> right.
>
> Would you say sys_munmap() of mmap_state->uaddr is not even needed since
> exit_mm() will do this any way further down in do_exit()?

No.

I meant:

	1. mremap() can move this vma, so do_exit() can't trust ->uaddr

	2. Even worse, mremap() itself is not safe. It can do ->close()
	   too and create the new vma with the same vm_ops. Another
	   unmap from (say) exit_mm() won't be happy.

>>> +	vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND | VM_SHARED | VM_WRITE;
>>
>> This probably also needs VM_IO, to protect from madvise(MADV_DOFORK).
>
> Yes, you are right. I will add that.
>
>> VM_SHARED/VM_WRITE doesn't look right.
>
> VM_SHARED is wrong but VM_WRITE is needed I think since the thread will
> write to the mmap'd page to signal to request preemption delay.

But ->mmap() should not set VM_WRITE if application does mmap(PROT_READ) ?
VM_WRITE-or-not should be decided by do_mmap_pgoff/mprotect, ->mmap()
should not play with this bit.

Oleg.

