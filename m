Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965424AbaGRKTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:19:33 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:59924 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054AbaGRKT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:19:27 -0400
Subject: [PATCH v2 1/3] perf/sdt : Listing of SDT markers by perf
To: linux-kernel@vger.kernel.org
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Date: Thu, 17 Jul 2014 11:25:12 +0530
Message-ID: <20140717055341.19995.97042.stgit@hemant-fedora>
In-Reply-To: <20140717054826.19995.61782.stgit@hemant-fedora>
References: <20140717054826.19995.61782.stgit@hemant-fedora>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071810-3864-0000-0000-0000001B865F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables perf to list the SDT markers present in a system. It looks
in dsos given by ldconfig --print-cache and for other binaries, it looks into
the PATH environment variable. After preparing a list of the binaries, then
it starts searching for SDT markers in them.
To find the SDT markers, first an elf section named .note.stapsdt is searched
for. And then the SDT notes are retreived one by one from that section.
To counter the effect of prelinking, the section ".stapsdt.base" is searched.
If its found, then the location of the SDT marker is adjusted.

All these markers' info is written into a cache file
"/var/cache/perf/perf-sdt.cache".
Since, the presence of SDT markers is quite common these days, hence, its better
to make them visible to a user easily. Also, creating a cache file will help a user
to probe (to be implemented) these markers without much hussle. This cache file will
hold most of the SDT markers.

The format of each SDT cache entry is -

%provider:marker:file_path:build_id:location:semaphore_loc

% - marks the beginning of each entry.
provider - The provider name of the SDT marker.
marker - The marker name of the SDT marker.
file_path - Full/absolute path of the file in which this marker is present.
location : Adjusted location of the SDT marker inside the program.
semaphore_loc : The semaphore address if present otherwise 0x0.

This format should help when probing will be implemented. The adjusted address
from the required entry can be directly used in probing if the build_id matches.

To scan the system for SDT markers invoke :
# perf list sdt --scan

"--scan" should be used for the first time and whenever there is any change in
the files containing the SDT markers. It looks into the common binaries available
in a system.

And then use :
# perf list sdt

This displays the list of SDT markers recorded in the SDT cache.
This shows the SDT markers present in the common binaries stored in the system,
present in PATH variable and the /lib/ and /lib64/ directories.

Or use:
# perf list

It should display all events including the SDT events.

Signed-off-by : hemant@linux.vnet.ibm.com
---
 tools/perf/Makefile.perf       |    1 
 tools/perf/builtin-list.c      |    6 
 tools/perf/util/parse-events.h |    3 
 tools/perf/util/sdt.c          |  503 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/symbol-elf.c   |  229 ++++++++++++++++++
 tools/perf/util/symbol.h       |   19 ++
 6 files changed, 760 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/util/sdt.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 9670a16..e098dcd 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -373,6 +373,7 @@ LIB_OBJS += $(OUTPUT)util/stat.o
 LIB_OBJS += $(OUTPUT)util/record.o
 LIB_OBJS += $(OUTPUT)util/srcline.o
 LIB_OBJS += $(OUTPUT)util/data.o
+LIB_OBJS += $(OUTPUT)util/sdt.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 011195e..e1e654b 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -23,7 +23,7 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 		OPT_END()
 	};
 	const char * const list_usage[] = {
-		"perf list [hw|sw|cache|tracepoint|pmu|event_glob]",
+		"perf list [hw|sw|cache|tracepoint|pmu|event_glob|sdt]",
 		NULL
 	};
 
@@ -34,6 +34,8 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	if (argc == 0) {
 		print_events(NULL, false);
+		printf("\n\nSDT events :\n");
+		sdt_cache__display();
 		return 0;
 	}
 
@@ -55,6 +57,8 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 			print_pmu_events(NULL, false);
 		else if (strcmp(argv[i], "--raw-dump") == 0)
 			print_events(NULL, true);
