Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab3EVCWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 22:22:05 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:45474 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab3EVCWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 22:22:00 -0400
X-AuditID: 85900ec0-d1ac5b900000151e-7d-519c2bc51744
Subject: [PATCH v2 1/5] [BUGFIX] tracing: Returns -EBUSY when
 event_enable_func fails to get module
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Wed, 22 May 2013 11:19:09 +0900
Message-ID: <20130522021909.4299.64015.stgit@mhiramat-M0-7522>
In-Reply-To: <20130522021903.4299.85911.stgit@mhiramat-M0-7522>
References: <20130522021903.4299.85911.stgit@mhiramat-M0-7522>
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

