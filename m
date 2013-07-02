Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab3GBU17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 16:27:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27520 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab3GBUY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 16:24:27 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=rl2FCl9SyfAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=TQi8bcP0i80A:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=Zitr5sS-VtFECFcuw-cA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130702202425.824494298@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 02 Jul 2013 16:22:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [for-next][PATCH 04/14] tracing: Simplify code for showing of soft disabled flag
References: <20130702202216.623562799@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Simplify-code-for-showing-of-soft-disabled-f.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@linux.intel.com>

Rather than enumerating each permutation, build the enable state
string up from the combination of states.  This also allows for the
simpler addition of more states.

Link: http://lkml.kernel.org/r/9aff5af6dee2f5a40ca30df41c39d5f33e998d7a.1372479499.git.tom.zanussi@linux.intel.com

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 903a0bf..7ee08b9 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -638,17 +638,17 @@ event_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
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
1.7.10.4


