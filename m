Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763197Ab3DCTPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:15:35 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:42887 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763014Ab3DCTPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:15:31 -0400
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
Subject: [PATCHSET v2] arch: unify task dump debug info
Date: Wed,  3 Apr 2013 12:14:50 -0700
Message-Id: <1365016497-32033-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Andrew, I think it's about ready and nobody seems to be against the
proposed changes.  Can you please take these into -mm?

This v2 of this patchset.  Changes from the last posting[1] are,

* CPU is now printed for both dump_stack() and show_regs() which s390
  folks tell me should be enough to allow converting s390 to use the
  generic version.

* s390 converted.

* DMI arch ID now uses the same ID string as the debug "DMI: "
  printout during boot as suggested by Bjorn Helgaas.

* arc duplicate removal patch folded in.

* Build breakage on blackfin should be fixed now.

* Rebased on top of -mm.

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

 WARNING: at /work/os/work/kernel/workqueue.c:4841 init_workqueues+0x35/0x505()
 Modules linked in:
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.9.0-rc1-work+ #3
 Hardware name: empty empty/S3992, BIOS 080011  10/26/2007
  0000000000000009 ffff88007c861e08 ffffffff81c614dc ffff88007c861e48
  ffffffff8108f500 ffffffff82228240 0000000000000040 ffffffff8234a08e
  0000000000000000 0000000000000000 0000000000000000 ffff88007c861e58
 Call Trace:
  [<ffffffff81c614dc>] dump_stack+0x19/0x1b
  [<ffffffff8108f500>] warn_slowpath_common+0x70/0xa0
  [<ffffffff8108f54a>] warn_slowpath_null+0x1a/0x20
  [<ffffffff8234a0c3>] init_workqueues+0x35/0x505
  ...

And BUG dump.

 kernel BUG at /work/os/work/kernel/workqueue.c:4841!
 invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
 Modules linked in:
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.9.0-rc1-work+ #7
 Hardware name: empty empty/S3992, BIOS 080011  10/26/2007
 task: ffff88007c85e040 ti: ffff88007c860000 task.ti: ffff88007c860000
 RIP: 0010:[<ffffffff8234a07e>]  [<ffffffff8234a07e>] init_workqueues+0x4/0x6
 RSP: 0000:ffff88007c861ec8  EFLAGS: 00010246
 RAX: ffff88007c861fd8 RBX: ffffffff824466a8 RCX: 0000000000000001
 RDX: 0000000000000046 RSI: 0000000000000001 RDI: ffffffff8234a07a
 RBP: ffff88007c861ec8 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff8234a07a
 R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 FS:  0000000000000000(0000) GS:ffff88007dc00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: ffff88015f7ff000 CR3: 00000000021f1000 CR4: 00000000000007f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Stack:
  ffff88007c861ef8 ffffffff81000312 ffffffff824466a8 ffff88007c85e650
  0000000000000003 0000000000000000 ffff88007c861f38 ffffffff82335e5d
  ffff88007c862080 ffffffff8223d8c0 ffff88007c862080 ffffffff81c47760
 Call Trace:
  [<ffffffff81000312>] do_one_initcall+0x122/0x170
  [<ffffffff82335e5d>] kernel_init_freeable+0x9b/0x1c8
  [<ffffffff81c47760>] ? rest_init+0x140/0x140
  [<ffffffff81c4776e>] kernel_init+0xe/0xf0
  [<ffffffff81c6be9c>] ret_from_fork+0x7c/0xb0
  [<ffffffff81c47760>] ? rest_init+0x140/0x140
  ...

This patchset contains the following seven patches.

 0001-x86-don-t-show-trace-beyond-show_stack-NULL-NULL.patch
 0002-sparc32-make-show_stack-acquire-fp-if-_ksp-is-not-sp.patch
 0003-dump_stack-consolidate-dump_stack-implementations-an.patch
 0004-dmi-morph-dmi_dump_ids-into-dmi_format_ids-which-for.patch
 0005-dump_stack-implement-arch-specific-hardware-descript.patch
 0006-dump_stack-unify-debug-information-printed-by-show_r.patch
 0007-arc-print-fatal-signals-reduce-duplicated-informatio.patch

0001-0002 update stack dumping functions in x86 and sparc32 in
preparation.

0003 makes all arches except blackfin use generic dump_stack().
blackfin still uses the generic helper to print the same info.

0004-0005 properly abstract DMI identifier printing in WARN() and
show_regs() so that all dumps print out the information.  This enables
show_regs() to use the same debug info message.

0006 updates show_regs() of all arches to use a common generic helper
to print debug info.

0007 removes somem duplicate information from arc dumps.

