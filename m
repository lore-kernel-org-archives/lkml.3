Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbaH0C34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 22:29:56 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:58955 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756994AbaH0C3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 22:29:54 -0400
From: Alexei Starovoitov <ast@plumgrid.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v7 net-next 00/28] BPF syscall
Date: Tue, 26 Aug 2014 19:29:14 -0700
Message-Id: <1409106582-10095-1-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, David,

posting whole thing again as RFC to get feedback on syscall only.
If syscall bpf(int cmd, union bpf_attr *attr, unsigned int size) is ok,
I'll split them into small chunks as requested and will repost without RFC.

Right now please only review syscall API
patch 0003 introduces sys_bpf and first BPF_MAP_CREATE command
patch 0005 adds four more commands to the same syscall
patch 0007 adds BPF_PROG_LOAD command
patch 0010 extends BPF_PROG_LOAD command with 3 more attributes
patch 0021 adds user space wrapper for BPF syscall
patch 0023 uses these wrappers in verifier testsuite

Note that additions of commands and attributes kept this syscall
backwards compatible from one patch to another.
I've decided not to bother with forward compatiblity for now.
We can address it later the way perf_event_open did.

Please ignore other patches, since I cannot easily remove them
without breaking compilation

btw, tested on x64/i386 and comiled tested on arm with NET-less config.

V6->V7:
- only BPF syscall interface changed from long+nlattr+a_lot_of_type_casts to
  single 'union bpf_attr'.
  It pretty much removed all type casts in kernel and in user space that
  were there because of 'long' and because of 'nlattr'

Thanks for feedback. I think this version is definitely cleaner.
As a side note I've addressed Cong's comment regarding commit log.
Now it documents syscall itself instead of wrappers of syscall.

If anyone prefers to see patches in the browser, they are here:
https://git.kernel.org/cgit/linux/kernel/git/ast/bpf.git/log/?h=v7

Thanks!

