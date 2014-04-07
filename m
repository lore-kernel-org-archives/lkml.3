Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbaDGPKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:10:08 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:63215 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbaDGPFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:05:04 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>
Cc: Robert Richter <robert.richter@linaro.org>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 04/16] perf, mmap: Factor out perf_get_fd()
Date: Mon,  7 Apr 2014 17:04:26 +0200
Message-Id: <1396883078-25320-5-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

This new function creates a new fd for an event. We need this later to
get a fd from a persistent event.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
---
 kernel/events/core.c     | 14 ++++++++------
 kernel/events/internal.h |  1 +
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 22ec8f0..9857475 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4206,6 +4206,11 @@ static const struct file_operations perf_fops = {
 	.fasync			= perf_fasync,
 };
 
+int perf_get_fd(struct perf_event *event, int f_flags)
+{
+	return anon_inode_getfd("[perf_event]", &perf_fops, event, f_flags);
+}
+
 /*
  * Perf event wakeup
  *
@@ -7028,7 +7033,6 @@ SYSCALL_DEFINE5(perf_event_open,
 	struct perf_event *event, *sibling;
 	struct perf_event_attr attr;
 	struct perf_event_context *ctx;
-	struct file *event_file = NULL;
 	struct fd group = {NULL, 0};
 	struct task_struct *task = NULL;
 	struct pmu *pmu;
@@ -7189,10 +7193,9 @@ SYSCALL_DEFINE5(perf_event_open,
 			goto err_context;
 	}
 
-	event_file = anon_inode_getfile("[perf_event]", &perf_fops, event,
-					f_flags);
-	if (IS_ERR(event_file)) {
-		err = PTR_ERR(event_file);
+	event_fd = perf_get_fd(event, f_flags);
+	if (event_fd < 0) {
+		err = event_fd;
 		goto err_context;
 	}
 
@@ -7257,7 +7260,6 @@ SYSCALL_DEFINE5(perf_event_open,
 	 * perf_group_detach().
 	 */
 	fdput(group);
-	fd_install(event_fd, event_file);
 	return event_fd;
 
 err_context:
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index e9007ff..5f1f92d 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -209,5 +209,6 @@ static inline void put_event(struct perf_event *event)
 
 extern int perf_alloc_rb(struct perf_event *event, int nr_pages, int flags);
 extern void perf_free_rb(struct perf_event *event);
+extern int perf_get_fd(struct perf_event *event, int f_flags);
 
 #endif /* _KERNEL_EVENTS_INTERNAL_H */
-- 
1.7.11.7

