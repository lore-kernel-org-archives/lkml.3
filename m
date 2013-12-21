Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab3LUWoY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 17:44:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:63767 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756095Ab3LUWoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 17:44:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,529,1384329600"; 
   d="scan'208";a="428381355"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 2/3] tracing: Add and use event_trigger_lseek()
Date: Sat, 21 Dec 2013 16:44:01 -0600
Message-Id: <b6945a78cef7c0af80a5035e6c7814819ddcc7e0.1387662969.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1387662969.git.tom.zanussi@linux.intel.com>
References: <cover.1387662969.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1387662969.git.tom.zanussi@linux.intel.com>
References: <cover.1387662969.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

event_trigger_fops is currently using ftrace_filter_lseek, which
doesn't work out so well if CONFIG_FUNCTION_TRACER isn't configured
(compile error).

We also wanted to be completely decoupled from ftrace anyway, so
create our own version and use it instead.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 kernel/trace/trace_events_trigger.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index f5b3f78..ff4d51e 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -277,11 +277,24 @@ event_trigger_release(struct inode *inode, struct file *file)
 	return event_trigger_regex_release(inode, file);
 }
 
+static loff_t
+event_trigger_lseek(struct file *file, loff_t offset, int whence)
+{
+	loff_t ret;
+
+	if (file->f_mode & FMODE_READ)
+		ret = seq_lseek(file, offset, whence);
+	else
+		file->f_pos = ret = 1;
+
+	return ret;
+}
+
 const struct file_operations event_trigger_fops = {
 	.open = event_trigger_open,
 	.read = seq_read,
 	.write = event_trigger_write,
-	.llseek = ftrace_filter_lseek,
+	.llseek = event_trigger_lseek,
 	.release = event_trigger_release,
 };
 
-- 
1.8.3.1

