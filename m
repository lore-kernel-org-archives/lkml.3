Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3HVORj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:17:39 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:61799 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab3HVOOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:14:42 -0400
From: Robert Richter <rric@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH v3 04/12] perf, mmap: Factor out perf_get_fd()
Date: Thu, 22 Aug 2013 16:13:19 +0200
Message-Id: <1377180807-12758-5-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1377180807-12758-1-git-send-email-rric@kernel.org>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

This new function creates a new fd for an event. We need this later to
get a fd from a persistent event.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 kernel/events/core.c     | 13 ++++++++-----
 kernel/events/internal.h |  1 +
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 24810d5..932acc6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4100,6 +4100,11 @@ static const struct file_operations perf_fops = {
 	.fasync			= perf_fasync,
 };
 
+int perf_get_fd(struct perf_event *event)
+{
+	return anon_inode_getfd("[perf_event]", &perf_fops, event, O_RDWR);
+}
+
 /*
  * Perf event wakeup
  *
@@ -6868,7 +6873,6 @@ SYSCALL_DEFINE5(perf_event_open,
 	struct perf_event *event, *sibling;
 	struct perf_event_attr attr;
 	struct perf_event_context *ctx;
-	struct file *event_file = NULL;
 	struct fd group = {NULL, 0};
 	struct task_struct *task = NULL;
 	struct pmu *pmu;
@@ -7025,9 +7029,9 @@ SYSCALL_DEFINE5(perf_event_open,
 			goto err_context;
 	}
 
-	event_file = anon_inode_getfile("[perf_event]", &perf_fops, event, O_RDWR);
-	if (IS_ERR(event_file)) {
-		err = PTR_ERR(event_file);
+	event_fd = perf_get_fd(event);
+	if (event_fd < 0) {
+		err = event_fd;
 		goto err_context;
 	}
 
@@ -7093,7 +7097,6 @@ SYSCALL_DEFINE5(perf_event_open,
 	 * perf_group_detach().
 	 */
 	fdput(group);
-	fd_install(event_fd, event_file);
 	return event_fd;
 
 err_context:
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 8ddaf57..d8708aa 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -192,5 +192,6 @@ static inline void put_event(struct perf_event *event)
 
 extern int perf_alloc_rb(struct perf_event *event, int nr_pages, int flags);
 extern void perf_free_rb(struct perf_event *event);
+extern int perf_get_fd(struct perf_event *event);
 
 #endif /* _KERNEL_EVENTS_INTERNAL_H */
-- 
1.8.3.2

