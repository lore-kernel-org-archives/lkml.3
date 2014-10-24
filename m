Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbaJXW6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:58:24 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:32950 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbaJXW6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:58:22 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Vince Weaver <vince@deater.net>, "hillf.zj" <hillf.zj@alibaba-inc.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 0/8] CR4 handling improvements
Date: Fri, 24 Oct 2014 15:58:05 -0700
Message-Id: <cover.1414190806.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This little series tightens up rdpmc permissions.  With it applied,
rdpmc can only be used if a perf_event is actually mmapped.  For now,
this is only really useful for seccomp.

At some point this could be further tightened up to only allow rdpmc
if an actual self-monitoring perf event that is compatible with
rdpmc is mapped.

This should add <50ns to context switches between rdpmc-capable and
rdpmc-non-capable mms.  I suspect that this is well under 10%
overhead, given that perf already adds some context switch latency.

I think that patches 1-3 are a good idea regardless of any rdpmc changes.

AMD Uncore userspace rdpmc is broken by these patches (cap_user_rdpmc
will be zero), but it was broken anyway.

Changes from v1 (aka RFC):
 - Rebased on top of the KVM CR4 fix.  This applies to a very recent -linus.
 - Renamed the cr4 helpers (Peter, Borislav)
 - Fixed buggy cr4 helpers (Hilf)
 - Improved lots of comments (everyone)
 - Renamed read_cr4 and write_cr4 to make sure I didn't miss anything.
   (NB: This will introduce conflicts with Andi's FSGSBASE work.  This is
    a good thing.)

Andy Lutomirski (7):
  x86: Clean up cr4 manipulation
  x86: Store a per-cpu shadow copy of CR4
  x86: Add a comment clarifying LDT context switching
  perf: Add pmu callbacks to track event mapping and unmapping
  perf: Pass the event to arch_perf_update_userpage
  x86, perf: Only allow rdpmc if a perf_event is mapped
  x86, perf: Add /sys/devices/cpu/rdpmc=2 to allow rdpmc for all tasks

Peter Zijlstra (1):
  perf: Clean up pmu::event_idx

 arch/powerpc/perf/hv-24x7.c          |  6 ---
 arch/powerpc/perf/hv-gpci.c          |  6 ---
 arch/s390/kernel/perf_cpum_sf.c      |  6 ---
 arch/x86/include/asm/mmu.h           |  2 +
 arch/x86/include/asm/mmu_context.h   | 32 ++++++++++++++-
 arch/x86/include/asm/paravirt.h      |  6 +--
 arch/x86/include/asm/processor.h     | 33 ----------------
 arch/x86/include/asm/special_insns.h |  6 +--
 arch/x86/include/asm/tlbflush.h      | 77 ++++++++++++++++++++++++++++++++----
 arch/x86/include/asm/virtext.h       |  5 ++-
 arch/x86/kernel/acpi/sleep.c         |  2 +-
 arch/x86/kernel/cpu/common.c         | 17 +++++---
 arch/x86/kernel/cpu/mcheck/mce.c     |  3 +-
 arch/x86/kernel/cpu/mcheck/p5.c      |  3 +-
 arch/x86/kernel/cpu/mcheck/winchip.c |  3 +-
 arch/x86/kernel/cpu/mtrr/cyrix.c     |  6 +--
 arch/x86/kernel/cpu/mtrr/generic.c   |  6 +--
 arch/x86/kernel/cpu/perf_event.c     | 76 ++++++++++++++++++++++++++---------
 arch/x86/kernel/cpu/perf_event.h     |  2 +
 arch/x86/kernel/head32.c             |  1 +
 arch/x86/kernel/head64.c             |  2 +
 arch/x86/kernel/i387.c               |  3 +-
 arch/x86/kernel/process.c            |  5 ++-
 arch/x86/kernel/process_32.c         |  2 +-
 arch/x86/kernel/process_64.c         |  2 +-
 arch/x86/kernel/setup.c              |  2 +-
 arch/x86/kernel/xsave.c              |  3 +-
 arch/x86/kvm/svm.c                   |  2 +-
 arch/x86/kvm/vmx.c                   | 10 ++---
 arch/x86/mm/fault.c                  |  2 +-
 arch/x86/mm/init.c                   | 12 +++++-
 arch/x86/mm/tlb.c                    |  3 --
 arch/x86/power/cpu.c                 | 11 ++----
 arch/x86/realmode/init.c             |  2 +-
 arch/x86/xen/enlighten.c             |  4 +-
 drivers/lguest/x86/core.c            |  4 +-
 include/linux/perf_event.h           |  7 ++++
 kernel/events/core.c                 | 29 ++++++--------
 kernel/events/hw_breakpoint.c        |  7 ----
 39 files changed, 256 insertions(+), 154 deletions(-)

-- 
1.9.3

