Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaIMOvK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 10:51:10 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:4749 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751926AbaIMOui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 10:50:38 -0400
Message-Id: <20140913145033.748654730@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sat, 13 Sep 2014 10:49:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Clark Williams <williams@redhat.com>
Subject: [for-nex][PATCH 1/2] ftrace: Add sanity check when unregistering last ftrace_ops
References: <20140913144906.020493245@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-ftrace-Add-sanity-check-when-unregistering-last-ftra.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When the last ftrace_ops is unregistered, all the function records should
have a zeroed flags value. Make sure that is the case when the last ftrace_ops
is unregistered.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d325a1e76554..fb186b9ddf51 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2416,6 +2416,21 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 
 	ftrace_run_update_code(command);
 
+	/*
+	 * If there's no more ops registered with ftrace, run a
+	 * sanity check to make sure all rec flags are cleared.
+	 */
+	if (ftrace_ops_list == &ftrace_list_end) {
+		struct ftrace_page *pg;
+		struct dyn_ftrace *rec;
+
+		do_for_each_ftrace_rec(pg, rec) {
+			if (FTRACE_WARN_ON_ONCE(rec->flags))
+				pr_warn("  %pS flags:%lx\n",
+					(void *)rec->ip, rec->flags);
+		} while_for_each_ftrace_rec();
+	}
+
 	ops->old_hash.filter_hash = NULL;
 	ops->old_hash.notrace_hash = NULL;
 
-- 
2.0.1


