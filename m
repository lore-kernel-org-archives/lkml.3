Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaKFVHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:07:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:43309 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbaKFVFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:05:50 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/18] perf record: Do not save pathname in ./debug/.build-id directory for vmlinux
Date: Thu,  6 Nov 2014 18:04:33 -0300
Message-Id: <1415307879-912-13-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415307879-912-1-git-send-email-acme@kernel.org>
References: <1415307879-912-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

When perf record finishes a session, it pre-processes samples in order
to write build-id info from DSOs that had samples.

During this process it'll call map__load() for the kernel map, and it
ends up calling dso__load_vmlinux_path() which replaces dso->long_name.

But this function checks kernel's build-id before searching vmlinux path
so it'll end up with a cryptic name, the pathname for the entry in the
~/.debug cache, which can be confusing to users.

This patch adds a flag to skip the build-id check during record, so
that it'll have the original vmlinux path for the kernel dso->long_name,
not the entry in the ~/.debug cache.

Before:
  # perf record -va sleep 3
  mmap size 528384B
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.196 MB perf.data (~8545 samples) ]
  Looking at the vmlinux_path (7 entries long)
  Using /home/namhyung/.debug/.build-id/f0/6e17aa50adf4d00b88925e03775de107611551 for symbols

After:
  # perf record -va sleep 3
  mmap size 528384B
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.193 MB perf.data (~8432 samples) ]
  Looking at the vmlinux_path (7 entries long)
  Using /lib/modules/3.16.4-1-ARCH/build/vmlinux for symbols

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1415063674-17206-7-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 11 +++++++++++
 tools/perf/util/symbol.c    | 11 ++++++-----
 tools/perf/util/symbol.h    |  1 +
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 5091a27e6d28..582c4da155ea 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -200,6 +200,17 @@ static int process_buildids(struct record *rec)
 	if (size == 0)
 		return 0;
 
+	/*
+	 * During this process, it'll load kernel map and replace the
+	 * dso->long_name to a real pathname it found.  In this case
+	 * we prefer the vmlinux path like
+	 *   /lib/modules/3.16.4/build/vmlinux
+	 *
+	 * rather than build-id path (in debug directory).
+	 *   $HOME/.debug/.build-id/f0/6e17aa50adf4d00b88925e03775de107611551
+	 */
+	symbol_conf.ignore_vmlinux_buildid = true;
+
 	return __perf_session__process_events(session, start,
 					      size - start,
 					      size, &build_id__mark_dso_hit_ops);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c69915c9d5bc..c24c5b83156c 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1511,12 +1511,10 @@ int dso__load_vmlinux_path(struct dso *dso, struct map *map,
 			   symbol_filter_t filter)
 {
 	int i, err = 0;
-	char *filename;
+	char *filename = NULL;
 
-	pr_debug("Looking at the vmlinux_path (%d entries long)\n",
-		 vmlinux_path__nr_entries + 1);
-
-	filename = dso__build_id_filename(dso, NULL, 0);
+	if (!symbol_conf.ignore_vmlinux_buildid)
+		filename = dso__build_id_filename(dso, NULL, 0);
 	if (filename != NULL) {
 		err = dso__load_vmlinux(dso, map, filename, true, filter);
 		if (err > 0)
@@ -1524,6 +1522,9 @@ int dso__load_vmlinux_path(struct dso *dso, struct map *map,
 		free(filename);
 	}
 
+	pr_debug("Looking at the vmlinux_path (%d entries long)\n",
+		 vmlinux_path__nr_entries + 1);
+
 	for (i = 0; i < vmlinux_path__nr_entries; ++i) {
 		err = dso__load_vmlinux(dso, map, vmlinux_path[i], false, filter);
 		if (err > 0)
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index eb2c19bf8d90..ded3ca7266de 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -105,6 +105,7 @@ struct symbol_conf {
 	unsigned short	nr_events;
 	bool		try_vmlinux_path,
 			ignore_vmlinux,
+			ignore_vmlinux_buildid,
 			show_kernel_path,
 			use_modules,
 			sort_by_name,
-- 
1.9.3

