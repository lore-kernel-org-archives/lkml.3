Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaLXHYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:24:31 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39539 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaLXHOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:14:51 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 04/37] perf tools: Add multi file interface to perf_data_file
Date: Wed, 24 Dec 2014 16:15:00 +0900
Message-Id: <1419405333-27952-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When multi file storage is enabled, the perf data files will be saved
in a directory (default: perf.data.dir) and it'll have a single header
file for metadata (task/comm/mmap events and file header) and multiple
data files (sample events) like below:

  $ tree perf.data.dir
  perf.data.dir
  |-- perf.data.0
  |-- perf.data.1
  |-- perf.data.2
  |-- perf.data.3
  `-- perf.header

  0 directories, 5 files

Existing data file interface supports multi files internally and add
new perf_data_file__prepare_write() and perf_data_file__write_multi()
functions in order to support multi-file record.  Note that multi read
interface is not needed since they're accessed via mmap.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/data.c | 149 +++++++++++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/data.h |  14 +++++
 tools/perf/util/util.c |  43 ++++++++++++++
 tools/perf/util/util.h |   1 +
 4 files changed, 201 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index 1921942fc2e0..8dacd34659cc 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -4,6 +4,7 @@
 #include <sys/stat.h>
 #include <unistd.h>
 #include <string.h>
+#include <dirent.h>
 
 #include "data.h"
 #include "util.h"
@@ -39,26 +40,97 @@ static int check_backup(struct perf_data_file *file)
 		char oldname[PATH_MAX];
 		snprintf(oldname, sizeof(oldname), "%s.old",
 			 file->path);
-		unlink(oldname);
+
+		if (S_ISDIR(st.st_mode))
+			rm_rf(oldname);
+		else
+			unlink(oldname);
+
 		rename(file->path, oldname);
 	}
 
 	return 0;
 }
 
+static int scandir_filter(const struct dirent *d)
+{
+	return !prefixcmp(d->d_name, "perf.data.");
+}
+
+static int open_file_read_multi(struct perf_data_file *file)
+{
+	int i, n;
+	int ret;
+	struct dirent **list;
+
+	n = scandir(file->path, &list, scandir_filter, versionsort);
+	if (n <= 0) {
+		ret = -errno;
+		pr_err("cannot find multi-data file\n");
+		return ret;
+	}
+
+	file->multi_fd = malloc(n * sizeof(int));
+	if (file->multi_fd == NULL) {
+		free(list);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < n; i++) {
+		char path[PATH_MAX];
+
+		scnprintf(path, sizeof(path), "%s/%s",
+			  file->path, list[i]->d_name);
+
+		ret = open(path, O_RDONLY);
+		if (ret < 0)
+			goto out_err;
+
+		file->multi_fd[i] = ret;
+	}
+
+	file->nr_multi = n;
+
+	free(list);
+	return 0;
+
+out_err:
+	while (--i >= 0)
+		close(file->multi_fd[i]);
+
+	zfree(&file->multi_fd);
+	free(list);
+	return ret;
+}
+
+static const char *default_data_path(struct perf_data_file *file)
+{
+	return file->is_multi ? "perf.data.dir" : "perf.data";
+}
+
 static int open_file_read(struct perf_data_file *file)
 {
 	struct stat st;
+	char path[PATH_MAX];
 	int fd;
 	char sbuf[STRERR_BUFSIZE];
 
-	fd = open(file->path, O_RDONLY);
+	strcpy(path, file->path);
+	if (file->is_multi) {
+		if (open_file_read_multi(file) < 0)
+			return -1;
+
+		if (path__join(path, sizeof(path), file->path, "perf.header") < 0)
+			return -1;
+	}
+
+	fd = open(path, O_RDONLY);
 	if (fd < 0) {
 		int err = errno;
 
-		pr_err("failed to open %s: %s", file->path,
+		pr_err("failed to open %s: %s", path,
 			strerror_r(err, sbuf, sizeof(sbuf)));
-		if (err == ENOENT && !strcmp(file->path, "perf.data"))
+		if (err == ENOENT && !strcmp(path, default_data_path(file)))
 			pr_err("  (try 'perf record' first)");
 		pr_err("\n");
 		return -err;
@@ -90,12 +162,26 @@ static int open_file_read(struct perf_data_file *file)
 static int open_file_write(struct perf_data_file *file)
 {
 	int fd;
+	char path[PATH_MAX];
 	char sbuf[STRERR_BUFSIZE];
 
 	if (check_backup(file))
 		return -1;
 
-	fd = open(file->path, O_CREAT|O_RDWR|O_TRUNC, S_IRUSR|S_IWUSR);
+	strcpy(path, file->path);
+
+	if (file->is_multi) {
+		if (mkdir(file->path, S_IRWXU) < 0) {
+			pr_err("cannot create data directory `%s': %s\n",
+			       file->path, strerror_r(errno, sbuf, sizeof(sbuf)));
+			return -1;
+		}
+
+		if (path__join(path, sizeof(path), file->path, "perf.header") < 0)
+			return -1;
+	}
+
+	fd = open(path, O_CREAT|O_RDWR|O_TRUNC, S_IRUSR|S_IWUSR);
 
 	if (fd < 0)
 		pr_err("failed to open %s : %s\n", file->path,
@@ -121,18 +207,69 @@ int perf_data_file__open(struct perf_data_file *file)
 		return 0;
 
 	if (!file->path)
-		file->path = "perf.data";
+		file->path = default_data_path(file);
 
 	return open_file(file);
 }
 
 void perf_data_file__close(struct perf_data_file *file)
 {
+	if (file->is_multi) {
+		int i;
+
+		for (i = 0; i < file->nr_multi; i++)
+			close(file->multi_fd[i]);
+
+		zfree(&file->multi_fd);
+	}
+
 	close(file->fd);
 }
 
