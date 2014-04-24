Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbaDXL4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:56:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbaDXLz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:55:58 -0400
Date: Thu, 24 Apr 2014 13:55:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] uprobes/tracing: Fix uprobe_perf_open() on
	uprobe_apply() failure
Message-ID: <20140424115540.GC8882@redhat.com>
References: <20140423165808.GA29485@redhat.com> <20140423165830.GA29493@redhat.com> <20140423231728.1b95e37c@gandalf.local.home> <20140424115458.GA8882@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424115458.GA8882@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uprobe_perf_open()->uprobe_apply() can fail, but this error is wrongly
ignored. Change uprobe_perf_open() to do uprobe_perf_close() and return
the error code in this case.

Change uprobe_perf_close() to propogate the error from uprobe_apply()
as well, although it should not fail.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/trace/trace_uprobe.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 1ed0030..9aad3e2 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1020,7 +1020,7 @@ static int uprobe_perf_close(struct trace_uprobe *tu, struct perf_event *event)
 	write_unlock(&tu->filter.rwlock);
 
 	if (!done)
-		uprobe_apply(tu->inode, tu->offset, &tu->consumer, false);
+		return uprobe_apply(tu->inode, tu->offset, &tu->consumer, false);
 
 	return 0;
 }
@@ -1028,6 +1028,7 @@ static int uprobe_perf_close(struct trace_uprobe *tu, struct perf_event *event)
 static int uprobe_perf_open(struct trace_uprobe *tu, struct perf_event *event)
 {
 	bool done;
+	int err;
 
 	write_lock(&tu->filter.rwlock);
 	if (event->hw.tp_target) {
@@ -1049,10 +1050,13 @@ static int uprobe_perf_open(struct trace_uprobe *tu, struct perf_event *event)
 	}
 	write_unlock(&tu->filter.rwlock);
 
-	if (!done)
-		uprobe_apply(tu->inode, tu->offset, &tu->consumer, true);
-
-	return 0;
+	err = 0;
+	if (!done) {
+		err = uprobe_apply(tu->inode, tu->offset, &tu->consumer, true);
+		if (err)
+			uprobe_perf_close(tu, event);
+	}
+	return err;
 }
 
 static bool uprobe_perf_filter(struct uprobe_consumer *uc,
-- 
1.5.5.1


