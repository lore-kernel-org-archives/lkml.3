Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab3HAC5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 22:57:31 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59615 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab3HACzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 22:55:49 -0400
X-AuditID: 9c930197-b7bfbae000000e88-c9-51f9ce312e0d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 7/9] perf tools: Save failed result of get_srcline()
Date: Thu,  1 Aug 2013 11:55:42 +0900
Message-Id: <1375325744-26613-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375325744-26613-1-git-send-email-namhyung@kernel.org>
References: <1375325744-26613-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Some dso's lack srcline info, so there's no point to keep trying on
them.  Just save failture status and skip them.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/dso.c     |  1 +
 tools/perf/util/dso.h     |  1 +
 tools/perf/util/srcline.c | 10 ++++++++--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index c4374f07603c..cc959d2fa5da 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -421,6 +421,7 @@ struct dso *dso__new(const char *name)
 		dso->loaded = 0;
 		dso->sorted_by_name = 0;
 		dso->has_build_id = 0;
+		dso->has_srcline = 1;
 		dso->kernel = DSO_TYPE_USER;
 		dso->needs_swap = DSO_SWAP__UNSET;
 		INIT_LIST_HEAD(&dso->node);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 94c2f1a8b116..2a1ae2a8d39c 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -79,6 +79,7 @@ struct dso {
 	enum dso_binary_type	data_type;
 	u8		 adjust_symbols:1;
 	u8		 has_build_id:1;
+	u8		 has_srcline:1;
 	u8		 hit:1;
 	u8		 annotate_warned:1;
 	u8		 sname_alloc:1;
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index c736d9428cf2..dcff10bed7da 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -58,10 +58,13 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 {
 	char *file;
 	unsigned line;
-	char *srcline = SRCLINE_UNKNOWN;
+	char *srcline;
 	char *dso_name = dso->long_name;
 	size_t size;
 
+	if (!dso->has_srcline)
+		return SRCLINE_UNKNOWN;
+
 	if (dso_name[0] == '[')
 		goto out;
 
@@ -81,8 +84,11 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 		srcline = SRCLINE_UNKNOWN;
 
 	free(file);
-out:
 	return srcline;
+
+out:
+	dso->has_srcline = 0;
+	return SRCLINE_UNKNOWN;
 }
 
 void free_srcline(char *srcline)
-- 
1.7.11.7

