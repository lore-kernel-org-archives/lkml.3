Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936591Ab3DHKWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:22:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42663 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935478Ab3DHJvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Rostedt <rostedt@goodmis.org>, Lingzhu Xiang <lxiang@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 017/102] tracing: Protect tracer flags with trace_types_lock
Date: Mon,  8 Apr 2013 10:49:32 +0100
Message-Id: <1365414657-29191-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lingzhu Xiang <lxiang@redhat.com>

commit 69d34da2984c95b33ea21518227e1f9470f11d95 upstream.

Backported for 3.4, 3.0-stable. Moved return to after unlock.

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Seems that the tracer flags have never been protected from
synchronous writes. Luckily, admins don't usually modify the
tracing flags via two different tasks. But if scripts were to
be used to modify them, then they could get corrupted.

Move the trace_types_lock that protects against tracers changing
to also protect the flags being set.

Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
Reviewed-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Luis Henriques<luis.henriques@canonical.com>
---
 kernel/trace/trace.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 199f77b..b354405 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2791,7 +2791,7 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 	char buf[64];
 	char *cmp;
 	int neg = 0;
-	int ret;
+	int ret = 0;
 	int i;
 
 	if (cnt >= sizeof(buf))
@@ -2808,6 +2808,8 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 		cmp += 2;
 	}
 
+	mutex_lock(&trace_types_lock);
+
 	for (i = 0; trace_options[i]; i++) {
 		if (strcmp(cmp, trace_options[i]) == 0) {
 			set_tracer_flags(1 << i, !neg);
@@ -2816,13 +2818,13 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 	}
 
 	/* If no option could be set, test the specific tracer options */
-	if (!trace_options[i]) {
-		mutex_lock(&trace_types_lock);
+	if (!trace_options[i])
 		ret = set_tracer_option(current_trace, cmp, neg);
-		mutex_unlock(&trace_types_lock);
-		if (ret)
-			return ret;
-	}
+
+	mutex_unlock(&trace_types_lock);
+
+	if (ret)
+		return ret;
 
 	*ppos += cnt;
 
@@ -4601,7 +4603,10 @@ trace_options_core_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	if (val != 0 && val != 1)
 		return -EINVAL;
+
+	mutex_lock(&trace_types_lock);
 	set_tracer_flags(1 << index, val);
+	mutex_unlock(&trace_types_lock);
 
 	*ppos += cnt;
 
-- 
1.8.1.2

