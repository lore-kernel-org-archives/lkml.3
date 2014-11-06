Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbaKFVFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:05:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:43294 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbaKFVFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:05:47 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/18] perf build-id: Move build-id related functions to util/build-id.c
Date: Thu,  6 Nov 2014 18:04:32 -0300
Message-Id: <1415307879-912-12-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415307879-912-1-git-send-email-acme@kernel.org>
References: <1415307879-912-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

It'd be better managing those functions in a separate place as
util/header.c file is already big.

It now exports following 3 functions to others:

  bool perf_session__read_build_ids(struct perf_session *session, bool with_hits);
  int perf_session__write_buildid_table(struct perf_session *session, int fd);
  int perf_session__cache_build_ids(struct perf_session *session);

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: http://lkml.kernel.org/r/545733E7.6010105@intel.com
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1415063674-17206-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/build-id.c | 334 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/build-id.h |  11 ++
 tools/perf/util/header.c   | 337 +--------------------------------------------
 tools/perf/util/header.h   |   8 +-
 4 files changed, 349 insertions(+), 341 deletions(-)

diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 2e7c68e39330..dd2a3e52ada1 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -15,6 +15,8 @@
 #include "debug.h"
 #include "session.h"
 #include "tool.h"
+#include "header.h"
+#include "vdso.h"
 
 int build_id__mark_dso_hit(struct perf_tool *tool __maybe_unused,
 			   union perf_event *event,
@@ -105,3 +107,335 @@ char *dso__build_id_filename(const struct dso *dso, char *bf, size_t size)
 			 build_id_hex, build_id_hex + 2);
 	return bf;
 }
+
+#define dsos__for_each_with_build_id(pos, head)	\
+	list_for_each_entry(pos, head, node)	\
+		if (!pos->has_build_id)		\
+			continue;		\
+		else
+
+static int write_buildid(const char *name, size_t name_len, u8 *build_id,
+			 pid_t pid, u16 misc, int fd)
+{
+	int err;
+	struct build_id_event b;
+	size_t len;
+
+	len = name_len + 1;
+	len = PERF_ALIGN(len, NAME_ALIGN);
+
+	memset(&b, 0, sizeof(b));
+	memcpy(&b.build_id, build_id, BUILD_ID_SIZE);
+	b.pid = pid;
+	b.header.misc = misc;
+	b.header.size = sizeof(b) + len;
+
+	err = writen(fd, &b, sizeof(b));
+	if (err < 0)
+		return err;
+
+	return write_padded(fd, name, name_len + 1, len);
+}
+
+static int __dsos__write_buildid_table(struct list_head *head,
+				       struct machine *machine,
+				       pid_t pid, u16 misc, int fd)
+{
+	char nm[PATH_MAX];
+	struct dso *pos;
+
+	dsos__for_each_with_build_id(pos, head) {
+		int err;
+		const char *name;
+		size_t name_len;
+
+		if (!pos->hit)
+			continue;
+
+		if (dso__is_vdso(pos)) {
+			name = pos->short_name;
+			name_len = pos->short_name_len + 1;
+		} else if (dso__is_kcore(pos)) {
+			machine__mmap_name(machine, nm, sizeof(nm));
+			name = nm;
+			name_len = strlen(nm) + 1;
+		} else {
+			name = pos->long_name;
+			name_len = pos->long_name_len + 1;
+		}
+
+		err = write_buildid(name, name_len, pos->build_id,
+				    pid, misc, fd);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int machine__write_buildid_table(struct machine *machine, int fd)
+{
+	int err;
+	u16 kmisc = PERF_RECORD_MISC_KERNEL,
+	    umisc = PERF_RECORD_MISC_USER;
+
+	if (!machine__is_host(machine)) {
+		kmisc = PERF_RECORD_MISC_GUEST_KERNEL;
+		umisc = PERF_RECORD_MISC_GUEST_USER;
+	}
+
+	err = __dsos__write_buildid_table(&machine->kernel_dsos.head, machine,
+					  machine->pid, kmisc, fd);
+	if (err == 0)
+		err = __dsos__write_buildid_table(&machine->user_dsos.head,
+						  machine, machine->pid, umisc,
+						  fd);
+	return err;
+}
+
+int perf_session__write_buildid_table(struct perf_session *session, int fd)
+{
+	struct rb_node *nd;
+	int err = machine__write_buildid_table(&session->machines.host, fd);
+
+	if (err)
+		return err;
+
+	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
+		struct machine *pos = rb_entry(nd, struct machine, rb_node);
+		err = machine__write_buildid_table(pos, fd);
+		if (err)
+			break;
+	}
+	return err;
+}
+
+static int __dsos__hit_all(struct list_head *head)
+{
+	struct dso *pos;
+
+	list_for_each_entry(pos, head, node)
+		pos->hit = true;
+
+	return 0;
+}
+
+static int machine__hit_all_dsos(struct machine *machine)
+{
+	int err;
+
+	err = __dsos__hit_all(&machine->kernel_dsos.head);
+	if (err)
+		return err;
+
+	return __dsos__hit_all(&machine->user_dsos.head);
+}
+
+int dsos__hit_all(struct perf_session *session)
+{
+	struct rb_node *nd;
+	int err;
+
+	err = machine__hit_all_dsos(&session->machines.host);
+	if (err)
+		return err;
+
+	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
+		struct machine *pos = rb_entry(nd, struct machine, rb_node);
+
+		err = machine__hit_all_dsos(pos);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
+			  const char *name, bool is_kallsyms, bool is_vdso)
+{
+	const size_t size = PATH_MAX;
+	char *realname, *filename = zalloc(size),
+	     *linkname = zalloc(size), *targetname;
+	int len, err = -1;
+	bool slash = is_kallsyms || is_vdso;
+
+	if (is_kallsyms) {
+		if (symbol_conf.kptr_restrict) {
+			pr_debug("Not caching a kptr_restrict'ed /proc/kallsyms\n");
+			err = 0;
+			goto out_free;
+		}
+		realname = (char *) name;
+	} else
+		realname = realpath(name, NULL);
+
+	if (realname == NULL || filename == NULL || linkname == NULL)
+		goto out_free;
+
+	len = scnprintf(filename, size, "%s%s%s",
+		       debugdir, slash ? "/" : "",
+		       is_vdso ? DSO__NAME_VDSO : realname);
+	if (mkdir_p(filename, 0755))
+		goto out_free;
+
+	snprintf(filename + len, size - len, "/%s", sbuild_id);
+
+	if (access(filename, F_OK)) {
+		if (is_kallsyms) {
+			 if (copyfile("/proc/kallsyms", filename))
+				goto out_free;
+		} else if (link(realname, filename) && copyfile(name, filename))
+			goto out_free;
+	}
+
+	len = scnprintf(linkname, size, "%s/.build-id/%.2s",
+		       debugdir, sbuild_id);
+
+	if (access(linkname, X_OK) && mkdir_p(linkname, 0755))
+		goto out_free;
+
+	snprintf(linkname + len, size - len, "/%s", sbuild_id + 2);
+	targetname = filename + strlen(debugdir) - 5;
+	memcpy(targetname, "../..", 5);
+
+	if (symlink(targetname, linkname) == 0)
+		err = 0;
+out_free:
+	if (!is_kallsyms)
+		free(realname);
+	free(filename);
+	free(linkname);
+	return err;
+}
+
+static int build_id_cache__add_b(const u8 *build_id, size_t build_id_size,
+				 const char *name, const char *debugdir,
+				 bool is_kallsyms, bool is_vdso)
+{
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+
+	build_id__sprintf(build_id, build_id_size, sbuild_id);
+
+	return build_id_cache__add_s(sbuild_id, debugdir, name,
+				     is_kallsyms, is_vdso);
+}
+
+int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir)
+{
+	const size_t size = PATH_MAX;
+	char *filename = zalloc(size),
+	     *linkname = zalloc(size);
+	int err = -1;
+
+	if (filename == NULL || linkname == NULL)
+		goto out_free;
+
+	snprintf(linkname, size, "%s/.build-id/%.2s/%s",
+		 debugdir, sbuild_id, sbuild_id + 2);
+
+	if (access(linkname, F_OK))
+		goto out_free;
+
+	if (readlink(linkname, filename, size - 1) < 0)
+		goto out_free;
+
+	if (unlink(linkname))
+		goto out_free;
+
+	/*
+	 * Since the link is relative, we must make it absolute:
+	 */
+	snprintf(linkname, size, "%s/.build-id/%.2s/%s",
+		 debugdir, sbuild_id, filename);
+
+	if (unlink(linkname))
+		goto out_free;
+
+	err = 0;
+out_free:
+	free(filename);
+	free(linkname);
+	return err;
+}
+
+static int dso__cache_build_id(struct dso *dso, struct machine *machine,
+			       const char *debugdir)
+{
+	bool is_kallsyms = dso->kernel && dso->long_name[0] != '/';
+	bool is_vdso = dso__is_vdso(dso);
+	const char *name = dso->long_name;
+	char nm[PATH_MAX];
+
+	if (dso__is_kcore(dso)) {
+		is_kallsyms = true;
+		machine__mmap_name(machine, nm, sizeof(nm));
+		name = nm;
+	}
+	return build_id_cache__add_b(dso->build_id, sizeof(dso->build_id), name,
+				     debugdir, is_kallsyms, is_vdso);
+}
+
+static int __dsos__cache_build_ids(struct list_head *head,
+				   struct machine *machine, const char *debugdir)
+{
+	struct dso *pos;
+	int err = 0;
+
+	dsos__for_each_with_build_id(pos, head)
+		if (dso__cache_build_id(pos, machine, debugdir))
+			err = -1;
+
+	return err;
+}
+
+static int machine__cache_build_ids(struct machine *machine, const char *debugdir)
+{
+	int ret = __dsos__cache_build_ids(&machine->kernel_dsos.head, machine,
+					  debugdir);
+	ret |= __dsos__cache_build_ids(&machine->user_dsos.head, machine,
+				       debugdir);
+	return ret;
+}
+
+int perf_session__cache_build_ids(struct perf_session *session)
+{
+	struct rb_node *nd;
+	int ret;
+	char debugdir[PATH_MAX];
+
+	snprintf(debugdir, sizeof(debugdir), "%s", buildid_dir);
+
+	if (mkdir(debugdir, 0755) != 0 && errno != EEXIST)
+		return -1;
+
+	ret = machine__cache_build_ids(&session->machines.host, debugdir);
+
+	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
+		struct machine *pos = rb_entry(nd, struct machine, rb_node);
+		ret |= machine__cache_build_ids(pos, debugdir);
+	}
+	return ret ? -1 : 0;
+}
+
+static bool machine__read_build_ids(struct machine *machine, bool with_hits)
+{
+	bool ret;
+
+	ret  = __dsos__read_build_ids(&machine->kernel_dsos.head, with_hits);
+	ret |= __dsos__read_build_ids(&machine->user_dsos.head, with_hits);
+	return ret;
+}
+
+bool perf_session__read_build_ids(struct perf_session *session, bool with_hits)
+{
+	struct rb_node *nd;
+	bool ret = machine__read_build_ids(&session->machines.host, with_hits);
+
+	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
+		struct machine *pos = rb_entry(nd, struct machine, rb_node);
+		ret |= machine__read_build_ids(pos, with_hits);
+	}
+
+	return ret;
+}
diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
index ae392561470b..666a3bd4f64e 100644
--- a/tools/perf/util/build-id.h
+++ b/tools/perf/util/build-id.h
@@ -15,4 +15,15 @@ char *dso__build_id_filename(const struct dso *dso, char *bf, size_t size);
 int build_id__mark_dso_hit(struct perf_tool *tool, union perf_event *event,
 			   struct perf_sample *sample, struct perf_evsel *evsel,
 			   struct machine *machine);
