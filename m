Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab3IKFK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:10:59 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:55636 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab3IKFJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 01:09:38 -0400
X-AuditID: 9c93017e-b7c00ae000002eb6-6f-522ffb0e92e0
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 7/9] perf tools: Save failed result of get_srcline()
Date: Wed, 11 Sep 2013 14:09:31 +0900
Message-Id: <1378876173-13363-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378876173-13363-1-git-send-email-namhyung@kernel.org>
References: <1378876173-13363-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Some dso's lack srcline info, so there's no point to keep trying on
them.  Just save failture status and skip them.

Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/dso.c     |  1 +
 tools/perf/util/dso.h     |  1 +
 tools/perf/util/srcline.c | 10 ++++++++--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index e3c1ff8512c8..1f81dd88afc4 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -427,6 +427,7 @@ struct dso *dso__new(const char *name)
 		dso->rel = 0;
 		dso->sorted_by_name = 0;
 		dso->has_build_id = 0;
+		dso->has_srcline = 1;
 		dso->kernel = DSO_TYPE_USER;
 		dso->needs_swap = DSO_SWAP__UNSET;
 		INIT_LIST_HEAD(&dso->node);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 477b3b68daf4..fa36677c6fd6 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -82,6 +82,7 @@ struct dso {
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

