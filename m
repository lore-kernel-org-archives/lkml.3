Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab3F1NHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:07:46 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:34241 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab3F1NHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:07:45 -0400
X-AuditID: 85900ec0-d56cbb900000151e-bf-51cd8a9e047c
Subject: [PATCH] tracing/kprobe: Recover old array if fails to enable kprobe
To: Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>
Date: Fri, 28 Jun 2013 22:04:52 +0900
Message-ID: <20130628130452.1132.85665.stgit@mhiramat-M0-7522>
In-Reply-To: <51CD25A6.2030907@hitachi.com>
References: <51CD25A6.2030907@hitachi.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make enable_trace_probe to recover (writeback) the old file array
and free new one if we fail to enable the kprobe.
However, this MUST NOT happen at this time except for unknown
bug or changing the implementation of enable_kprobe(), because
usual failure cases (not registered or gone) are already filtered.
Thus I just add a WARN_ON() on the error path.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/trace_kprobe.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index f237417..d29773e 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -202,6 +202,20 @@ static int trace_probe_nr_files(struct trace_probe *tp)
 
 static DEFINE_MUTEX(probe_enable_lock);
 
+static int __enable_trace_probe(struct trace_probe *tp)
+{
+	int ret = 0;
+
+	if (trace_probe_is_registered(tp) && !trace_probe_has_gone(tp)) {
+		if (trace_probe_is_return(tp))
+			ret = enable_kretprobe(&tp->rp);
+		else
+			ret = enable_kprobe(&tp->rp.kp);
+		WARN_ON(ret);/* This must succeed. */
+	}
+	return ret;
+}
+
 /*
  * Enable trace_probe
  * if the file is NULL, enable "perf" handler, or enable "trace" handler.
@@ -232,19 +246,21 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 		rcu_assign_pointer(tp->files, new);
 		tp->flags |= TP_FLAG_TRACE;
 
+		ret = __enable_trace_probe(tp);
+		if (ret < 0) {
+			/* Write back the old list */
+			rcu_assign_pointer(tp->files, old);
+			old = new;	/* "new" must be freed */
+		}
+
 		if (old) {
 			/* Make sure the probe is done with old files */
 			synchronize_sched();
 			kfree(old);
 		}
-	} else
+	} else {
 		tp->flags |= TP_FLAG_PROFILE;
-
-	if (trace_probe_is_registered(tp) && !trace_probe_has_gone(tp)) {
-		if (trace_probe_is_return(tp))
-			ret = enable_kretprobe(&tp->rp);
-		else
-			ret = enable_kprobe(&tp->rp.kp);
+		ret = __enable_trace_probe(tp);
 	}
 
  out_unlock:

