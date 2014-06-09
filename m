Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528AbaFIUHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:07:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327AbaFIUCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:02:47 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 01/15] tools lib traceevent: Add flag to not load event plugins
Date: Mon,  9 Jun 2014 22:02:16 +0200
Message-Id: <1402344150-14860-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
References: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add a flag to pevent that will let the callers be able to set it and
keep the system, and perhaps even normal plugins from being loaded.

This is useful when plugins might hide certain information and seeing
the raw events shows what may be going on.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20140603032223.678098063@goodmis.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/traceevent/event-parse.h  | 2 ++
 tools/lib/traceevent/event-plugin.c | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index feab942..a68ec3d 100644
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
index 0c8bf67..317466b 100644
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
1.8.3.1

