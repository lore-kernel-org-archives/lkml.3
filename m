Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab3EPLve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:51:34 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50683 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab3EPLv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:51:28 -0400
X-AuditID: 85900ec0-d60ccb900000151e-03-5194c83eed8c
Subject: [PATCH 1/5] [BUGFIX] tracing: Returns -EBUSY when event_enable_func
 fails to get module
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Thu, 16 May 2013 20:48:49 +0900
Message-ID: <20130516114848.13508.97899.stgit@mhiramat-M0-7522>
In-Reply-To: <20130516114839.13508.92844.stgit@mhiramat-M0-7522>
References: <20130516114839.13508.92844.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since try_module_get returns false( = 0) when it fails to
pindown a module, event_enable_func() returns 0 which means
"succeed". This can cause a kernel panic when the entry
is removed, because the event is already released.

This fixes the bug by returning -EBUSY, because the reason
why it fails is under removing module at that time.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/trace_events.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 7a0cf68..27963e2 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2072,8 +2072,10 @@ event_enable_func(struct ftrace_hash *hash,
  out_reg:
 	/* Don't let event modules unload while probe registered */
 	ret = try_module_get(file->event_call->mod);
-	if (!ret)
+	if (!ret) {
+		ret = -EBUSY;
 		goto out_free;
+	}
 
 	ret = __ftrace_event_enable_disable(file, 1, 1);
 	if (ret < 0)