+		else if (strcmp(argv[i], "sdt") == 0)
+			print_sdt_events(argv[++i]);
 		else {
 			char *sep = strchr(argv[i], ':'), *s;
 			int sep_idx;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index df094b4..486d230 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -109,4 +109,7 @@ extern int is_valid_tracepoint(const char *event_string);
 
 extern int valid_debugfs_mount(const char *debugfs);
 
+void print_sdt_events(const char *arg);
+extern void sdt_cache__display(void);
+
 #endif /* __PERF_PARSE_EVENTS_H */
diff --git a/tools/perf/util/sdt.c b/tools/perf/util/sdt.c
new file mode 100644
index 0000000..f5bfdbd
--- /dev/null
+++ b/tools/perf/util/sdt.c
@@ -0,0 +1,503 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <string.h>
+#include <linux/limits.h>
+#include <dirent.h>
+#include <errno.h>
+#include <sys/mman.h>
+
+#include "linux/list.h"
+#include "symbol.h"
+#include "build-id.h"
+#include "include/linux/kernel.h"
+#include "parse-events.h"
+
+#define LIB_COMM "ldconfig --print-cache"
+
+#define SDT_CACHE_DIR "/var/cache/perf/"
+#define SDT_CACHE "perf-sdt.cache"
+#define SDT_CACHE_TMP "perf-sdt.cache.tmp"
+
+#define DELIM ':'
+
+struct path_list {
+	char path[PATH_MAX];
+	struct list_head list;
+} execs;
+
+/* Write operation for cache */
+static void write_cache(FILE *cache, char *buffer)
+{
+	fprintf(cache, "%s", buffer);
+}
+
+/* copies from src to target till 'delim' */
+static int copy_delim(char *src, char *target, char delim, size_t size)
+{
+	int i;
+
+	memset(target, '\0', size);
+	for (i = 0; src[i] != delim; i++)
+		target[i] = src[i];
+
+	return i + 1;
+}
+
+/*
+ * get_sdt_note_info() is the function actually responsible for
+ * flushing the SDT notes info into the "cache" file or to the
+ * stdout if "cache" points to NULL. Also, this function finds out
+ * the build-id of an ELF to be written into "cache".
+ */
+static void get_sdt_note_info(struct list_head *start, const char *target,
+			      FILE *cache)
+{
+	struct sdt_note *pos;
+	u8 build_id[BUILD_ID_SIZE];
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+	char buffer[2 * PATH_MAX];
+
+	if (list_empty(start))
+		return;
+
+	/* Read the build id of the file */
+	if (filename__read_build_id(target, &build_id,
+				    sizeof(build_id)) < 0) {
+		pr_debug("Couldn't read build-id in %s\n", target);
+		return;
+	}
+	/* Convert the build id into a string */
+	build_id__sprintf(build_id, sizeof(build_id), sbuild_id);
+
+	list_for_each_entry(pos, start, note_list) {
+		sprintf(buffer, "%%%s:%s:%s:%s:0x%lx:0x%lx",
+			pos->provider, pos->name, target, sbuild_id,
+			pos->bit32 ? pos->addr.a32[0] :
+			pos->addr.a64[0],
+			pos->bit32 ? pos->addr.a32[2] :
+			pos->addr.a64[2]);
+
+		/*
+		 * Format of any line of this sdt-cache :
+		 * %provider:marker:filename:build-id:location:semaphore
+		 */
+		write_cache(cache, buffer);
+	}
+}
+
+/* Free the sdt note list */
+static void cleanup_sdt_note_list(struct list_head *sdt_notes)
+{
+	struct sdt_note *tmp, *pos;
+
+	if (list_empty(sdt_notes))
+		return;
+
+	list_for_each_entry_safe(pos, tmp, sdt_notes, note_list) {
+		list_del(&pos->note_list);
+		free(pos->name);
+		free(pos->provider);
+		free(pos);
+	}
+}
+
+/*
+ * filename__find_sdt() looks for sdt markers and the list is stored
+ * in sdt_notes. The fd passed here is the file in which the info
+ * about the SDT markers is filled up.
+ */
+static int filename__find_sdt(const char *target, FILE *cache)
+{
+	int ret;
+
+	LIST_HEAD(sdt_notes);
+
+	ret = get_sdt_note_list(&sdt_notes, target);
+	if (!ret)
+		get_sdt_note_info(&sdt_notes, target, cache);
+
+	cleanup_sdt_note_list(&sdt_notes);
+	return ret;
+}
+
+/*
+ * Finds out the libraries present in a system as shown by the command
+ * "ldconfig --print-cache". Uses "=>" and '/' to find out the start of a
+ * dso path.
+ */
+static char *parse_lib_name(char *str)
+{
+	char *ptr, *q, *r;
+
+	while (str != NULL) {
+		/* look for "=>" and then '/' */
+		ptr = strstr(str, "=>");
+		if (ptr) {
+			ptr++;
+			q = strchr(ptr, '/');
+			if (!q)
+				return NULL;
+			r = strchr(ptr, '\n');
+			*r = '\0';
+			return q;
+		} else if (ptr == NULL) {
+			return NULL;
+		} else {
+			str = ptr + 1;
+			continue;
+		}
+	}
+
+	return NULL;
+}
+
+/*
+ * Checks if a path is already present in the list.
+ * Returns 'true' if present and 'false' otherwise.
+ */
+static bool is_present_in_list(struct list_head *path_list, char *path)
+{
+	struct path_list *tmp;
+
+	list_for_each_entry(tmp, path_list, list) {
+		if (!strcmp(path, tmp->path))
+			return true;
+	}
+
+	return false;
+}
+
+static inline void append_path(char *path, struct list_head *list)
+{
+	char *res_path = NULL;
+	struct path_list *tmp = NULL;
+
+	res_path = (char *)malloc(sizeof(char) * PATH_MAX);
+
+	if (!res_path)
+		return;
+
+	memset(res_path, '\0', PATH_MAX);
+
+	if (realpath(path, res_path) && !is_present_in_list(list, res_path)) {
+		tmp = (struct path_list *) malloc(sizeof(struct path_list));
+		if (!tmp) {
+			free(res_path);
+			return;
+		}
+		strcpy(tmp->path, res_path);
+		list_add(&(tmp->list), list);
+		if (res_path)
+			free(res_path);
+	}
+}
+
+static void flush_sdt_list(struct list_head *head, FILE *cache)
+{
+	struct path_list *tmp;
+
+	list_for_each_entry(tmp, head, list)
+		filename__find_sdt(tmp->path, cache);
+}
+
+static void cleanup_path_list(struct list_head *head)
+{
+	struct path_list *tmp, *pos;
+
+	list_for_each_entry_safe(tmp, pos, head, list) {
+		list_del(&tmp->list);
+		free(tmp);
+	}
+}
+
+/*
+ * Finds SDT markers in the dsos which are present in a system.
+ * "cache" is the stream which is filled up with all these SDT info.
+ */
+static void find_sdt_in_dsos(FILE *cache)
+{
+	FILE *fp;
+	size_t len = 0;
+	char *line, *path = NULL;
+	struct path_list lib_list;
+
+	INIT_LIST_HEAD(&lib_list.list);
+
+	/*
+	 * Run the command ldconfig to find out the libraries in
+	 * a system from the file ld.so.cache
+	 */
+	fp = popen(LIB_COMM, "r");
+	if (fp == NULL) {
+		printf("Error in running %s\n", LIB_COMM);
+		return;
+	}
+
+	/*
+	 * Take a line from the o/p of ldconfig and
+	 * parse it to find a library path
+	 */
+	while (getline(&line, &len, fp) != -1) {
+		path = parse_lib_name(line);
+		if (path)
+			append_path(path, &lib_list.list);
+	}
+	/* line and fp no more required */
+	free(line);
+	pclose(fp);
+
+	/* Find and write the SDT markers in the perf-sdt cache*/
+	flush_sdt_list(&lib_list.list, cache);
+
+	cleanup_path_list(&lib_list.list);
+	return;
+}
+
+/*
+ * Go through all the files inside "path".
+ * But don't go into sub-directories.
+ */
+static void walk_through_dir(char *path)
+{
+	struct dirent *entry;
+	DIR *dir;
+	struct stat sb;
+	int ret = 0;
+	char *swd;
+
+	dir = opendir(path);
+	if (!dir)
+		return;
+
+	/* save the current working directory */
+	swd = getcwd(NULL, 0);
+	if (!swd) {
+		pr_err("getcwd : error");
+		return;
+	}
+
+	ret = chdir(path);
+	if (ret) {
+		pr_err("chdir : error in %s", path);
+		return;
+	}
+	while ((entry = readdir(dir)) != NULL) {
+
+		ret = stat(entry->d_name, &sb);
+		if (ret == -1) {
+			pr_debug("%s : error in stat!\n", entry->d_name);
+			continue;
+		}
+
+		/* Not pursuing sub-directories */
+		if ((sb.st_mode & S_IFMT) != S_IFDIR)
+			if (sb.st_mode & S_IXUSR)
+				append_path(entry->d_name, &execs.list);
+	}
+
+	closedir(dir);
+
+	/* return to the saved working directory */
+	ret = chdir(swd);
+	if (ret) {
+		pr_err("chdir : error");
+		return;
+	}
+}
+
+/*
+ * parse_list() parses the list obtained from PATH and for each
+ * path, we call walk_through_dir() to traverse through the this
+ * path's subtree and obtain the list of all Elfs.
+ */
+static void parse_list(char *exe_list)
+{
+	struct path_list dir_exe_list, *tmp;
+	char *path = exe_list;
+	char *next_path;
+
+	INIT_LIST_HEAD(&dir_exe_list.list);
+
+	if (!exe_list)
+		return;
+
+	while (path) {
+		/* Parse the string based on ':' */
+		next_path = strchr(path, DELIM);
+		if (next_path) {
+			*next_path = '\0';
+			next_path++;
+		}
+
+		append_path(path, &(dir_exe_list.list));
+		path = next_path;
+	}
+
+	/* Traversing the directory paths */
+	list_for_each_entry(tmp, &dir_exe_list.list, list)
+		walk_through_dir(tmp->path);
+
+	cleanup_path_list(&dir_exe_list.list);
+}
+
+/*
+ * Obtain the list of paths from the PATH env variable
+ */
+static int find_sdt_in_execs(FILE *cache)
+{
+	char *list = NULL;
+	const char *env = "PATH";
+
+	INIT_LIST_HEAD(&execs.list);
+
+	list = getenv(env);
+	if (list)
+		parse_list(list);
+
+	flush_sdt_list(&execs.list, cache);
+	cleanup_path_list(&execs.list);
+
+	return 0;
+}
+
+/*
+ * find_sdt_in_bins() : this function calls diff functions to find
+ * out the SDT markers in different binaries and writes it to a
+ * temporary file.
+ * If everything goes smooth, this temporary file is renamed to the
+ * original cache file name.
+ */
+static int find_sdt_in_bins(void)
+{
+	FILE *cache;
+	struct stat buf;
+	int ret;
+
+	ret = stat(SDT_CACHE_DIR, &buf);
+	if (ret) {
+		ret = mkdir(SDT_CACHE_DIR, buf.st_mode);
+		if (ret) {
+			pr_err("%s : %s\n", SDT_CACHE_DIR, strerror(errno));
+			return -errno;
+		}
+	}
+
+	cache = fopen(SDT_CACHE_DIR SDT_CACHE_TMP, "w");
+	if (!cache) {
+		printf("Error in creating/opening the %s file!\n",
+		       SDT_CACHE_DIR SDT_CACHE_TMP);
+		return -errno;
+	}
+
+	find_sdt_in_dsos(cache);
+	find_sdt_in_execs(cache);
+
+	if (!fclose(cache)) {
+		ret = rename(SDT_CACHE_DIR SDT_CACHE_TMP,
+		SDT_CACHE_DIR SDT_CACHE);
+		if (ret)
+			pr_err("%s : %s\n", SDT_CACHE_TMP, strerror(errno));
+
+	} else {
+		pr_err("%s : %s\n", SDT_CACHE_TMP, strerror(errno));
+		ret = -errno;
+	}
+
+	return ret;
+}
+
+/* Take the entries from the sdt cache and display them */
+void sdt_cache__display(void)
+{
+	struct stat sb;
+	int len;
+	int fd;
+	int ret;
+	char *data, *ptr, *p;
+	char provider[PATH_MAX], marker[PATH_MAX], file_name[PATH_MAX];
+
+	fd = open(SDT_CACHE_DIR SDT_CACHE, O_RDONLY);
+	if (fd == -1) {
+		pr_err("Error in opening %s\n", SDT_CACHE_DIR SDT_CACHE);
+		pr_err("Please run\n perf list sdt --scan\n");
+		return;
+	}
+
+	ret = fstat(fd, &sb);
+	if (ret == -1) {
+		pr_err("Error in fstat\n");
+		return;
+	}
+
+	if (!S_ISREG(sb.st_mode)) {
+		pr_err("%s is not a file\n", SDT_CACHE_DIR SDT_CACHE);
+		return;
+	}
+
+	data = mmap(0, sb.st_size, PROT_READ, MAP_SHARED, fd, 0);
+	if (data == MAP_FAILED) {
+		pr_err("Error in mmap\n");
+		return;
+	}
+
+	ret = madvise(data, sb.st_size, MADV_SEQUENTIAL);
+	if (ret == -1) {
+		pr_debug("Error in madvise\n");
+		return;
+	}
+
+	ret = close(fd);
+	if (ret == -1) {
+		pr_err("Error in close\n");
+		return;
+	}
+
+	ptr = strchr(data, '%');
+	while (ptr) {
+		p = ++ptr;
+		len = copy_delim(p, provider, ':', PATH_MAX);
+		p += len;
+		len = copy_delim(p, marker, ':', PATH_MAX);
+		p += len;
+		len = copy_delim(p, file_name, ':', PATH_MAX);
+		p += len;
+		printf("%%%s : %s \t \t (@%s)\n", provider, marker, file_name);
+		ptr = strchr(ptr, '%');
+	}
+
+	ret = munmap(data, sb.st_size);
+	if (ret == -1) {
+		pr_err("Error in munmap\n");
+		return;
+	}
+
+}
+
+void print_sdt_events(const char *arg)
+{
+	int ret;
+
+	if (arg) {
+		if (!strcmp(arg, "--scan")) {
+			ret = find_sdt_in_bins();
+			if (!ret) {
+				printf("perf sdt cache created!\n Use : ");
+				printf("\"perf list sdt\""
+				       "\n to see the SDT markers\n");
+			} else {
+				pr_err("Error in creating the cache"
+				       " for sdt markers\n");
+			}
+		} else {
+			pr_err("%s: Unknown argument\n", arg);
+			return;
+		}
+	} else {
+		sdt_cache__display();
+	}
+	return;
+}
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 6864661..7173c5b 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1619,6 +1619,235 @@ void kcore_extract__delete(struct kcore_extract *kce)
 	unlink(kce->extract_filename);
 }
 
