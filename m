Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964884Ab3GQRvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:51:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964830Ab3GQRvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:51:37 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 20/23] perf tools: Add perf_data_file__open interface to data object
Date: Wed, 17 Jul 2013 19:50:00 +0200
Message-Id: <1374083403-14591-21-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding perf_data_file__open interface to data object
to open the perf.data file for both read and write.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/Makefile               |   1 +
 tools/perf/builtin-record.c       |  34 +----------
 tools/perf/builtin-top.c          |   9 +--
 tools/perf/tests/session-simple.c |   3 -
 tools/perf/util/data.c            | 120 ++++++++++++++++++++++++++++++++++++++
 tools/perf/util/data.h            |   4 ++
 tools/perf/util/session.c         |  84 +++++++++-----------------
 tools/perf/util/session.h         |   2 +-
 8 files changed, 154 insertions(+), 103 deletions(-)
 create mode 100644 tools/perf/util/data.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ca3e17b..f86424c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -360,6 +360,7 @@ LIB_OBJS += $(OUTPUT)util/rblist.o
 LIB_OBJS += $(OUTPUT)util/intlist.o
 LIB_OBJS += $(OUTPUT)util/vdso.o
 LIB_OBJS += $(OUTPUT)util/stat.o
+LIB_OBJS += $(OUTPUT)util/data.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index c4ec7eb..4754ec2 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -441,15 +441,12 @@ out:
 
 static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 {
-	struct stat st;
-	int flags;
 	int err, feat;
 	unsigned long waking = 0;
 	const bool forks = argc > 0;
 	struct perf_record_opts *opts = &rec->opts;
 	struct perf_evlist *evsel_list = rec->evlist;
 	struct perf_data_file *file = rec->file;
-	const char *output_name = file->path;
 	struct perf_session *session;
 	bool disabled = false;
 
@@ -463,35 +460,6 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	signal(SIGUSR1, sig_handler);
 	signal(SIGTERM, sig_handler);
 
-	if (!output_name) {
-		if (!fstat(STDOUT_FILENO, &st) && S_ISFIFO(st.st_mode))
-			file->is_pipe = true;
-		else
-			file->path = output_name = "perf.data";
-	}
-	if (output_name) {
-		if (!strcmp(output_name, "-"))
-			file->is_pipe = true;
-		else if (!stat(output_name, &st) && st.st_size) {
-			char oldname[PATH_MAX];
-			snprintf(oldname, sizeof(oldname), "%s.old",
-				 output_name);
-			unlink(oldname);
-			rename(output_name, oldname);
-		}
-	}
-
-	flags = O_CREAT|O_RDWR|O_TRUNC;
-
-	if (file->is_pipe)
-		file->fd = STDOUT_FILENO;
-	else
-		file->fd = open(output_name, flags, S_IRUSR | S_IWUSR);
-	if (file->fd < 0) {
-		perror("failed to create output file");
-		return -1;
-	}
-
 	session = perf_session__new(file, false, NULL);
 	if (session == NULL) {
 		pr_err("Not enough memory for reading perf file header\n");
@@ -619,7 +587,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	fprintf(stderr,
 		"[ perf record: Captured and wrote %.3f MB %s (~%" PRIu64 " samples) ]\n",
 		(double)rec->bytes_written / 1024.0 / 1024.0,
-		output_name,
+		file->path,
 		rec->bytes_written / 24);
 
 	return 0;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 3b01281..26f80a9 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -931,15 +931,8 @@ static int __cmd_top(struct perf_top *top)
 	struct perf_record_opts *opts = &top->record_opts;
 	pthread_t thread;
 	int ret;
-	struct perf_data_file file = {
-		.mode = PERF_DATA_MODE_WRITE,
-	};
 
-	/*
-	 * FIXME: perf_session__new should allow passing a O_MMAP, so that all this
-	 * mmap reading, etc is encapsulated in it. Use O_WRONLY for now.
-	 */
-	top->session = perf_session__new(&file, false, NULL);
+	top->session = perf_session__new(NULL, false, NULL);
 	if (top->session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/tests/session-simple.c b/tools/perf/tests/session-simple.c
index 4038a8e..391671b 100644
--- a/tools/perf/tests/session-simple.c
+++ b/tools/perf/tests/session-simple.c
@@ -114,9 +114,6 @@ static int session_write(void)
 	file.path = get_file();
 	TEST_ASSERT_VAL("failed to get temporary file", file.path);
 
-	file.fd = open(file.path, O_RDWR);
-	TEST_ASSERT_VAL("failed to open data file", file.fd >= 0);
-
 	evlist = get_evlist();
 	TEST_ASSERT_VAL("failed to get evlist", evlist);
 
diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
new file mode 100644
index 0000000..7d09faf
--- /dev/null
+++ b/tools/perf/util/data.c
@@ -0,0 +1,120 @@
+#include <linux/compiler.h>
+#include <linux/kernel.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <string.h>
+
+#include "data.h"
+#include "util.h"
+
+static bool check_pipe(struct perf_data_file *file)
+{
+	struct stat st;
+	bool is_pipe = false;
+	int fd = perf_data_file__is_read(file) ?
+		 STDIN_FILENO : STDOUT_FILENO;
+
+	if (!file->path) {
+		if (!fstat(fd, &st) && S_ISFIFO(st.st_mode))
+			is_pipe = true;
+	} else {
+		if (!strcmp(file->path, "-"))
+			is_pipe = true;
+	}
+
+	if (is_pipe)
+		file->fd = fd;
+
+	return file->is_pipe = is_pipe;
+}
+
+static int check_backup(struct perf_data_file *file)
+{
+	struct stat st;
+
+	if (!stat(file->path, &st) && st.st_size) {
+		/* TODO check errors properly */
+		char oldname[PATH_MAX];
+		snprintf(oldname, sizeof(oldname), "%s.old",
+			 file->path);
+		unlink(oldname);
+		rename(file->path, oldname);
+	}
+
+	return 0;
+}
+
+static int open_file_read(struct perf_data_file *file)
+{
+	struct stat st;
+	int fd;
+
+	fd = open(file->path, O_RDONLY);
+	if (fd < 0) {
+		int err = errno;
+
+		pr_err("failed to open %s: %s", file->path, strerror(err));
+		if (err == ENOENT && !strcmp(file->path, "perf.data"))
+			pr_err("  (try 'perf record' first)");
+		pr_err("\n");
+		return -err;
+	}
+
+	if (fstat(fd, &st) < 0)
+		goto out_close;
+
+	if (!file->force && st.st_uid && (st.st_uid != geteuid())) {
+		pr_err("file %s not owned by current user or root\n",
+		       file->path);
+		goto out_close;
+	}
+
+	if (!st.st_size) {
+		pr_info("zero-sized file (%s), nothing to do!\n",
+			file->path);
+		goto out_close;
+	}
+
+	file->size = st.st_size;
+	return fd;
+
+ out_close:
+	close(fd);
+	return -1;
+}
+
+static int open_file_write(struct perf_data_file *file)
+{
+	if (check_backup(file))
+		return -1;
+
+	return open(file->path, O_CREAT|O_RDWR|O_TRUNC, S_IRUSR|S_IWUSR);
+}
+
+static int open_file(struct perf_data_file *file)
+{
+	int fd;
+
+	fd = perf_data_file__is_read(file) ?
+	     open_file_read(file) : open_file_write(file);
+
+	file->fd = fd;
+	return fd < 0 ? -1 : 0;
+}
+
+int perf_data_file__open(struct perf_data_file *file)
+{
+	if (check_pipe(file))
+		return 0;
+
+	if (!file->path)
+		file->path = "perf.data";
+
+	return open_file(file);
+}
+
+void perf_data_file__close(struct perf_data_file *file)
+{
+	close(file->fd);
+}
diff --git a/tools/perf/util/data.h b/tools/perf/util/data.h
index ffa0186..d6c262e 100644
--- a/tools/perf/util/data.h
+++ b/tools/perf/util/data.h
@@ -13,6 +13,7 @@ struct perf_data_file {
 	int fd;
 	bool is_pipe;
 	bool force;
+	unsigned long size;
 	enum perf_data_mode mode;
 };
 
@@ -26,4 +27,7 @@ static inline bool perf_data_file__is_write(struct perf_data_file *file)
 	return file->mode == PERF_DATA_MODE_WRITE;
 }
 
+int perf_data_file__open(struct perf_data_file *file);
+void perf_data_file__close(struct perf_data_file *file);
+
 #endif /* __PERF_DATA_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 60d55ca..cfd9735 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -16,46 +16,14 @@
 #include "perf_regs.h"
 #include "vdso.h"
 
-static int perf_session__open(struct perf_session *self, bool force)
+static int perf_session__open(struct perf_session *self)
 {
-	struct stat input_stat;
-
-	if (!strcmp(self->filename, "-")) {
-		self->fd_pipe = true;
-		self->fd = STDIN_FILENO;
-
+	if (self->fd_pipe) {
 		if (perf_session__read_header(self) < 0)
 			pr_err("incompatible file format (rerun with -v to learn more)");
-
 		return 0;
 	}
 
-	self->fd = open(self->filename, O_RDONLY);
-	if (self->fd < 0) {
-		int err = errno;
-
-		pr_err("failed to open %s: %s", self->filename, strerror(err));
-		if (err == ENOENT && !strcmp(self->filename, "perf.data"))
-			pr_err("  (try 'perf record' first)");
-		pr_err("\n");
-		return -errno;
-	}
-
-	if (fstat(self->fd, &input_stat) < 0)
-		goto out_close;
-
-	if (!force && input_stat.st_uid && (input_stat.st_uid != geteuid())) {
-		pr_err("file %s not owned by current user or root\n",
-		       self->filename);
-		goto out_close;
-	}
-
-	if (!input_stat.st_size) {
-		pr_info("zero-sized file (%s), nothing to do!\n",
-			self->filename);
-		goto out_close;
-	}
-
 	if (perf_session__read_header(self) < 0) {
 		pr_err("incompatible file format (rerun with -v to learn more)");
 		goto out_close;
@@ -71,12 +39,9 @@ static int perf_session__open(struct perf_session *self, bool force)
 		goto out_close;
 	}
 
-	self->size = input_stat.st_size;
 	return 0;
 
 out_close:
-	close(self->fd);
-	self->fd = -1;
 	return -1;
 }
 
@@ -105,35 +70,35 @@ struct perf_session *perf_session__new(struct perf_data_file *file,
 				       bool repipe, struct perf_tool *tool)
 {
 	struct perf_session *self;
-	const char *filename = file->path;
-	struct stat st;
-	size_t len;
 
-	if (!filename || !strlen(filename)) {
-		if (!fstat(STDIN_FILENO, &st) && S_ISFIFO(st.st_mode))
-			filename = "-";
-		else
-			filename = "perf.data";
-	}
-
-	len = strlen(filename);
-	self = zalloc(sizeof(*self) + len);
-
-	if (self == NULL)
+	self = zalloc(sizeof(*self));
+	if (!self)
 		goto out;
 
-	memcpy(self->filename, filename, len);
 	self->repipe = repipe;
 	INIT_LIST_HEAD(&self->ordered_samples.samples);
 	INIT_LIST_HEAD(&self->ordered_samples.sample_cache);
 	INIT_LIST_HEAD(&self->ordered_samples.to_free);
 	machines__init(&self->machines);
 
-	if (perf_data_file__is_read(file)) {
-		if (perf_session__open(self, file->force) < 0)
+	if (file) {
+		if (perf_data_file__open(file))
 			goto out_delete;
-		perf_session__set_id_hdr_size(self);
-	} else if (perf_data_file__is_write(file)) {
+
+		self->fd       = file->fd;
+		self->fd_pipe  = file->is_pipe;
+		self->filename = file->path;
+		self->size     = file->size;
+
+		if (perf_data_file__is_read(file)) {
+			if (perf_session__open(self) < 0)
+				goto out_close;
+
+			perf_session__set_id_hdr_size(self);
+		}
+	}
+
+	if (!file || perf_data_file__is_write(file)) {
 		/*
 		 * In O_RDONLY mode this will be performed when reading the
 		 * kernel MMAP event, in perf_event__process_mmap().
@@ -148,10 +113,13 @@ struct perf_session *perf_session__new(struct perf_data_file *file,
 		tool->ordered_samples = false;
 	}
 
-out:
 	return self;
-out_delete:
+
+ out_close:
+	perf_data_file__close(file);
+ out_delete:
 	perf_session__delete(self);
+ out:
 	return NULL;
 }
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 8054acd..aa8fc69 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -39,7 +39,7 @@ struct perf_session {
 	bool			fd_pipe;
 	bool			repipe;
 	struct ordered_samples	ordered_samples;
-	char			filename[1];
+	const char		*filename;
 };
 
 struct perf_tool;
-- 
1.7.11.7

