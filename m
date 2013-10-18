Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab3JRBt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 21:49:27 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:46208 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab3JRBt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 21:49:26 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: kernel-br@googlegroups.com, "Geyslan G. Bem" <geyslan@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] tracing: fix referencing after memory freeing and refactors code
Date: Thu, 17 Oct 2013 22:44:56 -0300
Message-Id: <1382060696-30746-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restructures function logic conditions testing 'tracing_open_generic'
return before the others. It avoids: unnecessary trace_array_get and
kzalloc when tracing is disabled; and fix the possible 'dir'
assignment after freeing it.

Centralizes the exiting, ensuring the 'trace_array_put' on error,
in accordance to Coding Style, Chapter 7.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 kernel/trace/trace_events.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 368a4d5..8232362 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1108,26 +1108,28 @@ static int system_tr_open(struct inode *inode, struct file *filp)
 	struct trace_array *tr = inode->i_private;
 	int ret;
 
-	if (trace_array_get(tr) < 0)
-		return -ENODEV;
+	ret = tracing_open_generic(inode, filp);
+	if (ret)
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

