Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761460Ab3EAPRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:17:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761439Ab3EAPQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:16:44 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Will Deacon <will.deacon@arm.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 5/8] perf tools: Add support to preload default formulas
Date: Wed,  1 May 2013 17:15:43 +0200
Message-Id: <1367421346-18257-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1367421346-18257-1-git-send-email-jolsa@redhat.com>
References: <1367421346-18257-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to read all formula definition files
under common locations:

  'formula'
    - under perf developement tree
  'PREFIX/PERF_EXEC_PATH/formulas'
    - when installed

Plus adding very basic formula definitions for CPI
and branch related counters.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile              |  8 ++++++
 tools/perf/formulas/default.conf | 26 ++++++++++++++++++++
 tools/perf/util/formula.c        | 53 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/formula.h        |  3 +++
 4 files changed, 90 insertions(+)
 create mode 100644 tools/perf/formulas/default.conf

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index bcbc524..c35bb7f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1010,6 +1010,12 @@ $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
 		'-DPREFIX="$(prefix_SQ)"' \
 		$<
 
+$(OUTPUT)util/formula.o: util/formula.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
+		'-DPERF_EXEC_PATH="$(perfexecdir_SQ)"' \
+		'-DPREFIX="$(prefix_SQ)"' \
+		$<
+
 $(OUTPUT)tests/attr.o: tests/attr.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
 		'-DBINDIR="$(bindir_SQ)"' -DPYTHON='"$(PYTHON_WORD)"' \
@@ -1201,6 +1207,8 @@ install-bin: all
 	$(INSTALL) tests/attr.py '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'
 	$(INSTALL) tests/attr/* '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/formulas'
+	$(INSTALL) -m 644 formulas/* $(DESTDIR_SQ)$(perfexec_instdir_SQ)/formulas
 
 install: install-bin try-install-man
 
diff --git a/tools/perf/formulas/default.conf b/tools/perf/formulas/default.conf
new file mode 100644
index 0000000..56712d6
--- /dev/null
+++ b/tools/perf/formulas/default.conf
@@ -0,0 +1,26 @@
+cpi {
+	events {
+		CY = cycles:u
+		IN = instructions:u
+	}
+
+	cpi = CY / IN
+
+	print cpi
+}
+
+branch {
+	events {
+		IN = instructions:u
+		BI = branch-instructions:u
+		BM = branch-misses:u
+	}
+
+	branch-rate       = BI / IN
+	branch-miss-rate  = BM / IN
+	branch-miss-ratio = BM / BI
+
+	print branch-rate
+	print branch-miss-rate
+	print branch-miss-ratio
+}
diff --git a/tools/perf/util/formula.c b/tools/perf/util/formula.c
index 2edc720..b9d95b2 100644
--- a/tools/perf/util/formula.c
+++ b/tools/perf/util/formula.c
@@ -159,6 +159,35 @@ int perf_formula__load(struct perf_formula *f, char *path)
 	return ret;
 }
 
+int perf_formula__load_dir(struct perf_formula *f, char *path)
+{
+	struct dirent *ent;
+	DIR *dir;
+	int ret = 0;
+
+	dir = opendir(path);
+	if (!dir) {
+		pr_err("formula: can't open dir '%s' - %s\n",
+		       path, strerror(errno));
+		return -1;
+	}
+
+	while (!ret && (ent = readdir(dir))) {
+		char file[PATH_MAX];
+
+		if (!strcmp(ent->d_name, ".") ||
+		    !strcmp(ent->d_name, ".."))
+			continue;
+
+		scnprintf(file, PATH_MAX, "%s/%s", path, ent->d_name);
+
+		ret = perf_formula__load(f, file);
+	}
+
+	closedir(dir);
+	return ret;
+}
+
 int perf_formula__free(struct perf_formula *f)
 {
 	struct perf_formula_file *file;
@@ -511,3 +540,27 @@ double perf_formula_expr__resolve(struct perf_formula_expr *expr,
 	pr_debug2("formula resolve %s = %F\n", name, result);
 	return result;
 }
+
+
+__attribute__((weak))
+int perf_formula__preload_arch(struct perf_formula *f __maybe_unused)
+{
+	return 0;
+}
+
+int perf_formula__preload(struct perf_formula *f)
+{
+	struct stat st;
+	int ret = 0;
+
+	if (!lstat("./formulas", &st))
+		ret = perf_formula__load_dir(f, (char *) "./formulas");
+	else {
+		char path[PATH_MAX];
+
+		scnprintf(path, PATH_MAX, "%s/%s/formulas/", PREFIX, PERF_EXEC_PATH);
+		ret = perf_formula__load_dir(f, path);
+	}
+
+	return ret ? ret : perf_formula__preload_arch(f);
+}
diff --git a/tools/perf/util/formula.h b/tools/perf/util/formula.h
index 90325ec..b6437d8 100644
--- a/tools/perf/util/formula.h
+++ b/tools/perf/util/formula.h
@@ -106,6 +106,7 @@ struct perf_formula_config {
 void perf_formula__init(struct perf_formula *f);
 
 int perf_formula__load(struct perf_formula *f, char *path);
+int perf_formula__load_dir(struct perf_formula *f, char *path);
 int perf_formula__free(struct perf_formula *f);
 
 struct perf_formula_set*
@@ -134,4 +135,6 @@ perf_formula_set__new(char *name, struct list_head *head);
 double perf_formula_expr__resolve(struct perf_formula_expr *expr,
 				  char *name);
 
+int perf_formula__preload(struct perf_formula *f);
+int perf_formula__preload_arch(struct perf_formula *f);
 #endif /* __PERF_FORMULA */
-- 
1.7.11.7

