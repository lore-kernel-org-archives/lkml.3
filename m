Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab3LJJVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:21:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44569 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3LJJVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:21:47 -0500
Date: Tue, 10 Dec 2013 01:21:09 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-f9bb36afb25d3bfda1c9276a55985b710c8a91ae@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1386076182-14484-23-git-send-email-jolsa@redhat.com>
References: <1386076182-14484-23-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Remove malloc_or_die from event-plugin.c
Git-Commit-ID: f9bb36afb25d3bfda1c9276a55985b710c8a91ae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:21:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9bb36afb25d3bfda1c9276a55985b710c8a91ae
Gitweb:     http://git.kernel.org/tip/f9bb36afb25d3bfda1c9276a55985b710c8a91ae
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 3 Dec 2013 14:09:36 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Dec 2013 15:35:48 -0300

tools lib traceevent: Remove malloc_or_die from event-plugin.c

Removing malloc_or_die calls from event-plugin.c,
replacing them with standard malloc and error path.

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386076182-14484-23-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-plugin.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index d272d87..125f567 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -47,7 +47,11 @@ load_plugin(struct pevent *pevent, const char *path,
 	char *plugin;
 	void *handle;
 
-	plugin = malloc_or_die(strlen(path) + strlen(file) + 2);
+	plugin = malloc(strlen(path) + strlen(file) + 2);
+	if (!plugin) {
+		warning("could not allocate plugin memory\n");
+		return;
+	}
 
 	strcpy(plugin, path);
 	strcat(plugin, "/");
@@ -71,7 +75,12 @@ load_plugin(struct pevent *pevent, const char *path,
 		goto out_free;
 	}
 
-	list = malloc_or_die(sizeof(*list));
+	list = malloc(sizeof(*list));
+	if (!list) {
+		warning("could not allocate plugin memory\n");
+		goto out_free;
+	}
+
 	list->next = *plugin_list;
 	list->handle = handle;
 	list->name = plugin;
@@ -163,7 +172,11 @@ load_plugins(struct pevent *pevent, const char *suffix,
 	if (!home)
 		return;
 
-	path = malloc_or_die(strlen(home) + strlen(LOCAL_PLUGIN_DIR) + 2);
+	path = malloc(strlen(home) + strlen(LOCAL_PLUGIN_DIR) + 2);
+	if (!path) {
+		warning("could not allocate plugin memory\n");
+		return;
+	}
 
 	strcpy(path, home);
 	strcat(path, "/");
