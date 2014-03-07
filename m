Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbaCGPPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:15:04 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:49575 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753045AbaCGPMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:12:06 -0500
Message-Id: <20140307151203.345107630@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 07 Mar 2014 10:09:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Ingo Molnar <mingo@redhat.com>
Subject: [for-next][PATCH 15/20] ftrace: Inline the code from ftrace_dyn_table_alloc()
References: <20140307150920.881849073@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0015-ftrace-Inline-the-code-from-ftrace_dyn_table_alloc.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

The function used to do allocations some time ago. This no longer
happens and it only checks the count and prints some info. This patch
inlines the body to the only caller. There are two reasons:
* the name of the function was misleading
* it's clear what is going on in ftrace_init now

Link: http://lkml.kernel.org/r/1393268401-24379-2-git-send-email-jslaby@suse.cz

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 3f95bbe..76b6ed2 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2465,22 +2465,6 @@ ftrace_allocate_pages(unsigned long num_to_init)
 	return NULL;
 }
 
-static int __init ftrace_dyn_table_alloc(unsigned long num_to_init)
-{
-	int cnt;
-
-	if (!num_to_init) {
-		pr_info("ftrace: No functions to be traced?\n");
-		return -1;
-	}
-
-	cnt = num_to_init / ENTRIES_PER_PAGE;
-	pr_info("ftrace: allocating %ld entries in %d pages\n",
-		num_to_init, cnt + 1);
-
-	return 0;
-}
-
 #define FTRACE_BUFF_MAX (KSYM_SYMBOL_LEN+4) /* room for wildcards */
 
 struct ftrace_iterator {
@@ -4403,10 +4387,13 @@ void __init ftrace_init(void)
 		goto failed;
 
 	count = __stop_mcount_loc - __start_mcount_loc;
-
-	ret = ftrace_dyn_table_alloc(count);
-	if (ret)
+	if (!count) {
+		pr_info("ftrace: No functions to be traced?\n");
 		goto failed;
+	}
+
+	pr_info("ftrace: allocating %ld entries in %ld pages\n",
+		count, count / ENTRIES_PER_PAGE + 1);
 
 	last_ftrace_enabled = ftrace_enabled = 1;
 
-- 
1.8.5.3


