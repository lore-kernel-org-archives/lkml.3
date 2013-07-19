Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659Ab3GSOPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:15:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17011 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760470Ab3GSOOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:14:50 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=18VaydosxjgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=-fX1h3xuSNMA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=6PPhqtZAo-UIe905SewA:9 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130719141449.578381670@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 19 Jul 2013 10:12:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, <stable@vger.kernel.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>,
        Alexander Z Lam <azl@google.com>
Subject: [for-next-3.11][PATCH 08/12] tracing: Fix error handling to ensure instances can always be
 removed
References: <20130719141224.703522101@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-Fix-error-handling-to-ensure-instances-can-a.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Z Lam <azl@google.com>

Remove debugfs directories for tracing instances during creation if an error
occurs causing the trace_array for that instance to not be added to
ftrace_trace_arrays. If the directory continues to exist after the error, it
cannot be removed because the respective trace_array is not in
ftrace_trace_arrays.

Link: http://lkml.kernel.org/r/1373502874-1706-2-git-send-email-azl@google.com

Cc: stable@vger.kernel.org # 3.10
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: David Sharp <dhsharp@google.com>
Cc: Alexander Z Lam <lambchop468@gmail.com>
Signed-off-by: Alexander Z Lam <azl@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 25b91af..7c3da7b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5973,8 +5973,10 @@ static int new_instance_create(const char *name)
 		goto out_free_tr;
 
 	ret = event_trace_add_tracer(tr->dir, tr);
-	if (ret)
+	if (ret) {
+		debugfs_remove_recursive(tr->dir);
 		goto out_free_tr;
+	}
 
 	init_tracer_debugfs(tr, tr->dir);
 
-- 
1.7.10.4


