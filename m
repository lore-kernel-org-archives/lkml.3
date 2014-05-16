Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992431AbaEPVo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:44:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:3300 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbaEPVnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:43:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1069,1389772800"; 
   d="scan'208";a="433231950"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 6/8] ftrace: Out of line ftrace_trigger_soft_disabled
Date: Fri, 16 May 2014 14:43:13 -0700
Message-Id: <1400276595-6965-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
References: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Out of lining this function saves about 14k text

   text	   data	    bss	    dec	    hex	filename
14094629	2004040	1507328	17605997	10ca56d	vmlinux-before-ftrace
14079650	2008136	1507328	17595114	10c7aea	vmlinux-ftrace

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/ftrace_event.h        | 23 +----------------------
 kernel/trace/trace_events_trigger.c | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index d16da3e..70be665 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -416,28 +416,7 @@ extern enum event_trigger_type event_triggers_call(struct ftrace_event_file *fil
 extern void event_triggers_post_call(struct ftrace_event_file *file,
 				     enum event_trigger_type tt);
 
-/**
- * ftrace_trigger_soft_disabled - do triggers and test if soft disabled
- * @file: The file pointer of the event to test
- *
- * If any triggers without filters are attached to this event, they
- * will be called here. If the event is soft disabled and has no
- * triggers that require testing the fields, it will return true,
- * otherwise false.
- */
-static inline bool
-ftrace_trigger_soft_disabled(struct ftrace_event_file *file)
-{
-	unsigned long eflags = file->flags;
-
-	if (!(eflags & FTRACE_EVENT_FL_TRIGGER_COND)) {
-		if (eflags & FTRACE_EVENT_FL_TRIGGER_MODE)
-			event_triggers_call(file, NULL);
-		if (eflags & FTRACE_EVENT_FL_SOFT_DISABLED)
-			return true;
-	}
-	return false;
-}
+extern bool ftrace_trigger_soft_disabled(struct ftrace_event_file *file);
 
 /*
  * Helper function for event_trigger_unlock_commit{_regs}().
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 4747b47..136c181 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -28,6 +28,31 @@
 static LIST_HEAD(trigger_commands);
 static DEFINE_MUTEX(trigger_cmd_mutex);
 
+
+/**
+ * ftrace_trigger_soft_disabled - do triggers and test if soft disabled
+ * @file: The file pointer of the event to test
+ *
+ * If any triggers without filters are attached to this event, they
+ * will be called here. If the event is soft disabled and has no
+ * triggers that require testing the fields, it will return true,
+ * otherwise false.
+ */
+bool
+ftrace_trigger_soft_disabled(struct ftrace_event_file *file)
+{
+	unsigned long eflags = file->flags;
+
+	if (!(eflags & FTRACE_EVENT_FL_TRIGGER_COND)) {
+		if (eflags & FTRACE_EVENT_FL_TRIGGER_MODE)
+			event_triggers_call(file, NULL);
+		if (eflags & FTRACE_EVENT_FL_SOFT_DISABLED)
+			return true;
+	}
+	return false;
+}
+EXPORT_SYMBOL(ftrace_trigger_soft_disabled);
+
 static void
 trigger_data_free(struct event_trigger_data *data)
 {
-- 
1.9.0

