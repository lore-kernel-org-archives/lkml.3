Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644Ab3C3C1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 22:27:32 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:62840 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab3C3C1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 22:27:30 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, x86@kernel.org
Cc: rth@twiddle.net, linux@arm.linux.org.uk, msalter@redhat.com,
        starvik@axis.com, dhowells@redhat.com, tony.luck@intel.com,
        benh@kernel.crashing.org, takata@linux-m32r.org, geert@linux-m68k.org,
        james.hogan@imgtec.com, monstr@monstr.eu, ralf@linux-mips.org,
        jonas@southpole.se, rkuo@codeaurora.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, davem@davemloft.net, lethal@linux-sh.org,
        vgupta@synopsys.com, chris@zankel.net, cmetcalf@tilera.com,
        ysato@users.sourceforge.jp, gxt@mprc.pku.edu.cn, jdike@addtoit.com
Subject: [PATCHSET] arch: unify task dump debug info
Date: Fri, 29 Mar 2013 19:27:03 -0700
Message-Id: <1364610428-2074-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

There are multiple ways a task can be dumped - explicit call to
dump_stack(), triggering WARN() or BUG(), through sysrq-t and so on.
Most of what gets printed is upto each architecture and the current
state is not particularly pretty.  Different pieces of information are
presented differently depending on which path the dump takes and which
architecture it's running on.  This is messy for no good reason and
makes it exceedingly difficult to add or modify debug information to
task dumps.

In all archs except for s390, there's nothing arch-specific about the
printed debug information.  This patchset updates all those archs to
use the same helpers to consistently print out the same debug
information.

An example WARN dump after this patchset.

 WARNING: at /work/os/work/kernel/workqueue.c:4840 init_workqueues+0x35/0x505()
 Modules linked in:
 Pid: 1, comm: swapper/0 Not tainted 3.9.0-rc1-work+ #18 empty empty/S3992
  0000000000000009 ffff88007c861e08 ffffffff81c61525 ffff88007c861e48
  ffffffff8108f500 ffffffff82228240 0000000000000040 ffffffff8234a041
  0000000000000000 0000000000000000 0000000000000000 ffff88007c861e58
 Call Trace:
  [<ffffffff81c61525>] dump_stack+0x19/0x1b
  [<ffffffff8108f500>] warn_slowpath_common+0x70/0xa0
  [<ffffffff8108f54a>] warn_slowpath_null+0x1a/0x20
  [<ffffffff8234a076>] init_workqueues+0x35/0x505
  ...

And BUG dump.

 kernel BUG at /work/os/work/kernel/workqueue.c:4841!
 invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
 Modules linked in:
 Pid: 1, comm: swapper/0 Tainted: G        W    3.9.0-rc1-work+ #20 empty empty/S3992
 CPU:0 task: ffff88007c85e040 ti: ffff88007c860000 task.ti: ffff88007c860000
 RIP: 0010:[<ffffffff8234a042>]  [<ffffffff8234a042>] init_workqueues+0x15/0x17
 RSP: 0000:ffff88007c861ec8  EFLAGS: 00010296
 RAX: 0000000000000024 RBX: ffffffff82446608 RCX: 0000000000000001
 ...
 Stack:
  ffff88007c861ef8 ffffffff81000312 ffffffff82446608 ffff88007c85e650
  0000000000000003 0000000000000000 ffff88007c861f38 ffffffff82335e5d
  ffff88007c862080 ffffffff8223d8c0 ffff88007c862080 ffffffff81c47730
 Call Trace:
  [<ffffffff81000312>] do_one_initcall+0x122/0x170
  [<ffffffff82335e5d>] kernel_init_freeable+0x9b/0x1c8
  ...

This patchset contains the following five patches.

 0001-x86-don-t-show-trace-beyond-show_stack-NULL-NULL.patch
 0002-sparc32-make-show_stack-acquire-fp-if-_ksp-is-not-sp.patch
 0003-dump_stack-consolidate-dump_stack-implementations-an.patch
 0004-dump_stack-implement-arch-specific-hardware-descript.patch
 0005-dump_stack-unify-debug-information-printed-by-show_r.patch

0001-0002 update stack dumping functions in x86 and sparc32 in
preparation.

0003 makes all arches except s390 and blackfin use generic
dump_stack().  blackfin still uses the generic helper to print the
same info.  s390 is left alone as its current debug info includes
arch-specific stuff.

0004 properly abstracts DMI identifier printing in WARN() and
show_regs() so that all dumps print out the information.  This enables
show_regs() to use the same debug info message.

