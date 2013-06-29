Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab3F2FKA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 01:10:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:54765 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579Ab3F2FIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 01:08:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,963,1363158000"; 
   d="scan'208";a="357641908"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, jovi.zhangwei@huawei.com,
        linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v2 01/11] tracing: simplify event_enable_read()
Date: Sat, 29 Jun 2013 00:08:04 -0500
Message-Id: <9aff5af6dee2f5a40ca30df41c39d5f33e998d7a.1372479499.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1372479499.git.tom.zanussi@linux.intel.com>
References: <cover.1372479499.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1372479499.git.tom.zanussi@linux.intel.com>
References: <cover.1372479499.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than enumerating each permutation, build the enable state
string up from the combination of states.  This also allows for the
simpler addition of more states.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 kernel/trace/trace_events.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 27963e2..ecb2609 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -624,17 +624,17 @@ event_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 		  loff_t *ppos)
 {
 	struct ftrace_event_file *file = filp->private_data;
-	char *buf;
+	char buf[4] = "0";
 
-	if (file->flags & FTRACE_EVENT_FL_ENABLED) {
-		if (file->flags & FTRACE_EVENT_FL_SOFT_DISABLED)
-			buf = "0*\n";
-		else if (file->flags & FTRACE_EVENT_FL_SOFT_MODE)
-			buf = "1*\n";
-		else
-			buf = "1\n";
-	} else
-		buf = "0\n";
+	if (file->flags & FTRACE_EVENT_FL_ENABLED &&
+	    !(file->flags & FTRACE_EVENT_FL_SOFT_DISABLED))
+		strcpy(buf, "1");
+
+	if (file->flags & FTRACE_EVENT_FL_SOFT_DISABLED ||
+	    file->flags & FTRACE_EVENT_FL_SOFT_MODE)
+		strcat(buf, "*");
+
+	strcat(buf, "\n");
 
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, strlen(buf));
 }
-- 
1.7.11.4

