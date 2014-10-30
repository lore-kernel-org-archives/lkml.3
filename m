Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbaJ3GrC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:47:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38129 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758636AbaJ3Gq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:46:58 -0400
Date: Wed, 29 Oct 2014 23:45:59 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-f6832e1720f5cc283703cfe9ccbfb46a3fb6f548@git.kernel.org>
Cc: mingo@kernel.org, hpa@zytor.com, dsahern@gmail.com, jolsa@redhat.com,
        peterz@infradead.org, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        paulus@samba.org, namhyung@gmail.com, adrian.hunter@intel.com,
        acme@redhat.com, eranian@google.com, tglx@linutronix.de
Reply-To: peterz@infradead.org, fweisbec@gmail.com, jolsa@redhat.com,
        mingo@kernel.org, hpa@zytor.com, dsahern@gmail.com, eranian@google.com,
        tglx@linutronix.de, namhyung@gmail.com, paulus@samba.org,
        adrian.hunter@intel.com, acme@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1414061124-26830-16-git-send-email-adrian.hunter@intel.com>
References: <1414061124-26830-16-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add support for 32-bit compatibility VDSOs
Git-Commit-ID: f6832e1720f5cc283703cfe9ccbfb46a3fb6f548
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

Commit-ID:  f6832e1720f5cc283703cfe9ccbfb46a3fb6f548
Gitweb:     http://git.kernel.org/tip/f6832e1720f5cc283703cfe9ccbfb46a3fb6f548
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 23 Oct 2014 13:45:23 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:32:48 -0200

perf tools: Add support for 32-bit compatibility VDSOs

'perf record' post-processes the event stream  to create a list of
build-ids for object files for which sample events have been recorded.
That results in those object files being recorded in the build-id cache.

In the case of VDSO, perf tools reads it from memory and copies it into
a temporary file, which as decribed above, gets added to the build-id
cache.

Then when the perf.data file is processed by other tools, the build-id
of VDSO is listed in the perf.data file and the VDSO can be read from
the build-id cache.  In that case the name of the map, the short name of
the DSO, and the entry in the build-id cache are all "[vdso]".

However, in the 64-bit case, there also can be 32-bit compatibility
VDSOs.

A previous patch added programs "perf-read-vdso32" and "perf
read-vdsox32".

This patch uses those programs to read the correct VDSO for a thread and
create a temporary file just as for the 64-bit VDSO.

The map name and the entry in the build-id cache are still "[vdso]" but
the DSO short name becomes "[vdso32]" and "[vdsox32]" respectively.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1414061124-26830-16-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/vdso.c | 170 ++++++++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/vdso.h |   4 +-
 2 files changed, 172 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index f51390a..69daef6 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -12,6 +12,7 @@
 #include "util.h"
 #include "symbol.h"
 #include "machine.h"
+#include "thread.h"
 #include "linux/string.h"
 #include "debug.h"
 
@@ -28,10 +29,15 @@ struct vdso_file {
 	bool error;
 	char temp_file_name[sizeof(VDSO__TEMP_FILE_NAME)];
 	const char *dso_name;
+	const char *read_prog;
 };
 
 struct vdso_info {
 	struct vdso_file vdso;
+#if BITS_PER_LONG == 64
+	struct vdso_file vdso32;
+	struct vdso_file vdsox32;
+#endif
 };
 
 static struct vdso_info *vdso_info__new(void)
@@ -41,6 +47,18 @@ static struct vdso_info *vdso_info__new(void)
 			.temp_file_name = VDSO__TEMP_FILE_NAME,
 			.dso_name = DSO__NAME_VDSO,
 		},
+#if BITS_PER_LONG == 64
+		.vdso32  = {
+			.temp_file_name = VDSO__TEMP_FILE_NAME,
+			.dso_name = DSO__NAME_VDSO32,
+			.read_prog = "perf-read-vdso32",
+		},
+		.vdsox32  = {
+			.temp_file_name = VDSO__TEMP_FILE_NAME,
+			.dso_name = DSO__NAME_VDSOX32,
+			.read_prog = "perf-read-vdsox32",
+		},
+#endif
 	};
 
 	return memdup(&vdso_info_init, sizeof(vdso_info_init));
@@ -92,6 +110,12 @@ void vdso__exit(struct machine *machine)
 
 	if (vdso_info->vdso.found)
 		unlink(vdso_info->vdso.temp_file_name);
+#if BITS_PER_LONG == 64
+	if (vdso_info->vdso32.found)
+		unlink(vdso_info->vdso32.temp_file_name);
+	if (vdso_info->vdsox32.found)
+		unlink(vdso_info->vdsox32.temp_file_name);
+#endif
 
 	zfree(&machine->vdso_info);
 }
@@ -110,6 +134,143 @@ static struct dso *vdso__new(struct machine *machine, const char *short_name,
 	return dso;
 }
 
