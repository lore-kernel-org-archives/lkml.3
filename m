Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbaCUFTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 01:19:16 -0400
Received: from mail.efficios.com ([78.47.125.74]:35979 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453AbaCUFTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 01:19:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH v7 0/2] Tracepoint API simplification/cleanup
Date: Fri, 21 Mar 2014 01:19:00 -0400
Message-Id: <1395379142-2118-1-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is v7 of the tracepoint register/unregister API simplification,
submitted for 3.15.

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

Thanks!

Mathieu

Mathieu Desnoyers (2):
  Tracepoint cleanup: remove unused API functions
  Tracepoint: register/unregister struct tracepoint

 include/linux/ftrace_event.h |    1 +
 include/linux/tracepoint.h   |   60 ++--
 include/trace/ftrace.h       |    2 +
 kernel/trace/trace_events.c  |    8 +-
 kernel/tracepoint.c          |  705 ++++++++++++++----------------------------
 5 files changed, 260 insertions(+), 516 deletions(-)

-- 
1.7.10.4

