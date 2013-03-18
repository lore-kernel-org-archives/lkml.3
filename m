Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3CRLJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:09:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34168 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab3CRLJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:09:08 -0400
Date: Mon, 18 Mar 2013 04:07:54 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-d610d98b5de6860feb21539726e9af7c9094151c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, namhyung.kim@lge.com,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1363332433-7637-1-git-send-email-namhyung@kernel.org>
References: <1363332433-7637-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf:
  Generate EXIT event only once per task context
Git-Commit-ID: d610d98b5de6860feb21539726e9af7c9094151c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Mar 2013 04:07:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d610d98b5de6860feb21539726e9af7c9094151c
Gitweb:     http://git.kernel.org/tip/d610d98b5de6860feb21539726e9af7c9094151c
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 15 Mar 2013 16:27:13 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Mar 2013 09:47:33 +0100

perf: Generate EXIT event only once per task context

perf_event_task_event() iterates pmu list and generate events
for each eligible pmu context.  But if task_event has task_ctx
like in EXIT it'll generate events even though the pmu doesn't
have an eligible one. Fix it by moving the code to proper
places.

Before this patch:

  $ perf record -n true
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.006 MB perf.data (~248 samples) ]

  $ perf report -D | tail
  Aggregated stats:
             TOTAL events:         73
              MMAP events:         67
              COMM events:          2
              EXIT events:          4
  cycles stats:
             TOTAL events:         73
              MMAP events:         67
              COMM events:          2
              EXIT events:          4

After this patch:

  $ perf report -D | tail
  Aggregated stats:
             TOTAL events:         70
              MMAP events:         67
              COMM events:          2
              EXIT events:          1
  cycles stats:
             TOTAL events:         70
              MMAP events:         67
              COMM events:          2
              EXIT events:          1

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1363332433-7637-1-git-send-email-namhyung@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index fa79c37..59412d0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4434,12 +4434,15 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 			if (ctxn < 0)
 				goto next;
 			ctx = rcu_dereference(current->perf_event_ctxp[ctxn]);
+			if (ctx)
+				perf_event_task_ctx(ctx, task_event);
 		}
-		if (ctx)
-			perf_event_task_ctx(ctx, task_event);
 next:
 		put_cpu_ptr(pmu->pmu_cpu_context);
 	}
+	if (task_event->task_ctx)
+		perf_event_task_ctx(task_event->task_ctx, task_event);
+
 	rcu_read_unlock();
 }
 
