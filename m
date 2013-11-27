Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab3K0GUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 01:20:14 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56223 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3K0GUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 01:20:08 -0500
X-AuditID: 9c930197-b7caaae000001cef-a2-52958f1671ac
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCHSET 00/17] tracing/uprobes: Add support for more fetch methods (v7)
Date: Wed, 27 Nov 2013 15:19:46 +0900
Message-Id: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset implements memory (address), stack[N], deference,
bitfield, retval (it needs uretprobe tho) and file_offset fetch
methods for uprobes.  It's based on the previous work [1] done by
Hyeoncheol Lee.

Now kprobes and uprobes have their own fetch_type_tables and, in turn,
memory and stack access methods.  The symbol and file_offset fetch
methods are only available to kprobes and uprobes, respectively.
Other fetch methods are shared.

For the file_offset method, it translates the offset argument to a
virtual address in a process.  To do that, it calculates base mapping
address using probe address (utask->vaddr) and probe offset
(tu->offset) and then adds the argument offset.  Those info are
carried via utask and a new fetch parameter.

The syntax is '@+offset' where offset are relative address to the base
address.  For shared libraries, it'd be simply the st_value of symbol
in ELF format.  But for executable, it needs to subtract base load
address (e.g. 0x40000 for x86_64) from the symbol value.  Please see
previous discussion for an example [2] - Note that the syntax changed
to '@+' from plain '@'.  The plain '@addr' syntax is used for
accessing absolute memory address if you already know the exact address.

Many thanks to Oleg who provides valuable feedbacks and suggestions.

The patch 1-2 are bug fixes and can be applied independently.
The patch 16 is a preparation for patch 17 which implements the
file_offset fetch method.


 * v7 changes:
  - restructure patches not to break build with !CONFIG_[KU]PROBE_EVENT
  - print 0x prefix for unsigned types
  - add @+file_offset fetch method (Oleg)
  - get rid of uprobe_buffer_mutex (Oleg)
  - pass 'is_return' to uprobes argument parser


[1] https://lkml.org/lkml/2012/11/14/84
[2] https://lkml.org/lkml/2013/11/5/25

A simple example:

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

  # perf probe -x /home/namhyung/tmp/foo -a 'foo=main+0x13 glob=@0x6008a8:s32 \
  > str=@+0x2008ac:string bit=@+0x2008bc:b10@2/32 argc=%di:s32 local=-0x8(%bp)'
  Added new event:
    probe_foo:foo      (on 0x4c3 with glob=@0x6008a8:s32 str=@+0x2008ac:string 
                           bit=@+0x2008bc:b10@2/32 argc=%di:s32 local=-0x8(%bp))

  You can now use it in all perf tools, such as:

          perf record -e probe_foo:foo -aR sleep 1

  # perf record -e probe_foo:foo ./foo
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.001 MB perf.data (~33 samples) ]

  # perf script | grep -v ^#
               foo  2008 [002  2199.867154: probe_foo:foo (4004c3)
                   glob=-1 str="hello uprobe." bit=0x5 argc=1 local=0x1234


This patchset is based on the current for-next branch of the Steven
Rostedt's linux-trace tree.  I also put this on my 'uprobe/fetch-v7'
branch in my tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Any comments are welcome, thanks.
Namhyung


Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Hemant Kumar <hkshaw@linux.vnet.ibm.com>


Hyeoncheol Lee (1):
  tracing/probes: Add fetch{,_size} member into deref fetch method

Namhyung Kim (15):
  tracing/uprobes: Fix documentation of uprobe registration syntax
  tracing/probes: Fix basic print type functions
  tracing/kprobes: Factor out struct trace_probe
  tracing/uprobes: Convert to struct trace_probe
  tracing/kprobes: Move common functions to trace_probe.h
  tracing/probes: Integrate duplicate set_print_fmt()
  tracing/probes: Move fetch function helpers to trace_probe.h
  tracing/probes: Split [ku]probes_fetch_type_table
  tracing/probes: Implement 'stack' fetch method for uprobes
  tracing/probes: Move 'symbol' fetch method to kprobes
  tracing/probes: Implement 'memory' fetch method for uprobes
  tracing/uprobes: Pass 'is_return' to traceprobe_parse_probe_arg()
  tracing/uprobes: Fetch args before reserving a ring buffer
  tracing/uprobes: Add support for full argument access methods
  tracing/uprobes: Add @+file_offset fetch method

Oleg Nesterov (1):
  uprobes: Allocate ->utask before handler_chain() for tracing handlers

 Documentation/trace/uprobetracer.txt |  36 +-
 kernel/events/uprobes.c              |   4 +
 kernel/trace/trace_kprobe.c          | 666 +++++++++++++++++++----------------
 kernel/trace/trace_probe.c           | 458 ++++++++++--------------
 kernel/trace/trace_probe.h           | 220 +++++++++++-
 kernel/trace/trace_uprobe.c          | 481 ++++++++++++++++++-------
 6 files changed, 1140 insertions(+), 725 deletions(-)

-- 
1.7.11.7

