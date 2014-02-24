Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaBXTAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:00:49 -0500
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59746 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643AbaBXTAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:00:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: rostedt@goodmis.org
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v2 2/6] ftrace: Inline the code from ftrace_dyn_table_alloc
Date: Mon, 24 Feb 2014 19:59:57 +0100
Message-Id: <1393268401-24379-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1393268401-24379-1-git-send-email-jslaby@suse.cz>
References: <1393268401-24379-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function used to do allocations some time ago. This no longer
happens and it only checks the count and prints some info. This patch
inlines the body to the only caller. There are two reasons:
* the name of the function was misleading
* it's clear what is going on in ftrace_init now

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/ftrace.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 3f95bbeb8e8d..76b6ed29d856 100644
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
1.8.5.2

