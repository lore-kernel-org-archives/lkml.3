Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbaEPOFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:05:07 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:28851 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752392AbaEPOFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:05:05 -0400
Message-Id: <20140516140502.195874839@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 16 May 2014 10:02:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/4] tools lib traceevent: Add flag to not load event plugins
References: <20140516140215.149535442@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-tools-lib-traceevent-Add-flag-to-not-load-event-plug.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add a flag to pevent that will let the callers be able to set it and
keep the system, and perhaps even normal plugins from being loaded.

This is useful when plugins might hide certain information and seeing
the raw events shows what may be going on.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.h  | 2 ++
 tools/lib/traceevent/event-plugin.c | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index feab94281634..a68ec3d8289f 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -354,6 +354,8 @@ enum pevent_func_arg_type {
 
 enum pevent_flag {
 	PEVENT_NSEC_OUTPUT		= 1,	/* output in NSECS */
+	PEVENT_DISABLE_SYS_PLUGINS	= 1 << 1,
+	PEVENT_DISABLE_PLUGINS		= 1 << 2,
 };
 
 #define PEVENT_ERRORS 							      \
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index 0c8bf6780e4d..317466bd1a37 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -148,12 +148,17 @@ load_plugins(struct pevent *pevent, const char *suffix,
 	char *path;
 	char *envdir;
 
+	if (pevent->flags & PEVENT_DISABLE_PLUGINS)
+		return;
+
 	/*
 	 * If a system plugin directory was defined,
 	 * check that first.
 	 */
 #ifdef PLUGIN_DIR
-	load_plugins_dir(pevent, suffix, PLUGIN_DIR, load_plugin, data);
+	if (!(pevent->flags & PEVENT_DISABLE_SYS_PLUGINS))
+		load_plugins_dir(pevent, suffix, PLUGIN_DIR,
+				 load_plugin, data);
 #endif
 
 	/*
-- 
1.8.5.3


