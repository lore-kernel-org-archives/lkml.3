Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbaHMFNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:13:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44697 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaHMFNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:13:21 -0400
Date: Tue, 12 Aug 2014 22:12:57 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-8n4s6b6zvsez5ktanw006125@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        minchan@kernel.org, acme@kernel.org, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, minchan@kernel.org,
        a.p.zijlstra@chello.nl, acme@kernel.org, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Make sure --symfs usage includes the path separator
Git-Commit-ID: 972f393bc8870e236edbd2ea0150a8da85b709e2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  972f393bc8870e236edbd2ea0150a8da85b709e2
Gitweb:     http://git.kernel.org/tip/972f393bc8870e236edbd2ea0150a8da85b709e2
Author:     Arnaldo Carvalho de Melo <acme@kernel.org>
AuthorDate: Tue, 29 Jul 2014 10:21:58 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 Jul 2014 09:58:21 -0300

perf symbols: Make sure --symfs usage includes the path separator

Minchan reported that perf failed to load vmlinux if --symfs argument
doesn't end with '/' character.

Fix it by making sure that the '/' path separator is used when composing
pathnames with a --symfs provided directory name.

Reported-by: Minchan Kim <minchan@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-8n4s6b6zvsez5ktanw006125@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |  9 +++------
 tools/perf/util/dso.c      | 28 +++++++++++++---------------
 tools/perf/util/symbol.c   |  3 +--
 tools/perf/util/symbol.h   |  9 +++++++++
 tools/perf/util/util.h     | 16 ++++++++++++++++
 5 files changed, 42 insertions(+), 23 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 809b4c5..7745fec 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -899,10 +899,8 @@ int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize)
 	struct kcore_extract kce;
 	bool delete_extract = false;
 
