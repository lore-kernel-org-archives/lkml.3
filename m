Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab3HAC4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 22:56:50 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43062 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab3HACzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 22:55:49 -0400
X-AuditID: 9c930197-b7bfbae000000e88-cb-51f9ce320297
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 9/9] perf tools: Fix srcline sort key behavior
Date: Thu,  1 Aug 2013 11:55:44 +0900
Message-Id: <1375325744-26613-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375325744-26613-1-git-send-email-namhyung@kernel.org>
References: <1375325744-26613-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Currently the srcline sort key compares ip rather than srcline info.
I guess this was due to a performance reason to run external addr2line
utility.  Now we have implemented the functionality inside, use the
srcline info when comparing hist entries.

Also constantly print "??:0" string for unknown srcline rather than
printing ip.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 58cfe69d3a6c..082480579861 100644
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
1.7.11.7

