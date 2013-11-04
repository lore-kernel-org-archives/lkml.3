Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab3KDIqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 03:46:46 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:48395 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3KDIqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 03:46:43 -0500
X-AuditID: 9c93017e-b7b3cae000002b69-fe-52775ef1c5df
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
	<20131102155458.GA6981@redhat.com>
Date: Mon, 04 Nov 2013 17:46:41 +0900
In-Reply-To: <20131102155458.GA6981@redhat.com> (Oleg Nesterov's message of
	"Sat, 2 Nov 2013 16:54:58 +0100")
Message-ID: <87ob60366m.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Nov 2013 16:54:58 +0100, Oleg Nesterov wrote:
> Hello,
>
> Let me first apologize again if this was already discussed. And I also
> need to mention that I know almost nothing about elf/randomization/etc.

No no, this was not discussed enough.  And I really appreciate your
thorough review! :)

>
> However,
>
> On 10/29, Namhyung Kim wrote:
>>
>>   # nm foo | grep -e glob$ -e str -e foo
>>   00000000006008bc D foo
>>   00000000006008a8 D glob
>>   00000000006008ac D str
>>
>>   # perf probe -x /home/namhyung/tmp/foo -a 'foo=main+0x13 glob=@0x8a8:s32 \
>
> This does not look right to me.
>
> - get_user_vaddr() is costly, it does vma_interval_tree_foreach() under
>   ->i_mmap_mutex.

Hmm.. yes, I think this is not needed.  I guess it should lookup a
proper vma in current->mm with mmap_sem read-locked.

>
> - this only allows to read the data from the same binary.

Right.  This is also an unnecessary restriction.  We should be able to
access data in other binary.

>
> - in particular, you can't read the data from bss

I can't understand why..  The bss region should also be in a same vma of
normal data, no?

>
> - get_user_vaddr() looks simply wrong. I blindly applied the whole series
>   and did the test to ensure.
>
>   Test-case:
>
> 	#include <stdio.h>
> 	#include <stdlib.h>
> 	#include <unistd.h>
>
> 	unsigned int global = 0x1234;
>
> 	void func(void)
> 	{
> 	}
>
> 	int main(void)
> 	{
> 		char cmd[64];
>
> 		global = 0x4321;
> 		func();
>
> 		printf("addr = %p\n", &global);
>
> 		sprintf(cmd, "cat /proc/%d/maps", getpid());
> 		system(cmd);
>
> 		return 0;
> 	}
>
> 	# nm foo | grep -w global
> 	0000000000600a04 D global
>
> 	# perf probe -x ./foo -a "func var=@0xa04:u32"
> 	# perf record -e probe_foo:func ./foo
> 	addr = 0x600a04
> 	00400000-00401000 r-xp 00000000 fe:01 20958                              /root/foo
> 	00600000-00601000 rw-p 00000000 fe:01 20958                              /root/foo
> 	...
>
> 	# perf script | tail -1
> 		foo   555 [000]  1302.345642: probe_foo:func: (40059c) var=1234
>
> 	Note that it reports "1234", not "4321". This is because
> 	get_user_vaddr() finds another (1st) read-only mapping, and
> 	prints the initial value of "global".
>
> 	IOW, it reads the memory from 0x400a04, not from 0x600a04.

Argh..  This is a problem.

I thought the gcc somehow aligns data to next page boundary.  But if
it's not the case, we need to recognize which is the proper one..

Simply preferring a writable vma to a read-only vma is what's came to my
head now.  Do you have an idea?

>
> -------------------------------------------------------------------------------
> Can't we simply implement get_user_vaddr() as
>
> 	static void __user *get_user_vaddr(unsigned long addr, struct trace_uprobe *tu)
> 	{
> 		void __user *vaddr = (void __force __user *)addr;
>
> 		/* A NULL tu means that we already got the vaddr */
> 		if (tu)
> 			vaddr += (current->mm->start_data & PAGE_MASK);
>
> 		return vaddr;
> 	}
>
> ?
>
> I did this change, and now the test-case above works. And it also works
> with "cc -pie -fPIC",
>
> 	# nm foo | grep -w global
> 	0000000000200c9c D global
>
> 	# perf probe -x ./foo -a "func var=@0xc9c:u32"
> 	# perf record -e probe_foo:func ./foo
> 	...
> 	# perf script | tail -1
> 		foo   576 [001]   475.519940: probe_foo:func: (7ffe95ca3814) var=4321
>
> What do you think?

This can only work with the probes fetching data from the executable,
right?  But as I said it should support any other binaries too.

What about this?


static void __user *get_user_vaddr(unsigned long addr, struct trace_uprobe *tu)
{
	unsigned long pgoff = addr >> PAGE_SHIFT;
	struct vm_area_struct *vma, *orig_vma = NULL;
	unsigned long vaddr = 0;

	if (tu == NULL) {
		/* A NULL tu means that we already got the vaddr */
		return (void __force __user *) addr;
	}

	down_read(&current->mm->mmap_sem);

	vma = current->mm->mmap;
	do {
		if (!vma->vm_file || vma->vm_file->f_inode != tu->inode) {
			/*
			 * We found read-only mapping for this inode.
			 * (provided that all mappings for this inode
			 * have consecutive addresses)
			 */
			if (orig_vma)
				break;
			continue;
		}

		if (vma->vm_pgoff > pgoff ||
		    (vma->vm_pgoff + vma_pages(vma) <= pgoff))
			continue;

		orig_vma = vma;

		/*
		 * We prefer writable mapping over read-only since
		 * data is usually in read/write memory region.  But
		 * in case of read-only data, it only can be found in
		 * read-only mapping so we save orig_vma and check
		 * whether it also has writable mapping.
		 */
		if (vma->vm_flags & VM_WRITE)
			break;
	} while ((vma = vma->vm_next) != NULL);

	if (orig_vma)
		vaddr = offset_to_vaddr(orig_vma, addr);

	up_read(&current->mm->mmap_sem);

	return (void __force __user *) vaddr;
}


>
> -------------------------------------------------------------------------------
> Note:
> 	- I think that /* A NULL tu means that we already got the vaddr */
> 	  needs more discussion... IOW, I am not sure about 11/13.

Discussion and feedbacks are always more than welcome. :)

>
> 	- Perhaps it also makes sense to allow to pass the absolute address
> 	  (iow, += start_data should be conditional)

For per-process uprobe, it might be useful.

>
> but lets ignore this for now.

Okay.  Let's discuss again after solving current issues.

Thanks,
Namhyung
