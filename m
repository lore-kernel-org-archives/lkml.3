Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab3G2Qly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:41:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:16206 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757772Ab3G2Qlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:41:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,771,1367996400"; 
   d="scan'208";a="378394887"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v4 11/11] tracing: change event_trigger_open to verify i_private != NULL
Date: Mon, 29 Jul 2013 11:41:07 -0500
Message-Id: <167fe38d53bbfdfb40ffe9bb2f7d122c08cddad5.1375111640.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1375111640.git.tom.zanussi@linux.intel.com>
References: <cover.1375111640.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1375111640.git.tom.zanussi@linux.intel.com>
References: <cover.1375111640.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to the other fixes for the same thing elsewhere by Oleg
Nesterov...

event_trigger_regex_open() is racy, ftrace_event_file can be already
freed by rmdir or trace_remove_event_call().

Change event_trigger_open() to read and verify "file = i_private"
under event_mutex.

This also moves event_file_data() into trace.h so it can be used
outside of trace_events.c.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 kernel/trace/trace.h                | 4 ++++
 kernel/trace/trace_events.c         | 5 -----
 kernel/trace/trace_events_trigger.c | 7 ++++++-
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index c56a773..a6ef810 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1023,6 +1023,10 @@ extern int event_trace_del_tracer(struct trace_array *tr);
 extern struct ftrace_event_file *find_event_file(struct trace_array *tr,
 						 const char *system,
 						 const char *event);
+static inline void *event_file_data(struct file *filp)
+{
+	return ACCESS_ONCE(file_inode(filp)->i_private);
+}
 
 extern struct mutex event_mutex;
 extern struct list_head ftrace_events;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 6b4cb04..a444f65 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -427,11 +427,6 @@ static void remove_subsystem(struct ftrace_subsystem_dir *dir)
 	}
 }
 
-static void *event_file_data(struct file *filp)
-{
-	return ACCESS_ONCE(file_inode(filp)->i_private);
-}
-
 static void remove_event_file_dir(struct ftrace_event_file *file)
 {
 	struct dentry *dir = file->dir;
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 54112be..011bdfb 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -133,7 +133,12 @@ static int event_trigger_regex_open(struct inode *inode, struct file *file)
 
 	mutex_lock(&event_mutex);
 
-	iter->file = inode->i_private;
+	iter->file = event_file_data(file);
+	if (!iter->file) {
+		kfree(iter);
+		mutex_unlock(&event_mutex);
+		return -ENODEV;
+	}
 
 	if (file->f_mode & FMODE_READ) {
 		ret = seq_open(file, &event_triggers_seq_ops);
-- 
1.7.11.4

