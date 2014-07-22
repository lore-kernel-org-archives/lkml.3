Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbaGVNWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:22:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:45622 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653AbaGVNVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:21:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="576986364"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 48/52] perf tools: Separate the VDSO map name from the VDSO dso name
Date: Tue, 22 Jul 2014 16:17:57 +0300
Message-Id: <1406035081-14301-49-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation for supporting 32-bit compatibility VDSOs.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/header.c     | 10 +++++-----
 tools/perf/util/symbol-elf.c |  2 +-
 tools/perf/util/vdso.c       | 11 ++++++++---
 tools/perf/util/vdso.h       |  6 ++++++
 4 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index a588a3e..158c787 100644
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
index 84f5e2a..0387780 100644
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
index 946d927..a9300f8 100644
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
index 7cf1576..be3eb43 100644
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
1.8.3.2