Alexei Starovoitov (28):
  net: filter: add "load 64-bit immediate" eBPF instruction
  net: filter: split filter.h and expose eBPF to user space
  bpf: introduce syscall(BPF, ...) and BPF maps
  bpf: enable bpf syscall on x64 and i386
  bpf: add lookup/update/delete/iterate methods to BPF maps
  bpf: add hashtable type of BPF maps
  bpf: expand BPF syscall with program load/unload
  bpf: handle pseudo BPF_CALL insn
  bpf: verifier (add docs)
  bpf: verifier (add ability to receive verification log)
  bpf: handle pseudo BPF_LD_IMM64 insn
  bpf: verifier (add branch/goto checks)
  bpf: verifier (add verifier core)
  bpf: verifier (add state prunning optimization)
  bpf: allow eBPF programs to use maps
  bpf: split eBPF out of NET
  tracing: allow eBPF programs to be attached to events
  tracing: allow eBPF programs call printk()
  tracing: allow eBPF programs to be attached to kprobe/kretprobe
  tracing: allow eBPF programs to call ktime_get_ns() and get_current()
  samples: bpf: add mini eBPF library to manipulate maps and programs
  samples: bpf: example of tracing filters with eBPF
  bpf: verifier test
  bpf: llvm backend
  samples: bpf: elf file loader
  samples: bpf: eBPF example in C
  samples: bpf: counting eBPF example in C
  samples: bpf: IO latency analysis (iosnoop/heatmap)

 Documentation/networking/filter.txt                |  313 +++-
 arch/Kconfig                                       |    3 +
 arch/x86/net/bpf_jit_comp.c                        |   17 +
 arch/x86/syscalls/syscall_32.tbl                   |    1 +
 arch/x86/syscalls/syscall_64.tbl                   |    1 +
 fs/btrfs/super.c                                   |    3 +
 include/linux/bpf.h                                |  139 ++
 include/linux/filter.h                             |  303 +---
 include/linux/ftrace_event.h                       |    5 +
 include/linux/syscalls.h                           |    3 +-
 include/trace/bpf_trace.h                          |   23 +
 include/trace/ftrace.h                             |   25 +
 include/uapi/asm-generic/unistd.h                  |    4 +-
 include/uapi/linux/Kbuild                          |    1 +
 include/uapi/linux/bpf.h                           |  439 +++++
 kernel/Makefile                                    |    2 +-
 kernel/bpf/Makefile                                |    2 +-
 kernel/bpf/core.c                                  |   17 +
 kernel/bpf/hashtab.c                               |  365 ++++
 kernel/bpf/syscall.c                               |  645 +++++++
 kernel/bpf/verifier.c                              | 1910 ++++++++++++++++++++
 kernel/sys_ni.c                                    |    3 +
 kernel/trace/Kconfig                               |    1 +
 kernel/trace/Makefile                              |    1 +
 kernel/trace/bpf_trace.c                           |  264 +++
 kernel/trace/trace.h                               |    3 +
 kernel/trace/trace_events.c                        |   41 +-
 kernel/trace/trace_events_filter.c                 |   72 +-
 kernel/trace/trace_kprobe.c                        |   28 +
 kernel/trace/trace_syscalls.c                      |   32 +
 lib/test_bpf.c                                     |   21 +
 net/Kconfig                                        |    1 +
 net/core/filter.c                                  |    2 +
 samples/bpf/Makefile                               |   28 +
 samples/bpf/bpf_helpers.h                          |   27 +
 samples/bpf/bpf_load.c                             |  234 +++
 samples/bpf/bpf_load.h                             |   26 +
 samples/bpf/dropmon.c                              |  122 ++
 samples/bpf/ex1_kern.c                             |   27 +
 samples/bpf/ex1_user.c                             |   24 +
 samples/bpf/ex2_kern.c                             |   73 +
 samples/bpf/ex2_user.c                             |   94 +
 samples/bpf/ex3_kern.c                             |  104 ++
 samples/bpf/ex3_user.c                             |  149 ++
 samples/bpf/libbpf.c                               |   89 +
 samples/bpf/libbpf.h                               |   21 +
 samples/bpf/test_verifier.c                        |  599 ++++++
 tools/bpf/llvm/.gitignore                          |   54 +
 tools/bpf/llvm/LICENSE.TXT                         |   70 +
 tools/bpf/llvm/Makefile.rules                      |  641 +++++++
 tools/bpf/llvm/README.txt                          |   23 +
 tools/bpf/llvm/bld/Makefile                        |   27 +
 tools/bpf/llvm/bld/Makefile.common                 |   14 +
 tools/bpf/llvm/bld/Makefile.config                 |  124 ++
 .../llvm/bld/include/llvm/Config/AsmParsers.def    |    8 +
 .../llvm/bld/include/llvm/Config/AsmPrinters.def   |    9 +
 .../llvm/bld/include/llvm/Config/Disassemblers.def |    8 +
 tools/bpf/llvm/bld/include/llvm/Config/Targets.def |    9 +
 .../bpf/llvm/bld/include/llvm/Support/DataTypes.h  |   96 +
 tools/bpf/llvm/bld/lib/Makefile                    |   11 +
 .../llvm/bld/lib/Target/BPF/InstPrinter/Makefile   |   10 +
 .../llvm/bld/lib/Target/BPF/MCTargetDesc/Makefile  |   11 +
 tools/bpf/llvm/bld/lib/Target/BPF/Makefile         |   17 +
 .../llvm/bld/lib/Target/BPF/TargetInfo/Makefile    |   10 +
 tools/bpf/llvm/bld/lib/Target/Makefile             |   11 +
 tools/bpf/llvm/bld/tools/Makefile                  |   12 +
 tools/bpf/llvm/bld/tools/llc/Makefile              |   15 +
 tools/bpf/llvm/lib/Target/BPF/BPF.h                |   28 +
 tools/bpf/llvm/lib/Target/BPF/BPF.td               |   29 +
 tools/bpf/llvm/lib/Target/BPF/BPFAsmPrinter.cpp    |  100 +
 tools/bpf/llvm/lib/Target/BPF/BPFCallingConv.td    |   24 +
 tools/bpf/llvm/lib/Target/BPF/BPFFrameLowering.cpp |   36 +
 tools/bpf/llvm/lib/Target/BPF/BPFFrameLowering.h   |   35 +
 tools/bpf/llvm/lib/Target/BPF/BPFISelDAGToDAG.cpp  |  182 ++
 tools/bpf/llvm/lib/Target/BPF/BPFISelLowering.cpp  |  683 +++++++
 tools/bpf/llvm/lib/Target/BPF/BPFISelLowering.h    |  105 ++
 tools/bpf/llvm/lib/Target/BPF/BPFInstrFormats.td   |   29 +
 tools/bpf/llvm/lib/Target/BPF/BPFInstrInfo.cpp     |  162 ++
 tools/bpf/llvm/lib/Target/BPF/BPFInstrInfo.h       |   53 +
 tools/bpf/llvm/lib/Target/BPF/BPFInstrInfo.td      |  498 +++++
 tools/bpf/llvm/lib/Target/BPF/BPFMCInstLower.cpp   |   77 +
 tools/bpf/llvm/lib/Target/BPF/BPFMCInstLower.h     |   40 +
 tools/bpf/llvm/lib/Target/BPF/BPFRegisterInfo.cpp  |  122 ++
 tools/bpf/llvm/lib/Target/BPF/BPFRegisterInfo.h    |   65 +
 tools/bpf/llvm/lib/Target/BPF/BPFRegisterInfo.td   |   39 +
 tools/bpf/llvm/lib/Target/BPF/BPFSubtarget.cpp     |   23 +
 tools/bpf/llvm/lib/Target/BPF/BPFSubtarget.h       |   33 +
 tools/bpf/llvm/lib/Target/BPF/BPFTargetMachine.cpp |   66 +
 tools/bpf/llvm/lib/Target/BPF/BPFTargetMachine.h   |   69 +
 .../lib/Target/BPF/InstPrinter/BPFInstPrinter.cpp  |   81 +
 .../lib/Target/BPF/InstPrinter/BPFInstPrinter.h    |   34 +
 .../lib/Target/BPF/MCTargetDesc/BPFAsmBackend.cpp  |   89 +
 .../llvm/lib/Target/BPF/MCTargetDesc/BPFBaseInfo.h |   33 +
 .../Target/BPF/MCTargetDesc/BPFELFObjectWriter.cpp |   56 +
 .../lib/Target/BPF/MCTargetDesc/BPFMCAsmInfo.h     |   34 +
 .../Target/BPF/MCTargetDesc/BPFMCCodeEmitter.cpp   |  167 ++
 .../Target/BPF/MCTargetDesc/BPFMCTargetDesc.cpp    |  115 ++
 .../lib/Target/BPF/MCTargetDesc/BPFMCTargetDesc.h  |   56 +
 .../lib/Target/BPF/TargetInfo/BPFTargetInfo.cpp    |   13 +
 tools/bpf/llvm/tools/llc/llc.cpp                   |  381 ++++
 100 files changed, 10742 insertions(+), 302 deletions(-)
 create mode 100644 include/linux/bpf.h
 create mode 100644 include/trace/bpf_trace.h
 create mode 100644 include/uapi/linux/bpf.h
 create mode 100644 kernel/bpf/hashtab.c
 create mode 100644 kernel/bpf/syscall.c
 create mode 100644 kernel/bpf/verifier.c
 create mode 100644 kernel/trace/bpf_trace.c
 create mode 100644 samples/bpf/Makefile
 create mode 100644 samples/bpf/bpf_helpers.h
 create mode 100644 samples/bpf/bpf_load.c
 create mode 100644 samples/bpf/bpf_load.h
 create mode 100644 samples/bpf/dropmon.c
 create mode 100644 samples/bpf/ex1_kern.c
 create mode 100644 samples/bpf/ex1_user.c
 create mode 100644 samples/bpf/ex2_kern.c
 create mode 100644 samples/bpf/ex2_user.c
 create mode 100644 samples/bpf/ex3_kern.c
 create mode 100644 samples/bpf/ex3_user.c
 create mode 100644 samples/bpf/libbpf.c
 create mode 100644 samples/bpf/libbpf.h
 create mode 100644 samples/bpf/test_verifier.c
 create mode 100644 tools/bpf/llvm/.gitignore
 create mode 100644 tools/bpf/llvm/LICENSE.TXT
 create mode 100644 tools/bpf/llvm/Makefile.rules
 create mode 100644 tools/bpf/llvm/README.txt
 create mode 100644 tools/bpf/llvm/bld/Makefile
 create mode 100644 tools/bpf/llvm/bld/Makefile.common
 create mode 100644 tools/bpf/llvm/bld/Makefile.config
 create mode 100644 tools/bpf/llvm/bld/include/llvm/Config/AsmParsers.def
 create mode 100644 tools/bpf/llvm/bld/include/llvm/Config/AsmPrinters.def
 create mode 100644 tools/bpf/llvm/bld/include/llvm/Config/Disassemblers.def
 create mode 100644 tools/bpf/llvm/bld/include/llvm/Config/Targets.def
 create mode 100644 tools/bpf/llvm/bld/include/llvm/Support/DataTypes.h
 create mode 100644 tools/bpf/llvm/bld/lib/Makefile
 create mode 100644 tools/bpf/llvm/bld/lib/Target/BPF/InstPrinter/Makefile
 create mode 100644 tools/bpf/llvm/bld/lib/Target/BPF/MCTargetDesc/Makefile
 create mode 100644 tools/bpf/llvm/bld/lib/Target/BPF/Makefile
 create mode 100644 tools/bpf/llvm/bld/lib/Target/BPF/TargetInfo/Makefile
 create mode 100644 tools/bpf/llvm/bld/lib/Target/Makefile
 create mode 100644 tools/bpf/llvm/bld/tools/Makefile
 create mode 100644 tools/bpf/llvm/bld/tools/llc/Makefile
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/BPF.h
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/BPF.td
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/BPFAsmPrinter.cpp
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/BPFCallingConv.td
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/BPFFrameLowering.cpp
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/BPFFrameLowering.h
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/BPFISelDAGToDAG.cpp
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/BPFISelLowering.cpp
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/BPFISelLowering.h
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/BPFInstrFormats.td
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/BPFInstrInfo.cpp
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/BPFInstrInfo.h
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/BPFInstrInfo.td
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/BPFMCInstLower.cpp
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/BPFMCInstLower.h
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/BPFRegisterInfo.cpp
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/BPFRegisterInfo.h
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/BPFRegisterInfo.td
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/BPFSubtarget.cpp
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/BPFSubtarget.h
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/BPFTargetMachine.cpp
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/BPFTargetMachine.h
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/InstPrinter/BPFInstPrinter.cpp
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/InstPrinter/BPFInstPrinter.h
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/MCTargetDesc/BPFAsmBackend.cpp
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/MCTargetDesc/BPFBaseInfo.h
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/MCTargetDesc/BPFELFObjectWriter.cpp
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/MCTargetDesc/BPFMCAsmInfo.h
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/MCTargetDesc/BPFMCCodeEmitter.cpp
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/MCTargetDesc/BPFMCTargetDesc.cpp
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/MCTargetDesc/BPFMCTargetDesc.h
 create mode 100644 tools/bpf/llvm/lib/Target/BPF/TargetInfo/BPFTargetInfo.cpp
 create mode 100644 tools/bpf/llvm/tools/llc/llc.cpp

-- 
1.7.9.5

