Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab3KDPHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 10:07:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631Ab3KDPHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 10:07:07 -0500
Date: Mon, 4 Nov 2013 16:01:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCHSET 00/13] tracing/uprobes: Add support for more fetch
	methods (v6)
Message-ID: <20131104150112.GC4440@redhat.com>
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org> <20131102155458.GA6981@redhat.com> <87ob60366m.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ob60366m.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04, Namhyung Kim wrote:
>
> On Sat, 2 Nov 2013 16:54:58 +0100, Oleg Nesterov wrote:
> >
> > This does not look right to me.
> >
> > - get_user_vaddr() is costly, it does vma_interval_tree_foreach() under
> >   ->i_mmap_mutex.
>
> Hmm.. yes, I think this is not needed.  I guess it should lookup a
> proper vma in current->mm with mmap_sem read-locked.
>
> >
> > - this only allows to read the data from the same binary.
>
> Right.  This is also an unnecessary restriction.  We should be able to
> access data in other binary.

Yes... but this needs another discussion. In general, we simply can not
do this with the suggested syntax.

Say you want to probe this "foo" binary and dump "stdin" from libc.so.
You can't do this. You simply can't know where libc.so will be mmaped.

But: if we attach the event to the already running process, or if we
disable the randomization, then we can probably do this, see below.

Or the syntax should be "name=probe @file/addr" or something like this.

> > - in particular, you can't read the data from bss
>
> I can't understand why..  The bss region should also be in a same vma of
> normal data, no?

No, no. bss is mmaped anonymously, at least in general. See set_brk() in
load_elf().

> > 	#include <stdio.h>
> > 	#include <stdlib.h>
> > 	#include <unistd.h>
> >
> > 	unsigned int global = 0x1234;
> >
> > 	void func(void)
> > 	{
> > 	}
> >
> > 	int main(void)
> > 	{
> > 		char cmd[64];
> >
> > 		global = 0x4321;
> > 		func();
> >
> > 		printf("addr = %p\n", &global);
> >
> > 		sprintf(cmd, "cat /proc/%d/maps", getpid());
> > 		system(cmd);
> >
> > 		return 0;
> > 	}
> >
> > 	# nm foo | grep -w global
> > 	0000000000600a04 D global
> >
> > 	# perf probe -x ./foo -a "func var=@0xa04:u32"
> > 	# perf record -e probe_foo:func ./foo
> > 	addr = 0x600a04
> > 	00400000-00401000 r-xp 00000000 fe:01 20958                              /root/foo
> > 	00600000-00601000 rw-p 00000000 fe:01 20958                              /root/foo
> > 	...
> >
> > 	# perf script | tail -1
> > 		foo   555 [000]  1302.345642: probe_foo:func: (40059c) var=1234
> >
> > 	Note that it reports "1234", not "4321". This is because
> > 	get_user_vaddr() finds another (1st) read-only mapping, and
> > 	prints the initial value of "global".
> >
> > 	IOW, it reads the memory from 0x400a04, not from 0x600a04.
>
> Argh..  This is a problem.
>
> I thought the gcc somehow aligns data to next page boundary.

And perhaps it even should, my system is old. But this doesn't really
matter, the process itself can create another mapping.

> But if
> it's not the case, we need to recognize which is the proper one..
>
> Simply preferring a writable vma to a read-only vma is what's came to my
> head now.  Do you have an idea?

So far I think that trace_uprobes.c should not play games with vma. At all.

> > -------------------------------------------------------------------------------
> > Can't we simply implement get_user_vaddr() as
> >
> > 	static void __user *get_user_vaddr(unsigned long addr, struct trace_uprobe *tu)
> > 	{
> > 		void __user *vaddr = (void __force __user *)addr;
> >
> > 		/* A NULL tu means that we already got the vaddr */
> > 		if (tu)
> > 			vaddr += (current->mm->start_data & PAGE_MASK);
> >
> > 		return vaddr;
> > 	}
> >
> > ?
> >
> > I did this change, and now the test-case above works. And it also works
> > with "cc -pie -fPIC",
> >
> > 	# nm foo | grep -w global
> > 	0000000000200c9c D global
> >
> > 	# perf probe -x ./foo -a "func var=@0xc9c:u32"
> > 	# perf record -e probe_foo:func ./foo
> > 	...
> > 	# perf script | tail -1
> > 		foo   576 [001]   475.519940: probe_foo:func: (7ffe95ca3814) var=4321
> >
> > What do you think?
>
> This can only work with the probes fetching data from the executable,
> right?  But as I said it should support any other binaries too.

See above, we can't in general read other binaries.

But: if we know know where it is mmapped we can do this, just we need
to calculate the right addr passed to trace_uprobes.

Or: we should support both absolute and relative addresses, this is what
I was going to discuss later.

> static void __user *get_user_vaddr(unsigned long addr, struct trace_uprobe *tu)
> {
> 	unsigned long pgoff = addr >> PAGE_SHIFT;
> 	struct vm_area_struct *vma, *orig_vma = NULL;
> 	unsigned long vaddr = 0;
>
> 	if (tu == NULL) {
> 		/* A NULL tu means that we already got the vaddr */
> 		return (void __force __user *) addr;
> 	}
>
> 	down_read(&current->mm->mmap_sem);
>
> 	vma = current->mm->mmap;

Cough, it can be null if another thread does munmap(0, TASK_SIZE) ;)

But this doesn't matter.

> 	do {
> 		if (!vma->vm_file || vma->vm_file->f_inode != tu->inode) {
> 			/*
> 			 * We found read-only mapping for this inode.
> 			 * (provided that all mappings for this inode
> 			 * have consecutive addresses)
> 			 */
> 			if (orig_vma)
> 				break;
> 			continue;
> 		}
>
> 		if (vma->vm_pgoff > pgoff ||
> 		    (vma->vm_pgoff + vma_pages(vma) <= pgoff))
> 			continue;
>
> 		orig_vma = vma;
>
> 		/*
> 		 * We prefer writable mapping over read-only since
> 		 * data is usually in read/write memory region.  But
> 		 * in case of read-only data, it only can be found in
> 		 * read-only mapping so we save orig_vma and check
> 		 * whether it also has writable mapping.
> 		 */
> 		if (vma->vm_flags & VM_WRITE)
> 			break;
> 	} while ((vma = vma->vm_next) != NULL);
>
> 	if (orig_vma)
> 		vaddr = offset_to_vaddr(orig_vma, addr);
>
> 	up_read(&current->mm->mmap_sem);
>
> 	return (void __force __user *) vaddr;
> }

For what? Why it is better then my suggestion?

How it can read bss? How it can read the data from other binaries?

How we can trust the result? This code relies on some guesses and
none of them are "strict".

If nothing else, elf can have the arbitrary number of mmaped sections,
this can't work in general?

Oleg.