0005 updates show_regs() of all arches except for s390 to use a common
generic helper to print debug info.

While this patchset changes how debug info is printed on some archs,
the printed information is always superset of what used to be there.

This patchset makes task dump debug messages consistent and enables
adding more information.  Workqueue is scheduled to add worker
information including the workqueue in use and work item specific
description.

This patchset is based on top of v3.9-rc4 and available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-unify-dump

While this patch touches a lot of archs, it isn't too likely to cause
non-trivial conflicts with arch-specfic changes and would probably be
best to route together either through -tip or -mm.

x86 is tested but other archs are either only compile tested or not
tested at all.  Changes to most archs are generally trivial.

diffstat follows.  Thanks.

 arch/alpha/kernel/process.c         |    1 
 arch/alpha/kernel/traps.c           |    7 ---
 arch/arc/kernel/stacktrace.c        |    7 ---
 arch/arc/kernel/troubleshoot.c      |    1 
 arch/arm/kernel/process.c           |    8 +---
 arch/arm/kernel/traps.c             |    7 ---
 arch/arm64/kernel/process.c         |    7 ---
 arch/arm64/kernel/traps.c           |    7 ---
 arch/avr32/kernel/process.c         |   13 +------
 arch/blackfin/kernel/dumpstack.c    |    1 
 arch/blackfin/kernel/trace.c        |    2 +
 arch/c6x/kernel/traps.c             |   10 -----
 arch/cris/arch-v10/kernel/process.c |    3 +
 arch/cris/arch-v32/kernel/process.c |    3 +
 arch/cris/kernel/traps.c            |    7 ---
 arch/frv/kernel/traps.c             |   14 -------
 arch/h8300/kernel/process.c         |    2 +
 arch/h8300/kernel/traps.c           |    7 ---
 arch/hexagon/kernel/traps.c         |    8 ----
 arch/hexagon/kernel/vm_events.c     |    2 +
 arch/ia64/kernel/process.c          |   12 +-----
 arch/ia64/kernel/setup.c            |    1 
 arch/m32r/kernel/process.c          |    2 +
 arch/m32r/kernel/traps.c            |    9 ----
 arch/m68k/kernel/traps.c            |   12 ------
 arch/metag/kernel/process.c         |    2 +
 arch/metag/kernel/traps.c           |    6 ---
 arch/microblaze/kernel/process.c    |    2 +
 arch/microblaze/kernel/traps.c      |    6 ---
 arch/mips/kernel/traps.c            |   15 --------
 arch/mn10300/kernel/process.c       |    1 
 arch/mn10300/kernel/traps.c         |   11 ------
 arch/openrisc/kernel/process.c      |    1 
 arch/openrisc/kernel/traps.c        |   11 ------
 arch/parisc/kernel/traps.c          |   10 +----
 arch/powerpc/kernel/process.c       |   14 +------
 arch/score/kernel/traps.c           |   12 +-----
 arch/sh/kernel/dumpstack.c          |    6 ---
 arch/sh/kernel/process_32.c         |    6 ---
 arch/sh/kernel/process_64.c         |    1 
 arch/sparc/kernel/process_32.c      |   23 ++++--------
 arch/sparc/kernel/process_64.c      |    2 +
 arch/sparc/kernel/traps_64.c        |    7 ---
 arch/tile/kernel/process.c          |    3 -
 arch/um/kernel/sysrq.c              |   12 ------
 arch/um/sys-ppc/sysrq.c             |    2 +
 arch/unicore32/kernel/process.c     |    6 ---
 arch/unicore32/kernel/traps.c       |    6 ---
 arch/x86/include/asm/bug.h          |    3 -
 arch/x86/kernel/dumpstack.c         |   28 ++++++---------
 arch/x86/kernel/dumpstack_32.c      |    4 --
 arch/x86/kernel/dumpstack_64.c      |    6 ---
 arch/x86/kernel/process.c           |   24 -------------
 arch/x86/kernel/process_32.c        |    2 -
 arch/x86/kernel/process_64.c        |    1 
 arch/x86/kernel/setup.c             |    1 
 arch/xtensa/kernel/traps.c          |   10 +----
 drivers/firmware/dmi_scan.c         |   26 ++++++++++++++
 include/linux/dmi.h                 |    2 +
 include/linux/printk.h              |    4 ++
 kernel/panic.c                      |    6 ---
 lib/dump_stack.c                    |   66 ++++++++++++++++++++++++++++++++++--
 62 files changed, 167 insertions(+), 334 deletions(-)

--
tejun
