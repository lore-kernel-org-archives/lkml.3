Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaENIUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 04:20:50 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39282 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaENIUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 04:20:46 -0400
Subject: [PATCH -tip v11 0/7] kprobes: NOKPROBE_SYMBOL for modules,
 and scalbility efforts
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 14 May 2014 17:20:34 +0900
Message-ID: <20140514082034.5791.38607.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Here is the version 11 of NOKPROBE_SYMBOL/scalability series.
This fixes some issues.

Blacklist for kmodule
=====================
Since most of the NOKPROBE_SYMBOL series are merged, this just adds
kernel module support of NOKPROBE_SYMBOL. If kprobes user module
has kprobes handlers and local functions which is only called from
the handlers, it should be marked as NOKPROBE_SYMBOL. Such symbols
are automatically added to kprobe blacklist.

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

Changes from v10:
 - [6/7] Use ACCESS_ONCE and barrier() to ensure acquiring cached
         kprobe right before checking cache-update.
 - [6/7] Retry cache read if th cache is updated.
 - [6/7] Update cache index when invalidate entry.
 - [6/7] Update comment of kpcache_invalidate(). 
 - [7/7] Update comment of the flag according to Steven's comment.

Changes from v9:
 - [1/7] Remove unneeded #include <linux/kprobes.h> from module.h
 - [6/7] Add a comment for kpcache_invalidate().
 - [6/7] Remove CONFIG_KPROBE_CACHE accoding to Ingo's suggestion.


Thank you,

---

Masami Hiramatsu (7):
      kprobes: Support blacklist functions in module
      kprobes: Use NOKPROBE_SYMBOL() in sample modules
      kprobes/x86: Use kprobe_blacklist for .kprobes.text and .entry.text
      kprobes/x86: Remove unneeded preempt_disable/enable in interrupt handlers
      kprobes: Enlarge hash table to 512 entries
      kprobes: Introduce kprobe cache to reduce cache misshits
      ftrace: Introduce FTRACE_OPS_FL_SELF_FILTER for ftrace-kprobe


 Documentation/kprobes.txt           |    8 +
 arch/x86/kernel/kprobes/core.c      |   37 +---
 arch/x86/kernel/kprobes/ftrace.c    |    2 
 include/linux/ftrace.h              |    3 
 include/linux/kprobes.h             |    2 
 include/linux/module.h              |    4 
 kernel/kprobes.c                    |  288 +++++++++++++++++++++++++++++------
 kernel/module.c                     |    6 +
 kernel/trace/ftrace.c               |    3 
 samples/kprobes/jprobe_example.c    |    1 
 samples/kprobes/kprobe_example.c    |    3 
 samples/kprobes/kretprobe_example.c |    2 
 12 files changed, 283 insertions(+), 76 deletions(-)

--
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


