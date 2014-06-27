Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbaF0SO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 14:14:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaF0SO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 14:14:26 -0400
Date: Fri, 27 Jun 2014 19:01:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] tracing/uprobes: Fix the usage of
	uprobe_buffer_enable() in probe_event_enable()
Message-ID: <20140627170146.GA18332@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140627170116.GA18298@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of uprobe_buffer_enable() added by dcad1a20 is very wrong,

1. uprobe_buffer_enable() and uprobe_buffer_disable() are not balanced,
   _enable() should be called only if !enabled.

2. If uprobe_buffer_enable() fails probe_event_enable() should clear
   tp.flags and free event_file_link.

3. If uprobe_register() fails it should do uprobe_buffer_disable().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_uprobe.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index c4cf0ab..3c9b97e 100644
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
1.5.5.1

