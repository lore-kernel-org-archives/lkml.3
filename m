Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbaDQIQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:16:52 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:33128 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaDQIQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:16:46 -0400
Subject: [PATCH -tip v9 00/26] kprobes: introduce NOKPROBE_SYMBOL,
 bugfixes and scalbility efforts
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 17 Apr 2014 17:16:37 +0900
Message-ID: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Here is the version 9 of NOKPROBE_SYMBOL series, including
bugfixes. This updates some issues pointed in Steven's review
against v8 (Thank you!)

Blacklist improvements
======================
Currently, kprobes uses __kprobes annotation and internal symbol-
name based blacklist to prohibit probing on some functions, because
to probe those functions may cause an infinite recursive loop by
int3/debug exceptions.
However, current mechanisms have some problems especially from the
view point of maintaining code;
 - __kprobes is easy to confuse the function is
   used by kprobes, despite it just means "no kprobe
   on it".
 - __kprobes moves functions to different section
   this will be not good for cache optimization.
 - symbol-name based solution is not good at all,
   since the symbol name easily be changed, and
   we cannot notice it.
 - it doesn't support functions in modules at all.

Thus, I decided to introduce new NOKPROBE_SYMBOL macro for building
an integrated kprobe blacklist.

The new macro stores the address of the given symbols into
_kprobe_blacklist section, and initialize the blacklist based on the
address list at boottime.
This is also applied for modules. When loading a module, kprobes
finds the blacklist symbols in _kprobe_blacklist section in the
module automatically.
This series replaces all __kprobes on x86 and generic code with the
NOKPROBE_SYMBOL() too.

Although, the new blacklist still support old-style __kprobes by
decoding .kprobes.text if exist, because it still be used on arch-
dependent code except for x86.

Scalability effort
==================
This series fixes not only the kernel crashable "qualitative" bugs
but also "quantitative" issue with massive multiple kprobes. Thus
we can now do a stress test, putting kprobes on all (non-blacklisted)
kernel functions and enabling all of them.
To set kprobes on all kernel functions, run the below script.
  ----
  #!/bin/sh
  TRACE_DIR=/sys/kernel/debug/tracing/
  echo > $TRACE_DIR/kprobe_events
  grep -iw t /proc/kallsyms | tr -d . | \
    awk 'BEGIN{i=0};{print("p:"$3"_"i, "0x"$1); i++}' | \
    while read l; do echo $l >> $TRACE_DIR/kprobe_events ; done
  ----
Since it doesn't check the blacklist at all, you'll see many write
errors, but no problem :).

Note that a kind of performance issue is still in the kprobe-tracer
if you trace all functions. Since a few ftrace functions are called
inside the kprobe tracer even if we shut off the tracing (tracing_on
= 0), enabling kprobe-events on the functions will cause a bad
performance impact (it is safe, but you'll see the system slowdown
and no event recorded because it is just ignored).
To find those functions, you can use the third column of
(debugfs)/tracing/kprobe_profile as below, which tells you the number
of miss-hit(ignored) for each events. If you find that some events
which have small number in 2nd column and large number in 3rd column,
those may course the slowdown.
  ----
  # sort -rnk 3 (debugfs)/tracing/kprobe_profile | head
  ftrace_cmp_recs_4907                               264950231     33648874543
  ring_buffer_lock_reserve_5087                              0      4802719935
  trace_buffer_lock_reserve_5199                             0      4385319303
  trace_event_buffer_lock_reserve_5200                       0      4379968153
  ftrace_location_range_4918                          18944015      2407616669
  bsearch_17098                                       18979815      2407579741
  ftrace_location_4972                                18927061      2406723128
  ftrace_int3_handler_1211                            18926980      2406303531
  poke_int3_handler_199                               18448012      1403516611
  inat_get_opcode_attribute_16941                            0        12715314
  ----

I'd recommend you to enable events on such functions after all other
events enabled. Then its performance impact becomes minimum.

To enable kprobes on all kernel functions, run the below script.
  ----
  #!/bin/sh
  TRACE_DIR=/sys/kernel/debug/tracing
  echo "Disable tracing to remove tracing overhead"
  echo 0 > $TRACE_DIR/tracing_on

  BADS="ftrace_cmp_recs ring_buffer_lock_reserve trace_buffer_lock_reserve trace_event_buffer_lock_reserve ftrace_location_range bsearch ftrace_location ftrace_int3_handler poke_int3_handler inat_get_opcode_attribute"
HIDES=
  for i in $BADS; do HIDES=$HIDES" --hide=$i*"; done

  SDATE=`date +%s`
  echo "Enabling trace events: start at $SDATE"

  cd $TRACE_DIR/events/kprobes/
  for i in `ls $HIDES` ; do echo 1 > $i/enable; done
  for j in $BADS; do for i in `ls -d $j*`;do echo 1 > $i/enable; done; done

  EDATE=`date +%s`
  TIME=`expr $EDATE - $SDATE`
  echo "Elapsed time: $TIME"
  ---- 
Note: Perhaps, using systemtap doesn't need to consider above bad
symbols since it has own logic not to probe itself.

Result
======
These were also enabled after all other events are enabled.
And it took 2254 sec(without any intervals) for enabling 37222 probes.
And at that point, the perf top showed below result:
  ----
  Samples: 10K of event 'cycles', Event count (approx.): 270565996
  +  16.39%  [kernel]                       [k] native_load_idt
  +  11.17%  [kernel]                       [k] int3
  -   7.91%  [kernel]                       [k] 0x00007fffa018e8e0
   - 0xffffffffa018d8e0
        59.09% trace_event_buffer_lock_reserve
           kprobe_trace_func
           kprobe_dispatcher
      + 40.45% trace_event_buffer_lock_reserve
  ----
