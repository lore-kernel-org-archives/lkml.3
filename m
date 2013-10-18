Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab3JRVFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 17:05:17 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:33322 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab3JRVFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 17:05:15 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: kernel-br@googlegroups.com
Cc: "Geyslan G. Bem" <geyslan@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] tracing: fix referencing after memory freeing and refactors code
Date: Fri, 18 Oct 2013 17:59:42 -0300
Message-Id: <1382129982-9668-2-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382129982-9668-1-git-send-email-geyslan@gmail.com>
References: <1382129982-9668-1-git-send-email-geyslan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 'system_tr_open()':
Fix possible 'dir' assignment after freeing it.

In both functions:
Restructures logic conditions testing 'tracing_is_disabled()'
return before the others tests.
Centralizes the exiting in accordance to Coding Style, Chapter 7.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 kernel/trace/trace_events.c | 46 +++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 368a4d5..0f56ebf 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1060,7 +1060,10 @@ static int subsystem_open(struct inode *inode, struct file *filp)
 	struct event_subsystem *system = NULL;
 	struct ftrace_subsystem_dir *dir = NULL; /* Initialize for gcc */
 	struct trace_array *tr;
-	int ret;
+	int ret = -ENODEV;
+
+	if (tracing_is_disabled())
+		return ret;
 
 	/* Make sure the system still exists */
 	mutex_lock(&trace_types_lock);
@@ -1082,23 +1085,21 @@ static int subsystem_open(struct inode *inode, struct file *filp)
 	mutex_unlock(&trace_types_lock);
 
 	if (!system)
-		return -ENODEV;
+		return ret;
 
 	/* Some versions of gcc think dir can be uninitialized here */
 	WARN_ON(!dir);
 
 	/* Still need to increment the ref count of the system */
-	if (trace_array_get(tr) < 0) {
-		put_system(dir);
-		return -ENODEV;
-	}
+	ret = trace_array_get(tr);
+	if (ret)
+		goto err_get;
 
-	ret = tracing_open_generic(inode, filp);
-	if (ret < 0) {
-		trace_array_put(tr);
-		put_system(dir);
-	}
+	filp->private_data = dir;
+	return 0;
 
+err_get:
+	put_system(dir);
 	return ret;
 }
 
@@ -1106,28 +1107,29 @@ static int system_tr_open(struct inode *inode, struct file *filp)
 {
 	struct ftrace_subsystem_dir *dir;
 	struct trace_array *tr = inode->i_private;
-	int ret;
+	int ret = -ENODEV;
 
-	if (trace_array_get(tr) < 0)
-		return -ENODEV;
+	if (tracing_is_disabled())
+		return ret;
+
+	ret = trace_array_get(tr);
+	if (ret)
+		return ret;
 
 	/* Make a temporary dir that has no system but points to tr */
 	dir = kzalloc(sizeof(*dir), GFP_KERNEL);
 	if (!dir) {
-		trace_array_put(tr);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_dir;
 	}
 
 	dir->tr = tr;
 
-	ret = tracing_open_generic(inode, filp);
-	if (ret < 0) {
-		trace_array_put(tr);
-		kfree(dir);
-	}
-
 	filp->private_data = dir;
+	return 0;
 
+err_dir:
+	trace_array_put(tr);
 	return ret;
 }
 
-- 
1.8.4

