Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759AbaCDUPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:15:40 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18892 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757514AbaCDUPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:15:36 -0500
Message-ID: <5316343B.2030404@oracle.com>
Date: Tue, 04 Mar 2014 13:14:51 -0700
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
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <20140304135624.GA6846@redhat.com> <53161116.9050109@oracle.com> <20140304190348.GA22075@redhat.com>
In-Reply-To: <20140304190348.GA22075@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 12:03 PM, Oleg Nesterov wrote:
> On 03/04, Khalid Aziz wrote:
>>
>> On 03/04/2014 06:56 AM, Oleg Nesterov wrote:
>>> Hmm. In fact I think do_exit() should crash after munmap? ->mmap_state
>>> should be NULL ?? Perhaps I misread this patch completely...
>>
>> do_exit() unmaps mmap_state->uaddr, and frees up mmap_state->kaddr and
>> mmap_state. mmap_state should not be NULL after unmap.
>
> Can't understand... do_exit() does:
>
> 	+#if CONFIG_SCHED_PREEMPT_DELAY
> 	+       if (tsk->sched_preempt_delay.mmap_state) {
> 	+               sys_munmap((unsigned long)
> 	+                       tsk->sched_preempt_delay.mmap_state->uaddr, PAGE_SIZE);
> 	+               vfree(tsk->sched_preempt_delay.mmap_state->kaddr);
> 	+               kfree(tsk->sched_preempt_delay.mmap_state);
> 	
> sys_munmap() (which btw should not be used) obviously unmaps that
> vma and vma_ops()->close() should be called.
>
> close_preempt_delay_vmops() does:
>
> 	state->task->sched_preempt_delay.mmap_state = NULL;
>
> vfree(tsk->sched_preempt_delay.mmap_state->kaddr) above will try to
> dereference .mmap_state == NULL.
>
> IOW, I think that with this patch this trivial program
>
> 	int main(void)
> 	{
> 		fd = open("/proc/self/task/$TID/sched_preempt_delay", O_RDWR);
> 		mmap(NULL, 4096, PROT_READ,MAP_SHARED, fd, 0);
> 		return 0;
> 	}
>
> should crash the kernel.
>
>>>> +	state->page = page;
>>>> +	state->kaddr = kaddr;
>>>> +	state->uaddr = (void *)vma->vm_start;
>>>
>>> This is used by do_exit(). But ->vm_start can be changed by mremap() ?
>>>
>>>
>>> Hmm. And mremap() can do vm_ops->close() too. But the new vma will
>>> have the same vm_ops/vm_private_data, so exit_mmap() will try to do
>>> this again... Perhaps I missed something, but I bet this all can't be
>>> right.
>>
>> Would you say sys_munmap() of mmap_state->uaddr is not even needed since
>> exit_mm() will do this any way further down in do_exit()?
>
> No.
>
> I meant:
>
> 	1. mremap() can move this vma, so do_exit() can't trust ->uaddr
>
> 	2. Even worse, mremap() itself is not safe. It can do ->close()
> 	   too and create the new vma with the same vm_ops. Another
> 	   unmap from (say) exit_mm() won't be happy.

I agree this looks like a potential spot for trouble. I was asking if 
removing sys_munmap() of uaddr from do_exit() solves both of the above 
problems? You have convinced me this sys_munmap() I added is unnecessary.

>
>>>> +	vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND | VM_SHARED | VM_WRITE;
>>>
>>> This probably also needs VM_IO, to protect from madvise(MADV_DOFORK).
>>
>> Yes, you are right. I will add that.
>>
>>> VM_SHARED/VM_WRITE doesn't look right.
>>
>> VM_SHARED is wrong but VM_WRITE is needed I think since the thread will
>> write to the mmap'd page to signal to request preemption delay.
>
> But ->mmap() should not set VM_WRITE if application does mmap(PROT_READ) ?
> VM_WRITE-or-not should be decided by do_mmap_pgoff/mprotect, ->mmap()
> should not play with this bit.
>

Ah, I see. This makes sense. I will remove it.

Thanks,
Khalid


