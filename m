Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934294AbaGYPig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:38:36 -0400
Received: from mail.kernel.org ([198.145.19.201]:35145 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933281AbaGYPic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:38:32 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/27] perf tools: Separate the VDSO map name from the VDSO dso name
Date: Fri, 25 Jul 2014 12:37:00 -0300
Message-Id: <1406302629-11790-19-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406302629-11790-1-git-send-email-acme@kernel.org>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

This is in preparation for supporting 32-bit compatibility VDSOs.

Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406035081-14301-49-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c     | 10 +++++-----
 tools/perf/util/symbol-elf.c |  2 +-
 tools/perf/util/vdso.c       | 11 ++++++++---
 tools/perf/util/vdso.h       |  6 ++++++
 4 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index a588a3eb5753..158c787ce0c4 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -256,9 +256,9 @@ static int __dsos__write_buildid_table(struct list_head *head,
 		if (!pos->hit)
 			continue;
 
-		if (is_vdso_map(pos->short_name)) {
-			name = (char *) VDSO__MAP_NAME;
-			name_len = sizeof(VDSO__MAP_NAME) + 1;
+		if (dso__is_vdso(pos)) {
+			name = pos->short_name;
+			name_len = pos->short_name_len + 1;
 		} else if (dso__is_kcore(pos)) {
 			machine__mmap_name(machine, nm, sizeof(nm));
 			name = nm;
@@ -339,7 +339,7 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 
 	len = scnprintf(filename, size, "%s%s%s",
 		       debugdir, slash ? "/" : "",
-		       is_vdso ? VDSO__MAP_NAME : realname);
+		       is_vdso ? DSO__NAME_VDSO : realname);
 	if (mkdir_p(filename, 0755))
 		goto out_free;
 
@@ -427,7 +427,7 @@ static int dso__cache_build_id(struct dso *dso, struct machine *machine,
 			       const char *debugdir)
 {
 	bool is_kallsyms = dso->kernel && dso->long_name[0] != '/';
-	bool is_vdso = is_vdso_map(dso->short_name);
+	bool is_vdso = dso__is_vdso(dso);
 	const char *name = dso->long_name;
 	char nm[PATH_MAX];
 
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index cef8f426356e..61b9cd456310 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -622,7 +622,7 @@ int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
 		GElf_Shdr shdr;
 		ss->adjust_symbols = (ehdr.e_type == ET_EXEC ||
 				ehdr.e_type == ET_REL ||
-				is_vdso_map(dso->short_name) ||
+				dso__is_vdso(dso) ||
 				elf_section_by_name(elf, &ehdr, &shdr,
 						     ".gnu.prelink_undo",
 						     NULL) != NULL);
diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index 946d927765c6..a9300f83654b 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -33,7 +33,7 @@ static struct vdso_info *vdso_info__new(void)
 	static const struct vdso_info vdso_info_init = {
 		.vdso    = {
 			.temp_file_name = VDSO__TEMP_FILE_NAME,
-			.dso_name = VDSO__MAP_NAME,
+			.dso_name = DSO__NAME_VDSO,
 		},
 	};
 
@@ -147,7 +147,7 @@ struct dso *vdso__dso_findnew(struct machine *machine)
 	if (!vdso_info)
 		return NULL;
 
-	dso = dsos__find(&machine->user_dsos, VDSO__MAP_NAME, true);
+	dso = dsos__find(&machine->user_dsos, DSO__NAME_VDSO, true);
 	if (!dso) {
 		char *file;
 
@@ -155,8 +155,13 @@ struct dso *vdso__dso_findnew(struct machine *machine)
 		if (!file)
 			return NULL;
 
-		dso = vdso__new(machine, VDSO__MAP_NAME, file);
+		dso = vdso__new(machine, DSO__NAME_VDSO, file);
 	}
 
 	return dso;
 }
+
+bool dso__is_vdso(struct dso *dso)
+{
+	return !strcmp(dso->short_name, DSO__NAME_VDSO);
+}
diff --git a/tools/perf/util/vdso.h b/tools/perf/util/vdso.h
index 7cf1576863a4..be3eb4324c1e 100644
--- a/tools/perf/util/vdso.h
+++ b/tools/perf/util/vdso.h
@@ -7,11 +7,17 @@
 
 #define VDSO__MAP_NAME "[vdso]"
 
+#define DSO__NAME_VDSO "[vdso]"
+
 static inline bool is_vdso_map(const char *filename)
 {
 	return !strcmp(filename, VDSO__MAP_NAME);
 }
 
+struct dso;
+
+bool dso__is_vdso(struct dso *dso);
+
 struct machine;
 
 struct dso *vdso__dso_findnew(struct machine *machine);
-- 
1.9.3

