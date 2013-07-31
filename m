Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399Ab3GaI5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:57:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41773 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759282Ab3GaI5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:57:12 -0400
Date: Wed, 31 Jul 2013 01:56:39 -0700
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-9a545de019b536771feefb76f85e5038b65c2190@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1374539466-4799-6-git-send-email-fweisbec@gmail.com>
References: <1374539466-4799-6-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Migrate per cpu event accounting
Git-Commit-ID: 9a545de019b536771feefb76f85e5038b65c2190
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 31 Jul 2013 01:56:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9a545de019b536771feefb76f85e5038b65c2190
Gitweb:     http://git.kernel.org/tip/9a545de019b536771feefb76f85e5038b65c2190
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 23 Jul 2013 02:31:03 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Jul 2013 22:29:14 +0200

perf: Migrate per cpu event accounting

When an event is migrated, move the event per-cpu
accounting accordingly so that branch stack and cgroup
events work correctly on the new CPU.

Original-patch-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1374539466-4799-6-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3a4b73a..63bdec9 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7145,6 +7145,7 @@ void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
 	list_for_each_entry_safe(event, tmp, &src_ctx->event_list,
 				 event_entry) {
 		perf_remove_from_context(event);
+		unaccount_event_cpu(event, src_cpu);
 		put_ctx(src_ctx);
 		list_add(&event->event_entry, &events);
 	}
@@ -7157,6 +7158,7 @@ void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
 		list_del(&event->event_entry);
 		if (event->state >= PERF_EVENT_STATE_OFF)
 			event->state = PERF_EVENT_STATE_INACTIVE;
+		account_event_cpu(event, dst_cpu);
 		perf_install_in_context(dst_ctx, event, dst_cpu);
 		get_ctx(dst_ctx);
 	}
