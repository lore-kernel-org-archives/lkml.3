Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241Ab3JNUez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:34:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38856 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631Ab3JNUDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:02 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 097/161] perf tools: Save failed result of get_srcline()
Date: Mon, 14 Oct 2013 17:01:26 -0300
Message-Id: <1381780950-25642-98-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Some dso's lack srcline info, so there's no point to keep trying on
them.  Just save failture status and skip them.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1378876173-13363-8-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c     |  1 +
 tools/perf/util/dso.h     |  1 +
 tools/perf/util/srcline.c | 10 ++++++++--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 6bfc8aacaf7c..af4c687cc49b 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -450,6 +450,7 @@ struct dso *dso__new(const char *name)
 		dso->rel = 0;
 		dso->sorted_by_name = 0;
 		dso->has_build_id = 0;
+		dso->has_srcline = 1;
 		dso->kernel = DSO_TYPE_USER;
 		dso->needs_swap = DSO_SWAP__UNSET;
 		INIT_LIST_HEAD(&dso->node);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 72eedd65fc2d..9ac666abbe7e 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -83,6 +83,7 @@ struct dso {
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
1.8.1.4

