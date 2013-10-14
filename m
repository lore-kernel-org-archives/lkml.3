Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075Ab3JNUax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:30:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38893 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757646Ab3JNUDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 095/161] perf tools: Do not try to call addr2line on non-binary files
Date: Mon, 14 Oct 2013 17:01:24 -0300
Message-Id: <1381780950-25642-96-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

No need to call addr2line since they don't have such information.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1378876173-13363-6-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c    |  3 ---
 tools/perf/util/srcline.c | 11 +++++++++--
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index b7e0ef0445de..d4435939c774 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -259,9 +259,6 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 	if (!self->ms.map)
 		goto out_ip;
 
-	if (!strncmp(self->ms.map->dso->long_name, "/tmp/perf-", 10))
-		goto out_ip;
-
 	path = get_srcline(self->ms.map->dso->long_name, self->ip);
 	self->srcline = path;
 
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 7e92cca6f502..777f91880cdb 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -57,11 +57,17 @@ char *get_srcline(const char *dso_name, unsigned long addr)
 {
 	char *file;
 	unsigned line;
-	char *srcline;
+	char *srcline = SRCLINE_UNKNOWN;
 	size_t size;
 
+	if (dso_name[0] == '[')
+		goto out;
+
+	if (!strncmp(dso_name, "/tmp/perf-", 10))
+		goto out;
+
 	if (!addr2line(dso_name, addr, &file, &line))
-		return SRCLINE_UNKNOWN;
+		goto out;
 
 	/* just calculate actual length */
 	size = snprintf(NULL, 0, "%s:%u", file, line) + 1;
@@ -73,6 +79,7 @@ char *get_srcline(const char *dso_name, unsigned long addr)
 		srcline = SRCLINE_UNKNOWN;
 
 	free(file);
+out:
 	return srcline;
 }
 
-- 
1.8.1.4

