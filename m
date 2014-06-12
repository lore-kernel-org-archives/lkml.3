Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934045AbaFLMBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:01:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60485 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933731AbaFLMBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:01:07 -0400
Date: Thu, 12 Jun 2014 05:00:31 -0700
From: "tip-bot for Steven Rostedt (Red Hat)" <tipbot@zytor.com>
Message-ID: <tip-a7c3196c79051f9e1a498f5be8fe6870bde5e55d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <20140603032223.678098063@goodmis.org>
References: <20140603032223.678098063@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Add flag to not load event plugins
Git-Commit-ID: a7c3196c79051f9e1a498f5be8fe6870bde5e55d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7c3196c79051f9e1a498f5be8fe6870bde5e55d
Gitweb:     http://git.kernel.org/tip/a7c3196c79051f9e1a498f5be8fe6870bde5e55d
Author:     Steven Rostedt (Red Hat) <rostedt@goodmis.org>
AuthorDate: Mon, 2 Jun 2014 23:20:13 -0400
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Sat, 7 Jun 2014 23:33:36 +0200

tools lib traceevent: Add flag to not load event plugins

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
