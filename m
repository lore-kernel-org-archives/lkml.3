Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab3LIKxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:53:04 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:36120 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758819Ab3LIKxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:53:01 -0500
Subject: [PATCH -tip v5 00/18] kprobes: introduce NOKPROBE_SYMBOL(),
 cleanup and fixes crash bugs
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Date: Mon, 09 Dec 2013 10:47:18 +0000
Message-ID: <20131209104717.13397.8864.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Here is the version 5 of NOKPORBE_SYMBOL series.

This version includes the cleanup patches and features
(make blacklist visible, module support) again.

And I've added a patch to show all the blacklist
functions which includes .entry.text and
.kprobes.text(if exist) so that user tools can
check the blacklisted functions before setting
new probe.

This series will fix the kernel crashable "qualitative"
bugs of kprobes even with lockdep. But we still have
"quantitative" issue which we are discussing on LKML.

https://lkml.org/lkml/2013/12/3/788

I'd like to send another series for solving this
"quantitative" issue.

Thank you,
---

Masami Hiramatsu (18):
      kprobes: Prohibit probing on .entry.text code
      kprobes: Introduce NOKPROBE_SYMBOL() macro for blacklist
      [BUGFIX] kprobes/x86: Prohibit probing on debug_stack_*
      [BUGFIX] x86: Prohibit probing on native_set_debugreg
      [BUGFIX] x86: Prohibit probing on thunk functions and restore
      kprobes/x86: Call exception handlers directly from do_int3/do_debug
      kprobes/x86: Allow probe on some kprobe preparation functions
      kprobes: Allow probe on some kprobe functions
      ftrace/kprobes: Allow probing on some preparation functions
      x86: Use NOKPROBE_SYMBOL() instead of __kprobes annotation
      kprobes: Use NOKPROBE_SYMBOL macro instead of __kprobes
      ftrace/kprobes: Use NOKPROBE_SYMBOL macro in ftrace
      notifier: Use NOKPROBE_SYMBOL macro in notifier
      sched: Use NOKPROBE_SYMBOL macro in sched
      kprobes: Show blacklist entries via debugfs
      kprobes: Support blacklist functions in module
      kprobes: Use NOKPROBE_SYMBOL() in sample modules
      kprobes/x86: Use kprobe_blacklist for .kprobes.text and .entry.text


 Documentation/kprobes.txt                |   24 +-
 arch/x86/include/asm/asm.h               |    7 
 arch/x86/include/asm/kprobes.h           |    2 
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
 arch/x86/kernel/kprobes/core.c           |  120 ++++----
 arch/x86/kernel/kprobes/ftrace.c         |   17 +
 arch/x86/kernel/kprobes/opt.c            |   32 +-
 arch/x86/kernel/kvm.c                    |    4 
 arch/x86/kernel/nmi.c                    |   18 +
 arch/x86/kernel/paravirt.c               |    5 
 arch/x86/kernel/traps.c                  |   30 +-
 arch/x86/lib/thunk_32.S                  |    3 
 arch/x86/lib/thunk_64.S                  |    3 
 arch/x86/mm/fault.c                      |   28 +-
 include/asm-generic/vmlinux.lds.h        |    9 +
 include/linux/kprobes.h                  |   22 +
 include/linux/module.h                   |    5 
 kernel/kprobes.c                         |  461 +++++++++++++++++++-----------
 kernel/module.c                          |    6 
 kernel/notifier.c                        |   22 +
 kernel/sched/core.c                      |    7 
 kernel/trace/trace_event_perf.c          |    5 
 kernel/trace/trace_kprobe.c              |   53 ++-
 kernel/trace/trace_probe.c               |   78 +++--
 kernel/trace/trace_probe.h               |    4 
 samples/kprobes/jprobe_example.c         |    1 
 samples/kprobes/kprobe_example.c         |    3 
 samples/kprobes/kretprobe_example.c      |    2 
 37 files changed, 649 insertions(+), 408 deletions(-)

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

