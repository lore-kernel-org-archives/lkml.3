Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbbA2KVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:21:45 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756744AbbA2JAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:52 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Vince Weaver <vince@deater.net>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 050/176] perf: Fix events installation during moving group
Date: Wed, 28 Jan 2015 15:28:00 +0100
Message-Id: <a1f8e24798f9d7cdca5bbf438be1a501bb53fa00.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9fc81d87420d0d3fd62d5e5529972c0ad9eab9cc upstream.

We allow PMU driver to change the cpu on which the event
should be installed to. This happened in patch:

  e2d37cd213dc ("perf: Allow the PMU driver to choose the CPU on which to install events")

This patch also forces all the group members to follow
the currently opened events cpu if the group happened
to be moved.

This and the change of event->cpu in perf_install_in_context()
function introduced in:

  0cda4c023132 ("perf: Introduce perf_pmu_migrate_context()")

forces group members to change their event->cpu,
if the currently-opened-event's PMU changed the cpu
and there is a group move.

Above behaviour causes problem for breakpoint events,
which uses event->cpu to touch cpu specific data for
breakpoints accounting. By changing event->cpu, some
breakpoints slots were wrongly accounted for given
cpu.

Vinces's perf fuzzer hit this issue and caused following
WARN on my setup:

   WARNING: CPU: 0 PID: 20214 at arch/x86/kernel/hw_breakpoint.c:119 arch_install_hw_breakpoint+0x142/0x150()
   Can't find any breakpoint slot
   [...]

This patch changes the group moving code to keep the event's
original cpu.

Reported-by: Vince Weaver <vince@deater.net>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Vince Weaver <vince@deater.net>
Cc: Yan, Zheng <zheng.z.yan@intel.com>
Link: http://lkml.kernel.org/r/1418243031-20367-3-git-send-email-jolsa@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/events/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 63bd27c861fe..452b2b0d7af1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7167,11 +7167,11 @@ SYSCALL_DEFINE5(perf_event_open,
 
 	if (move_group) {
 		synchronize_rcu();
-		perf_install_in_context(ctx, group_leader, event->cpu);
+		perf_install_in_context(ctx, group_leader, group_leader->cpu);
 		get_ctx(ctx);
 		list_for_each_entry(sibling, &group_leader->sibling_list,
 				    group_entry) {
-			perf_install_in_context(ctx, sibling, event->cpu);
+			perf_install_in_context(ctx, sibling, sibling->cpu);
 			get_ctx(ctx);
 		}
 	}
-- 
2.2.2

