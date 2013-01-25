Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab3AYLDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:03:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41213 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab3AYLDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:03:06 -0500
Date: Fri, 25 Jan 2013 03:02:34 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-f35488f97b4b49cb76d87bb7e8da9e93fc70b4e9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1355749718-4355-3-git-send-email-jolsa@redhat.com>
References: <1355749718-4355-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add support for wildcard in tracepoint system name
Git-Commit-ID: f35488f97b4b49cb76d87bb7e8da9e93fc70b4e9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:02:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f35488f97b4b49cb76d87bb7e8da9e93fc70b4e9
Gitweb:     http://git.kernel.org/tip/f35488f97b4b49cb76d87bb7e8da9e93fc70b4e9
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 17 Dec 2012 14:08:37 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:10 -0300

perf tools: Add support for wildcard in tracepoint system name

Adding support for wildcards '*?" in the tracepoint system part.

It's now possible to open all available tracepoints like:

  # perf stat -e '*:*' ls

You might need to increase limit for open files via ulimit.

If ftrace events tracepoints are configured in, the record command fails
on above event selection because of them.

The stat command disables counters that fails to open, the record
command fails completely. We probably want to be smarter here.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1355749718-4355-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c | 51 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index d64ff29..626c120 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -380,8 +380,8 @@ static int add_tracepoint(struct list_head **listp, int *idx,
 	return 0;
 }
 
-static int add_tracepoint_multi(struct list_head **list, int *idx,
-				char *sys_name, char *evt_name)
+static int add_tracepoint_multi_event(struct list_head **list, int *idx,
+				      char *sys_name, char *evt_name)
 {
 	char evt_path[MAXPATHLEN];
 	struct dirent *evt_ent;
@@ -412,6 +412,46 @@ static int add_tracepoint_multi(struct list_head **list, int *idx,
 	return ret;
 }
 
+static int add_tracepoint_event(struct list_head **list, int *idx,
+				char *sys_name, char *evt_name)
+{
+	return strpbrk(evt_name, "*?") ?
+	       add_tracepoint_multi_event(list, idx, sys_name, evt_name) :
+	       add_tracepoint(list, idx, sys_name, evt_name);
+}
+
+static int add_tracepoint_multi_sys(struct list_head **list, int *idx,
+				    char *sys_name, char *evt_name)
+{
+	struct dirent *events_ent;
+	DIR *events_dir;
+	int ret = 0;
+
+	events_dir = opendir(tracing_events_path);
+	if (!events_dir) {
+		perror("Can't open event dir");
+		return -1;
+	}
+
+	while (!ret && (events_ent = readdir(events_dir))) {
+		if (!strcmp(events_ent->d_name, ".")
+		    || !strcmp(events_ent->d_name, "..")
+		    || !strcmp(events_ent->d_name, "enable")
+		    || !strcmp(events_ent->d_name, "header_event")
+		    || !strcmp(events_ent->d_name, "header_page"))
+			continue;
+
+		if (!strglobmatch(events_ent->d_name, sys_name))
+			continue;
+
+		ret = add_tracepoint_event(list, idx, events_ent->d_name,
+					   evt_name);
+	}
+
+	closedir(events_dir);
+	return ret;
+}
+
 int parse_events_add_tracepoint(struct list_head **list, int *idx,
 				char *sys, char *event)
 {
@@ -421,9 +461,10 @@ int parse_events_add_tracepoint(struct list_head **list, int *idx,
 	if (ret)
 		return ret;
 
-	return strpbrk(event, "*?") ?
-	       add_tracepoint_multi(list, idx, sys, event) :
-	       add_tracepoint(list, idx, sys, event);
+	if (strpbrk(sys, "*?"))
+		return add_tracepoint_multi_sys(list, idx, sys, event);
+	else
+		return add_tracepoint_event(list, idx, sys, event);
 }
 
 static int
