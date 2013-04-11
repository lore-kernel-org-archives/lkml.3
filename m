Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762484Ab3DKU3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:29:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9444 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756Ab3DKU0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:18 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=GThR628NrdUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=CmE_PxhClxwA:10 a=VwQbUJbxAAAA:8 a=EcS1gyuxdr9p5kJSHoYA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202552.232760989@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [ 037/171 ] tracing: Protect tracer flags with trace_types_lock
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0037-tracing-Protect-tracer-flags-with-trace_types_lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

[ Upstream commit 69d34da2984c95b33ea21518227e1f9470f11d95 ]

Seems that the tracer flags have never been protected from
synchronous writes. Luckily, admins don't usually modify the
tracing flags via two different tasks. But if scripts were to
be used to modify them, then they could get corrupted.

Move the trace_types_lock that protects against tracers changing
to also protect the flags being set.

Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0293d9a..06b227d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2819,6 +2819,8 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 		cmp += 2;
 	}
 
+	mutex_lock(&trace_types_lock);
+
 	for (i = 0; trace_options[i]; i++) {
 		if (strcmp(cmp, trace_options[i]) == 0) {
 			set_tracer_flags(1 << i, !neg);
@@ -2827,13 +2829,10 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
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
 
 	*ppos += cnt;
 
@@ -4613,7 +4612,10 @@ trace_options_core_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	if (val != 0 && val != 1)
 		return -EINVAL;
+
+	mutex_lock(&trace_types_lock);
 	set_tracer_flags(1 << index, val);
+	mutex_unlock(&trace_types_lock);
 
 	*ppos += cnt;
 
-- 
1.7.10.4