-	if (filename) {
-		snprintf(symfs_filename, sizeof(symfs_filename), "%s%s",
-			 symbol_conf.symfs, filename);
-	}
+	if (filename)
+		symbol__join_symfs(symfs_filename, filename);
 
 	if (filename == NULL) {
 		if (dso->has_build_id) {
@@ -922,8 +920,7 @@ fallback:
 		 * DSO is the same as when 'perf record' ran.
 		 */
 		filename = (char *)dso->long_name;
-		snprintf(symfs_filename, sizeof(symfs_filename), "%s%s",
-			 symbol_conf.symfs, filename);
+		symbol__join_symfs(symfs_filename, filename);
 		free_filename = false;
 	}
 
diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 90d02c66..bdafd30 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -37,6 +37,7 @@ int dso__read_binary_type_filename(const struct dso *dso,
 {
 	char build_id_hex[BUILD_ID_SIZE * 2 + 1];
 	int ret = 0;
+	size_t len;
 
 	switch (type) {
 	case DSO_BINARY_TYPE__DEBUGLINK: {
@@ -60,26 +61,25 @@ int dso__read_binary_type_filename(const struct dso *dso,
 		break;
 
 	case DSO_BINARY_TYPE__FEDORA_DEBUGINFO:
-		snprintf(filename, size, "%s/usr/lib/debug%s.debug",
-			 symbol_conf.symfs, dso->long_name);
+		len = __symbol__join_symfs(filename, size, "/usr/lib/debug");
+		snprintf(filename + len, size - len, "%s.debug", dso->long_name);
 		break;
 
 	case DSO_BINARY_TYPE__UBUNTU_DEBUGINFO:
-		snprintf(filename, size, "%s/usr/lib/debug%s",
-			 symbol_conf.symfs, dso->long_name);
+		len = __symbol__join_symfs(filename, size, "/usr/lib/debug");
+		snprintf(filename + len, size - len, "%s", dso->long_name);
 		break;
 
 	case DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO:
 	{
 		const char *last_slash;
-		size_t len;
 		size_t dir_size;
 
 		last_slash = dso->long_name + dso->long_name_len;
 		while (last_slash != dso->long_name && *last_slash != '/')
 			last_slash--;
 
-		len = scnprintf(filename, size, "%s", symbol_conf.symfs);
+		len = __symbol__join_symfs(filename, size, "");
 		dir_size = last_slash - dso->long_name + 2;
 		if (dir_size > (size - len)) {
 			ret = -1;
@@ -100,26 +100,24 @@ int dso__read_binary_type_filename(const struct dso *dso,
 		build_id__sprintf(dso->build_id,
 				  sizeof(dso->build_id),
 				  build_id_hex);
-		snprintf(filename, size,
-			 "%s/usr/lib/debug/.build-id/%.2s/%s.debug",
-			 symbol_conf.symfs, build_id_hex, build_id_hex + 2);
+		len = __symbol__join_symfs(filename, size, "/usr/lib/debug/.build-id/");
+		snprintf(filename + len, size - len, "%.2s/%s.debug",
+			 build_id_hex, build_id_hex + 2);
 		break;
 
 	case DSO_BINARY_TYPE__VMLINUX:
 	case DSO_BINARY_TYPE__GUEST_VMLINUX:
 	case DSO_BINARY_TYPE__SYSTEM_PATH_DSO:
-		snprintf(filename, size, "%s%s",
-			 symbol_conf.symfs, dso->long_name);
+		__symbol__join_symfs(filename, size, dso->long_name);
 		break;
 
 	case DSO_BINARY_TYPE__GUEST_KMODULE:
-		snprintf(filename, size, "%s%s%s", symbol_conf.symfs,
-			 root_dir, dso->long_name);
+		path__join3(filename, size, symbol_conf.symfs,
+			    root_dir, dso->long_name);
 		break;
 
 	case DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE:
-		snprintf(filename, size, "%s%s", symbol_conf.symfs,
-			 dso->long_name);
+		__symbol__join_symfs(filename, size, dso->long_name);
 		break;
 
 	case DSO_BINARY_TYPE__KCORE:
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index eb06746..f134ec1 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1468,8 +1468,7 @@ int dso__load_vmlinux(struct dso *dso, struct map *map,
 	if (vmlinux[0] == '/')
 		snprintf(symfs_vmlinux, sizeof(symfs_vmlinux), "%s", vmlinux);
 	else
-		snprintf(symfs_vmlinux, sizeof(symfs_vmlinux), "%s%s",
-			 symbol_conf.symfs, vmlinux);
+		symbol__join_symfs(symfs_vmlinux, vmlinux);
 
 	if (dso->kernel == DSO_TYPE_GUEST_KERNEL)
 		symtab_type = DSO_BINARY_TYPE__GUEST_VMLINUX;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index e7295e9..196b291 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -13,6 +13,7 @@
 #include <libgen.h>
 #include "build-id.h"
 #include "event.h"
+#include "util.h"
 
 #ifdef HAVE_LIBELF_SUPPORT
 #include <libelf.h>
@@ -143,6 +144,14 @@ struct symbol_conf {
 };
 
 extern struct symbol_conf symbol_conf;
+
+static inline int __symbol__join_symfs(char *bf, size_t size, const char *path)
+{
+	return path__join(bf, size, symbol_conf.symfs, path);
+}
+
+#define symbol__join_symfs(bf, path) __symbol__join_symfs(bf, sizeof(bf), path)
+
 extern int vmlinux_path__nr_entries;
 extern char **vmlinux_path;
 
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 6686436..38af775 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -68,6 +68,7 @@
 #include <sys/socket.h>
 #include <sys/ioctl.h>
 #include <inttypes.h>
+#include <linux/kernel.h>
 #include <linux/magic.h>
 #include <linux/types.h>
 #include <sys/ttydefaults.h>
@@ -317,6 +318,21 @@ unsigned long parse_tag_value(const char *str, struct parse_tag *tags);
 
 #define SRCLINE_UNKNOWN  ((char *) "??:0")
 
+static inline int path__join(char *bf, size_t size,
+			     const char *path1, const char *path2)
+{
+	return scnprintf(bf, size, "%s%s%s", path1, path1[0] ? "/" : "", path2);
+}
+
+static inline int path__join3(char *bf, size_t size,
+			      const char *path1, const char *path2,
+			      const char *path3)
+{
+	return scnprintf(bf, size, "%s%s%s%s%s",
+			 path1, path1[0] ? "/" : "",
+			 path2, path2[0] ? "/" : "", path3);
+}
+
 struct dso;
 
 char *get_srcline(struct dso *dso, unsigned long addr);