+
+int dsos__hit_all(struct perf_session *session);
+
+bool perf_session__read_build_ids(struct perf_session *session, bool with_hits);
+int perf_session__write_buildid_table(struct perf_session *session, int fd);
+int perf_session__cache_build_ids(struct perf_session *session);
+
+int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
+			  const char *name, bool is_kallsyms, bool is_vdso);
+int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir);
+
 #endif
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index be8d02eb97e9..3e2c156d9c64 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -79,10 +79,7 @@ static int do_write(int fd, const void *buf, size_t size)
 	return 0;
 }
 
-#define NAME_ALIGN 64
-
-static int write_padded(int fd, const void *bf, size_t count,
-			size_t count_aligned)
+int write_padded(int fd, const void *bf, size_t count, size_t count_aligned)
 {
 	static const char zero_buf[NAME_ALIGN];
 	int err = do_write(fd, bf, count);
@@ -171,338 +168,6 @@ perf_header__set_cmdline(int argc, const char **argv)
 	return 0;
 }
 
-#define dsos__for_each_with_build_id(pos, head)	\
-	list_for_each_entry(pos, head, node)	\
-		if (!pos->has_build_id)		\
-			continue;		\
-		else
-
-static int write_buildid(const char *name, size_t name_len, u8 *build_id,
-			 pid_t pid, u16 misc, int fd)
-{
-	int err;
-	struct build_id_event b;
-	size_t len;
-
-	len = name_len + 1;
-	len = PERF_ALIGN(len, NAME_ALIGN);
-
-	memset(&b, 0, sizeof(b));
-	memcpy(&b.build_id, build_id, BUILD_ID_SIZE);
-	b.pid = pid;
-	b.header.misc = misc;
-	b.header.size = sizeof(b) + len;
-
-	err = do_write(fd, &b, sizeof(b));
-	if (err < 0)
-		return err;
-
-	return write_padded(fd, name, name_len + 1, len);
-}
-
-static int __dsos__hit_all(struct list_head *head)
-{
-	struct dso *pos;
-
-	list_for_each_entry(pos, head, node)
-		pos->hit = true;
-
-	return 0;
-}
-
-static int machine__hit_all_dsos(struct machine *machine)
-{
-	int err;
-
-	err = __dsos__hit_all(&machine->kernel_dsos.head);
-	if (err)
-		return err;
-
-	return __dsos__hit_all(&machine->user_dsos.head);
-}
-
-int dsos__hit_all(struct perf_session *session)
-{
-	struct rb_node *nd;
-	int err;
-
-	err = machine__hit_all_dsos(&session->machines.host);
-	if (err)
-		return err;
-
-	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
-		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-
-		err = machine__hit_all_dsos(pos);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
-static int __dsos__write_buildid_table(struct list_head *head,
-				       struct machine *machine,
-				       pid_t pid, u16 misc, int fd)
-{
-	char nm[PATH_MAX];
-	struct dso *pos;
-
-	dsos__for_each_with_build_id(pos, head) {
-		int err;
-		const char *name;
-		size_t name_len;
-
-		if (!pos->hit)
-			continue;
-
-		if (dso__is_vdso(pos)) {
-			name = pos->short_name;
-			name_len = pos->short_name_len + 1;
-		} else if (dso__is_kcore(pos)) {
-			machine__mmap_name(machine, nm, sizeof(nm));
-			name = nm;
-			name_len = strlen(nm) + 1;
-		} else {
-			name = pos->long_name;
-			name_len = pos->long_name_len + 1;
-		}
-
-		err = write_buildid(name, name_len, pos->build_id,
-				    pid, misc, fd);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
-static int machine__write_buildid_table(struct machine *machine, int fd)
-{
-	int err;
-	u16 kmisc = PERF_RECORD_MISC_KERNEL,
-	    umisc = PERF_RECORD_MISC_USER;
-
-	if (!machine__is_host(machine)) {
-		kmisc = PERF_RECORD_MISC_GUEST_KERNEL;
-		umisc = PERF_RECORD_MISC_GUEST_USER;
-	}
-
-	err = __dsos__write_buildid_table(&machine->kernel_dsos.head, machine,
-					  machine->pid, kmisc, fd);
-	if (err == 0)
-		err = __dsos__write_buildid_table(&machine->user_dsos.head,
-						  machine, machine->pid, umisc,
-						  fd);
-	return err;
-}
-
-static int perf_session__write_buildid_table(struct perf_session *session, int fd)
-{
-	struct rb_node *nd;
-	int err = machine__write_buildid_table(&session->machines.host, fd);
-
-	if (err)
-		return err;
-
-	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
-		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		err = machine__write_buildid_table(pos, fd);
-		if (err)
-			break;
-	}
-	return err;
-}
-
-int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
-			  const char *name, bool is_kallsyms, bool is_vdso)
-{
-	const size_t size = PATH_MAX;
-	char *realname, *filename = zalloc(size),
-	     *linkname = zalloc(size), *targetname;
-	int len, err = -1;
-	bool slash = is_kallsyms || is_vdso;
-
-	if (is_kallsyms) {
-		if (symbol_conf.kptr_restrict) {
-			pr_debug("Not caching a kptr_restrict'ed /proc/kallsyms\n");
-			err = 0;
-			goto out_free;
-		}
-		realname = (char *) name;
-	} else
-		realname = realpath(name, NULL);
-
-	if (realname == NULL || filename == NULL || linkname == NULL)
-		goto out_free;
-
-	len = scnprintf(filename, size, "%s%s%s",
-		       debugdir, slash ? "/" : "",
-		       is_vdso ? DSO__NAME_VDSO : realname);
-	if (mkdir_p(filename, 0755))
-		goto out_free;
-
-	snprintf(filename + len, size - len, "/%s", sbuild_id);
-
-	if (access(filename, F_OK)) {
-		if (is_kallsyms) {
-			 if (copyfile("/proc/kallsyms", filename))
-				goto out_free;
-		} else if (link(realname, filename) && copyfile(name, filename))
-			goto out_free;
-	}
-
-	len = scnprintf(linkname, size, "%s/.build-id/%.2s",
-		       debugdir, sbuild_id);
-
-	if (access(linkname, X_OK) && mkdir_p(linkname, 0755))
-		goto out_free;
-
-	snprintf(linkname + len, size - len, "/%s", sbuild_id + 2);
-	targetname = filename + strlen(debugdir) - 5;
-	memcpy(targetname, "../..", 5);
-
-	if (symlink(targetname, linkname) == 0)
-		err = 0;
-out_free:
-	if (!is_kallsyms)
-		free(realname);
-	free(filename);
-	free(linkname);
-	return err;
-}
-
-static int build_id_cache__add_b(const u8 *build_id, size_t build_id_size,
-				 const char *name, const char *debugdir,
-				 bool is_kallsyms, bool is_vdso)
-{
-	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
-
-	build_id__sprintf(build_id, build_id_size, sbuild_id);
-
-	return build_id_cache__add_s(sbuild_id, debugdir, name,
-				     is_kallsyms, is_vdso);
-}
-
-int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir)
-{
-	const size_t size = PATH_MAX;
-	char *filename = zalloc(size),
-	     *linkname = zalloc(size);
-	int err = -1;
-
-	if (filename == NULL || linkname == NULL)
-		goto out_free;
-
-	snprintf(linkname, size, "%s/.build-id/%.2s/%s",
-		 debugdir, sbuild_id, sbuild_id + 2);
-
-	if (access(linkname, F_OK))
-		goto out_free;
-
-	if (readlink(linkname, filename, size - 1) < 0)
-		goto out_free;
-
-	if (unlink(linkname))
-		goto out_free;
-
-	/*
-	 * Since the link is relative, we must make it absolute:
-	 */
-	snprintf(linkname, size, "%s/.build-id/%.2s/%s",
-		 debugdir, sbuild_id, filename);
-
-	if (unlink(linkname))
-		goto out_free;
-
-	err = 0;
-out_free:
-	free(filename);
-	free(linkname);
-	return err;
-}
-
-static int dso__cache_build_id(struct dso *dso, struct machine *machine,
-			       const char *debugdir)
-{
-	bool is_kallsyms = dso->kernel && dso->long_name[0] != '/';
-	bool is_vdso = dso__is_vdso(dso);
-	const char *name = dso->long_name;
-	char nm[PATH_MAX];
-
-	if (dso__is_kcore(dso)) {
-		is_kallsyms = true;
-		machine__mmap_name(machine, nm, sizeof(nm));
-		name = nm;
-	}
-	return build_id_cache__add_b(dso->build_id, sizeof(dso->build_id), name,
-				     debugdir, is_kallsyms, is_vdso);
-}
-
-static int __dsos__cache_build_ids(struct list_head *head,
-				   struct machine *machine, const char *debugdir)
-{
-	struct dso *pos;
-	int err = 0;
-
-	dsos__for_each_with_build_id(pos, head)
-		if (dso__cache_build_id(pos, machine, debugdir))
-			err = -1;
-
-	return err;
-}
-
-static int machine__cache_build_ids(struct machine *machine, const char *debugdir)
-{
-	int ret = __dsos__cache_build_ids(&machine->kernel_dsos.head, machine,
-					  debugdir);
-	ret |= __dsos__cache_build_ids(&machine->user_dsos.head, machine,
-				       debugdir);
-	return ret;
-}
-
-static int perf_session__cache_build_ids(struct perf_session *session)
-{
-	struct rb_node *nd;
-	int ret;
-	char debugdir[PATH_MAX];
-
-	snprintf(debugdir, sizeof(debugdir), "%s", buildid_dir);
-
-	if (mkdir(debugdir, 0755) != 0 && errno != EEXIST)
-		return -1;
-
-	ret = machine__cache_build_ids(&session->machines.host, debugdir);
-
-	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
-		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		ret |= machine__cache_build_ids(pos, debugdir);
-	}
-	return ret ? -1 : 0;
-}
-
-static bool machine__read_build_ids(struct machine *machine, bool with_hits)
-{
-	bool ret;
-
-	ret  = __dsos__read_build_ids(&machine->kernel_dsos.head, with_hits);
-	ret |= __dsos__read_build_ids(&machine->user_dsos.head, with_hits);
-	return ret;
-}
-
-static bool perf_session__read_build_ids(struct perf_session *session, bool with_hits)
-{
-	struct rb_node *nd;
-	bool ret = machine__read_build_ids(&session->machines.host, with_hits);
-
-	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
-		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		ret |= machine__read_build_ids(pos, with_hits);
-	}
-
-	return ret;
-}
-
 static int write_tracing_data(int fd, struct perf_header *h __maybe_unused,
 			    struct perf_evlist *evlist)
 {
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 8f5cbaea64a5..3bb90ac172a1 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -122,10 +122,6 @@ int perf_header__process_sections(struct perf_header *header, int fd,
 
 int perf_header__fprintf_info(struct perf_session *s, FILE *fp, bool full);
 
-int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
-			  const char *name, bool is_kallsyms, bool is_vdso);
-int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir);
-
 int perf_event__synthesize_attr(struct perf_tool *tool,
 				struct perf_event_attr *attr, u32 ids, u64 *id,
 				perf_event__handler_t process);
@@ -151,7 +147,9 @@ int perf_event__process_build_id(struct perf_tool *tool,
 				 struct perf_session *session);
 bool is_perf_magic(u64 magic);
 
-int dsos__hit_all(struct perf_session *session);
+#define NAME_ALIGN 64
+
+int write_padded(int fd, const void *bf, size_t count, size_t count_aligned);
 
 /*
  * arch specific callback
-- 
1.9.3

