Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab3GWAbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 20:31:23 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:43414 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab3GWAbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 20:31:19 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 5/8] perf: Migrate per cpu event accounting
Date: Tue, 23 Jul 2013 02:31:03 +0200
Message-Id: <1374539466-4799-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an event is migrated, move the event per-cpu
accounting accordingly so that branch stack and cgroup
events work correctly on the new CPU.

Original-patch-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
---
 kernel/events/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index fd820a4..b40c3db 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7144,6 +7144,7 @@ void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
 	list_for_each_entry_safe(event, tmp, &src_ctx->event_list,
 				 event_entry) {
 		perf_remove_from_context(event);
+		unaccount_event_cpu(event, src_cpu);
 		put_ctx(src_ctx);
 		list_add(&event->event_entry, &events);
 	}
@@ -7156,6 +7157,7 @@ void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
 		list_del(&event->event_entry);
 		if (event->state >= PERF_EVENT_STATE_OFF)
 			event->state = PERF_EVENT_STATE_INACTIVE;
+		account_event_cpu(event, dst_cpu);
 		perf_install_in_context(dst_ctx, event, dst_cpu);
 		get_ctx(dst_ctx);
 	}
-- 
1.7.5.4

