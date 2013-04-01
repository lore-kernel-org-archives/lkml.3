Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239Ab3DAQNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 12:13:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759060Ab3DAQNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 12:13:06 -0400
Date: Mon, 1 Apr 2013 18:09:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] uprobes/tracing: Change create_trace_uprobe() to
	support uretprobes
Message-ID: <20130401160900.GA19590@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130401160827.GA19206@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally change create_trace_uprobe() to check if argv[0][0] == 'r'
and pass the correct "is_ret" to alloc_trace_uprobe().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_uprobe.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 1b3622a..2773d2a 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -200,7 +200,7 @@ end:
 
 /*
  * Argument syntax:
- *  - Add uprobe: p[:[GRP/]EVENT] PATH:SYMBOL[+offs] [FETCHARGS]
+ *  - Add uprobe: p|r[:[GRP/]EVENT] PATH:SYMBOL [FETCHARGS]
  *
  *  - Remove uprobe: -:[GRP/]EVENT
  */
@@ -212,20 +212,23 @@ static int create_trace_uprobe(int argc, char **argv)
 	char buf[MAX_EVENT_NAME_LEN];
 	struct path path;
 	unsigned long offset;
-	bool is_delete;
+	bool is_delete, is_return;
 	int i, ret;
 
 	inode = NULL;
 	ret = 0;
 	is_delete = false;
+	is_return = false;
 	event = NULL;
 	group = NULL;
 
 	/* argc must be >= 1 */
 	if (argv[0][0] == '-')
 		is_delete = true;
+	else if (argv[0][0] == 'r')
+		is_return = true;
 	else if (argv[0][0] != 'p') {
-		pr_info("Probe definition must be started with 'p' or '-'.\n");
+		pr_info("Probe definition must be started with 'p', 'r' or '-'.\n");
 		return -EINVAL;
 	}
 
@@ -323,7 +326,7 @@ static int create_trace_uprobe(int argc, char **argv)
 		kfree(tail);
 	}
 
-	tu = alloc_trace_uprobe(group, event, argc, false);
+	tu = alloc_trace_uprobe(group, event, argc, is_return);
 	if (IS_ERR(tu)) {
 		pr_info("Failed to allocate trace_uprobe.(%d)\n", (int)PTR_ERR(tu));
 		ret = PTR_ERR(tu);
-- 
1.5.5.1

