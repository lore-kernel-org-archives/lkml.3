Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab3KBPxq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 11:53:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854Ab3KBPxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 11:53:43 -0400
Date: Sat, 2 Nov 2013 16:54:58 +0100
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
Message-ID: <20131102155458.GA6981@redhat.com>
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383029621-7384-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Let me first apologize again if this was already discussed. And I also
need to mention that I know almost nothing about elf/randomization/etc.

However,

On 10/29, Namhyung Kim wrote:
>
>   # nm foo | grep -e glob$ -e str -e foo
>   00000000006008bc D foo
>   00000000006008a8 D glob
>   00000000006008ac D str
>
>   # perf probe -x /home/namhyung/tmp/foo -a 'foo=main+0x13 glob=@0x8a8:s32 \

This does not look right to me.

- get_user_vaddr() is costly, it does vma_interval_tree_foreach() under
  ->i_mmap_mutex.

- this only allows to read the data from the same binary.

- in particular, you can't read the data from bss

- get_user_vaddr() looks simply wrong. I blindly applied the whole series
  and did the test to ensure.

  Test-case:

	#include <stdio.h>
	#include <stdlib.h>
	#include <unistd.h>

	unsigned int global = 0x1234;

	void func(void)
	{
	}

	int main(void)
	{
		char cmd[64];

		global = 0x4321;
		func();

		printf("addr = %p\n", &global);

		sprintf(cmd, "cat /proc/%d/maps", getpid());
		system(cmd);

		return 0;
	}

	# nm foo | grep -w global
	0000000000600a04 D global

	# perf probe -x ./foo -a "func var=@0xa04:u32"
	# perf record -e probe_foo:func ./foo
	addr = 0x600a04
	00400000-00401000 r-xp 00000000 fe:01 20958                              /root/foo
	00600000-00601000 rw-p 00000000 fe:01 20958                              /root/foo
	...

	# perf script | tail -1
		foo   555 [000]  1302.345642: probe_foo:func: (40059c) var=1234

	Note that it reports "1234", not "4321". This is because
	get_user_vaddr() finds another (1st) read-only mapping, and
	prints the initial value of "global".

	IOW, it reads the memory from 0x400a04, not from 0x600a04.

-------------------------------------------------------------------------------
Can't we simply implement get_user_vaddr() as

	static void __user *get_user_vaddr(unsigned long addr, struct trace_uprobe *tu)
	{
		void __user *vaddr = (void __force __user *)addr;

		/* A NULL tu means that we already got the vaddr */
		if (tu)
			vaddr += (current->mm->start_data & PAGE_MASK);

		return vaddr;
	}

?

I did this change, and now the test-case above works. And it also works
with "cc -pie -fPIC",

	# nm foo | grep -w global
	0000000000200c9c D global

	# perf probe -x ./foo -a "func var=@0xc9c:u32"
	# perf record -e probe_foo:func ./foo
	...
	# perf script | tail -1
		foo   576 [001]   475.519940: probe_foo:func: (7ffe95ca3814) var=4321

What do you think?

-------------------------------------------------------------------------------
Note:
	- I think that /* A NULL tu means that we already got the vaddr */
	  needs more discussion... IOW, I am not sure about 11/13.

	- Perhaps it also makes sense to allow to pass the absolute address
	  (iow, += start_data should be conditional)

but lets ignore this for now.

Oleg.

