Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933341AbbANHnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:43:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58952 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933220AbbANHjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:39:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vince Weaver <vince@deater.net>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.10 40/44] perf: Fix events installation during moving group
Date: Tue, 13 Jan 2015 23:24:01 -0800
Message-Id: <20150114072229.572991912@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072227.419663002@linuxfoundation.org>
References: <20150114072227.419663002@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/events/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6887,11 +6887,11 @@ SYSCALL_DEFINE5(perf_event_open,
 
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


