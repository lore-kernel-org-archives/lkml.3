Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab3JNUdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:33:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38881 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638Ab3JNUDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 099/161] perf tools: Fix srcline sort key behavior
Date: Mon, 14 Oct 2013 17:01:28 -0300
Message-Id: <1381780950-25642-100-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Currently the srcline sort key compares ip rather than srcline info.  I
guess this was due to a performance reason to run external addr2line
utility.  Now we have implemented the functionality inside, use the
srcline info when comparing hist entries.

Also constantly print "??:0" string for unknown srcline rather than
printing ip.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1378876173-13363-10-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index f732120e8bc6..32c56377e008 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -243,33 +243,32 @@ struct sort_entry sort_sym = {
 static int64_t
 sort__srcline_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	return (int64_t)(right->ip - left->ip);
+	if (!left->srcline) {
+		if (!left->ms.map)
+			left->srcline = SRCLINE_UNKNOWN;
+		else {
+			struct map *map = left->ms.map;
+			left->srcline = get_srcline(map->dso,
+					    map__rip_2objdump(map, left->ip));
+		}
+	}
+	if (!right->srcline) {
+		if (!right->ms.map)
+			right->srcline = SRCLINE_UNKNOWN;
+		else {
+			struct map *map = right->ms.map;
+			right->srcline = get_srcline(map->dso,
+					    map__rip_2objdump(map, right->ip));
+		}
+	}
+	return strcmp(left->srcline, right->srcline);
 }
 
 static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 					size_t size,
 					unsigned int width __maybe_unused)
 {
-	FILE *fp = NULL;
-	char *path = self->srcline;
-
-	if (path != NULL)
-		goto out_path;
-
-	if (!self->ms.map)
-		goto out_ip;
-
-	path = get_srcline(self->ms.map->dso, self->ip);
-	self->srcline = path;
-
-out_path:
-	if (fp)
-		pclose(fp);
-	return repsep_snprintf(bf, size, "%s", path);
-out_ip:
-	if (fp)
-		pclose(fp);
-	return repsep_snprintf(bf, size, "%-#*llx", BITS_PER_LONG / 4, self->ip);
+	return repsep_snprintf(bf, size, "%s", self->srcline);
 }
 
 struct sort_entry sort_srcline = {
-- 
1.8.1.4

