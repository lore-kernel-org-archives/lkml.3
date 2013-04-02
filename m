Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760344Ab3DBD51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:57:27 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:57342 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760567Ab3DBDze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:55:34 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 18/23] perf: deprecate LIBELF_SUPPORT in favor of CONFIG_LIBELF
Date: Mon,  1 Apr 2013 21:54:32 -0600
Message-Id: <1364874877-5618-19-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
References: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile                 |    2 --
 tools/perf/builtin-inject.c         |    3 ++-
 tools/perf/perf.c                   |    2 +-
 tools/perf/util/generate-cmdlist.sh |    4 ++--
 tools/perf/util/map.c               |    3 ++-
 tools/perf/util/symbol.h            |    4 ++--
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index cc44818..f9847db 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -584,8 +584,6 @@ ifneq ($(OUTPUT),)
 endif
 
 ifdef CONFIG_LIBELF
-    BASIC_CFLAGS += -DLIBELF_SUPPORT
-
     FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
     ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
 	    BASIC_CFLAGS += -DLIBELF_MMAP
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 84ad6ab..92e8012 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -17,6 +17,7 @@
 #include "util/build-id.h"
 
 #include "util/parse-options.h"
+#include <linux/kconfig.h>
 
 #include <linux/list.h>
 
@@ -229,7 +230,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
 				 * account this as unresolved.
 				 */
 			} else {
-#ifdef LIBELF_SUPPORT
+#ifdef CONFIG_LIBELF
 				pr_warning("no symbols found in %s, maybe "
 					   "install a debug package?\n",
 					   al.map->dso->long_name);
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index f7fcf78..0919ee1 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -50,7 +50,7 @@ static struct cmd_struct commands[] = {
 	{ "version",	cmd_version,	0 },
 	{ "script",	cmd_script,	0 },
 	{ "sched",	cmd_sched,	0 },
-#ifdef LIBELF_SUPPORT
+#ifdef CONFIG_LIBELF
 	{ "probe",	cmd_probe,	0 },
 #endif
 	{ "kmem",	cmd_kmem,	0 },
diff --git a/tools/perf/util/generate-cmdlist.sh b/tools/perf/util/generate-cmdlist.sh
index 3ac3803..8c039f6 100755
--- a/tools/perf/util/generate-cmdlist.sh
+++ b/tools/perf/util/generate-cmdlist.sh
@@ -22,7 +22,7 @@ do
      }' "Documentation/perf-$cmd.txt"
 done
 
-echo "#ifdef LIBELF_SUPPORT"
+echo "#ifdef CONFIG_LIBELF"
 sed -n -e 's/^perf-\([^ 	]*\)[ 	].* full.*/\1/p' command-list.txt |
 sort |
 while read cmd
@@ -35,5 +35,5 @@ do
 	    p
      }' "Documentation/perf-$cmd.txt"
 done
-echo "#endif /* LIBELF_SUPPORT */"
+echo "#endif /* CONFIG_LIBELF */"
 echo "};"
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 6fcb9de..80f351f 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -11,6 +11,7 @@
 #include "strlist.h"
 #include "vdso.h"
 #include "build-id.h"
+#include <linux/kconfig.h>
 #include <linux/string.h>
 
 const char *map_type__name[MAP__NR_TYPES] = {
@@ -165,7 +166,7 @@ int map__load(struct map *map, symbol_filter_t filter)
 		pr_warning(", continuing without symbols\n");
 		return -1;
 	} else if (nr == 0) {
-#ifdef LIBELF_SUPPORT
+#ifdef CONFIG_LIBELF
 		const size_t len = strlen(name);
 		const size_t real_len = len - sizeof(DSO__DELETED);
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index cd284dc..3875d40 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -14,7 +14,7 @@
 #include "build-id.h"
 #include <linux/kconfig.h>
 
-#ifdef LIBELF_SUPPORT
+#ifdef CONFIG_LIBELF
 #include <libelf.h>
 #include <gelf.h>
 #endif
@@ -172,7 +172,7 @@ struct symsrc {
 	int fd;
 	enum dso_binary_type type;
 
-#ifdef LIBELF_SUPPORT
+#ifdef CONFIG_LIBELF
 	Elf *elf;
 	GElf_Ehdr ehdr;
 
-- 
1.7.10.1

