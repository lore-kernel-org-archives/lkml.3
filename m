Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479Ab3LDUOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:14:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59892 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933475Ab3LDUNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:13:52 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 33/38] tools lib traceevent: Remove malloc_or_die from event-plugin.c
Date: Wed,  4 Dec 2013 17:06:57 -0300
Message-Id: <1386187622-2928-34-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386187622-2928-1-git-send-email-acme@infradead.org>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

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
index d272d87aa7d4..125f5676bcb5 100644
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
1.8.1.4

