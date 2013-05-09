Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab3EIFq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 01:46:59 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:57965 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab3EIFqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 01:46:55 -0400
X-AuditID: 85900ec0-d24c6b900000151e-8a-518b384bab99
Subject: [PATCH 01/11] [BUGFIX] tracing: Return 0 if event_enable_func
 succeeded
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Thu, 09 May 2013 14:44:14 +0900
Message-ID: <20130509054413.30398.55650.stgit@mhiramat-M0-7522>
In-Reply-To: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
References: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return 0 instead of the number of activated ftrace if
event_enable_func succeeded and return an error code if failed,
beacuse 0 is success code at caller (ftrace_regex_write).

Without this fix, writing enable_event trigger on set_ftrace_filter
always doesn't work, since event_enable_func returns 1 to
ftrace_regex_write, it consumes 1 byte and pass input string
without the first character again. This makes event_enable_func
fail and disables event entry.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
---
 kernel/trace/trace_events.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 53582e9..44ac836 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2061,8 +2061,11 @@ event_enable_func(struct ftrace_hash *hash,
 	if (ret < 0)
 		goto out_put;
 	ret = register_ftrace_function_probe(glob, ops, data);
-	if (!ret)
+	if (!ret) {
+		ret = -ENOENT;
 		goto out_disable;
+	} else
+		ret = 0;
  out:
 	mutex_unlock(&event_mutex);
 	return ret;

