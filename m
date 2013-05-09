Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab3EIFrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 01:47:11 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58003 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab3EIFrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 01:47:08 -0400
X-AuditID: 85900ec0-d4ccab900000151e-90-518b385a2c62
Subject: [PATCH 06/11] [BUGFIX] tracing: Modify soft-mode only if no other
 referrer
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dhsharp@google.com>, yrl.pp-manager.tt@hitachi.com,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <tom.zanussi@intel.com>,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Date: Thu, 09 May 2013 14:44:29 +0900
Message-ID: <20130509054429.30398.7464.stgit@mhiramat-M0-7522>
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

Modify soft-mode flag only if no other soft-mode referrer
(currently only the ftrace triggers) by using a reference
counter in each ftrace_event_file.

Without this fix, adding and removing several different
enable/disable_event triggers on the same event clear
soft-mode bit from the ftrace_event_file. This also
happens with a typo of glob on setting triggers.

e.g.

# echo vfs_symlink:enable_event:net:netif_rx > set_ftrace_filter
# cat events/net/netif_rx/enable
0*
# echo typo_func:enable_event:net:netif_rx > set_ftrace_filter
# cat events/net/netif_rx/enable
0
# cat set_ftrace_filter
#### all functions enabled ####
vfs_symlink:enable_event:net:netif_rx:unlimited

As above, we still have a trigger, but soft-mode is gone.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: David Sharp <dhsharp@google.com>
Cc: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
---
 include/linux/ftrace_event.h |    1 +
 kernel/trace/trace_events.c  |   12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 34e00fb..4372658 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -293,6 +293,7 @@ struct ftrace_event_file {
 	 * caching and such. Which is mostly OK ;-)
 	 */
 	unsigned long		flags;
+	atomic_t		sm_ref;	/* soft-mode reference counter */
 };
 
 #define __TRACE_EVENT_FLAGS(name, value)				\
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index cc3c130..deda9ae 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -251,7 +251,8 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
 	switch (enable) {
 	case 0:
 		/*
-		 * When soft_disable is set and enable is cleared, we want
+		 * When soft_disable is set and enable is cleared, the sm_ref
+		 * reference counter is decremented. If it reaches 0, we want
 		 * to clear the SOFT_DISABLED flag but leave the event in the
 		 * state that it was. That is, if the event was enabled and
 		 * SOFT_DISABLED isn't set, then do nothing. But if SOFT_DISABLED
@@ -263,6 +264,8 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
 		 * "soft enable"s (clearing the SOFT_DISABLED bit) wont work.
 		 */
 		if (soft_disable) {
+			if (atomic_dec_return(&file->sm_ref) > 0)
+				break;
 			disable = file->flags & FTRACE_EVENT_FL_SOFT_DISABLED;
 			clear_bit(FTRACE_EVENT_FL_SOFT_MODE_BIT, &file->flags);
 		} else
@@ -291,8 +294,11 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
 		 */
 		if (!soft_disable)
 			clear_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags);
-		else
+		else {
+			if (atomic_inc_return(&file->sm_ref) > 1)
+				break;
 			set_bit(FTRACE_EVENT_FL_SOFT_MODE_BIT, &file->flags);
+		}
 
 		if (!(file->flags & FTRACE_EVENT_FL_ENABLED)) {
 
@@ -1540,6 +1546,7 @@ __trace_add_new_event(struct ftrace_event_call *call,
 
 	file->event_call = call;
 	file->tr = tr;
+	atomic_set(&file->sm_ref, 0);
 	list_add(&file->list, &tr->events);
 
 	return event_create_dir(tr->event_dir, file, id, enable, filter, format);
@@ -1562,6 +1569,7 @@ __trace_early_add_new_event(struct ftrace_event_call *call,
 
 	file->event_call = call;
 	file->tr = tr;
+	atomic_set(&file->sm_ref, 0);
 	list_add(&file->list, &tr->events);
 
 	return 0;

