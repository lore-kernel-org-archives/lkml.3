Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab3LSJJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:09:49 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:56536 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3LSJJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:09:39 -0500
Subject: [PATCH -tip v6 00/22] kprobes: introduce NOKPROBE_SYMBOL(),
 cleanup and fixes crash bugs
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Date: Thu, 19 Dec 2013 09:03:54 +0000
Message-ID: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Here is the version 6 of NOKPROBE_SYMBOL series. :)

This includes small updates and introducing nokprobe_inline
macro to prevent probing on the static/inlined small
functions since NOKPROBE_SYMBOL will inhibit inlining
by referring function address.
This macro is more self-describing than normal
 __always_inline. (Thanks to Steven Rostedt!)

This series also adds four new patches, the first is
prohibiting probes on memset/memcpy since probing it
freezes the kernel. The next is allowing kprobes on
text_poke/hw_breakpoint handler which is not related
to kprobes int3/debug handling path. And the third is
removing preempt disable/enable in kprobes/x86 code.
The last is original instruction recovery code for
bad kprobes (Thanks to Ingo Molnar!) This recovery
code is important to make the kprobes more robust.


Currently, kprobes uses __kprobes annotation and
internal symbol-name based blacklist to prohibit
probing on some functions, because to probe those
functions may cause an infinit recursive loop by
int3/debug exceptions.
However, current mechanisms have some problems
especially from the view point of maintaining code;
 - __kprobes is easy to confuse the function is
   used by kprobes, despite it just means "no kprobe
   on it".
 - __kprobes moves functions to different section
   this will be not good for cache optimization.
 - symbol-name based solution is not good at all,
   since the symbol name easily be changed, and
   we cannot notice it.
 - it doesn't support functions in modules at all.

Thus, I decided to introduce new NOKPROBE_SYMBOL
macro for building an integrated kprobe blacklist.

The new macro stores the address of the given symbols
into _kprobe_blacklist section, and initialize the
blacklist based on the address list at boottime.
This is also applied for modules. When loading a
module, kprobes finds the blacklist symbols in
_kprobe_blacklist section in the module automatically.
This series replaces all __kprobes on x86 and generic
code with the NOKPROBE_SYMBOL() too.

Although, the new blacklist still support old-style
__kprobes by decoding .kprobes.text if exist, because
it still be used on arch-dependent code except for x86.

This series will fix the kernel crashable "qualitative"
bugs of kprobes even with lockdep. But we still have
"quantitative" issue which we are discussing on LKML.

https://lkml.org/lkml/2013/12/3/788

I'd like to send another series for solving this
"quantitative" issue.

Changes from the previous:
 - [2/22] Introduce nokprobe_inline macro
 - [6/22] Prohibit probing on memset/memcpy
 - [11/22] Allow probing on text_poke/hw_breakpoint
 - [12/22] Use nokprobe_inline macro instead of __always_inline
 - [14/22] Ditto.
 - [21/22] Remove preempt disable/enable from kprobes/x86
 - [22/22] Add emergency int3 recovery code

Thank you,
---

Masami Hiramatsu (22):
      kprobes: Prohibit probing on .entry.text code
      kprobes: Introduce NOKPROBE_SYMBOL() macro for blacklist
      [BUGFIX] kprobes/x86: Prohibit probing on debug_stack_*
      [BUGFIX] x86: Prohibit probing on native_set_debugreg/load_idt
      [BUGFIX] x86: Prohibit probing on thunk functions and restore
      [BUGFIX] x86: Prohibit probing on memcpy/memset
      kprobes/x86: Call exception handlers directly from do_int3/do_debug
      kprobes/x86: Allow probe on some kprobe preparation functions
      kprobes: Allow probe on some kprobe functions
      ftrace/kprobes: Allow probing on some preparation functions
      x86: Allow kprobes on text_poke/hw_breakpoint
      x86: Use NOKPROBE_SYMBOL() instead of __kprobes annotation
      kprobes: Use NOKPROBE_SYMBOL macro instead of __kprobes
      ftrace/kprobes: Use NOKPROBE_SYMBOL macro in ftrace
      notifier: Use NOKPROBE_SYMBOL macro in notifier
      sched: Use NOKPROBE_SYMBOL macro in sched
      kprobes: Show blacklist entries via debugfs
      kprobes: Support blacklist functions in module
      kprobes: Use NOKPROBE_SYMBOL() in sample modules
      kprobes/x86: Use kprobe_blacklist for .kprobes.text and .entry.text
      kprobes/x86: Remove unneeded preempt_disable/enable in interrupt handlers
      [RFC] kprobes/x86: Add emergency recovery process for bad kprobes


 Documentation/kprobes.txt                |   24 +-
 arch/x86/include/asm/asm.h               |    7 
 arch/x86/include/asm/fixmap.h            |    7 
 arch/x86/include/asm/kprobes.h           |    3 
 arch/x86/include/asm/paravirt.h          |    7 
 arch/x86/include/asm/processor.h         |    2 
 arch/x86/include/asm/special_insns.h     |    4 
 arch/x86/include/asm/string_32.h         |    6 
 arch/x86/include/asm/tlbflush.h          |    6 
 arch/x86/include/asm/traps.h             |    2 
 arch/x86/kernel/alternative.c            |    3 
 arch/x86/kernel/apic/hw_nmi.c            |    3 
 arch/x86/kernel/cpu/common.c             |    4 
 arch/x86/kernel/cpu/perf_event.c         |    3 
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |    3 
 arch/x86/kernel/dumpstack.c              |    9 -
 arch/x86/kernel/entry_32.S               |   33 --
 arch/x86/kernel/entry_64.S               |   20 -
 arch/x86/kernel/hw_breakpoint.c          |    5 
 arch/x86/kernel/kprobes/core.c           |  193 +++++++-----
 arch/x86/kernel/kprobes/ftrace.c         |   17 +
 arch/x86/kernel/kprobes/opt.c            |   32 +-
 arch/x86/kernel/kvm.c                    |    4 
 arch/x86/kernel/nmi.c                    |   18 +
 arch/x86/kernel/paravirt.c               |    6 
 arch/x86/kernel/traps.c                  |   30 +-
 arch/x86/lguest/boot.c                   |    1 
 arch/x86/lib/memcpy_32.c                 |    2 
 arch/x86/lib/memcpy_64.S                 |    4 
 arch/x86/lib/memset_64.S                 |    3 
 arch/x86/lib/thunk_32.S                  |    3 
 arch/x86/lib/thunk_64.S                  |    3 
 arch/x86/mm/fault.c                      |   28 +-
 arch/x86/mm/pgtable.c                    |    3 
 include/asm-generic/vmlinux.lds.h        |    9 +
 include/linux/compiler.h                 |    2 
 include/linux/kprobes.h                  |   31 ++
 include/linux/module.h                   |    5 
 kernel/kprobes.c                         |  466 +++++++++++++++++++-----------
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
 tools/perf/bench/mem-memcpy-x86-64-asm.S |    1 
 tools/perf/bench/mem-memset-x86-64-asm.S |    1 
 51 files changed, 747 insertions(+), 447 deletions(-)

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

