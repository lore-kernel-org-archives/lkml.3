Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762442Ab3DBWZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:25:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33528 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933735Ab3DBWO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:14:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Lingzhu Xiang <lxiang@redhat.com>, CAI Qian <caiqian@redhat.com>
Subject: [ 42/68] tracing: Protect tracer flags with trace_types_lock
Date: Tue,  2 Apr 2013 15:13:31 -0700
Message-Id: <20130402221334.808009081@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221329.915209206@linuxfoundation.org>
References: <20130402221329.915209206@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 69d34da2984c95b33ea21518227e1f9470f11d95 upstream.

Seems that the tracer flags have never been protected from
synchronous writes. Luckily, admins don't usually modify the
tracing flags via two different tasks. But if scripts were to
be used to modify them, then they could get corrupted.

Move the trace_types_lock that protects against tracers changing
to also protect the flags being set.

[Backported for 3.4, 3.0-stable. Moved return to after unlock.]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
Reviewed-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2768,7 +2768,7 @@ tracing_trace_options_write(struct file
 	char buf[64];
 	char *cmp;
 	int neg = 0;
-	int ret;
+	int ret = 0;
 	int i;
 
 	if (cnt >= sizeof(buf))
@@ -2785,6 +2785,8 @@ tracing_trace_options_write(struct file
 		cmp += 2;
 	}
 
+	mutex_lock(&trace_types_lock);
+
 	for (i = 0; trace_options[i]; i++) {
 		if (strcmp(cmp, trace_options[i]) == 0) {
 			set_tracer_flags(1 << i, !neg);
@@ -2793,13 +2795,13 @@ tracing_trace_options_write(struct file
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
 
@@ -4486,7 +4488,10 @@ trace_options_core_write(struct file *fi
 
 	if (val != 0 && val != 1)
 		return -EINVAL;
+
+	mutex_lock(&trace_types_lock);
 	set_tracer_flags(1 << index, val);
+	mutex_unlock(&trace_types_lock);
 
 	*ppos += cnt;
 


