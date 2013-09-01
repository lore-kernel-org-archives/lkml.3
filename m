Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab3IAKtR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:49:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757339Ab3IAKtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:49:11 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [RFC 00/24] perf tools: Add traceevent plugins support
Date: Sun,  1 Sep 2013 12:48:25 +0200
Message-Id: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
backporting traceevent plugin support from trace-cmd.

Having plugins allow traceevent to properly parse
'print fmt' line of tracepoint format and display
proper/additional data in perf script command, like:

- displaying call_site details in kmem:* tracepoints:
  $ sudo perf record -e kmem:kmalloc ls

  before:
  ls 31708 [003] 15123.850504: kmem:kmalloc: call_site=ffffffff812030eb ptr=0xffff8801cbb91840 bytes_req=40 bytes_alloc=64 gfp_
  ls 31708 [003] 15123.850506: kmem:kmalloc: call_site=ffffffff811be761 ptr=0xffff8801cbbddd20 bytes_req=32 bytes_alloc=32 gfp_
  ls 31708 [003] 15123.850507: kmem:kmalloc: call_site=ffffffff811be6ab ptr=0xffff880163bf1800 bytes_req=112 bytes_alloc=128 gf
  ls 31708 [003] 15123.850535: kmem:kmalloc: call_site=ffffffff811bed5e ptr=0xffff88017d41b000 bytes_req=4096 bytes_alloc=4096 
  ls 31708 [003] 15123.850691: kmem:kmalloc: call_site=ffffffff81128333 ptr=0xffff88020eedc000 bytes_req=4104 bytes_alloc=8192 
  ls 31708 [003] 15123.850838: kmem:kmalloc: call_site=ffffffff8121c28e ptr=0xffff8801cb981940 bytes_req=48 bytes_alloc=64 gfp_
  ls 31708 [003] 15123.850848: kmem:kmalloc: call_site=ffffffff8121c418 ptr=0xffff8801cb916bc0 bytes_req=50 bytes_alloc=64 gfp_
  ls 31708 [003] 15123.850850: kmem:kmalloc: call_site=ffffffff8121c418 ptr=0xffff8801cb916b40 bytes_req=51 bytes_alloc=64 gfp_

  now:
  $ sudo perf script
  ...
  ls 30512 [001] 14717.425867: kmem:kmalloc: (perf_event_mmap+0xf3) call_site=ffffffff81128333 ptr=0xffff880211cea000 bytes_req
  ls 30512 [001] 14717.425981: kmem:kmalloc: (proc_reg_open+0x4b) call_site=ffffffff812030eb ptr=0xffff88017de85a40 bytes_req=4
  ls 30512 [001] 14717.425982: kmem:kmalloc: (single_open+0x41) call_site=ffffffff811be761 ptr=0xffff8801958e1e00 bytes_req=32 
  ls 30512 [001] 14717.425982: kmem:kmalloc: (seq_open+0xfb) call_site=ffffffff811be6ab ptr=0xffff880211d88f00 bytes_req=112 by
  ls 30512 [001] 14717.425989: kmem:kmalloc: (seq_read+0x2ee) call_site=ffffffff811bed5e ptr=0xffff88017be8c000 bytes_req=4096 
  ls 30512 [001] 14717.426034: kmem:kmalloc: (perf_event_mmap+0xf3) call_site=ffffffff81128333 ptr=0xffff880211cea000 bytes_req
  ls 30512 [001] 14717.426079: kmem:kmalloc: (ext4_readdir+0x6fe) call_site=ffffffff8121c28e ptr=0xffff88017de85f00 bytes_req=4
  ls 30512 [001] 14717.426081: kmem:kmalloc: (ext4_htree_store_dirent+0x38) call_site=ffffffff8121c418 ptr=0xffff88017de85080 b
  ...

- displaying details for timer_expire_entry and hrtimer_start tracepoints:

  $ sudo perf record -e timer:* ls

  before:
  ls 31727 [001] 15171.487282: timer:hrtimer_cancel: hrtimer=0xffff88021e24e4c0
  ls 31727 [001] 15171.487284: timer:hrtimer_expire_entry: [FAILED TO PARSE] hrtimer=0xffff88021e24e4c0 now=15167505000662 func
  ls 31727 [001] 15171.487290: timer:hrtimer_expire_exit: hrtimer=0xffff88021e24e4c0
  ls 31727 [001] 15171.487290: timer:hrtimer_start: [FAILED TO PARSE] hrtimer=0xffff88021e24e4c0 function=0xffffffff810b6460 ex

  now:
  $ sudo perf script
  ..
  ls 30557 [001] 14855.443889: timer:hrtimer_cancel: hrtimer=0xffff88021e24e4c0
  ls 30557 [001] 14855.443891: timer:hrtimer_expire_entry: hrtimer=0xffff88021e24e4c0 now=14851544000735 function=tick_sched_timer/0x0
  ls 30557 [001] 14855.443897: timer:hrtimer_expire_exit: hrtimer=0xffff88021e24e4c0
  ls 30557 [001] 14855.443897: timer:hrtimer_start: hrtimer=0xffff88021e24e4c0 function=tick_sched_timer expires=14851545000000 softexpires=14851545000000
  ls 30557 [001] 14855.443899: timer:timer_cancel: timer=0xffff88021e250b68
  ls 30557 [001] 14855.443900: timer:timer_expire_entry: timer=0xffff88021e250b68 function=delayed_work_timer_fn now=4309518840
  ls 30557 [001] 14855.443903: timer:timer_expire_exit: timer=0xffff88021e250b68
  ls 30557 [001] 14855.444888: timer:hrtimer_cancel: hrtimer=0xffff88021e24e4c0
  ls 30557 [001] 14855.444889: timer:hrtimer_expire_entry: hrtimer=0xffff88021e24e4c0 now=14851545000598 function=tick_sched_timer/0x0
  ...


