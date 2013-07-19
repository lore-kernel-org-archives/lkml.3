Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760851Ab3GSP4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 11:56:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760643Ab3GSP4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:56:02 -0400
Date: Fri, 19 Jul 2013 17:51:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] tracing: Simplify trace_array_get()
Message-ID: <20130719155101.GA19509@redhat.com>
References: <20130719155041.GA19501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719155041.GA19501@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trace_array_get() scans the global ftrace_trace_arrays list
to ensure that "this_tr" was not removed by instance_delete().

This looks a bit confusing, we can simply use list_empty() with
the same result. list_empty() == F can not be false positive,
new_instance_create() does everything under the same lock and
tracer_alloc_buffers() which plays with global_trace is __init.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0cd500b..ee471fb 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -206,16 +206,12 @@ LIST_HEAD(ftrace_trace_arrays);
 
 int trace_array_get(struct trace_array *this_tr)
 {
-	struct trace_array *tr;
 	int ret = -ENODEV;
 
 	mutex_lock(&trace_types_lock);
-	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
-		if (tr == this_tr) {
-			tr->ref++;
-			ret = 0;
-			break;
-		}
+	if (!list_empty(&this_tr->list)) {
+		this_tr->ref++;
+		ret = 0;
 	}
 	mutex_unlock(&trace_types_lock);
 
@@ -6019,7 +6015,7 @@ static int instance_delete(const char *name)
 	if (tr->ref)
 		goto out_unlock;
 
-	list_del(&tr->list);
+	list_del_init(&tr->list); /* trace_array_get() checks list_empty() */
 
 	event_trace_del_tracer(tr);
 	debugfs_remove_recursive(tr->dir);
-- 
1.5.5.1


