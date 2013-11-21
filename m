Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab3KUIdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 03:33:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:41984 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab3KUIdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 03:33:10 -0500
X-IronPort-AV: E=Sophos;i="4.93,742,1378828800"; 
   d="scan'208";a="9093173"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: mingo@kernel.org, dsahern@gmail.com
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] perf util: optimize util/machine.c:machines__find().
Date: Thu, 21 Nov 2013 16:31:10 -0500
Message-Id: <1385069470-22692-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/21 16:31:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/21 16:31:09,
	Serialize complete at 2013/11/21 16:31:09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove an unnecessary variable default_machine.
* Return earlier to avoid unnecessary searching in children.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/util/machine.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 84cdb07..f0dd5f6 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -175,8 +175,7 @@ struct machine *machines__find(struct machines *machines, pid_t pid)
 {
 	struct rb_node **p = &machines->guests.rb_node;
 	struct rb_node *parent = NULL;
-	struct machine *machine;
-	struct machine *default_machine = NULL;
+	struct machine *machine = NULL;
 
 	if (pid == HOST_KERNEL_ID)
 		return &machines->host;
@@ -184,17 +183,17 @@ struct machine *machines__find(struct machines *machines, pid_t pid)
 	while (*p != NULL) {
 		parent = *p;
 		machine = rb_entry(parent, struct machine, rb_node);
+		if (!machine->pid)
+			break;
 		if (pid < machine->pid)
 			p = &(*p)->rb_left;
 		else if (pid > machine->pid)
 			p = &(*p)->rb_right;
 		else
-			return machine;
-		if (!machine->pid)
-			default_machine = machine;
+			break;
 	}
 
-	return default_machine;
+	return machine;
 }
 
 struct machine *machines__findnew(struct machines *machines, pid_t pid)
-- 
1.8.2.1

