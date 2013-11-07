Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3KGEBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 23:01:11 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:38742 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753226Ab3KGEAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 23:00:52 -0500
Message-Id: <20131107040050.373164640@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Nov 2013 23:00:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [for-next][PATCH 3/5] tracing: Do not assign filp->private_data to freed memory
References: <20131107040002.605895766@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Do-not-assign-filp-private_data-to-freed-mem.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Geyslan G. Bem" <geyslan@gmail.com>

In system_tr_open(), the filp->private_data can be assigned the 'dir'
variable even if it was freed. This is on the error path, and is
harmless because the error return code will prevent filp->private_data
from being used. But for correctness, we should not assign it to
a recently freed variable, as that can cause static tools to give
false warnings.

Also have both subsystem_open() and system_tr_open() return -ENODEV
if tracing has been disabled.

Link: http://lkml.kernel.org/r/1383764571-7318-1-git-send-email-geyslan@gmail.com

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 043f833..f919a2e 100644
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
1.8.4.rc3


