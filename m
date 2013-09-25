Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab3IYMy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:54:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538Ab3IYMvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:51:21 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/21] perf: Add new 'paused' attribute
Date: Wed, 25 Sep 2013 14:50:34 +0200
Message-Id: <1380113447-17144-9-git-send-email-jolsa@redhat.com>
In-Reply-To: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding new 'paused' perf_event_attr attribute bit. It sets
the initial event state as paused, so it wont get started
until it's triggered by toggling mechanism.

Original-patch-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/uapi/linux/perf_event.h | 3 ++-
 kernel/events/core.c            | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index b941c21..1539c47 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -278,8 +278,9 @@ struct perf_event_attr {
 				exclude_callchain_kernel : 1, /* exclude kernel callchains */
 				exclude_callchain_user   : 1, /* exclude user callchains */
 				mmap2          :  1, /* include mmap with inode data     */
+				paused         :  1, /* create as paused */
 
-				__reserved_1   : 40;
+				__reserved_1   : 39;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2c8ff93..f5f00a6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6731,6 +6731,9 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 
 	event->state		= PERF_EVENT_STATE_INACTIVE;
 
+	if (attr->paused)
+		event->paused = true;
+
 	if (task) {
 		event->attach_state = PERF_ATTACH_TASK;
 
-- 
1.7.11.7

