Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaAQPAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:00:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36314 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbaAQO5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:57:42 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "David A. Long" <dave.long@linaro.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/19] perf symbols: Export elf_section_by_name and reuse
Date: Fri, 17 Jan 2014 11:57:22 -0300
Message-Id: <1389970645-12075-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389970645-12075-1-git-send-email-acme@infradead.org>
References: <1389970645-12075-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Remove duplicated elf_section_by_name() functions from unwind.c and
probe-event.c and use one exported elf_section_by_name() instance
defined in symbol-elf.c.

Note that this also moves get_text_start_address() to merge
HAVE_DWARF_SUPPORT defined area.

Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "David A. Long" <dave.long@linaro.org>
Cc: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20140116093949.24403.38093.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c | 76 ++++++++++++++++---------------------------
 tools/perf/util/symbol-elf.c  |  5 ++-
 tools/perf/util/symbol.h      |  5 +++
 tools/perf/util/unwind.c      | 20 ++----------
 4 files changed, 37 insertions(+), 69 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index c68711c50f47..a8a9b6cd93a8 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -173,54 +173,6 @@ const char *kernel_get_module_path(const char *module)
 	return (dso) ? dso->long_name : NULL;
 }
 
-#ifdef HAVE_DWARF_SUPPORT
-/* Copied from unwind.c */
-static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
-				    GElf_Shdr *shp, const char *name)
-{
-	Elf_Scn *sec = NULL;
-
-	while ((sec = elf_nextscn(elf, sec)) != NULL) {
-		char *str;
-
-		gelf_getshdr(sec, shp);
-		str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
-		if (!strcmp(name, str))
-			break;
-	}
-
-	return sec;
-}
-
-static int get_text_start_address(const char *exec, unsigned long *address)
-{
-	Elf *elf;
-	GElf_Ehdr ehdr;
-	GElf_Shdr shdr;
-	int fd, ret = -ENOENT;
-
-	fd = open(exec, O_RDONLY);
-	if (fd < 0)
-		return -errno;
-
-	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
-	if (elf == NULL)
-		return -EINVAL;
-
-	if (gelf_getehdr(elf, &ehdr) == NULL)
-		goto out;
-
-	if (!elf_section_by_name(elf, &ehdr, &shdr, ".text"))
-		goto out;
-
-	*address = shdr.sh_addr - shdr.sh_offset;
-	ret = 0;
-out:
-	elf_end(elf);
-	return ret;
-}
-#endif
-
 static int init_user_exec(void)
 {
 	int ret = 0;
@@ -341,6 +293,34 @@ static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 	return 0;
 }
 
+static int get_text_start_address(const char *exec, unsigned long *address)
+{
+	Elf *elf;
+	GElf_Ehdr ehdr;
+	GElf_Shdr shdr;
+	int fd, ret = -ENOENT;
+
+	fd = open(exec, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
+	if (elf == NULL)
+		return -EINVAL;
+
+	if (gelf_getehdr(elf, &ehdr) == NULL)
+		goto out;
+
+	if (!elf_section_by_name(elf, &ehdr, &shdr, ".text", NULL))
+		goto out;
+
+	*address = shdr.sh_addr - shdr.sh_offset;
+	ret = 0;
+out:
+	elf_end(elf);
+	return ret;
+}
+
 static int add_exec_to_probe_trace_events(struct probe_trace_event *tevs,
 					  int ntevs, const char *exec)
 {
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 4b0a127a4d3b..759456728703 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -136,9 +136,8 @@ static size_t elf_addr_to_index(Elf *elf, GElf_Addr addr)
 	return -1;
 }
 
-static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
-				    GElf_Shdr *shp, const char *name,
-				    size_t *idx)
+Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
+			     GElf_Shdr *shp, const char *name, size_t *idx)
 {
 	Elf_Scn *sec = NULL;
 	size_t cnt = 1;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index cbd680361806..fffe2888a1c7 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -52,6 +52,11 @@ static inline char *bfd_demangle(void __maybe_unused *v,
 # define PERF_ELF_C_READ_MMAP ELF_C_READ
 #endif
 
+#ifdef HAVE_LIBELF_SUPPORT
+extern Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
+				GElf_Shdr *shp, const char *name, size_t *idx);
+#endif
+
 #ifndef DMGL_PARAMS
 #define DMGL_PARAMS      (1 << 0)       /* Include function args */
 #define DMGL_ANSI        (1 << 1)       /* Include const, volatile, etc */
diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
index 416f22bf3693..742f23bf35ff 100644
--- a/tools/perf/util/unwind.c
+++ b/tools/perf/util/unwind.c
@@ -28,6 +28,7 @@
 #include "session.h"
 #include "perf_regs.h"
 #include "unwind.h"
+#include "symbol.h"
 #include "util.h"
 
 extern int
@@ -158,23 +159,6 @@ static int __dw_read_encoded_value(u8 **p, u8 *end, u64 *val,
 	__v;                                                    \
 	})
 
-static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
-				    GElf_Shdr *shp, const char *name)
-{
-	Elf_Scn *sec = NULL;
-
-	while ((sec = elf_nextscn(elf, sec)) != NULL) {
-		char *str;
-
-		gelf_getshdr(sec, shp);
-		str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
-		if (!strcmp(name, str))
-			break;
-	}
-
-	return sec;
-}
-
 static u64 elf_section_offset(int fd, const char *name)
 {
 	Elf *elf;
@@ -190,7 +174,7 @@ static u64 elf_section_offset(int fd, const char *name)
 		if (gelf_getehdr(elf, &ehdr) == NULL)
 			break;
 
-		if (!elf_section_by_name(elf, &ehdr, &shdr, name))
+		if (!elf_section_by_name(elf, &ehdr, &shdr, name, NULL))
 			break;
 
 		offset = shdr.sh_offset;
-- 
1.8.1.4

