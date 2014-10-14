Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbaJNW5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 18:57:47 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64482 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbaJNW5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 18:57:46 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC 0/5] CR4 handling improvements
Date: Tue, 14 Oct 2014 15:57:34 -0700
Message-Id: <cover.1413323611.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter, etc,

This little series tightens up rdpmc permissions.  With it applied,
rdpmc can only be used if a perf_event is actually mmapped.  For now,
this is only really useful for seccomp.

At some point this could be further tightened up to only allow rdpmc
if an actual self-monitoring perf event that is compatible with
rdpmc is mapped.  (Is the current code there even correct?  What
happens if you set up a perf counter targetting a different pid and
then try to rdpmc it?  Do you end up reading the right value or does
perf event context switching mess you up?)

This should add <50ns to context switches between rdpmc-capable and
rdpmc-non-capable mms.  I suspect that this is well under 10%
overhead, given that perf already adds some context switch latency.

If needed, we could add a global switch that turns this behavior
off.  We could also rehink the logic.

I think that patches 1-3 are a good idea regardless of any rdpmc changes.

(Please don't apply quite yet, because there'll be a merge conflict
with some changes that haven't landed yet.  This is against 3.17.)

Andy Lutomirski (5):
  x86: Clean up cr4 manipulation
  x86: Store a per-cpu shadow copy of CR4
  x86: Add a comment clarifying LDT context switching
  perf: Add pmu callbacks to track event mapping and unmapping
  x86,perf: Only allow rdpmc if a perf_event is mapped

 arch/x86/include/asm/mmu.h           |  2 +
 arch/x86/include/asm/mmu_context.h   | 30 +++++++++++++-
 arch/x86/include/asm/processor.h     | 33 ----------------
 arch/x86/include/asm/tlbflush.h      | 77 ++++++++++++++++++++++++++++++++----
 arch/x86/include/asm/virtext.h       |  3 +-
 arch/x86/kernel/cpu/common.c         | 17 +++++---
 arch/x86/kernel/cpu/mcheck/mce.c     |  3 +-
 arch/x86/kernel/cpu/mcheck/p5.c      |  3 +-
 arch/x86/kernel/cpu/mcheck/winchip.c |  3 +-
 arch/x86/kernel/cpu/perf_event.c     | 61 +++++++++++++++++++++-------
 arch/x86/kernel/head32.c             |  1 +
 arch/x86/kernel/head64.c             |  2 +
 arch/x86/kernel/i387.c               |  3 +-
 arch/x86/kernel/process.c            |  5 ++-
 arch/x86/kernel/xsave.c              |  3 +-
 arch/x86/kvm/vmx.c                   |  8 ++--
 arch/x86/mm/init.c                   | 12 +++++-
 arch/x86/mm/tlb.c                    |  3 --
 arch/x86/xen/enlighten.c             |  4 +-
 include/linux/perf_event.h           |  7 ++++
 kernel/events/core.c                 |  9 +++++
 21 files changed, 210 insertions(+), 79 deletions(-)

-- 
1.9.3

