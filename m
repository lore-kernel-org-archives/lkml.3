Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbaLKM0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:26:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56111 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbaLKM0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:26:20 -0500
Date: Thu, 11 Dec 2014 04:25:39 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-9fc81d87420d0d3fd62d5e5529972c0ad9eab9cc@git.kernel.org>
Cc: peterz@infradead.org, fweisbec@gmail.com, zheng.z.yan@intel.com,
        mingo@kernel.org, jolsa@redhat.com, vince@deater.net,
        torvalds@linux-foundation.org, jolsa@kernel.org, eranian@google.com,
        hpa@zytor.com, stable@vger.kernel.org, acme@redhat.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
Reply-To: hpa@zytor.com, jolsa@kernel.org, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        stable@vger.kernel.org, acme@redhat.com, mingo@kernel.org,
        zheng.z.yan@intel.com, peterz@infradead.org, fweisbec@gmail.com,
        torvalds@linux-foundation.org, vince@deater.net, jolsa@redhat.com
In-Reply-To: <1418243031-20367-3-git-send-email-jolsa@kernel.org>
References: <1418243031-20367-3-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf:
  Fix events installation during moving group
Git-Commit-ID: 9fc81d87420d0d3fd62d5e5529972c0ad9eab9cc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9fc81d87420d0d3fd62d5e5529972c0ad9eab9cc
Gitweb:     http://git.kernel.org/tip/9fc81d87420d0d3fd62d5e5529972c0ad9eab9cc
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Wed, 10 Dec 2014 21:23:51 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 11 Dec 2014 11:24:15 +0100

perf: Fix events installation during moving group

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
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/1418243031-20367-3-git-send-email-jolsa@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1cd5eef..2ab0238 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7435,11 +7435,11 @@ SYSCALL_DEFINE5(perf_event_open,
 
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
