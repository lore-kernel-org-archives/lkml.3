Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761445AbaGRKUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:20:19 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:49193 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912AbaGRKUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:20:15 -0400
Subject: [PATCH v2 2/3] perf/sdt: Listing SDT markers for a single file
To: linux-kernel@vger.kernel.org
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Date: Thu, 17 Jul 2014 11:26:04 +0530
Message-ID: <20140717055517.19995.57453.stgit@hemant-fedora>
In-Reply-To: <20140717054826.19995.61782.stgit@hemant-fedora>
References: <20140717054826.19995.61782.stgit@hemant-fedora>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071810-8878-0000-0000-00000010E57D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables perf to look for SDT markers in a single file.
The previous patch looks for SDT markers in a set of default paths and records
them in a SDT cache. However, not all the SDT markers are present in the
SDT cache file.
An individual file argument can be given to "perf list" to find out the SDT markers
present in that file. Usage is as below :

# perf list sdt /home/hemant/tmp

/home/hemant/tmp:
%user : foo
%user : bar

On using this command, the entries for this file name is searched in the cache, and
the build-ids are comapred. If build-ids don't match, the entries in the cache related
to this file name are modified. The previous entries will be deleted and new entries
will be added. If previously, there were no entries for a particular filename, then
entries for that file will be added and accordingly modified.

Signed-off-by : hemant@linux.vnet.ibm.com
---
 tools/perf/util/sdt.c |  317 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 296 insertions(+), 21 deletions(-)

diff --git a/tools/perf/util/sdt.c b/tools/perf/util/sdt.c
index f5bfdbd..57ec767 100644
--- a/tools/perf/util/sdt.c
+++ b/tools/perf/util/sdt.c
@@ -29,6 +29,11 @@ struct path_list {
 	struct list_head list;
 } execs;
 
