Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab3J3KgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:36:10 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:36630 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3J3KgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:36:08 -0400
Message-ID: <5270E112.3020107@hitachi.com>
Date: Wed, 30 Oct 2013 19:36:02 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCHSET 00/13] tracing/uprobes: Add support for more fetch
 methods (v6)
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1383029621-7384-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/29 15:53), Namhyung Kim wrote:
> Hello,
> 
> This patchset implements memory (address), stack[N], deference,
> bitfield and retval (it needs uretprobe tho) fetch methods for
> uprobes.  It's based on the previous work [1] done by Hyeoncheol Lee.
> 
> Now kprobes and uprobes have their own fetch_type_tables and, in turn,
> memory and stack access methods.  Other fetch methods are shared.
> 
> For the dereference method, I added a new argument to fetch functions.
> It's because for uprobes it needs to know whether the given address is
> a file offset or a virtual address in an user process.  For instance,
> in case of fetching from a memory directly (like @offset) it should
> convert the address (offset) to a virtual address of the process, but
> if it's a dereferencing, the given address already has the virtual
> address.
> 
> To determine this in a fetch function, I passed a pointer to
> trace_uprobe for direct fetch, and passed NULL for dereference.
> 
> The patch 1-2 are bug fixes and can be applied independently.

You'd better add [BUGFIX] and send those separately. ;)
But anyway, I'm OK to pull those first two (and others too).


> Please look at patch 10 that uses per-cpu buffer for accessing user
> memory as suggested by Steven.  While I tried hard not to mess things
> up there might be a chance I did something horrible.  It'd be great if
> you guys take a look and give comments.
> 
> 
>  * v6 changes:
>   - add more Ack's from Masami
>   - fix ref count of uprobe_cpu_buffer (thanks to Jovi)
> 
>  * v5 changes:
>   - use user_stack_pointer() instead of GET_USP()
>   - fix a bug in 'stack' fetch method of uprobes
> 
>  * v4 changes:
>   - add Ack's from Masami
>   - rearrange patches to make it easy for simple fixes to be applied
>   - update documentation
>   - use per-cpu buffer for storing args (thanks to Steve!)
> 
> 
> [1] https://lkml.org/lkml/2012/11/14/84
> 
> A simple example:
> 
>   # cat foo.c
>   int glob = -1;
>   char str[] = "hello uprobe.";
> 
>   struct foo {
>     unsigned int unused: 2;
>     unsigned int foo: 20;
>     unsigned int bar: 10;
>   } foo = {
>     .foo = 5,
>   };
> 
>   int main(int argc, char *argv[])
>   {
>     long local = 0x1234;
> 
>     return 127;
>   }
> 
>   # gcc -o foo -g foo.c
> 
>   # objdump -d foo | grep -A9 -F '<main>'
>   00000000004004b0 <main>:
>     4004b0:	55                   	push   %rbp
>     4004b1:	48 89 e5             	mov    %rsp,%rbp
>     4004b4:	89 7d ec             	mov    %edi,-0x14(%rbp)
>     4004b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
>     4004bb:	48 c7 45 f8 34 12 00 	movq   $0x1234,-0x8(%rbp)
>     4004c2:	00 
>     4004c3:	b8 7f 00 00 00       	mov    $0x7f,%eax
>     4004c8:	5d                   	pop    %rbp
>     4004c9:	c3                   	retq   
> 
>   # nm foo | grep -e glob$ -e str -e foo
>   00000000006008bc D foo
>   00000000006008a8 D glob
>   00000000006008ac D str
> 
>   # perf probe -x /home/namhyung/tmp/foo -a 'foo=main+0x13 glob=@0x8a8:s32 \
>   > str=@0x8ac:string bit=@0x8bc:b10@2/32 argc=%di local=-0x8(%bp)'
>   Added new event:
>     probe_foo:foo      (on 0x4c3 with glob=@0x8a8:s32 str=@0x8ac:string 
>                                  bit=@0x8bc:b10@2/32 argc=%di local=-0x8(%bp))
> 
>   You can now use it in all perf tools, such as:
> 
>           perf record -e probe_foo:foo -aR sleep 1
> 
>   # perf record -e probe_foo:foo ./foo
>   [ perf record: Woken up 1 times to write data ]
>   [ perf record: Captured and wrote 0.001 MB perf.data (~33 samples) ]
> 
>   # perf script | grep -v ^#
>                foo  2008 [002  2199.867154: probe_foo:foo (4004c3)
>                    glob=-1 str="hello uprobe." bit=5 argc=1 local=1234

Nice ! :)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


