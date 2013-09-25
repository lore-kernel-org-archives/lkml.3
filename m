Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab3IYMvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:51:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394Ab3IYMvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:51:19 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 07/21] perf: Toggle whole group in toggle event overflow
Date: Wed, 25 Sep 2013 14:50:33 +0200
Message-Id: <1380113447-17144-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toggling whole group in toggle event overflow,
so we could use the toggling for even groups.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/events/core.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index b41a0d8..2c8ff93 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5267,8 +5267,8 @@ static void perf_log_throttle(struct perf_event *event, int enable)
  * - fix race against other toggler
  * - fix race against other callers of ->stop/start (adjust period/freq)
  */
-static void perf_event_toggle(struct perf_event *event,
-			      enum perf_event_toggle_flag flag)
+static void __perf_event_toggle(struct perf_event *event,
+				enum perf_event_toggle_flag flag)
 {
 	unsigned long flags;
 	bool active;
@@ -5304,6 +5304,16 @@ static void perf_event_toggle(struct perf_event *event,
 	local_irq_restore(flags);
 }
 
+static void perf_event_toggle(struct perf_event *leader,
+			      enum perf_event_toggle_flag flag)
+{
+	struct perf_event *event;
+
+	__perf_event_toggle(leader, flag);
+	list_for_each_entry(event, &leader->sibling_list, group_entry)
+		__perf_event_toggle(event, flag);
+}
+
 static void
 perf_event_toggle_overflow(struct perf_event *event,
 			   struct perf_sample_data *data,
-- 
1.7.11.7

