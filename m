Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab3AYMOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:14:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42423 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab3AYMOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:14:31 -0500
Date: Fri, 25 Jan 2013 04:14:08 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-em50vqvvmlnc6k9tw4xtixus@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Allow passing a list to intlist__new
Git-Commit-ID: ffe0fb769a6db3b6027d9228b6fecb6b352e4834
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 04:14:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ffe0fb769a6db3b6027d9228b6fecb6b352e4834
Gitweb:     http://git.kernel.org/tip/ffe0fb769a6db3b6027d9228b6fecb6b352e4834
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 24 Jan 2013 16:17:27 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:53 -0300

perf tools: Allow passing a list to intlist__new

Just like strlist allows passing a list of entries to parse.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-em50vqvvmlnc6k9tw4xtixus@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c  |  2 +-
 tools/perf/util/intlist.c | 27 ++++++++++++++++++++++++++-
 tools/perf/util/intlist.h |  2 +-
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e05ba81..7978c81 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -694,7 +694,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 		static struct intlist *seen;
 
 		if (!seen)
-			seen = intlist__new();
+			seen = intlist__new(NULL);
 
 		if (!intlist__has_entry(seen, event->ip.pid)) {
 			pr_err("Can't find guest [%d]'s kernel information\n",
diff --git a/tools/perf/util/intlist.c b/tools/perf/util/intlist.c
index cbf0c32..11a8d86 100644
--- a/tools/perf/util/intlist.c
+++ b/tools/perf/util/intlist.c
@@ -73,7 +73,26 @@ struct int_node *intlist__find(struct intlist *ilist, int i)
 	return node;
 }
 
-struct intlist *intlist__new(void)
+static int intlist__parse_list(struct intlist *ilist, const char *s)
+{
+	char *sep;
+	int err;
+
+	do {
+		long value = strtol(s, &sep, 10);
+		err = -EINVAL;
+		if (*sep != ',' && *sep != '\0')
+			break;
+		err = intlist__add(ilist, value);
+		if (err)
+			break;
+		s = sep + 1;
+	} while (*sep != '\0');
+
+	return err;
+}
+
+struct intlist *intlist__new(const char *slist)
 {
 	struct intlist *ilist = malloc(sizeof(*ilist));
 
@@ -82,9 +101,15 @@ struct intlist *intlist__new(void)
 		ilist->rblist.node_cmp    = intlist__node_cmp;
 		ilist->rblist.node_new    = intlist__node_new;
 		ilist->rblist.node_delete = intlist__node_delete;
+
+		if (slist && intlist__parse_list(ilist, slist))
+			goto out_delete;
 	}
 
 	return ilist;
+out_delete:
+	intlist__delete(ilist);
+	return NULL;
 }
 
 void intlist__delete(struct intlist *ilist)
diff --git a/tools/perf/util/intlist.h b/tools/perf/util/intlist.h
index 6d63ab9..62351da 100644
--- a/tools/perf/util/intlist.h
+++ b/tools/perf/util/intlist.h
@@ -15,7 +15,7 @@ struct intlist {
 	struct rblist rblist;
 };
 
-struct intlist *intlist__new(void);
+struct intlist *intlist__new(const char *slist);
 void intlist__delete(struct intlist *ilist);
 
 void intlist__remove(struct intlist *ilist, struct int_node *in);
