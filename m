Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaB0Neh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:34:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55065 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaB0Neb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:34:31 -0500
Date: Thu, 27 Feb 2014 05:34:01 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-sctoo9t2f3nn2c9g568928q3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Optimize group_sched_in()
Git-Commit-ID: 4a2345937c17722bd2979f662ae909846b4a052a
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

Commit-ID:  4a2345937c17722bd2979f662ae909846b4a052a
Gitweb:     http://git.kernel.org/tip/4a2345937c17722bd2979f662ae909846b4a052a
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 24 Feb 2014 12:43:31 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Feb 2014 12:43:26 +0100

perf: Optimize group_sched_in()

Use the ctx pmu instead of the event pmu.

When a group leader is a software event but the group contains
hardware events, the entire group is on the hardware PMU.

Using the hardware PMU for the transaction makes most sense since
that's the most expensive one to programm (and software PMUs generally
don't have TXN support anyway).

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-sctoo9t2f3nn2c9g568928q3@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 823a53d..661951a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1733,7 +1733,7 @@ group_sched_in(struct perf_event *group_event,
 	       struct perf_event_context *ctx)
 {
 	struct perf_event *event, *partial_group = NULL;
-	struct pmu *pmu = group_event->pmu;
+	struct pmu *pmu = ctx->pmu;
 	u64 now = ctx->time;
 	bool simulate = false;
 