+static int populate_sdt_note(Elf **elf, const char *data, size_t len, int type,
+			     struct sdt_note **note)
+{
+	const char *provider, *name;
+	struct sdt_note *tmp = NULL;
+	GElf_Ehdr ehdr;
+	GElf_Addr base_off = 0;
+	GElf_Shdr shdr;
+	int ret = -1;
+	int i;
+
+	union {
+		Elf64_Addr a64[3];
+		Elf32_Addr a32[3];
+	} buf;
+
+	Elf_Data dst = {
+		.d_buf = &buf, .d_type = ELF_T_ADDR, .d_version = EV_CURRENT,
+		.d_size = gelf_fsize((*elf), ELF_T_ADDR, 3, EV_CURRENT),
+		.d_off = 0, .d_align = 0
+	};
+	Elf_Data src = {
+		.d_buf = (void *) data, .d_type = ELF_T_ADDR,
+		.d_version = EV_CURRENT, .d_size = dst.d_size, .d_off = 0,
+		.d_align = 0
+	};
+
+	/* Check the type of each of the notes */
+	if (type != SDT_NOTE_TYPE)
+		goto out_err;
+
+	tmp = (struct sdt_note *)calloc(1, sizeof(struct sdt_note));
+	if (!tmp) {
+		ret = -ENOMEM;
+		goto out_err;
+	}
+
+	INIT_LIST_HEAD(&tmp->note_list);
+
+	if (len < dst.d_size + 3)
+		goto out_free_note;
+
+	/* Translation from file representation to memory representation */
+	if (gelf_xlatetom(*elf, &dst, &src,
+			  elf_getident(*elf, NULL)[EI_DATA]) == NULL)
+		printf("gelf_xlatetom : %s\n", elf_errmsg(-1));
+
+	/* Populate the fields of sdt_note */
+	provider = data + dst.d_size;
+
+	name = (const char *)memchr(provider, '\0', data + len - provider);
+	if (name++ == NULL)
+		goto out_free_note;
+
+	tmp->provider = strdup(provider);
+	if (!tmp->provider) {
+		ret = -ENOMEM;
+		goto out_free_note;
+	}
+	tmp->name = strdup(name);
+	if (!tmp->name) {
+		ret = -ENOMEM;
+		goto out_free_prov;
+	}
+
+	/* Obtain the addresses */
+	if (gelf_getclass(*elf) == ELFCLASS32) {
+		for (i = 0; i < 3; i++)
+			tmp->addr.a32[i] = buf.a32[i];
+		tmp->bit32 = true;
+	} else {
+		for (i = 0; i < 3; i++)
+			tmp->addr.a64[i] = buf.a64[i];
+		tmp->bit32 = false;
+	}
+
+	/* Now Adjust the prelink effect */
+	if (!gelf_getehdr(*elf, &ehdr)) {
+		pr_debug("%s : cannot get elf header.\n", __func__);
+		ret = -EBADF;
+		goto out_free_name;
+	}
+
+	/*
+	 * Find out the .stapsdt.base section.
+	 * This scn will help us to handle prelinking (if present).
+	 * Compare the retrieved file offset of the base section with the
+	 * base address in the description of the SDT note. If its different,
+	 * then accordingly, adjust the note location.
+	 */
+	if (elf_section_by_name(*elf, &ehdr, &shdr, SDT_BASE_SCN, NULL)) {
+		base_off = shdr.sh_offset;
+		if (base_off) {
+			if (tmp->bit32)
+				tmp->addr.a32[0] = tmp->addr.a32[0] + base_off -
+					tmp->addr.a32[1];
+			else
+				tmp->addr.a64[0] = tmp->addr.a64[0] + base_off -
+					tmp->addr.a64[1];
+		}
+	}
+
+	*note = tmp;
+	return 0;
+
+out_free_name:
+	free(tmp->name);
+out_free_prov:
+	free(tmp->provider);
+out_free_note:
+	free(tmp);
+out_err:
+	return ret;
+}
+
+static int construct_sdt_notes_list(Elf *elf, struct list_head *sdt_notes)
+{
+	GElf_Ehdr ehdr;
+	Elf_Scn *scn = NULL;
+	Elf_Data *data;
+	GElf_Shdr shdr;
+	size_t shstrndx, next;
+	GElf_Nhdr nhdr;
+	size_t name_off, desc_off, offset;
+	struct sdt_note *tmp = NULL;
+	int ret = 0, val = 0;
+
+	if (gelf_getehdr(elf, &ehdr) == NULL) {
+		ret = -EBADF;
+		goto out_ret;
+	}
+	if (elf_getshdrstrndx(elf, &shstrndx) != 0) {
+		ret = -EBADF;
+		goto out_ret;
+	}
+
+	/* Look for the required section */
+	scn = elf_section_by_name(elf, &ehdr, &shdr, SDT_NOTE_SCN, NULL);
+	if (!scn) {
+		ret = -ENOENT;
+		goto out_ret;
+	}
+
+	if (!(shdr.sh_type == SHT_NOTE) || (shdr.sh_flags & SHF_ALLOC)) {
+		ret = -ENOENT;
+		goto out_ret;
+	}
+
+	data = elf_getdata(scn, NULL);
+
+	/* Get the SDT notes */
+	for (offset = 0; (next = gelf_getnote(data, offset, &nhdr, &name_off,
+					      &desc_off)) > 0; offset = next) {
+		if (nhdr.n_namesz == sizeof(SDT_NOTE_NAME) &&
+		    !memcmp(data->d_buf + name_off, SDT_NOTE_NAME,
+			    sizeof(SDT_NOTE_NAME))) {
+			val = populate_sdt_note(&elf, ((data->d_buf) + desc_off),
+						nhdr.n_descsz, nhdr.n_type,
+						&tmp);
+			if (!val)
+				list_add_tail(&tmp->note_list, sdt_notes);
+			if (val == -ENOMEM) {
+				ret = val;
+				goto out_ret;
+			}
+		}
+	}
+	if (list_empty(sdt_notes))
+		ret = -ENOENT;
+
+out_ret:
+	return ret;
+}
+
+int get_sdt_note_list(struct list_head *head, const char *target)
+{
+	Elf *elf;
+	int fd, ret;
+
+	fd = open(target, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	symbol__elf_init();
+	elf = elf_begin(fd, ELF_C_READ, NULL);
+	if (!elf) {
+		ret = -EBADF;
+		goto out_close;
+	}
+	ret = construct_sdt_notes_list(elf, head);
+	elf_end(elf);
+
+out_close:
+	close(fd);
+	return ret;
+}
+
+/*
+ * Returns 'true' if the file is an elf and 'false' otherwise
+ */
+bool is_an_elf(char *file)
+{
+	int fd;
+	Elf *elf;
+	bool ret = true;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0) {
+		ret = false;
+		goto out_ret;
+	}
+
+	symbol__elf_init();
+	elf = elf_begin(fd, ELF_C_READ, NULL);
+	if (!elf) {
+		ret = false;
+		goto out_close;
+	}
+	if (elf_kind(elf) != ELF_K_ELF)
+		ret = false;
+
+	elf_end(elf);
+
+out_close:
+	close(fd);
+out_ret:
+	return ret;
+}
+
 void symbol__elf_init(void)
 {
 	elf_version(EV_CURRENT);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 615c752..83be31a 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -294,4 +294,23 @@ int compare_proc_modules(const char *from, const char *to);
 int setup_list(struct strlist **list, const char *list_str,
 	       const char *list_name);
 
+struct sdt_note {
+	char *name;
+	char *provider;
+	bool bit32;
+	union {
+		Elf64_Addr a64[3];
+		Elf32_Addr a32[3];
+	} addr;
+	struct list_head note_list;
+};
+
+int get_sdt_note_list(struct list_head *head, const char *target);
+bool is_an_elf(char *file);
+
+#define SDT_BASE_SCN ".stapsdt.base"
+#define SDT_NOTE_SCN  ".note.stapsdt"
+#define SDT_NOTE_TYPE 3
+#define SDT_NOTE_NAME "stapsdt"
+
 #endif /* __PERF_SYMBOL */

