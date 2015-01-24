Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbbAXOH5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:07:57 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:59468 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbbAXOET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:19 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 19/32] tracing: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:25 -0500
Message-Id: <1422108218-25398-20-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422108218-25398-1-git-send-email-tj@kernel.org>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Please wait till the forementioned patches are merged to mainline
before applying to subsystem trees.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/trace.c     | 6 +++---
 kernel/trace/trace_seq.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4a9079b..1380c16 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3352,12 +3352,12 @@ tracing_cpumask_read(struct file *filp, char __user *ubuf,
 
 	mutex_lock(&tracing_cpumask_update_lock);
 
-	len = cpumask_scnprintf(mask_str, count, tr->tracing_cpumask);
-	if (count - len < 2) {
+	len = snprintf(mask_str, count, "%*pb\n",
+		       cpumask_pr_args(tr->tracing_cpumask));
+	if (len >= count) {
 		count = -EINVAL;
 		goto out_err;
 	}
-	len += sprintf(mask_str + len, "\n");
 	count = simple_read_from_buffer(ubuf, count, ppos, mask_str, NR_CPUS+1);
 
 out_err:
diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
index f8b45d8..e694c9f 100644
--- a/kernel/trace/trace_seq.c
+++ b/kernel/trace/trace_seq.c
@@ -120,7 +120,7 @@ void trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
 
 	__trace_seq_init(s);
 
-	seq_buf_bitmask(&s->seq, maskp, nmaskbits);
+	seq_buf_printf(&s->seq, "%*pb", nmaskbits, maskp);
 
 	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
 		s->seq.len = save_len;
-- 
2.1.0

