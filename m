Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab3LDUHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:07:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59315 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525Ab3LDUHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:07:16 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/38] perf tools: Do not disable source line lookup just because of 1 failure
Date: Wed,  4 Dec 2013 17:06:28 -0300
Message-Id: <1386187622-2928-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386187622-2928-1-git-send-email-acme@infradead.org>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Looking up an ip's source file name and line number does not succeed
always.  Current logic disables the lookup for a dso entirely on any
failure.  Change it so that disabling never happens if there has ever
been a successful lookup for that dso but disable if the first 123
lookups fail.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1386055390-13757-8-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c     |  1 +
 tools/perf/util/dso.h     |  1 +
 tools/perf/util/srcline.c | 20 ++++++++++++++++----
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 49da9684f635..a0c7c591f4b2 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -451,6 +451,7 @@ struct dso *dso__new(const char *name)
 		dso->sorted_by_name = 0;
 		dso->has_build_id = 0;
 		dso->has_srcline = 1;
+		dso->a2l_fails = 1;
 		dso->kernel = DSO_TYPE_USER;
 		dso->needs_swap = DSO_SWAP__UNSET;
 		INIT_LIST_HEAD(&dso->node);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 7142e5261266..384f2d97e38e 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -79,6 +79,7 @@ struct dso {
 	struct rb_root	 cache;
 	void		 *a2l;
 	char		 *symsrc_filename;
+	unsigned int	 a2l_fails;
 	enum dso_kernel_type	kernel;
 	enum dso_swap_type	needs_swap;
 	enum dso_binary_type	symtab_type;
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 93795f9c2480..0c075560ad46 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -244,6 +244,12 @@ void dso__free_a2l(struct dso *dso __maybe_unused)
 
 #endif /* HAVE_LIBBFD_SUPPORT */
 
+/*
+ * Number of addr2line failures (without success) before disabling it for that
+ * dso.
+ */
+#define A2L_FAIL_LIMIT 123
+
 char *get_srcline(struct dso *dso, unsigned long addr)
 {
 	char *file = NULL;
@@ -268,15 +274,21 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 	if (!addr2line(dso_name, addr, &file, &line, dso))
 		goto out;
 
-	if (asprintf(&srcline, "%s:%u", file, line) < 0)
-		srcline = SRCLINE_UNKNOWN;
+	if (asprintf(&srcline, "%s:%u", file, line) < 0) {
+		free(file);
+		goto out;
+	}
+
+	dso->a2l_fails = 0;
 
 	free(file);
 	return srcline;
 
 out:
-	dso->has_srcline = 0;
-	dso__free_a2l(dso);
+	if (dso->a2l_fails && ++dso->a2l_fails > A2L_FAIL_LIMIT) {
+		dso->has_srcline = 0;
+		dso__free_a2l(dso);
+	}
 	return SRCLINE_UNKNOWN;
 }
 
-- 
1.8.1.4

