Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab3LRKcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:32:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44627 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3LRKcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:32:10 -0500
Date: Wed, 18 Dec 2013 02:31:32 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-vkf3upzrfrxtr01wueej4xw4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Clarify method to get DSO binary_type filename
Git-Commit-ID: ee4e9625c8d4ec3a35322a882f7b6e035d2a1ad5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 18 Dec 2013 02:31:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee4e9625c8d4ec3a35322a882f7b6e035d2a1ad5
Gitweb:     http://git.kernel.org/tip/ee4e9625c8d4ec3a35322a882f7b6e035d2a1ad5
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 16 Dec 2013 17:03:18 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 16 Dec 2013 17:03:18 -0300

perf symbols: Clarify method to get DSO binary_type filename

Using dso__binary_type_file() make it look like this function will
return a file, not just its filename, so rename it to:

	dso__read_binary_type_filename()

to make its purpose clear, just like we have:

	dso__read_running_kernel_build_id()

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-vkf3upzrfrxtr01wueej4xw4@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c    | 14 +++++++-------
 tools/perf/util/dso.h    |  4 ++--
 tools/perf/util/symbol.c |  4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index e7f4449..eef1662 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -28,8 +28,9 @@ char dso__symtab_origin(const struct dso *dso)
 	return origin[dso->symtab_type];
 }
 
-int dso__binary_type_file(const struct dso *dso, enum dso_binary_type type,
-			  char *root_dir, char *filename, size_t size)
+int dso__read_binary_type_filename(const struct dso *dso,
+				   enum dso_binary_type type,
+				   char *root_dir, char *filename, size_t size)
 {
 	char build_id_hex[BUILD_ID_SIZE * 2 + 1];
 	int ret = 0;
@@ -137,19 +138,18 @@ int dso__binary_type_file(const struct dso *dso, enum dso_binary_type type,
 
 static int open_dso(struct dso *dso, struct machine *machine)
 {
-	char *root_dir = (char *) "";
-	char *name;
 	int fd;
+	char *root_dir = (char *)"";
+	char *name = malloc(PATH_MAX);
 
-	name = malloc(PATH_MAX);
 	if (!name)
 		return -ENOMEM;
 
 	if (machine)
 		root_dir = machine->root_dir;
 
-	if (dso__binary_type_file(dso, dso->data_type,
-				  root_dir, name, PATH_MAX)) {
+	if (dso__read_binary_type_filename(dso, dso->data_type,
+					    root_dir, name, PATH_MAX)) {
 		free(name);
 		return -EINVAL;
 	}
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index e1cc506..aa33847 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -128,8 +128,8 @@ void dso__read_running_kernel_build_id(struct dso *dso,
 int dso__kernel_module_get_build_id(struct dso *dso, const char *root_dir);
 
 char dso__symtab_origin(const struct dso *dso);
-int dso__binary_type_file(const struct dso *dso, enum dso_binary_type type,
-			  char *root_dir, char *filename, size_t size);
+int dso__read_binary_type_filename(const struct dso *dso, enum dso_binary_type type,
+				   char *root_dir, char *filename, size_t size);
 
 int dso__data_fd(struct dso *dso, struct machine *machine);
 ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 61eb1cd..9ee4b80 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1258,8 +1258,8 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 
 		enum dso_binary_type symtab_type = binary_type_symtab[i];
 
-		if (dso__binary_type_file(dso, symtab_type,
-					  root_dir, name, PATH_MAX))
+		if (dso__read_binary_type_filename(dso, symtab_type,
+						   root_dir, name, PATH_MAX))
 			continue;
 
 		/* Name is now the name of the next image to try */
