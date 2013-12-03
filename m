Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab3LCHQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 02:16:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:2119 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214Ab3LCHPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 02:15:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,816,1378882800"; 
   d="scan'208";a="445838797"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 7/7] perf tools: Do not disable source line lookup just because of 1 failure
Date: Tue,  3 Dec 2013 09:23:10 +0200
Message-Id: <1386055390-13757-8-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386055390-13757-1-git-send-email-adrian.hunter@intel.com>
References: <1386055390-13757-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking up an ip's source file name and line
number does not succeed always.  Current logic
disables the lookup for a dso entirely on any
failure.  Change it so that disabling never
happens if there has ever been a successful
lookup for that dso but disable if the first
123 lookups fail.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/dso.c     |  1 +
 tools/perf/util/dso.h     |  1 +
 tools/perf/util/srcline.c | 20 ++++++++++++++++----
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 49da968..a0c7c59 100644
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
index 7142e52..384f2d9 100644
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
index e09c9e0..d351d62 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -193,6 +193,12 @@ void dso__free_a2l(struct dso *dso __maybe_unused)
 
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
@@ -217,15 +223,21 @@ char *get_srcline(struct dso *dso, unsigned long addr)
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
1.7.11.7

