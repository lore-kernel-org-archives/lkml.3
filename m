Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab3LCNLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:11:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068Ab3LCNLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:11:12 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 22/28] tools lib traceevent: Remove malloc_or_die from event-plugin.c
Date: Tue,  3 Dec 2013 14:09:36 +0100
Message-Id: <1386076182-14484-23-git-send-email-jolsa@redhat.com>
In-Reply-To: <1386076182-14484-1-git-send-email-jolsa@redhat.com>
References: <1386076182-14484-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing malloc_or_die calls from event-plugin.c,
replacing them with standard malloc and error path.

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
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
-- 
1.8.3.1

