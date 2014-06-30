Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbaF3VwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:52:22 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:59013 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754463AbaF3Vvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:51:46 -0400
Message-Id: <20140630215145.055601726@goodmis.org>
User-Agent: quilt/0.63-1
Date: Mon, 30 Jun 2014 17:50:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [for-next][PATCH 4/4] tracing/uprobes: Fix the usage of uprobe_buffer_enable() in
 probe_event_enable()
References: <20140630215038.852406012@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0004-tracing-uprobes-Fix-the-usage-of-uprobe_buffer_enabl.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

The usage of uprobe_buffer_enable() added by dcad1a20 is very wrong,

1. uprobe_buffer_enable() and uprobe_buffer_disable() are not balanced,
   _enable() should be called only if !enabled.

2. If uprobe_buffer_enable() fails probe_event_enable() should clear
   tp.flags and free event_file_link.

3. If uprobe_register() fails it should do uprobe_buffer_disable().

Link: http://lkml.kernel.org/p/20140627170146.GA18332@redhat.com

Acked-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Fixes: dcad1a204f72 "tracing/uprobes: Fetch args before reserving a ring buffer"
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_uprobe.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index c4cf0abd60ba..3c9b97e6b1f4 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -911,26 +911,33 @@ probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
 		tu->tp.flags |= TP_FLAG_PROFILE;
 	}
 
-	ret = uprobe_buffer_enable();
-	if (ret < 0)
-		return ret;
-
 	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
 
 	if (enabled)
 		return 0;
 
+	ret = uprobe_buffer_enable();
+	if (ret)
+		goto err_flags;
+
 	tu->consumer.filter = filter;
 	ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
-	if (ret) {
-		if (file) {
-			list_del(&link->list);
-			kfree(link);
-			tu->tp.flags &= ~TP_FLAG_TRACE;
-		} else
-			tu->tp.flags &= ~TP_FLAG_PROFILE;
-	}
+	if (ret)
+		goto err_buffer;
 
+	return 0;
+
+ err_buffer:
+	uprobe_buffer_disable();
+
+ err_flags:
+	if (file) {
+		list_del(&link->list);
+		kfree(link);
+		tu->tp.flags &= ~TP_FLAG_TRACE;
+	} else {
+		tu->tp.flags &= ~TP_FLAG_PROFILE;
+	}
 	return ret;
 }
 
-- 
2.0.0