While this patchset changes how debug info is printed on some archs,
the printed information is always superset of what used to be there.

This patchset makes task dump debug messages consistent and enables
adding more information.  Workqueue is scheduled to add worker
information including the workqueue in use and work item specific
description.

This patchset is based on top of -mm as of 2013/04/03 and available in
the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-unify-dump

While this patch touches a lot of archs, it isn't too likely to cause
non-trivial conflicts with arch-specfic changes and would probably be
best to route together either through -mm.

x86 is tested but other archs are either only compile tested or not
tested at all.  Changes to most archs are generally trivial.

diffstat follows.  Thanks.

 arch/alpha/kernel/process.c         |    1 
 arch/alpha/kernel/traps.c           |    7 ----
 arch/arc/kernel/stacktrace.c        |    7 ----
 arch/arc/kernel/troubleshoot.c      |    3 +
 arch/arm/kernel/process.c           |    8 +---
 arch/arm/kernel/traps.c             |    7 ----
 arch/arm64/kernel/process.c         |    7 ----
 arch/arm64/kernel/traps.c           |    7 ----
 arch/avr32/kernel/process.c         |   13 +------
 arch/blackfin/kernel/dumpstack.c    |    1 
 arch/blackfin/kernel/trace.c        |    2 +
 arch/c6x/kernel/traps.c             |   10 ------
 arch/cris/arch-v10/kernel/process.c |    3 +
 arch/cris/arch-v32/kernel/process.c |    3 +
 arch/cris/kernel/traps.c            |    7 ----
 arch/frv/kernel/traps.c             |   14 --------
 arch/h8300/kernel/process.c         |    2 +
 arch/h8300/kernel/traps.c           |    7 ----
 arch/hexagon/kernel/traps.c         |    8 ----
 arch/hexagon/kernel/vm_events.c     |    2 +
 arch/ia64/kernel/process.c          |   12 +------
 arch/ia64/kernel/setup.c            |    1 
 arch/m32r/kernel/process.c          |    2 +
 arch/m32r/kernel/traps.c            |    9 -----
 arch/m68k/kernel/traps.c            |   12 -------
 arch/metag/kernel/process.c         |    2 +
 arch/metag/kernel/traps.c           |    6 ---
 arch/microblaze/kernel/process.c    |    2 +
 arch/microblaze/kernel/traps.c      |    6 ---
 arch/mips/kernel/traps.c            |   15 ---------
 arch/mn10300/kernel/process.c       |    1 
 arch/mn10300/kernel/traps.c         |   11 ------
 arch/openrisc/kernel/process.c      |    1 
 arch/openrisc/kernel/traps.c        |   11 ------
 arch/parisc/kernel/traps.c          |   10 +-----
 arch/powerpc/kernel/process.c       |   14 +-------
 arch/s390/kernel/dumpstack.c        |   26 ---------------
 arch/score/kernel/traps.c           |   12 +------
 arch/sh/kernel/dumpstack.c          |    6 ---
 arch/sh/kernel/process_32.c         |    6 ---
 arch/sh/kernel/process_64.c         |    1 
 arch/sparc/kernel/process_32.c      |   23 ++++---------
 arch/sparc/kernel/process_64.c      |    2 +
 arch/sparc/kernel/traps_64.c        |    7 ----
 arch/tile/kernel/process.c          |    3 -
 arch/um/kernel/sysrq.c              |   12 -------
 arch/um/sys-ppc/sysrq.c             |    2 +
 arch/unicore32/kernel/process.c     |    6 ---
 arch/unicore32/kernel/traps.c       |    6 ---
 arch/x86/include/asm/bug.h          |    3 -
 arch/x86/kernel/dumpstack.c         |   28 ++++++----------
 arch/x86/kernel/dumpstack_32.c      |    4 --
 arch/x86/kernel/dumpstack_64.c      |    6 ---
 arch/x86/kernel/process.c           |   24 --------------
 arch/x86/kernel/process_32.c        |    2 -
 arch/x86/kernel/process_64.c        |    1 
 arch/x86/kernel/setup.c             |    1 
 arch/xtensa/kernel/traps.c          |   10 +-----
 drivers/firmware/dmi_scan.c         |   57 ++++++++++++++++++++++++----------
 include/linux/dmi.h                 |    2 +
 include/linux/printk.h              |   15 +++++++++
 kernel/panic.c                      |    6 ---
 kernel/printk.c                     |   60 ++++++++++++++++++++++++++++++++++++
 kernel/signal.c                     |    3 -
 lib/dump_stack.c                    |   11 ++++--
 65 files changed, 200 insertions(+), 379 deletions(-)

--
tejun

[1] https://lkml.org/lkml/2013/3/29/354
