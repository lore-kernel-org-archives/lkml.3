Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab3KFTIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:08:43 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55686 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab3KFTIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:08:41 -0500
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: kernel-br@googlegroups.com
Cc: "Geyslan G. Bem" <geyslan@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] tracing: fix referencing after memory freeing and refactors code
Date: Wed,  6 Nov 2013 16:02:51 -0300
Message-Id: <1383764571-7318-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 'system_tr_open()':
Fix possible 'dir' assignment after freeing it.

In both functions:
Restructures logic conditions testing 'tracing_is_disabled()'
return before the others tests.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 kernel/trace/trace_events.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 368a4d5..b44a7ea 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1062,6 +1062,9 @@ static int subsystem_open(struct inode *inode, struct file *filp)
 	struct trace_array *tr;
 	int ret;
 
+	if (tracing_is_disabled())
+		return -ENODEV;
+
 	/* Make sure the system still exists */
 	mutex_lock(&trace_types_lock);
 	mutex_lock(&event_mutex);
@@ -1108,6 +1111,9 @@ static int system_tr_open(struct inode *inode, struct file *filp)
 	struct trace_array *tr = inode->i_private;
 	int ret;
 
+	if (tracing_is_disabled())
+		return -ENODEV;
+
 	if (trace_array_get(tr) < 0)
 		return -ENODEV;
 
@@ -1124,11 +1130,12 @@ static int system_tr_open(struct inode *inode, struct file *filp)
 	if (ret < 0) {
 		trace_array_put(tr);
 		kfree(dir);
+		return ret;
 	}
 
 	filp->private_data = dir;
 
-	return ret;
+	return 0;
 }
 
 static int subsystem_release(struct inode *inode, struct file *file)
-- 
1.8.4.2

