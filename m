Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742Ab3LKMiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:38:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:32364 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab3LKMiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:38:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="442367996"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v0 06/71] perf: Allow set-output for task contexts of different types
Date: Wed, 11 Dec 2013 14:36:18 +0200
Message-Id: <1386765443-26966-7-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Set-output must be limited to events that cannot be active on different
cpus at the same time.  Thus either the event cpu must be the same, or
the event task must be the same.  Current logic does not check the task
directly but checks whether the perf_event_context is the same, however
there are separate contexts for hardware and software events so in that
case the perf_event_context is different even though the task is the same.
This patch changes the logic to check the task directly.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 kernel/events/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index ca8a130..93d712d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6982,7 +6982,8 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 	/*
 	 * If its not a per-cpu rb, it must be the same task.
 	 */
-	if (output_event->cpu == -1 && output_event->ctx != event->ctx)
+	if (output_event->cpu == -1 &&
+	    output_event->ctx->task != event->ctx->task)
 		goto out;
 	/*
 	 * XXX^2: that's all bollocks
-- 
1.8.5.1