+int perf_data_file__prepare_write(struct perf_data_file *file, int nr)
+{
+	int i;
+	int ret;
+	char path[PATH_MAX];
+
+	if (!file->is_multi)
+		return 0;
+
+	file->multi_fd = malloc(nr * sizeof(int));
+	if (file->multi_fd == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < nr; i++) {
+		scnprintf(path, sizeof(path), "%s/perf.data.%d", file->path, i);
+		ret = open(path, O_RDWR|O_CREAT|O_TRUNC, S_IRUSR|S_IWUSR);
+		if (ret < 0)
+			goto out_err;
+
+		file->multi_fd[i] = ret;
+	}
+
+	file->nr_multi = nr;
+	return 0;
+
+out_err:
+	while (--i >= 0)
+		close(file->multi_fd[i]);
+
+	zfree(&file->multi_fd);
+	return ret;
+}
+
 ssize_t perf_data_file__write(struct perf_data_file *file,
 			      void *buf, size_t size)
 {
 	return writen(file->fd, buf, size);
 }
+
+ssize_t perf_data_file__write_multi(struct perf_data_file *file,
+				    void *buf, size_t size, int idx)
+{
+	if (!file->is_multi)
+		return -1;
+
+	return writen(file->multi_fd[idx], buf, size);
+}
diff --git a/tools/perf/util/data.h b/tools/perf/util/data.h
index 2b15d0c95c7f..f5c229166614 100644
--- a/tools/perf/util/data.h
+++ b/tools/perf/util/data.h
@@ -11,6 +11,9 @@ enum perf_data_mode {
 struct perf_data_file {
 	const char		*path;
 	int			 fd;
+	int			 nr_multi;
+	int			*multi_fd;
+	bool			 is_multi;
 	bool			 is_pipe;
 	bool			 force;
 	unsigned long		 size;
@@ -37,6 +40,14 @@ static inline int perf_data_file__fd(struct perf_data_file *file)
 	return file->fd;
 }
 
+static inline int perf_data_file__multi_fd(struct perf_data_file *file, int idx)
+{
+	if (!file->is_multi || idx >= file->nr_multi)
+		return -1;
+
+	return file->multi_fd[idx];
+}
+
 static inline unsigned long perf_data_file__size(struct perf_data_file *file)
 {
 	return file->size;
@@ -46,5 +57,8 @@ int perf_data_file__open(struct perf_data_file *file);
 void perf_data_file__close(struct perf_data_file *file);
 ssize_t perf_data_file__write(struct perf_data_file *file,
 			      void *buf, size_t size);
+int perf_data_file__prepare_write(struct perf_data_file *file, int nr);
+ssize_t perf_data_file__write_multi(struct perf_data_file *file,
+				    void *buf, size_t size, int idx);
 
 #endif /* __PERF_DATA_H */
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index d5eab3f3323f..a5046d52e311 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -72,6 +72,49 @@ int mkdir_p(char *path, mode_t mode)
 	return (stat(path, &st) && mkdir(path, mode)) ? -1 : 0;
 }
 
+int rm_rf(char *path)
+{
+	DIR *dir;
+	int ret = 0;
+	struct dirent *d;
+	char namebuf[PATH_MAX];
+
+	dir = opendir(path);
+	if (dir == NULL)
+		return 0;
+
+	while ((d = readdir(dir)) != NULL && !ret) {
+		struct stat statbuf;
+
+		if (d->d_name[0] == '.')
+			continue;
+
+		scnprintf(namebuf, sizeof(namebuf), "%s/%s",
+			  path, d->d_name);
+
+		ret = stat(namebuf, &statbuf);
+		if (ret < 0) {
+			pr_debug("stat failed: %s\n", namebuf);
+			break;
+		}
+
+		if (S_ISREG(statbuf.st_mode))
+			ret = unlink(namebuf);
+		else if (S_ISDIR(statbuf.st_mode))
+			ret = rm_rf(namebuf);
+		else {
+			pr_debug("unknown file: %s\n", namebuf);
+			ret = -1;
+		}
+	}
+	closedir(dir);
+
+	if (ret < 0)
+		return ret;
+
+	return rmdir(path);
+}
+
 static int slow_copyfile(const char *from, const char *to, mode_t mode)
 {
 	int err = -1;
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index abc445ee4f60..d75975a71d2c 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -248,6 +248,7 @@ static inline int sane_case(int x, int high)
 }
 
 int mkdir_p(char *path, mode_t mode);
+int rm_rf(char *path);
 int copyfile(const char *from, const char *to);
 int copyfile_mode(const char *from, const char *to, mode_t mode);
 
-- 
2.1.3

