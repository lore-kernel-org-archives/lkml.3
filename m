Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbaC1WKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 18:10:20 -0400
Received: from mail.efficios.com ([78.47.125.74]:59703 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbaC1WKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 18:10:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH v8 0/1] Tracepoint API simplification, text size shrink
Date: Fri, 28 Mar 2014 15:09:57 -0700
Message-Id: <1396044598-9358-1-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is v8 of the tracepoint register/unregister API simplification,
submitted for 3.15.

This removes 8.8kB to the size of vmlinux (mostly text).

Changes since v1:
- Adapt ftrace/perf callers,
- Update tracepoint.h macro,
- Build tested.

Changes since v2:
- Introduce for_each_tracepoint() iterator to allow listing the
  currently loaded tracepoints, for modules using coming/going
  notifiers to track tracepoints.

Changes since v3:
- Introduce module coming and going notifiers each with their own
  priority to ensure that other coming notifiers are called after, and
  coming notifiers are called before the tracepoint notifiers.
- Fix: move for_each_tracepoint() outside of the CONFIG_MODULE ifdef.

Changes since v4:
- Split tracepoints_mutex into two locks: tp_modlist_mutex, which
  protects the tracepoint list of modules, and a tracepoint_mutex, which
  protects the tracepoints per se. tracepoint_mutex nests inside
  tp_modlist_mutex.
- Introduce a tracepoint module notifier, to ensure consistency between
  iteration on tracepoints with for_each_tracepoint() and module coming
  and going notifications. This consistency is ensured by holding
  tp_modlist_mutex when calling the notifier and when iterating on the
  tracepoint module list.

Changes since v5:
- Remove tracepoint_add_old_probes within "Tracepoint cleanup: remove
  unused API functions" rather than in later patch.
- Remove struct tp_probes "old probes" list within "Tracepoint cleanup:
  remove unused API functions", as it is not needed anymore.
- Within "Tracepoint cleanup: remove unused API functions", simply add
  the new module to tail of list, since there is no need to keep it
  ordered anymore.

Changes since v6:
- Remove unused struct list_head list from struct tp_probes in patch
  "Tracepoint: register/unregister struct tracepoint",
- Rename for_each_tracepoint() to for_each_kernel_tracepoint(). Only
  iterate on kernel tracepoints,
- Registered tracepoint module notifiers now receive struct tp_module
  pointer rather than struct module pointer,
- register_tracepoint_module_notifier and
  unregister_tracepoint_module_notifier now iterate on all modules and
  call coming/going notifiers. This ensures notifier registration and
  listing of already loaded modules are done atomically (protected by
  tp_modlist_mutex).

Changes since v7:
- Coding style updates,
- Shrink size of ftrace/perf struct ftrace_event_call,
- Put back the original tracepoints_mutex name, keep an original comment
  layout that goes beyond 80 columns, put back original
  tracepoint_module_list name, and rename tp_modlist_mutex to
  tracepoint_module_list_mutex, so this patch does not introduce
  cosmetic changes to pre-existing code.

Thanks!

Mathieu

Mathieu Desnoyers (1):
  Tracepoint: register/unregister struct tracepoint

 include/linux/ftrace_event.h        |   20 +-
 include/linux/tracepoint.h          |   41 +--
 include/trace/ftrace.h              |    9 +-
 kernel/trace/trace_events.c         |   51 ++--
 kernel/trace/trace_events_trigger.c |    2 +-
 kernel/trace/trace_export.c         |    2 +-
 kernel/trace/trace_kprobe.c         |   29 +-
 kernel/trace/trace_output.c         |    2 +-
 kernel/trace/trace_uprobe.c         |   28 +-
 kernel/tracepoint.c                 |  509 +++++++++++++++--------------------
 10 files changed, 336 insertions(+), 357 deletions(-)

-- 
1.7.10.4

