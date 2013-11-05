Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab3KEBxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 20:53:24 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60608 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab3KEBxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 20:53:23 -0500
X-AuditID: 9c930197-b7b60ae000006860-63-52784f910cda
From: Namhyung Kim <namhyung@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCHSET 00/13] tracing/uprobes: Add support for more fetch methods (v6)
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org>
	<20131102155458.GA6981@redhat.com> <87ob60366m.fsf@sejong.aot.lge.com>
	<20131104150112.GC4440@redhat.com>
Date: Tue, 05 Nov 2013 10:53:20 +0900
In-Reply-To: <20131104150112.GC4440@redhat.com> (Oleg Nesterov's message of
	"Mon, 4 Nov 2013 16:01:12 +0100")
Message-ID: <87zjpj1unj.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Nov 2013 16:01:12 +0100, Oleg Nesterov wrote:
> On 11/04, Namhyung Kim wrote:
>>
>> On Sat, 2 Nov 2013 16:54:58 +0100, Oleg Nesterov wrote:
>> >
>> > This does not look right to me.
>> >
>> > - get_user_vaddr() is costly, it does vma_interval_tree_foreach() under
>> >   ->i_mmap_mutex.
>>
>> Hmm.. yes, I think this is not needed.  I guess it should lookup a
>> proper vma in current->mm with mmap_sem read-locked.
>>
>> >
>> > - this only allows to read the data from the same binary.
>>
>> Right.  This is also an unnecessary restriction.  We should be able to
>> access data in other binary.
>
> Yes... but this needs another discussion. In general, we simply can not
> do this with the suggested syntax.

Agreed.

>
> Say you want to probe this "foo" binary and dump "stdin" from libc.so.
> You can't do this. You simply can't know where libc.so will be mmaped.
>
> But: if we attach the event to the already running process, or if we
> disable the randomization, then we can probably do this, see below.
>
> Or the syntax should be "name=probe @file/addr" or something like this.

Okay.  Let's call this kind of thing "cross-fetch" (or a better name can
be suggested).  This is more complex situation and needs more discussion
as you said.  So let's skip the discussion for now. :)

>
>> > - in particular, you can't read the data from bss
>>
>> I can't understand why..  The bss region should also be in a same vma of
>> normal data, no?
>
> No, no. bss is mmaped anonymously, at least in general. See set_brk() in
> load_elf().

Ah, thanks for the pointer.  I also need to say that I'm not familiar
with the code base.

Looking at the code, it seems to add a anon mapping iff the bss region
spans on two or more pages - that's why I missed it from my simple
test. :/

>
>> I thought the gcc somehow aligns data to next page boundary.
>
> And perhaps it even should, my system is old. But this doesn't really
> matter, the process itself can create another mapping.

Right.

>
>> But if
>> it's not the case, we need to recognize which is the proper one..
>>
>> Simply preferring a writable vma to a read-only vma is what's came to my
>> head now.  Do you have an idea?
>
> So far I think that trace_uprobes.c should not play games with vma. At all.

Yes, playing with vma is fragile.  But otherwise how can we get the
address from the file+offset in random processes?

>
>> > -------------------------------------------------------------------------------
>> > Can't we simply implement get_user_vaddr() as
>> >
>> > 	static void __user *get_user_vaddr(unsigned long addr, struct trace_uprobe *tu)
>> > 	{
>> > 		void __user *vaddr = (void __force __user *)addr;
>> >
>> > 		/* A NULL tu means that we already got the vaddr */
>> > 		if (tu)
>> > 			vaddr += (current->mm->start_data & PAGE_MASK);
>> >
>> > 		return vaddr;
>> > 	}
>> >
>> > ?
>> >
>> > I did this change, and now the test-case above works. And it also works
>> > with "cc -pie -fPIC",
>> >
>> > 	# nm foo | grep -w global
>> > 	0000000000200c9c D global
>> >
>> > 	# perf probe -x ./foo -a "func var=@0xc9c:u32"
>> > 	# perf record -e probe_foo:func ./foo
>> > 	...
>> > 	# perf script | tail -1
>> > 		foo   576 [001]   475.519940: probe_foo:func: (7ffe95ca3814) var=4321
>> >
>> > What do you think?
>>
>> This can only work with the probes fetching data from the executable,
>> right?  But as I said it should support any other binaries too.
>
> See above, we can't in general read other binaries.

Okay, I need to clarify my words.  I'm not saying about "cross-fetch"
here, what I wanted to say is adding a probe in some dso and fetch data
from the dso.

Primary usecase I have in mind is supporting SDTs in the perf probe
tool.  Currently many libraries including glibc add tracepoints (SDTs)
within themselves to be traced/profilied easily.

You can see Hemant's work on this here:

  https://lkml.org/lkml/2013/10/18/274

>
> But: if we know know where it is mmapped we can do this, just we need
> to calculate the right addr passed to trace_uprobes.
>
> Or: we should support both absolute and relative addresses, this is what
> I was going to discuss later.

But I guess this "specifying address directly" is hard to apply to
multiple processes - like system-wide tracing in perf.

>
>> static void __user *get_user_vaddr(unsigned long addr, struct trace_uprobe *tu)
>> {
>> 	unsigned long pgoff = addr >> PAGE_SHIFT;
>> 	struct vm_area_struct *vma, *orig_vma = NULL;
>> 	unsigned long vaddr = 0;
>>
>> 	if (tu == NULL) {
>> 		/* A NULL tu means that we already got the vaddr */
>> 		return (void __force __user *) addr;
>> 	}
>>
>> 	down_read(&current->mm->mmap_sem);
>>
>> 	vma = current->mm->mmap;
>
> Cough, it can be null if another thread does munmap(0, TASK_SIZE) ;)
>
> But this doesn't matter.

:)

>
>> 	do {
>> 		if (!vma->vm_file || vma->vm_file->f_inode != tu->inode) {
>> 			/*
>> 			 * We found read-only mapping for this inode.
>> 			 * (provided that all mappings for this inode
>> 			 * have consecutive addresses)
>> 			 */
>> 			if (orig_vma)
>> 				break;
>> 			continue;
>> 		}
>>
>> 		if (vma->vm_pgoff > pgoff ||
>> 		    (vma->vm_pgoff + vma_pages(vma) <= pgoff))
>> 			continue;
>>
>> 		orig_vma = vma;
>>
>> 		/*
>> 		 * We prefer writable mapping over read-only since
>> 		 * data is usually in read/write memory region.  But
>> 		 * in case of read-only data, it only can be found in
>> 		 * read-only mapping so we save orig_vma and check
>> 		 * whether it also has writable mapping.
>> 		 */
>> 		if (vma->vm_flags & VM_WRITE)
>> 			break;
>> 	} while ((vma = vma->vm_next) != NULL);
>>
>> 	if (orig_vma)
>> 		vaddr = offset_to_vaddr(orig_vma, addr);
>>
>> 	up_read(&current->mm->mmap_sem);
>>
>> 	return (void __force __user *) vaddr;
>> }
>
> For what? Why it is better then my suggestion?

Just to support fetching (not cross-fetching!) from other binaries
(dsos) other than an executable.

>
> How it can read bss? How it can read the data from other binaries?

Yes, it'd fail if bss resides in a separate vma. :-/

>
> How we can trust the result? This code relies on some guesses and
> none of them are "strict".
>
> If nothing else, elf can have the arbitrary number of mmaped sections,
> this can't work in general?

These two are still problems to be solved.

Thanks,
Namhyung
