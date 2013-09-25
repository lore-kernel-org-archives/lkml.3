Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab3IYMvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:51:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394Ab3IYMvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:51:13 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 03/21] perf x86: Update event count properly for read syscall
Date: Wed, 25 Sep 2013 14:50:29 +0200
Message-Id: <1380113447-17144-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Within the read syscall we update the event count via
pmu->read callback if the event is in ACTIVE state.

This triggers event update (x86_perf_event_update) for
x86 pmu and leads to wrong event count in case the event
hasn't been started yet -> the event base is not adjusted
to new cpu and new count computation is based on previous
CPU prev_count.

Fixing this to update the counter only if it has been
started, so the event base is properly adjusted.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 8355c84..e89c773 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1570,7 +1570,11 @@ early_initcall(init_hw_perf_events);
 
 static inline void x86_pmu_read(struct perf_event *event)
 {
-	x86_perf_event_update(event);
+	struct hw_perf_event *hwc = &event->hw;
+
+	/* Update only if the event has already been started. */
+	if (!(hwc->state & PERF_HES_ARCH))
+		x86_perf_event_update(event);
 }
 
 /*
-- 
1.7.11.7