All plugins present in trace-cmd are backported plus
added new scsi and xen. The 'xen' plugin still cannot
handle all the 'print fmt' functions, since I dont follow
xen code ;-) Also xen tracepoints use 'sizeof' in the
format string and it's not clear yet how to handle that.

Plugins get installed to following locations:
  '$(HOME)/.traceevent/plugins'
   - if no prefix is provided
  '$(perfexecdir)/traceevent/plugins'
   - if prefix is provided

thanks for comments,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
Jiri Olsa (24):
      perf tools: Fix 'make install prefix=...' build rule
      perf tools: Remove unused trace-event-* code
      perf tools: Unify page_size usage
      tools list traceevent: Add plugin support
      tools list traceevent: Add options support
      tools list traceevent: Add plugin build support
      tools list traceevent: Add traceevent_host_bigendian function
      tools list traceevent: Add pevent_print_func_field function
      tools list traceevent: Add jbd2 plugin
      tools list traceevent: Add blk plugin
      tools list traceevent: Add hrtimer plugin
      tools list traceevent: Add kmem plugin
      tools list traceevent: Add kvm plugin
      tools list traceevent: Add mac80211 plugin
      tools list traceevent: Add sched_switch plugin
      tools list traceevent: Add function plugin
      tools list traceevent: Update kvm plugin with is_writable_pte helper
      tools list traceevent: Add xen plugin
      tools list traceevent: Add scsi plugin
      tools list traceevent: Change pevent_parse_event to return event format
      perf tools: Add traceevents Makefile install rule
      perf tools: Add trace-event object
      perf tools: Add traceevent object to interface traceevent lib
      perf tools: Overload pr_stat traceevent print function

 tools/lib/traceevent/Makefile              |  57 +++++++++--
 tools/lib/traceevent/event-option.c        | 278 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/lib/traceevent/event-parse.c         |  70 +++++++++----
 tools/lib/traceevent/event-parse.h         |  29 +++++-
 tools/lib/traceevent/event-plugin.c        | 202 +++++++++++++++++++++++++++++++++++++
 tools/lib/traceevent/plugin_blk.c          | 389 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/lib/traceevent/plugin_function.c     | 182 +++++++++++++++++++++++++++++++++
 tools/lib/traceevent/plugin_hrtimer.c      |  94 ++++++++++++++++++
 tools/lib/traceevent/plugin_jbd2.c         |  68 +++++++++++++
 tools/lib/traceevent/plugin_kmem.c         |  76 ++++++++++++++
 tools/lib/traceevent/plugin_kvm.c          | 480 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/lib/traceevent/plugin_mac80211.c     | 204 +++++++++++++++++++++++++++++++++++++
 tools/lib/traceevent/plugin_sched_switch.c | 147 +++++++++++++++++++++++++++
 tools/lib/traceevent/plugin_scsi.c         | 431 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/lib/traceevent/plugin_xen.c          | 132 ++++++++++++++++++++++++
 tools/perf/Makefile                        |  13 ++-
 tools/perf/builtin-record.c                |   5 +-
 tools/perf/builtin-script.c                |   2 +-
 tools/perf/builtin-trace.c                 |   5 +-
 tools/perf/config/Makefile                 |   4 +-
 tools/perf/perf.c                          |   1 +
 tools/perf/util/debug.c                    |  16 +++
 tools/perf/util/debug.h                    |   2 +
 tools/perf/util/evsel.c                    |  44 +-------
 tools/perf/util/header.c                   |   8 +-
 tools/perf/util/python-ext-sources         |   1 +
 tools/perf/util/python.c                   |   1 +
 tools/perf/util/session.c                  |   2 +-
 tools/perf/util/session.h                  |   3 +-
 tools/perf/util/trace-event-parse.c        |  53 +---------
 tools/perf/util/trace-event-read.c         |  20 ++--
 tools/perf/util/trace-event.c              | 121 ++++++++++++++++++++++
 tools/perf/util/trace-event.h              |  22 ++--
 33 files changed, 3002 insertions(+), 160 deletions(-)
 create mode 100644 tools/lib/traceevent/event-option.c
 create mode 100644 tools/lib/traceevent/event-plugin.c
 create mode 100644 tools/lib/traceevent/plugin_blk.c
 create mode 100644 tools/lib/traceevent/plugin_function.c
 create mode 100644 tools/lib/traceevent/plugin_hrtimer.c
 create mode 100644 tools/lib/traceevent/plugin_jbd2.c
 create mode 100644 tools/lib/traceevent/plugin_kmem.c
 create mode 100644 tools/lib/traceevent/plugin_kvm.c
 create mode 100644 tools/lib/traceevent/plugin_mac80211.c
 create mode 100644 tools/lib/traceevent/plugin_sched_switch.c
 create mode 100644 tools/lib/traceevent/plugin_scsi.c
 create mode 100644 tools/lib/traceevent/plugin_xen.c
 create mode 100644 tools/perf/util/trace-event.c
