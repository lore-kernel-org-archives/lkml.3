Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbaGHAxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:53:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbaGGXyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.15 104/122] tracing/uprobes: Fix the usage of uprobe_buffer_enable() in probe_event_enable()
Date: Mon,  7 Jul 2014 16:57:46 -0700
Message-Id: <20140707235737.364007343@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit fb6bab6a5ad46d00b5ffa22268f21df1cd7c59df upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_uprobe.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -911,26 +911,33 @@ probe_event_enable(struct trace_uprobe *
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
+
+	return 0;
 
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
 


