Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab3G3Lda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 07:33:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11008 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab3G3Lby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 07:31:54 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=m8Pfgv50XzoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=nZekNazA9lsA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=3nbZYyFuAAAA:8 a=x79F7FTOO-CCiT12Jg8A:9 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130730113152.279015307@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 30 Jul 2013 07:27:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next-3.11][PATCH 2/8] tracing: Change event_enable/disable_read() to verify i_private !=
 NULL
References: <20130730112718.273490378@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Change-event_enable-disable_read-to-verify-i.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

tracing_open_generic_file() is racy, ftrace_event_file can be
already freed by rmdir or trace_remove_event_call().

Change event_enable_read() and event_disable_read() to read and
verify "file = i_private" under event_mutex.

This fixes nothing, but now we can change debugfs_remove("enable")
callers to nullify ->i_private and fix the the problem.

Link: http://lkml.kernel.org/r/20130726172536.GA3612@redhat.com

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index c2d13c5..3dfa841 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -684,15 +684,25 @@ static ssize_t
 event_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 		  loff_t *ppos)
 {
-	struct ftrace_event_file *file = filp->private_data;
+	struct ftrace_event_file *file;
+	unsigned long flags;
 	char buf[4] = "0";
 
-	if (file->flags & FTRACE_EVENT_FL_ENABLED &&
-	    !(file->flags & FTRACE_EVENT_FL_SOFT_DISABLED))
+	mutex_lock(&event_mutex);
+	file = event_file_data(filp);
+	if (likely(file))
+		flags = file->flags;
+	mutex_unlock(&event_mutex);
+
+	if (!file)
+		return -ENODEV;
+
+	if (flags & FTRACE_EVENT_FL_ENABLED &&
+	    !(flags & FTRACE_EVENT_FL_SOFT_DISABLED))
 		strcpy(buf, "1");
 
-	if (file->flags & FTRACE_EVENT_FL_SOFT_DISABLED ||
-	    file->flags & FTRACE_EVENT_FL_SOFT_MODE)
+	if (flags & FTRACE_EVENT_FL_SOFT_DISABLED ||
+	    flags & FTRACE_EVENT_FL_SOFT_MODE)
 		strcat(buf, "*");
 
 	strcat(buf, "\n");
@@ -704,13 +714,10 @@ static ssize_t
 event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		   loff_t *ppos)
 {
-	struct ftrace_event_file *file = filp->private_data;
+	struct ftrace_event_file *file;
 	unsigned long val;
 	int ret;
 
-	if (!file)
-		return -EINVAL;
-
 	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
 	if (ret)
 		return ret;
@@ -722,8 +729,11 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	switch (val) {
 	case 0:
 	case 1:
+		ret = -ENODEV;
 		mutex_lock(&event_mutex);
-		ret = ftrace_event_enable_disable(file, val);
+		file = event_file_data(filp);
+		if (likely(file))
+			ret = ftrace_event_enable_disable(file, val);
 		mutex_unlock(&event_mutex);
 		break;
 
-- 
1.7.10.4


