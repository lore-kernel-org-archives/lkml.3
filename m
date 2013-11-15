Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab3KOEx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 23:53:28 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40655 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004Ab3KOExU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 23:53:20 -0500
X-AuditID: 85900ec0-d1328b9000001514-dd-5285a8bd8319
Subject: [PATCH -tip RFC v2 00/22] kprobes: introduce NOKPROBE_SYMBOL() and
 general cleaning of kprobe blacklist
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 15 Nov 2013 04:53:12 +0000
Message-ID: <20131115045312.27580.95902.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the blacklist is maintained by hand in kprobes.c 
which is separated from the function definition and is hard
to catch up the kernel update.

To solve this issue, I've tried to implement new
NOKPROBE_SYMBOL() macro for making kprobe blacklist at 
build time. Since the NOKPROBE_SYMBOL() macros can be placed
right after the function is defined, it is easy to maintain.

This series replaces __kprobes with NOKPROBE_SYMBOL() macro
or apply __always_inline annotation for some cases, because
NOKPROBE_SYMBOL() will inhibit inlining by referring the
symbol address. :(

In this series, I replaced all __kprobes under kernel/ and
arch/x86. For future work, I'd like to replace all the
__kprobes annotation for all archs too. But this is just
for review the impact of the cleanup.

Also, I decided to classify current __kprobes annotation
users who misuse it too many. Most of the preparation,
registration, optimization functions related to kprobes
are not involved in the breakpoint or other exception
handling. This means that those never cause problems
such as infinite recursion if we put kprobes on it.
This also reduces blacklist a lot.

For easy to check the blacklist, this series includes
a patch which provides debugfs interface for the blacklist.
You can see what address region/symbols are not allowed
to probe via /sys/kernel/debug/kprobes/blacklist.

The blacklist now also support modules. :)
kprobes users can make a custom blacklisted functions which
will be called from kprobes handlers. Example codes are also
updated, so you can see how it works.

This series also includes a change which prohibits probing
on the address in .entry.text because the code is used for
very low-level sensitive interrupt/syscall entries. Probing
such code may cause unexpected result (actually most of
that area is already in the kprobe blacklist).
So I've decide to prohibit probing all of them.

After applying this series, I got an empty .kprobes.text :)

$ grep kprobes_text System.map
ffffffff81604980 T __kprobes_text_end
ffffffff81604980 T __kprobes_text_start

Thank you,

Changes from previous version:
 - Replace __kprobes with NOKPROBE_SYMBOL() and remove
   unneeded __kprobes on the files compiled on x86.
 - Add blacklist on modules support.
 - Add debugfs interface for blacklist.
 - Fix indent of the NOKPROBE_SYMBOL() by using tabs.
 - Fix NOKPROBE_SYMBOL() for expanding nested macro.
 - Update Documentations/kprobes.txt about blacklist.
---

Masami Hiramatsu (22):
      kprobes: Prohibit probing on .entry.text code
      kprobes: Introduce NOKPROBE_SYMBOL() macro for blacklist
      kprobes: Show blacklist entries via debugfs
      kprobes: Support blacklist functions in module
      kprobes: Use NOKPROBE_SYMBOL() in sample modules
      kprobes/x86: Allow probe on some kprobe preparation functions
      kprobes/x86: Use NOKPROBE_SYMBOL instead of __kprobes
      kprobes: Allow probe on some kprobe functions
      kprobes: Use NOKPROBE_SYMBOL macro instead of __kprobes
      ftrace/kprobes: Allow probing on some preparation functions
      ftrace/kprobes: Use NOKPROBE_SYMBOL macro in ftrace
      x86/hw_breakpoint: Use NOKPROBE_SYMBOL macro in hw_breakpoint
      x86/trap: Use NOKPROBE_SYMBOL macro in trap.c
      x86/fault: Use NOKPROBE_SYMBOL macro in fault.c
      x86/alternative: Use NOKPROBE_SYMBOL macro in alternative.c
      x86/nmi: Use NOKPROBE_SYMBOL macro for nmi handlers
      x86/kvm: Use NOKPROBE_SYMBOL macro in kvm.c
      x86/dumpstack: Use NOKPROBE_SYMBOL macro in dumpstack.c
      [BUGFIX] kprobes/x86: Prohibit probing on debug_stack_*
      [BUGFIX] kprobes: Prohibit probing on func_ptr_is_kernel_text
      notifier: Use NOKPROBE_SYMBOL macro in notifier
      sched: Use NOKPROBE_SYMBOL macro in sched


 Documentation/kprobes.txt                |   24 ++
 arch/x86/include/asm/traps.h             |    2 
 arch/x86/kernel/alternative.c            |    3 
 arch/x86/kernel/apic/hw_nmi.c            |    3 
 arch/x86/kernel/cpu/common.c             |    4 
 arch/x86/kernel/cpu/perf_event.c         |    3 
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |    3 
 arch/x86/kernel/dumpstack.c              |    9 -
 arch/x86/kernel/entry_32.S               |   33 --
 arch/x86/kernel/entry_64.S               |   20 -
 arch/x86/kernel/hw_breakpoint.c          |    6 
 arch/x86/kernel/kprobes/core.c           |   97 ++++---
 arch/x86/kernel/kprobes/ftrace.c         |   17 +
 arch/x86/kernel/kprobes/opt.c            |   32 +-
 arch/x86/kernel/kvm.c                    |    4 
 arch/x86/kernel/nmi.c                    |   18 +
 arch/x86/kernel/paravirt.c               |    4 
 arch/x86/kernel/traps.c                  |   20 +
 arch/x86/mm/fault.c                      |   28 +-
 include/asm-generic/vmlinux.lds.h        |    9 +
 include/linux/kprobes.h                  |   20 +
 include/linux/module.h                   |    5 
 kernel/extable.c                         |    2 
 kernel/kprobes.c                         |  415 ++++++++++++++++++------------
 kernel/module.c                          |    6 
 kernel/notifier.c                        |   22 +-
 kernel/sched/core.c                      |    7 -
 kernel/trace/trace_event_perf.c          |    5 
 kernel/trace/trace_kprobe.c              |   53 ++--
 kernel/trace/trace_probe.c               |   78 +++---
 kernel/trace/trace_probe.h               |    4 
 samples/kprobes/jprobe_example.c         |    1 
 samples/kprobes/kprobe_example.c         |    3 
 samples/kprobes/kretprobe_example.c      |    2 
 34 files changed, 580 insertions(+), 382 deletions(-)

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
