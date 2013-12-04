Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722Ab3LDUQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:16:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59328 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933228Ab3LDUHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:07:17 -0500
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
Subject: [PATCH 02/38] perf symbols: Retain bfd reference to lookup source line numbers
Date: Wed,  4 Dec 2013 17:06:26 -0300
Message-Id: <1386187622-2928-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386187622-2928-1-git-send-email-acme@infradead.org>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Closng and re-opening for every lookup when using libbfd to lookup
source file name and line number is very very slow.  Instead keep the
reference on struct dso.

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
Link: http://lkml.kernel.org/r/1386055390-13757-5-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c     |  1 +
 tools/perf/util/dso.h     |  3 +++
 tools/perf/util/srcline.c | 36 ++++++++++++++++++++++++++++++------
 3 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index af4c687cc49b..68aa55aa5c17 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -469,6 +469,7 @@ void dso__delete(struct dso *dso)
 	if (dso->lname_alloc)
 		free(dso->long_name);
 	dso_cache__free(&dso->cache);
+	dso__free_a2l(dso);
 	free(dso);
 }
 
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 9ac666abbe7e..d8613dc3ca8f 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -77,6 +77,7 @@ struct dso {
 	struct rb_root	 symbols[MAP__NR_TYPES];
 	struct rb_root	 symbol_names[MAP__NR_TYPES];
 	struct rb_root	 cache;
+	void		 *a2l;
 	enum dso_kernel_type	kernel;
 	enum dso_swap_type	needs_swap;
 	enum dso_binary_type	symtab_type;
@@ -166,4 +167,6 @@ static inline bool dso__is_kcore(struct dso *dso)
 	       dso->data_type == DSO_BINARY_TYPE__GUEST_KCORE;
 }
 
+void dso__free_a2l(struct dso *dso);
+
 #endif /* __PERF_DSO */
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 4c8e816a2191..25b85b28301b 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -146,18 +146,24 @@ static void addr2line_cleanup(struct a2l_data *a2l)
 }
 
 static int addr2line(const char *dso_name, unsigned long addr,
-		     char **file, unsigned int *line)
+		     char **file, unsigned int *line, struct dso *dso)
 {
 	int ret = 0;
-	struct a2l_data *a2l;
+	struct a2l_data *a2l = dso->a2l;
+
+	if (!a2l) {
+		dso->a2l = addr2line_init(dso_name);
+		a2l = dso->a2l;
+	}
 
-	a2l = addr2line_init(dso_name);
 	if (a2l == NULL) {
 		pr_warning("addr2line_init failed for %s\n", dso_name);
 		return 0;
 	}
 
 	a2l->addr = addr;
+	a2l->found = false;
+
 	bfd_map_over_sections(a2l->abfd, find_address_in_section, a2l);
 
 	if (a2l->found && a2l->filename) {
@@ -168,14 +174,26 @@ static int addr2line(const char *dso_name, unsigned long addr,
 			ret = 1;
 	}
 
-	addr2line_cleanup(a2l);
 	return ret;
 }
 
+void dso__free_a2l(struct dso *dso)
+{
+	struct a2l_data *a2l = dso->a2l;
+
+	if (!a2l)
+		return;
+
+	addr2line_cleanup(a2l);
+
+	dso->a2l = NULL;
+}
+
 #else /* HAVE_LIBBFD_SUPPORT */
 
 static int addr2line(const char *dso_name, unsigned long addr,
-		     char **file, unsigned int *line_nr)
+		     char **file, unsigned int *line_nr,
+		     struct dso *dso __maybe_unused)
 {
 	FILE *fp;
 	char cmd[PATH_MAX];
@@ -219,6 +237,11 @@ out:
 	pclose(fp);
 	return ret;
 }
+
+void dso__free_a2l(struct dso *dso __maybe_unused)
+{
+}
+
 #endif /* HAVE_LIBBFD_SUPPORT */
 
 char *get_srcline(struct dso *dso, unsigned long addr)
@@ -237,7 +260,7 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 	if (!strncmp(dso_name, "/tmp/perf-", 10))
 		goto out;
 
-	if (!addr2line(dso_name, addr, &file, &line))
+	if (!addr2line(dso_name, addr, &file, &line, dso))
 		goto out;
 
 	if (asprintf(&srcline, "%s:%u", file, line) < 0)
@@ -248,6 +271,7 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 
 out:
 	dso->has_srcline = 0;
+	dso__free_a2l(dso);
 	return SRCLINE_UNKNOWN;
 }
 
-- 
1.8.1.4

