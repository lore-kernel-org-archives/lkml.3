Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab3CZXkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:40:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab3CZWoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 40/98] tracing: Protect tracer flags with trace_types_lock
Date: Tue, 26 Mar 2013 15:42:29 -0700
Message-Id: <20130326224246.637101658@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2871,6 +2871,8 @@ static int trace_set_options(char *optio
 		cmp += 2;
 	}
 
+	mutex_lock(&trace_types_lock);
+
 	for (i = 0; trace_options[i]; i++) {
 		if (strcmp(cmp, trace_options[i]) == 0) {
 			set_tracer_flags(1 << i, !neg);
@@ -2879,11 +2881,10 @@ static int trace_set_options(char *optio
 	}
 
 	/* If no option could be set, test the specific tracer options */
-	if (!trace_options[i]) {
-		mutex_lock(&trace_types_lock);
+	if (!trace_options[i])
 		ret = set_tracer_option(current_trace, cmp, neg);
-		mutex_unlock(&trace_types_lock);
-	}
+
+	mutex_unlock(&trace_types_lock);
 
 	return ret;
 }
@@ -4641,7 +4642,10 @@ trace_options_core_write(struct file *fi
 
 	if (val != 0 && val != 1)
 		return -EINVAL;
+
+	mutex_lock(&trace_types_lock);
 	set_tracer_flags(1 << index, val);
+	mutex_unlock(&trace_types_lock);
 
 	*ppos += cnt;
 


