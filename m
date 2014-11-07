Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaKGFbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:31:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57863 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaKGFbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:31:18 -0500
Date: Thu, 6 Nov 2014 21:30:55 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-00dc865798a31d3d5300dd5d70166a4a85f76a20@git.kernel.org>
Cc: dsahern@gmail.com, namhyung@kernel.org, acme@redhat.com,
        tglx@linutronix.de, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, namhyung.kim@lge.com, jolsa@redhat.com,
        paulus@samba.org, hpa@zytor.com, adrian.hunter@intel.com,
        mingo@kernel.org, eranian@google.com
Reply-To: jolsa@redhat.com, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, namhyung.kim@lge.com, eranian@google.com,
        mingo@kernel.org, adrian.hunter@intel.com, hpa@zytor.com,
        paulus@samba.org, namhyung@kernel.org, dsahern@gmail.com,
        tglx@linutronix.de, acme@redhat.com
In-Reply-To: <1415063674-17206-7-git-send-email-namhyung@kernel.org>
References: <1415063674-17206-7-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Do not save pathname in ./debug/
 .build-id directory for vmlinux
Git-Commit-ID: 00dc865798a31d3d5300dd5d70166a4a85f76a20
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

Commit-ID:  00dc865798a31d3d5300dd5d70166a4a85f76a20
Gitweb:     http://git.kernel.org/tip/00dc865798a31d3d5300dd5d70166a4a85f76a20
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 4 Nov 2014 10:14:32 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Nov 2014 10:14:08 -0300

perf record: Do not save pathname in ./debug/.build-id directory for vmlinux

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
index 5091a27..582c4da 100644
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
index c69915c..c24c5b8 100644
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
index eb2c19b..ded3ca7 100644
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
