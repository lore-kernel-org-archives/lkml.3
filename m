Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab3IKFJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:09:41 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:55155 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab3IKFJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 01:09:38 -0400
X-AuditID: 9c93017e-b7c00ae000002eb6-70-522ffb0ea6d4
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Roberto Vitillo <ravitillo@lbl.gov>
Subject: [PATCH 8/9] perf tools: Implement addr2line directly using libbfd
Date: Wed, 11 Sep 2013 14:09:32 +0900
Message-Id: <1378876173-13363-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378876173-13363-1-git-send-email-namhyung@kernel.org>
References: <1378876173-13363-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roberto Vitillo <ravitillo@lbl.gov>

When the srcline sort key is used , the external addr2line utility
needs to be run for each hist entry to get the srcline info.  This can
consume quite a time if one has a huge perf.data file.

So rather than executing the external utility, implement it internally
and just call it.  We can do it since we've linked with libbfd
already.

Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Roberto Agostino Vitillo <ravitillo@lbl.gov>
[namhyung@kernel.org: Use a2l_data struct instead of static globals]
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/config/Makefile |   4 ++
 tools/perf/util/srcline.c  | 167 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 171 insertions(+)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 214e17e97e5c..128d580ca397 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -396,6 +396,10 @@ else
   endif
 endif
 
+ifndef ($(filter -lbfd,$(EXTLIBS)),)
+  CFLAGS += -DLIBBFD_SUPPORT
+endif
+
 ifndef NO_STRLCPY
   ifeq ($(call try-cc,$(SOURCE_STRLCPY),,-DHAVE_STRLCPY),y)
     CFLAGS += -DHAVE_STRLCPY
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index dcff10bed7da..10983a92bb5e 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -8,6 +8,172 @@
 #include "util/util.h"
 #include "util/debug.h"
 
+#ifdef LIBBFD_SUPPORT
+
+/*
+ * Implement addr2line using libbfd.
+ */
+#define PACKAGE "perf"
+#include <bfd.h>
+
+struct a2l_data {
+	const char 	*input;
+	unsigned long 	addr;
+
+	bool 		found;
+	const char 	*filename;
+	const char 	*funcname;
+	unsigned 	line;
+
+	bfd 		*abfd;
+	asymbol 	**syms;
+};
+
+static int bfd_error(const char *string)
+{
+	const char *errmsg;
+
+	errmsg = bfd_errmsg(bfd_get_error());
+	fflush(stdout);
+
+	if (string)
+		pr_debug("%s: %s\n", string, errmsg);
+	else
+		pr_debug("%s\n", errmsg);
+
+	return -1;
+}
+
+static int slurp_symtab(bfd *abfd, struct a2l_data *a2l)
+{
+	long storage;
+	long symcount;
+	asymbol **syms;
+	bfd_boolean dynamic = FALSE;
+
+	if ((bfd_get_file_flags(abfd) & HAS_SYMS) == 0)
+		return bfd_error(bfd_get_filename(abfd));
+
+	storage = bfd_get_symtab_upper_bound(abfd);
+	if (storage == 0L) {
+		storage = bfd_get_dynamic_symtab_upper_bound(abfd);
+		dynamic = TRUE;
+	}
+	if (storage < 0L)
+		return bfd_error(bfd_get_filename(abfd));
+
+	syms = malloc(storage);
+	if (dynamic)
+		symcount = bfd_canonicalize_dynamic_symtab(abfd, syms);
+	else
+		symcount = bfd_canonicalize_symtab(abfd, syms);
+
+	if (symcount < 0) {
+		free(syms);
+		return bfd_error(bfd_get_filename(abfd));
+	}
+
+	a2l->syms = syms;
+	return 0;
+}
+
+static void find_address_in_section(bfd *abfd, asection *section, void *data)
+{
+	bfd_vma pc, vma;
+	bfd_size_type size;
+	struct a2l_data *a2l = data;
+
+	if (a2l->found)
+		return;
+
+	if ((bfd_get_section_flags(abfd, section) & SEC_ALLOC) == 0)
+		return;
+
+	pc = a2l->addr;
+	vma = bfd_get_section_vma(abfd, section);
+	size = bfd_get_section_size(section);
+
+	if (pc < vma || pc >= vma + size)
+		return;
+
+	a2l->found = bfd_find_nearest_line(abfd, section, a2l->syms, pc - vma,
+					   &a2l->filename, &a2l->funcname,
+					   &a2l->line);
+}
+
+static struct a2l_data *addr2line_init(const char *path)
+{
+	bfd *abfd;
+	struct a2l_data *a2l = NULL;
+
+	abfd = bfd_openr(path, NULL);
+	if (abfd == NULL)
+		return NULL;
+
+	if (!bfd_check_format(abfd, bfd_object))
+		goto out;
+
+	a2l = zalloc(sizeof(*a2l));
+	if (a2l == NULL)
+		goto out;
+
+	a2l->abfd = abfd;
+	a2l->input = strdup(path);
+	if (a2l->input == NULL)
+		goto out;
+
+	if (slurp_symtab(abfd, a2l))
+		goto out;
+
+	return a2l;
+
+out:
+	if (a2l) {
+		free((void *)a2l->input);
+		free(a2l);
+	}
+	bfd_close(abfd);
+	return NULL;
+}
+
+static void addr2line_cleanup(struct a2l_data *a2l)
+{
+	if (a2l->abfd)
+		bfd_close(a2l->abfd);
+	free((void *)a2l->input);
+	free(a2l->syms);
+	free(a2l);
+}
+
+static int addr2line(const char *dso_name, unsigned long addr,
+		     char **file, unsigned int *line)
+{
+	int ret = 0;
+	struct a2l_data *a2l;
+
+	a2l = addr2line_init(dso_name);
+	if (a2l == NULL) {
+		pr_warning("addr2line_init failed for %s\n", dso_name);
+		return 0;
+	}
+
+	a2l->addr = addr;
+	bfd_map_over_sections(a2l->abfd, find_address_in_section, a2l);
+
+	if (a2l->found && a2l->filename) {
+		*file = strdup(a2l->filename);
+		*line = a2l->line;
+
+		if (*file)
+			ret = 1;
+	}
+
+	addr2line_cleanup(a2l);
+	return ret;
+}
+
+#else /* LIBBFD_SUPPORT */
+
 static int addr2line(const char *dso_name, unsigned long addr,
 		     char **file, unsigned int *line_nr)
 {
@@ -53,6 +219,7 @@ out:
 	pclose(fp);
 	return ret;
 }
+#endif /* LIBBFD_SUPPORT */
 
 char *get_srcline(struct dso *dso, unsigned long addr)
 {
-- 
1.7.11.7