+struct update_buf {
+	char data[2 * PATH_MAX];
+	struct list_head list;
+};
+
 /* Write operation for cache */
 static void write_cache(FILE *cache, char *buffer)
 {
@@ -48,6 +53,239 @@ static int copy_delim(char *src, char *target, char delim, size_t size)
 }
 
 /*
+ * Takes input the beginning of a line of the cache and returns the filename,
+ * build id and the length of that line
+ */
+static int find_file_build(char *p, char *file_name, char *bid, char *end)
+{
+	int i, len;
+	char *eol, *sol = p;
+
+	/* Skip two ':' to get to the file name */
+	for (i = 0; i < 2; i++) {
+		p = strchr(p, ':');
+		p++;
+	}
+
+	len = copy_delim(p, file_name, ':', PATH_MAX);
+	p += len;
+
+	/* Just after the file name, lies the build id */
+	if (len)
+		len = copy_delim(p, bid, ':', BUILD_ID_SIZE * 2 + 1);
+
+	eol = strchr(p, '%');
+	if (!eol)
+		eol = end;
+	return eol - sol;
+}
+
+/* Prepares a list of buffers to be written into the sdt cache */
+static int prepare_buffer(const char *target, struct list_head *start,
+			  char *build_id, struct list_head *update_list)
+{
+	struct update_buf *buf;
+	struct sdt_note *tmp;
+	int count, len = 0;
+
+	list_for_each_entry(tmp, start, note_list) {
+		buf = (struct update_buf *)malloc(sizeof(struct update_buf));
+		if (!buf) {
+			pr_debug("prepare_buf: Error in calloc\n");
+			return 0;
+		}
+		INIT_LIST_HEAD(&buf->list);
+		memset(buf->data, '\0', 2 * PATH_MAX);
+
+		count = sprintf(buf->data, "%%%s:%s:%s:%s:0x%lx:0x%lx",
+				tmp->provider, tmp->name, target, build_id,
+				tmp->bit32 ? tmp->addr.a32[0] :
+				tmp->addr.a64[0],
+				tmp->bit32 ? tmp->addr.a32[2] :
+				tmp->addr.a64[2]);
+		list_add(&buf->list, update_list);
+
+		len += count;
+	}
+
+	return len;
+}
+
+static void cleanup_buffer_list(struct list_head *head)
+{
+	struct update_buf *tmp, *pos;
+
+	list_for_each_entry_safe(tmp, pos, head, list) {
+		list_del(&tmp->list);
+		free(tmp);
+	}
+}
+
+/*
+ * Update the sdt cache with the new info.
+ * First part of this function searches for the entry needed to be modified.
+ * Second part focusses on modifying the lines.
+ */
+static void sdt_cache__update(struct list_head *start, const char *file)
+{
+	char *data, *ptr;
+	struct stat sb;
+	int fd, ret, i = 0, update_count = 0, count = 0;
+	char file_name[PATH_MAX], *p;
+	u8 build_id[BUILD_ID_SIZE];
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1], bid[BUILD_ID_SIZE * 2 + 1];
+	int len = 0, offset = 0, final_size = 0, diff;
+	char *beg = NULL, target[PATH_MAX];
+	bool  update = false;
+	struct update_buf upd, *pos;
+
+	INIT_LIST_HEAD(&upd.list);
+
+	/* Resolve the target to canonical path first */
+	memset(target, '\0', PATH_MAX);
+	if (!realpath(file, target)) {
+		pr_debug("sdt_cache__update : realpath() failed\n");
+		return;
+	}
+
+	/* Read the build id of the file */
+	if (filename__read_build_id(target, &build_id,
+				    sizeof(build_id)) < 0) {
+		pr_err("Couldn't read build-id in %s\n", target);
+		return;
+	}
+	/* Convert the build id into a string */
+	build_id__sprintf(build_id, sizeof(build_id), sbuild_id);
+
+	fd = open(SDT_CACHE_DIR SDT_CACHE, O_RDWR);
+	if (fd == -1) {
+		pr_err("Error in opening %s\n", SDT_CACHE_DIR SDT_CACHE);
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
+	data = mmap(0, sb.st_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	if (data == MAP_FAILED) {
+		pr_err("Error in mmap\n");
+		return;
+	}
+
+	ptr = strchr(data, '%');
+	while (ptr) {
+		p = ptr;
+		memset(file_name, '\0', PATH_MAX);
+		/* offset contains the length of one '%' to next '%' */
+		offset = find_file_build(p, file_name, bid, data + sb.st_size);
+
+		if (!strcmp(target, file_name)) {
+			if (!strcmp(bid, sbuild_id)) {
+				/* No need to go further if the build ids match*/
+				break;
+			} else {
+				/*
+				 * Build ids don't match!
+				 * Add the length of this line to 'len'
+				 */
+				if (!count) {
+					beg = ptr;
+					update = true;
+					len += offset;
+					count++;
+				} else {
+					len += offset;
+					count++;
+				}
+			}
+		} else if (update) {
+			break;
+		}
+
+		ptr++;
+		ptr = strchr(ptr, '%');
+	}
+
+	final_size = sb.st_size;
+
+	/* For a file which isn't present in the cache already */
+	if (!update && !ptr) {
+		beg = data + sb.st_size;
+		update = true;
+	}
+	if (update) {
+		/*
+		 * 'len' keeps the account of total characters neeeded to be
+		 * removed. This shifts all the characters starting from 'beg'.
+		 */
+		i = 0;
+		while (beg[len + i]) {
+			beg[i] = beg[len + i];
+			i++;
+		}
+		/* Clear out the end extraneous bytes */
+		for (i = 0; i <= len; i++)
+			data[sb.st_size - i] = '\0';
+
+		/* Build the string to be updated */
+		if (start)
+			update_count = prepare_buffer(target, start, sbuild_id,
+						      &upd.list);
+		diff = len;
+		/* Calculate the new size of the file */
+		final_size = sb.st_size - diff + update_count;
+
+		/* Reduce/Increase the size of the file */
+		ret = truncate(SDT_CACHE_DIR SDT_CACHE, final_size);
+		if (ret == -1) {
+			pr_debug("Error in truncate\n");
+			return;
+		}
+		/* remap the cache due to the change in size */
+		data = mremap(data, sb.st_size, final_size, MREMAP_MAYMOVE);
+		if (data == MAP_FAILED) {
+			pr_debug("Error in mremap\n");
+			return;
+		}
+
+		len = 0;
+
+		if (start)
+			/* Now update that update_buf into cache */
+			list_for_each_entry(pos, &upd.list, list) {
+				strcpy(data + sb.st_size - diff + len,
+				       pos->data);
+				len += strlen(pos->data);
+			}
+
+		if (!start && (data[final_size - 1] == '%'))
+			ret = truncate(SDT_CACHE_DIR SDT_CACHE, final_size - 1);
+		/* Cleanup the buffer */
+		cleanup_buffer_list(&upd.list);
+	}
+	ret = munmap(data, final_size);
+	if (ret == -1) {
+		pr_err("Error in munmap this\n");
+		return;
+	}
+	ret = close(fd);
+	if (ret == -1) {
+		pr_err("Error in close\n");
+		return;
+	}
+
+	return;
+}
+
+/*
  * get_sdt_note_info() is the function actually responsible for
  * flushing the SDT notes info into the "cache" file or to the
  * stdout if "cache" points to NULL. Also, this function finds out
@@ -64,29 +302,38 @@ static void get_sdt_note_info(struct list_head *start, const char *target,
 	if (list_empty(start))
 		return;
 
-	/* Read the build id of the file */
-	if (filename__read_build_id(target, &build_id,
-				    sizeof(build_id)) < 0) {
-		pr_debug("Couldn't read build-id in %s\n", target);
-		return;
+	if (cache) {
+		/* Read the build id of the file */
+		if (filename__read_build_id(target, &build_id,
+					    sizeof(build_id)) < 0) {
+			pr_debug("Couldn't read build-id in %s\n", target);
+			return;
+		}
+		/* Convert the build id into a string */
+		build_id__sprintf(build_id, sizeof(build_id), sbuild_id);
+	} else {
+		printf("%s :\n", target);
 	}
-	/* Convert the build id into a string */
-	build_id__sprintf(build_id, sizeof(build_id), sbuild_id);
-
 	list_for_each_entry(pos, start, note_list) {
-		sprintf(buffer, "%%%s:%s:%s:%s:0x%lx:0x%lx",
-			pos->provider, pos->name, target, sbuild_id,
-			pos->bit32 ? pos->addr.a32[0] :
-			pos->addr.a64[0],
-			pos->bit32 ? pos->addr.a32[2] :
-			pos->addr.a64[2]);
-
-		/*
-		 * Format of any line of this sdt-cache :
-		 * %provider:marker:filename:build-id:location:semaphore
-		 */
-		write_cache(cache, buffer);
+		if (cache) {
+			sprintf(buffer, "%%%s:%s:%s:%s:0x%lx:0x%lx",
+				pos->provider, pos->name, target, sbuild_id,
+				pos->bit32 ? pos->addr.a32[0] :
+				pos->addr.a64[0],
+				pos->bit32 ? pos->addr.a32[2] :
+				pos->addr.a64[2]);
+
+			/*
+			 * Format of any line of this sdt-cache :
+			 * %provider:marker:filename:build-id:location:semaphore
+			 */
+			write_cache(cache, buffer);
+		} else {
+			printf("%%%s : %s\n", pos->provider, pos->name);
+		}
 	}
+	if (!cache)
+		sdt_cache__update(start, target);
 }
 
 /* Free the sdt note list */
@@ -106,6 +353,30 @@ static void cleanup_sdt_note_list(struct list_head *sdt_notes)
 }
 
 /*
+ * Error displayed in case of query of a
+ * single file for SDT markers
+ */
+static int sdt_err(int val, const char *target)
+{
+	switch (-val) {
+	case 0:
+		break;
+	case ENOENT:
+		/* Absence of SDT markers */
+		printf("%s : No SDT markers found\n", target);
+		break;
+	case EBADF:
+		printf("%s : Bad file name\n", target);
+		break;
+	default:
+		printf("%s\n", strerror(val));
+	}
+
+	return val;
+}
+
+
+/*
  * filename__find_sdt() looks for sdt markers and the list is stored
  * in sdt_notes. The fd passed here is the file in which the info
  * about the SDT markers is filled up.
@@ -119,6 +390,10 @@ static int filename__find_sdt(const char *target, FILE *cache)
 	ret = get_sdt_note_list(&sdt_notes, target);
 	if (!ret)
 		get_sdt_note_info(&sdt_notes, target, cache);
+	else if (!cache)     /* using cache as flag */
+		sdt_err(ret, target);
+	if (ret == -ENOENT && !cache)
+		sdt_cache__update(NULL, target);
 
 	cleanup_sdt_note_list(&sdt_notes);
 	return ret;
@@ -493,7 +768,7 @@ void print_sdt_events(const char *arg)
 				       " for sdt markers\n");
 			}
 		} else {
-			pr_err("%s: Unknown argument\n", arg);
+			filename__find_sdt(arg, NULL);
 			return;
 		}
 	} else {