+#if BITS_PER_LONG == 64
+
+static enum dso_type machine__thread_dso_type(struct machine *machine,
+					      struct thread *thread)
+{
+	enum dso_type dso_type = DSO__TYPE_UNKNOWN;
+	struct map *map;
+	struct dso *dso;
+
+	map = map_groups__first(thread->mg, MAP__FUNCTION);
+	for (; map ; map = map_groups__next(map)) {
+		dso = map->dso;
+		if (!dso || dso->long_name[0] != '/')
+			continue;
+		dso_type = dso__type(dso, machine);
+		if (dso_type != DSO__TYPE_UNKNOWN)
+			break;
+	}
+
+	return dso_type;
+}
+
+static int vdso__do_copy_compat(FILE *f, int fd)
+{
+	char buf[4096];
+	size_t count;
+
+	while (1) {
+		count = fread(buf, 1, sizeof(buf), f);
+		if (ferror(f))
+			return -errno;
+		if (feof(f))
+			break;
+		if (count && writen(fd, buf, count) != (ssize_t)count)
+			return -errno;
+	}
+
+	return 0;
+}
+
+static int vdso__copy_compat(const char *prog, int fd)
+{
+	FILE *f;
+	int err;
+
+	f = popen(prog, "r");
+	if (!f)
+		return -errno;
+
+	err = vdso__do_copy_compat(f, fd);
+
+	if (pclose(f) == -1)
+		return -errno;
+
+	return err;
+}
+
+static int vdso__create_compat_file(const char *prog, char *temp_name)
+{
+	int fd, err;
+
+	fd = mkstemp(temp_name);
+	if (fd < 0)
+		return -errno;
+
+	err = vdso__copy_compat(prog, fd);
+
+	if (close(fd) == -1)
+		return -errno;
+
+	return err;
+}
+
+static const char *vdso__get_compat_file(struct vdso_file *vdso_file)
+{
+	int err;
+
+	if (vdso_file->found)
+		return vdso_file->temp_file_name;
+
+	if (vdso_file->error)
+		return NULL;
+
+	err = vdso__create_compat_file(vdso_file->read_prog,
+				       vdso_file->temp_file_name);
+	if (err) {
+		pr_err("%s failed, error %d\n", vdso_file->read_prog, err);
+		vdso_file->error = true;
+		return NULL;
+	}
+
+	vdso_file->found = true;
+
+	return vdso_file->temp_file_name;
+}
+
+static struct dso *vdso__findnew_compat(struct machine *machine,
+					struct vdso_file *vdso_file)
+{
+	const char *file_name;
+	struct dso *dso;
+
+	dso = dsos__find(&machine->user_dsos, vdso_file->dso_name, true);
+	if (dso)
+		return dso;
+
+	file_name = vdso__get_compat_file(vdso_file);
+	if (!file_name)
+		return NULL;
+
+	return vdso__new(machine, vdso_file->dso_name, file_name);
+}
+
+static int vdso__dso_findnew_compat(struct machine *machine,
+				    struct thread *thread,
+				    struct vdso_info *vdso_info,
+				    struct dso **dso)
+{
+	enum dso_type dso_type;
+
+	dso_type = machine__thread_dso_type(machine, thread);
+	switch (dso_type) {
+	case DSO__TYPE_32BIT:
+		*dso = vdso__findnew_compat(machine, &vdso_info->vdso32);
+		return 1;
+	case DSO__TYPE_X32BIT:
+		*dso = vdso__findnew_compat(machine, &vdso_info->vdsox32);
+		return 1;
+	case DSO__TYPE_UNKNOWN:
+	case DSO__TYPE_64BIT:
+	default:
+		return 0;
+	}
+}
+
+#endif
+
 struct dso *vdso__dso_findnew(struct machine *machine,
 			      struct thread *thread __maybe_unused)
 {
@@ -123,6 +284,11 @@ struct dso *vdso__dso_findnew(struct machine *machine,
 	if (!vdso_info)
 		return NULL;
 
+#if BITS_PER_LONG == 64
+	if (vdso__dso_findnew_compat(machine, thread, vdso_info, &dso))
+		return dso;
+#endif
+
 	dso = dsos__find(&machine->user_dsos, DSO__NAME_VDSO, true);
 	if (!dso) {
 		char *file;
@@ -139,5 +305,7 @@ struct dso *vdso__dso_findnew(struct machine *machine,
 
 bool dso__is_vdso(struct dso *dso)
 {
-	return !strcmp(dso->short_name, DSO__NAME_VDSO);
+	return !strcmp(dso->short_name, DSO__NAME_VDSO) ||
+	       !strcmp(dso->short_name, DSO__NAME_VDSO32) ||
+	       !strcmp(dso->short_name, DSO__NAME_VDSOX32);
 }
diff --git a/tools/perf/util/vdso.h b/tools/perf/util/vdso.h
index af9d692..d97da16 100644
--- a/tools/perf/util/vdso.h
+++ b/tools/perf/util/vdso.h
@@ -7,7 +7,9 @@
 
 #define VDSO__MAP_NAME "[vdso]"
 
-#define DSO__NAME_VDSO "[vdso]"
+#define DSO__NAME_VDSO    "[vdso]"
+#define DSO__NAME_VDSO32  "[vdso32]"
+#define DSO__NAME_VDSOX32 "[vdsox32]"
 
 static inline bool is_vdso_map(const char *filename)
 {
