Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690Ab3GCMfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:35:52 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:52553 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab3GCMfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:35:50 -0400
X-AuditID: 9c93017e-b7c04ae00000295f-e8-51d41aa42de1
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hyeoncheol Lee <cheol.lee@lge.com>, LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCHSET 00/12] tracing/uprobes: Add support for more fetch methods
Date: Wed,  3 Jul 2013 21:35:34 +0900
Message-Id: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset implements memory (address), stack[N], deference,
bitfield and retval (it needs uretprobe tho) fetch methods for
uprobes.  It's based on the previous work [1] done by Hyeoncheol Lee.

Now kprobes and uprobes have their own fetch_type_tables and, in turn,
memory and stack access methods.  Other fetch methods are shared.

For the dereference method, I added a new argument to fetch functions.
It's because for uprobes it needs to know whether the given address is
a file offset or a virtual address in an user process.  For instance,
in case of fetching from a memory directly (like @offset) it should
convert the address (offset) to a virtual address of the process, but
if it's a dereferencing, the given address already has the virtual
address.

To determine this in a fetch function, I passed a pointer to
trace_uprobe for direct fetch, and passed NULL for dereference.


[1] https://lkml.org/lkml/2012/11/14/84

Simple example:

  # cat foo.c
  int glob = -1;
  char str[] = "hello uprobe.";

  struct foo {
    unsigned int unused: 2;
    unsigned int foo: 20;
    unsigned int bar: 10;
  } foo = {
    .foo = 5,
  };

  int main(int argc, char *argv[])
  {
    long local = 0x1234;

    return 127;
  }

  # gcc -o foo -g foo.c

  # objdump -d foo | grep -A9 -F '<main>'
  00000000004004b0 <main>:
    4004b0:	55                   	push   %rbp
    4004b1:	48 89 e5             	mov    %rsp,%rbp
    4004b4:	89 7d ec             	mov    %edi,-0x14(%rbp)
    4004b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    4004bb:	48 c7 45 f8 34 12 00 	movq   $0x1234,-0x8(%rbp)
    4004c2:	00 
    4004c3:	b8 7f 00 00 00       	mov    $0x7f,%eax
    4004c8:	5d                   	pop    %rbp
    4004c9:	c3                   	retq   

  # nm foo | grep -e glob$ -e str -e foo
  00000000006008bc D foo
  00000000006008a8 D glob
  00000000006008ac D str

  # perf probe -x /home/namhyung/tmp/foo -a 'foo=main+0x13 glob=@0x8a8:s32 \
  > str=@0x8ac:string bit=@0x8bc:b10@2/32 argc=%di local=-0x8(%bp)'
  Added new event:
    probe_foo:foo      (on 0x4c3 with glob=@0x8a8:s32 str=@0x8ac:string 
                                 bit=@0x8bc:b10@2/32 argc=%di local=-0x8(%bp))

  You can now use it in all perf tools, such as:

          perf record -e probe_foo:foo -aR sleep 1

  # perf record -e probe_foo:foo ./foo
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.001 MB perf.data (~33 samples) ]

  # perf script | grep -v ^#
               foo  2008 [002  2199.867154: probe_foo:foo (4004c3)
                   glob=4294967295 str="hello uprobe." bit=5 argc=1 local=1234

Note that 4294967295 is 0xffffffff.

Obviously, the perf tools also need to be improved.  I'll work on that
later.

This patchset is based on the current tip/perf/core.  I also put this
on my 'uprobe/fetch-v1' branch in my tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Any comments are welcome, thanks.
Namhyung


Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hyeoncheol Lee (2):
  tracing/kprobes: Move fetch functions to trace_kprobe.c
  tracing/kprobes: Add fetch{,_size} member into symbol and deref fetch
    method

Namhyung Kim (10):
  tracing/kprobes: Make stack and memory fetch functions static
  tracing/kprobes: Factor out struct trace_probe
  tracing/uprobes: Convert to struct trace_probe
  tracing/kprobes: Move common functions to trace_probe.c
  tracing/kprobes: Remove duplicate set_print_fmt()
  tracing/uprobes: Fetch args before reserving a ring buffer
  tracing/uprobes: Fix a comment for uprobe registration syntax
  tracing/kprobes: Add priv argument to fetch functions
  tracing/uprobes: Add more fetch functions
  tracing/uprobes: Add support for full argument access methods

 kernel/trace/trace_kprobe.c | 529 ++++++++++++++++++++++----------------------
 kernel/trace/trace_probe.c  | 451 ++++++++++++++++++-------------------
 kernel/trace/trace_probe.h  | 154 ++++++++++++-
 kernel/trace/trace_uprobe.c | 429 ++++++++++++++++++++++++-----------
 4 files changed, 926 insertions(+), 637 deletions(-)

-- 
1.7.11.7

