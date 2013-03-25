Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124Ab3CYB11 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:27:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34026 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756120Ab3CYBQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:07 -0400
Message-Id: <20130325010530.122444643@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:23 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Subject: [ 059/104] tracing: Protect tracer flags with trace_types_lock
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 69d34da2984c95b33ea21518227e1f9470f11d95 upstream.

Seems that the tracer flags have never been protected from
synchronous writes. Luckily, admins don't usually modify the
tracing flags via two different tasks. But if scripts were to
be used to modify them, then they could get corrupted.

Move the trace_types_lock that protects against tracers changing
to also protect the flags being set.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[bwh: Backported to 3.2: also move failure return in
 tracing_trace_options_write() after unlocking]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2661,7 +2661,7 @@ tracing_trace_options_write(struct file
 	char buf[64];
 	char *cmp;
 	int neg = 0;
-	int ret;
+	int ret = 0;
 	int i;
 
 	if (cnt >= sizeof(buf))
@@ -2678,6 +2678,8 @@ tracing_trace_options_write(struct file
 		cmp += 2;
 	}
 
+	mutex_lock(&trace_types_lock);
+
 	for (i = 0; trace_options[i]; i++) {
 		if (strcmp(cmp, trace_options[i]) == 0) {
 			set_tracer_flags(1 << i, !neg);
@@ -2686,13 +2688,13 @@ tracing_trace_options_write(struct file
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
 
@@ -4379,7 +4381,10 @@ trace_options_core_write(struct file *fi
 
 	if (val != 0 && val != 1)
 		return -EINVAL;
+
+	mutex_lock(&trace_types_lock);
 	set_tracer_flags(1 << index, val);
+	mutex_unlock(&trace_types_lock);
 
 	*ppos += cnt;
 