0x00007fffa018e8e0 may be the trampoline buffer of an optimized
probe on trace_event_buffer_lock_reserve. native_load_idt and int3
are also called from normal kprobes.
This means, at least my environment, kprobes now passed the
stress test, and even if we put probes on all available functions
it just slows down about 50%.

Changes from v8:
 - Add Steven's Reviewed-by tag to some patches (Thank you!)
 - [1/26] Add WARN_ON() to check kprobe_status
 - [4/26] Fix the documentation and a comment
 - [8/26] Update the patch description
 - [12/26] small style fix 
 - [14/26] Fix line-break style issues
 - [16/26] Fix line-break style issues

Changes from v7:
 - [24/26] Enlarge hash table to 512 instead of 4096.
 - Re-evaluate the performance improvements.

Changes from v6:
 - Updated patches on the latest -tip.
 - [1/26] Add patch: Fix page-fault handling logic on x86 kprobes
 - [2/26] Add patch: Allow to handle reentered kprobe on singlestepping
 - [9/26] Add new patch: Call exception_enter after kprobes handled
 - [12/26] Allow probing fetch functions in trace_uprobe.c.
 - [24/26] Add new patch: Enlarge kprobes hash table size
 - [25/26] Add new patch: Kprobe cache for frequently accessd kprobes
 - [26/26] Add new patch: Skip Ftrace hlist check with ftrace-based kprobe

Changes from v5:
 - [2/22] Introduce nokprobe_inline macro
 - [6/22] Prohibit probing on memset/memcpy
 - [11/22] Allow probing on text_poke/hw_breakpoint
 - [12/22] Use nokprobe_inline macro instead of __always_inline
 - [14/22] Ditto.
 - [21/22] Remove preempt disable/enable from kprobes/x86
 - [22/22] Add emergency int3 recovery code

Thank you,

---

Masami Hiramatsu (26):
      [BUGFIX]kprobes/x86: Fix page-fault handling logic
      kprobes/x86: Allow to handle reentered kprobe on singlestepping
      kprobes: Prohibit probing on .entry.text code
      kprobes: Introduce NOKPROBE_SYMBOL() macro for blacklist
      [BUGFIX] kprobes/x86: Prohibit probing on debug_stack_*
      [BUGFIX] x86: Prohibit probing on native_set_debugreg/load_idt
      [BUGFIX] x86: Prohibit probing on thunk functions and restore
      kprobes/x86: Call exception handlers directly from do_int3/do_debug
      x86: Call exception_enter after kprobes handled
      kprobes/x86: Allow probe on some kprobe preparation functions
      kprobes: Allow probe on some kprobe functions
      ftrace/*probes: Allow probing on some functions
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
      kprobes: Enlarge hash table to 512 entries
      kprobes: Introduce kprobe cache to reduce cache misshits
      ftrace: Introduce FTRACE_OPS_FL_SELF_FILTER for ftrace-kprobe


 Documentation/kprobes.txt                |   24 +
 arch/Kconfig                             |   10 
 arch/x86/include/asm/asm.h               |    7 
 arch/x86/include/asm/kprobes.h           |    2 
 arch/x86/include/asm/traps.h             |    2 
 arch/x86/kernel/alternative.c            |    3 
 arch/x86/kernel/apic/hw_nmi.c            |    3 
 arch/x86/kernel/cpu/common.c             |    4 
 arch/x86/kernel/cpu/perf_event.c         |    3 
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |    3 
 arch/x86/kernel/dumpstack.c              |    9 
 arch/x86/kernel/entry_32.S               |   33 --
 arch/x86/kernel/entry_64.S               |   20 -
 arch/x86/kernel/hw_breakpoint.c          |    5 
 arch/x86/kernel/kprobes/core.c           |  165 ++++----
 arch/x86/kernel/kprobes/ftrace.c         |   19 +
 arch/x86/kernel/kprobes/opt.c            |   32 +-
 arch/x86/kernel/kvm.c                    |    4 
 arch/x86/kernel/nmi.c                    |   18 +
 arch/x86/kernel/paravirt.c               |    6 
 arch/x86/kernel/traps.c                  |   35 +-
 arch/x86/lib/thunk_32.S                  |    3 
 arch/x86/lib/thunk_64.S                  |    3 
 arch/x86/mm/fault.c                      |   29 +
 include/asm-generic/vmlinux.lds.h        |    9 
 include/linux/compiler.h                 |    2 
 include/linux/ftrace.h                   |    3 
 include/linux/kprobes.h                  |   23 +
 include/linux/module.h                   |    5 
 kernel/kprobes.c                         |  607 +++++++++++++++++++++---------
 kernel/module.c                          |    6 
 kernel/notifier.c                        |   22 +
 kernel/sched/core.c                      |    7 
 kernel/trace/ftrace.c                    |    3 
 kernel/trace/trace_event_perf.c          |    5 
 kernel/trace/trace_kprobe.c              |   71 ++--
 kernel/trace/trace_probe.c               |   65 ++-
 kernel/trace/trace_probe.h               |   15 -
 kernel/trace/trace_uprobe.c              |   20 -
 samples/kprobes/jprobe_example.c         |    1 
 samples/kprobes/kprobe_example.c         |    3 
 samples/kprobes/kretprobe_example.c      |    2 
 42 files changed, 830 insertions(+), 481 deletions(-)

--
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


