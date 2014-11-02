Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaKBMmd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 07:42:33 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:44032 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaKBMmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 07:42:31 -0500
Subject: [PATCH v4 2/5] perf/sdt: Add SDT events into a cache
To: linux-kernel@vger.kernel.org
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Date: Sun, 02 Nov 2014 16:24:33 +0530
Message-ID: <20141102105420.21708.66385.stgit@hemant-fedora>
In-Reply-To: <20141102105006.21708.28734.stgit@hemant-fedora>
References: <20141102105006.21708.28734.stgit@hemant-fedora>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110212-0033-0000-0000-0000006C01F6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new sub-command to perf : sdt-cache.
sdt-cache command can be used to add SDT events.
When user invokes "perf sdt-cache add <file-name>", a hash table/list is
created named as file_hash list. A typical entry in a file_hash table looks
like:

                file hash      file_sdt_ent     file_sdt_ent
                |---------|   ---------------   -------------
                | hlist ==|===|=>file_list =|===|=>file_list=|==..
    key = 644 =>|         |   | sbuild_id   |   | sbuild_id  |
                |---------|   | name        |   | name       |
                |         |   | sdt_list    |   | sdt_list   |
    key = 645 =>| hlist   |   |   ||        |   |    ||      |
                |---------|   ---------------   --------------
                    ||            ||                 || Connected to SDT notes
                          ---------------
                          |  note_list  |
                          |  name       |sdt_note
                          |  provider   |
                          -----||--------
                  connected to other SDT notes

Each entry of the file_hash table is an hlist which connects to file_list
in file_sdt_ent. file_sdt_ent is allocated per file whenever a file is
mapped to file_hash list. File name serves as the key to this hash table.
If a file is added to this hash list, a file_sdt_ent is allocated and a
list of SDT events in that file is created and assigned to sdt_list of
file_sdt_ent.

Example usage :
# ./perf sdt-cache --add /home/user_app

    4 events added for /home/user_app

# ./perf sdt-cache --add /lib64/libc.so.6

    8 events added for /usr/lib64/libc-2.16.so

Signed-off-by: Hemant Kumar <hemant@linux.vnet.ibm.com>
---
 tools/perf/Documentation/perf-sdt-cache.txt |   27 +
 tools/perf/Makefile.perf                    |    4 
 tools/perf/builtin-sdt-cache.c              |   59 +++
 tools/perf/builtin.h                        |    1 
 tools/perf/command-list.txt                 |    1 
 tools/perf/perf.c                           |    1 
 tools/perf/util/parse-events.h              |    2 
 tools/perf/util/sdt.c                       |  615 +++++++++++++++++++++++++++
 8 files changed, 710 insertions(+)
 create mode 100644 tools/perf/Documentation/perf-sdt-cache.txt
 create mode 100644 tools/perf/builtin-sdt-cache.c
 create mode 100644 tools/perf/util/sdt.c

diff --git a/tools/perf/Documentation/perf-sdt-cache.txt b/tools/perf/Documentation/perf-sdt-cache.txt
new file mode 100644
index 0000000..08b9985
--- /dev/null
+++ b/tools/perf/Documentation/perf-sdt-cache.txt
@@ -0,0 +1,27 @@
+perf-sdt-cache(1)
+=====================
+
+NAME
+----
+perf-sdt-cache - Manage SDT events' cache.
+
+SYNOPSIS
+--------
+[verse]
+'perf sdt-cache --add <file_name>'
+
+DESCRIPTION
+-----------
+This command manages the SDT events cache. It can add/remove SDT events
+associated with an ELF to the cache.
+
+OPTIONS
+-------
+-a::
+--add::
+        Add SDT events in the specified file to the cache. Takes file name
+	as an argument.
+
+SEE ALSO
+--------
+linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 3caf7da..4f5c696 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -353,6 +353,7 @@ LIB_OBJS += $(OUTPUT)util/sigchain.o
 LIB_OBJS += $(OUTPUT)util/dso.o
 LIB_OBJS += $(OUTPUT)util/symbol.o
 LIB_OBJS += $(OUTPUT)util/symbol-elf.o
+LIB_OBJS += $(OUTPUT)util/sdt.o
 LIB_OBJS += $(OUTPUT)util/color.o
 LIB_OBJS += $(OUTPUT)util/pager.o
 LIB_OBJS += $(OUTPUT)util/header.o
@@ -472,6 +473,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-timechart.o
 BUILTIN_OBJS += $(OUTPUT)builtin-top.o
 BUILTIN_OBJS += $(OUTPUT)builtin-script.o
 BUILTIN_OBJS += $(OUTPUT)builtin-probe.o
+BUILTIN_OBJS += $(OUTPUT)builtin-sdt-cache.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kmem.o
 BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
@@ -499,8 +501,10 @@ LIB_OBJS := $(filter-out $(OUTPUT)util/symbol-elf.o,$(LIB_OBJS))
 LIB_OBJS := $(filter-out $(OUTPUT)util/dwarf-aux.o,$(LIB_OBJS))
 LIB_OBJS := $(filter-out $(OUTPUT)util/probe-event.o,$(LIB_OBJS))
 LIB_OBJS := $(filter-out $(OUTPUT)util/probe-finder.o,$(LIB_OBJS))
+LIB_OBJS := $(filter-out $(OUTPUT)util/sdt.o,$(LIB_OBJS))
 
 BUILTIN_OBJS := $(filter-out $(OUTPUT)builtin-probe.o,$(BUILTIN_OBJS))
+BUILTIN_OBJS := $(filter-out $(OUTPUT)builtin-sdt-cache.o,$(BUILTIN_OBJS))
 
 # Use minimal symbol handling
 LIB_OBJS += $(OUTPUT)util/symbol-minimal.o
diff --git a/tools/perf/builtin-sdt-cache.c b/tools/perf/builtin-sdt-cache.c
new file mode 100644
index 0000000..0e012f6
--- /dev/null
+++ b/tools/perf/builtin-sdt-cache.c
@@ -0,0 +1,59 @@
+/*
+ * builtin-sdt-cache.c
+ *
+ * Builtin sdt command: Add/remove/show SDT events
+ */
+#include "builtin.h"
+
+#include "perf.h"
+
+#include "util/parse-events.h"
+#include "util/cache.h"
+#include "util/parse-options.h"
+#include "symbol.h"
+#include "debug.h"
+
+/* Session management structure */
+static struct {
+	bool add;
+	const char *target;
+} params;
+
+static int opt_add_sdt_events(const struct option *opt __maybe_unused,
+			      const char *str, int unset __maybe_unused)
+{
+	params.add = true;
+	params.target = str;
+
+	return 0;
+}
+
+int cmd_sdt_cache(int argc, const char **argv, const char *prefix __maybe_unused)
+{
+	int ret;
+	const struct option sdt_cache_options[] = {
+		OPT_CALLBACK('a', "add", NULL, "filename",
+			     "add SDT events from a file.",
+			     opt_add_sdt_events),
+		OPT_END()
+	};
+	const char * const sdt_cache_usage[] = {
+		"perf sdt-cache --add filename",
+		NULL
+	};
+
+	argc = parse_options(argc, argv, sdt_cache_options,
+			     sdt_cache_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+
+	setup_pager();
+
+	symbol__elf_init();
+	if (params.add) {
+		ret = add_sdt_events(params.target);
+		if (ret < 0)
+			pr_err("Cannot add SDT events to cache\n");
+	} else
+		usage_with_options(sdt_cache_usage, sdt_cache_options);
+	return 0;
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index b210d62..2746358 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -37,6 +37,7 @@ extern int cmd_test(int argc, const char **argv, const char *prefix);
 extern int cmd_trace(int argc, const char **argv, const char *prefix);
 extern int cmd_inject(int argc, const char **argv, const char *prefix);
 extern int cmd_mem(int argc, const char **argv, const char *prefix);
+extern int cmd_sdt_cache(int argc, const char **argv, const char *prefix);
 
 extern int find_scripts(char **scripts_array, char **scripts_path_array);
 #endif
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 0906fc4..e36047f 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -25,3 +25,4 @@ perf-test			mainporcelain common
 perf-timechart			mainporcelain common
 perf-top			mainporcelain common
 perf-trace			mainporcelain common
+perf-sdt-cache			mainporcelain full
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 452a847..8db763d 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -52,6 +52,7 @@ static struct cmd_struct commands[] = {
 	{ "sched",	cmd_sched,	0 },
 #ifdef HAVE_LIBELF_SUPPORT
 	{ "probe",	cmd_probe,	0 },
+	{ "sdt-cache",  cmd_sdt_cache,  0 },
 #endif
 	{ "kmem",	cmd_kmem,	0 },
 	{ "lock",	cmd_lock,	0 },
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index db2cf78..8bde8ea 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -123,4 +123,6 @@ extern int is_valid_tracepoint(const char *event_string);
 
 extern int valid_debugfs_mount(const char *debugfs);
 
+int add_sdt_events(const char *file);
+
 #endif /* __PERF_PARSE_EVENTS_H */
diff --git a/tools/perf/util/sdt.c b/tools/perf/util/sdt.c
new file mode 100644
index 0000000..3b84355
--- /dev/null
+++ b/tools/perf/util/sdt.c
@@ -0,0 +1,615 @@
+/*
+ * util/sdt.c
+ * This contains the relevant functions needed to find the SDT events
+ * in a binary and adding them to a cache.
+ *
+ * TODOS:
+ * - Listing SDT events in most of the binaries present in the system.
+ * - Looking into directories provided by the user for binaries with SDTs,
+ * etc.
+ * - Support SDT event arguments.
+ * - Support SDT event semaphores.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/stat.h>
+
+#include "parse-events.h"
+#include "probe-event.h"
+#include "linux/list.h"
+#include "symbol.h"
+#include "build-id.h"
+#include "debug.h"
+
+#include "build-id.h"
+
+#include <linux/bitops.h>
+#include <linux/hash.h>
+
+#define SDT_HASH_BITS 11
+#define SDT_HASH_SIZE (1 << SDT_HASH_BITS)
+#define HASH_PRIME_BASE 37
+#define SDT_CACHE_DIR ".debug"
+#define SDT_FILE_CACHE ".sdt-cache"
+
+#define DELIM ':'
+#define MAX_ADDR 17
+
+struct file_sdt_ent {
+	char name[PATH_MAX];			/* file name */
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1];	/* Build id of the file */
+	struct hlist_node file_list;
+	struct list_head sdt_list;		/* SDT notes in this file */
+};
+
+struct hash_table {
+	struct hlist_head ent[SDT_HASH_SIZE];
+};
+
+struct file_info {
+	char *name;                             /* File name */
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1];  /* Build id of the file */
+};
+
+/**
+ * get_hash_key: calculates the key to hash tables
+ * @str: input string
+ *
+ * A simple basic function to calculate hash keys.
+ * adds the ascii values for all the chars in @str, multiplies with a prime
+ * and finds the modulo with SDT_HASH_SIZE.
+ *
+ * Return : An integer key
+ */
+static unsigned get_hash_key(const char *str)
+{
+	unsigned value = 0, key;
+	unsigned c;
+
+	for (c = 0; str[c] != '\0'; c++)
+		value += str[c];
+
+	key = (value * HASH_PRIME_BASE) % SDT_HASH_SIZE;
+
+	return key;
+}
+
+/**
+ * sdt_err: print SDT related error
+ * @val: error code
+ * @target: input file
+ *
+ * Display error corresponding to @val for file @target
+ */
+static int sdt_err(int val, const char *target)
+{
+	char buf[PATH_MAX];
+
+	switch (-val) {
+	case 0:
+		break;
+	case ENOENT:
+		/* Absence of SDT markers */
+		pr_err("%s: No SDT events found\n", target);
+		break;
+	case EBADF:
+		pr_err("%s: Bad file name\n", target);
+		break;
+	default:
+		pr_err("%s\n", strerror_r(val, buf, sizeof(buf)));
+	}
+
+	return val;
+}
+
+/**
+ * file_list_entry__init: Initialize a file_list_entry
+ * @fse: file_list_entry
+ * @file: file information
+ *
+ * Initializes @fse with the build id from @file.
+ */
+static void file_list_entry__init(struct file_sdt_ent *fse,
+				 struct file_info *file)
+{
+	strcpy(fse->sbuild_id, file->sbuild_id);
+	INIT_HLIST_NODE(&fse->file_list);
+	INIT_LIST_HEAD(&fse->sdt_list);
+}
+
+/**
+ * file_hash_list__add: add an entry to file_hash_list
+ * @file_hash: hash table for file and sdt notes
+ * @sdt_notes: list of sdt_notes
+ * @file: struct having file name and build id
+ *
+ * Get the key corresponding to @file->name. Fetch the entry
+ * for that key. Build a file_list_entry fse, assign the SDT notes
+ * to it and then assign fse to the fetched entry into the hash.
+ */
+static int file_hash_list__add(struct hash_table *file_hash,
+			       struct list_head *sdt_notes,
+			       struct file_info *file)
+{
+	struct file_sdt_ent *fse;
+	struct hlist_head *head;
+	int nr_evs, key;
+
+	key = get_hash_key(file->name);
+	head = &file_hash->ent[key];
+
+	/* Initialize the file entry */
+	fse = malloc(sizeof(*fse));
+	if (!fse)
+		return -ENOMEM;
+	file_list_entry__init(fse, file);
+	nr_evs = sdt_notes__get_count(sdt_notes);
+	/* Add the sdt_notes list */
+	list_splice(sdt_notes, &fse->sdt_list);
+
+	strcpy(fse->name, file->name);
+	/* Add the file to the file hash entry */
+	hlist_add_head(&fse->file_list, head);
+
+	return nr_evs;
+}
+
+/**
+ * file_hash_list__remove: Remove a file entry from the file_hash table
+ * @file_hash: file_hash_table
+ * @target: file name
+ *
+ * Removes the entries from file_hash table corresponding to @target.
+ * Gets the key from @target. Also frees up the SDT events for that
+ * file.
+ */
+static int file_hash_list__remove(struct hash_table *file_hash,
+				   const char *target)
+{
+	struct file_sdt_ent *fse;
+	struct hlist_head *ent_head;
+	struct hlist_node *tmp1;
+	char *res_path;
+	int key, nr_del = 0;
+
+	res_path = realpath(target, NULL);
+	if (!res_path)
+		return -ENOMEM;
+
+	key = get_hash_key(target);
+	ent_head = &file_hash->ent[key];
+
+	/* Got the file hash entry */
+	hlist_for_each_entry_safe(fse, tmp1, ent_head, file_list) {
+		if (strcmp(res_path, fse->name))
+			continue;
+
+		/* Got the file list entry, now start removing */
+		nr_del = cleanup_sdt_note_list(&fse->sdt_list);
+		hlist_del(&fse->file_list);
+		free(fse);
+	}
+	free(res_path);
+	return nr_del;
+}
+
+/**
+ * file_hash_list__entry_exists: Checks if a file is already present
+ * @file_hash: file_hash table
+ * @file: file name and build id to check
+ *
+ * Obtains the key from @file->name, fetches the ent[key] from file_hash,
+ * and goes through the chain to find out the correct file list entry.
+ * Compares the build id, if they match, return true, else, false.
+ */
+static bool file_hash_list__entry_exists(struct hash_table *file_hash,
+					  struct file_info *file)
+{
+	struct file_sdt_ent *fse;
+	struct hlist_head *head;
+	int key;
+
+	key = get_hash_key(file->name);
+	head = &file_hash->ent[key];
+	hlist_for_each_entry(fse, head, file_list) {
+		if (!strcmp(file->name, fse->name))
+			if (!strcmp(file->sbuild_id, fse->sbuild_id))
+				return true;
+	}
+	return false;
+}
+
+/**
+ * sdt_note__read: Parse SDT note info
+ * @data: string containing the SDT note's info
+ * @sdt_list: empty list
+ *
+ * Parse @data to find out SDT note name, provider, location and semaphore.
+ * All these data are separated by DELIM:
+ * provider:marker_name:loc1:loc2
+ */
+static struct sdt_note *sdt_note__read(char *data)
+{
+	struct sdt_note *sn = NULL;
+	int value = 0;
+	char *loc = NULL, *sem = NULL;
+
+	sn = malloc(sizeof(*sn));
+	if (!sn) {
+		pr_err("Out of memory\n");
+		goto out_err;
+	}
+	sn->provider = NULL;
+	sn->name = NULL;
+	INIT_LIST_HEAD(&sn->note_list);
+
+	value = sscanf(data, "%m[^':']:%m[^':']:%m[^':']:%ms\n", &sn->provider,
+		     &sn->name, &loc, &sem);
+	if (value != 4)
+		goto out_free_note;
+	value = sscanf(loc, "%lx", &sn->addr.a64[0]);
+	if (value != 1)
+		goto out_free_note;
+	value = sscanf(sem, "%lx", &sn->addr.a64[2]);
+	if (value != 1)
+		goto out_free_note;
+	goto out;
+
+out_free_note:
+	free(sn->provider);
+	free(sn->name);
+	free(sn);
+	sn = NULL;
+out:
+	free(loc);
+	free(sem);
+out_err:
+	return sn;
+}
+
+/**
+ * file_hash_list__populate: Fill up the file hash table
+ * @file_hash: empty file hash table
+ * @cache: FILE * to read from
+ *
+ * Parse @cache for file_name and its SDT events.
+ * The format of the cache is :
+ *
+ * file_name:build_id\n
+ * %provider:marker:location:semaphore\n
+ * %provider:marker:location:semaphore\n
+ * file_name:build_id\n
+ * ...
+ *
+ * Parse according to the above format. Find out the file_name and build_id
+ * first and then use sdt_note__read() to parse the SDT note info.
+ * Find out the hash key from the file_name and use that to add this new
+ * entry to file hash.
+ */
+static int file_hash_list__populate(struct hash_table *file_hash, FILE *cache)
+{
+	struct file_sdt_ent *fse = NULL;
+	struct sdt_note *sn;
+	int key, val, ret = -EBADF;
+	char *ptr, *tmp, *data = NULL;
+	size_t len = 2 * PATH_MAX;
+
+	data = zalloc(sizeof(char) * len);
+	if (!data) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	for (val = getline(&data, &len, cache); val != -1;
+	     val = getline(&data, &len, cache)) {
+		if (!data)
+			goto out;
+		if (*data == '%') {
+			/*
+			 * Its an SDT event entry :
+			 * %provider:marker:addr1:addr2\n
+			 */
+			if (!fse)
+				goto out;
+			sn = sdt_note__read(data + 1);
+			if (sn == NULL) {
+				ret = -EBADF;
+				goto out;
+			}
+			list_add(&sn->note_list, &fse->sdt_list);
+		} else {
+			/*
+			 * Its a file entry:
+			 * file_name:build_id\n
+			 */
+			fse = malloc(sizeof(*fse));
+			if (!fse) {
+				ret = -ENOMEM;
+				break;
+			}
+			INIT_LIST_HEAD(&fse->sdt_list);
+			INIT_HLIST_NODE(&fse->file_list);
+			/* File name */
+			ptr = strtok_r(data, ":", &tmp);
+			if (!ptr)
+				break;
+			strcpy(fse->name, ptr);
+			/* build id */
+			ptr = strtok_r(NULL, "\n", &tmp);
+			if (!ptr)
+				break;
+			strcpy(fse->sbuild_id, ptr);
+			key = get_hash_key(fse->name);
+			hlist_add_head(&fse->file_list, &file_hash->ent[key]);
+			ret = 0;
+		}
+	}
+
+out:
+	free(data);
+	return ret;
+}
+
+/**
+ * file_hash_list__init: Initializes the file hash list
+ * @file_hash: empty file_hash
+ *
+ * Initializes the entries(ent's) of file_hash and opens the cache file.
+ * To look for the cache file, look into the directory in HOME env variable.
+ */
+static int file_hash_list__init(struct hash_table *file_hash)
+{
+	FILE *cache;
+	int i, ret = 0;
+	char sdt_cache_path[PATH_MAX], *val;
+	struct stat fs;
+
+	for (i = 0; i < SDT_HASH_SIZE; i++)
+		INIT_HLIST_HEAD(&file_hash->ent[i]);
+
+	val = getenv("HOME");
+	if (val)
+		scnprintf(sdt_cache_path, sizeof(sdt_cache_path), "%s/%s/%s",
+			 val, SDT_CACHE_DIR, SDT_FILE_CACHE);
+	else {
+		pr_err("Error: Couldn't get user's home directory\n");
+		ret = -1;
+		goto out;
+	}
+
+	cache = fopen(sdt_cache_path, "r");
+	if (cache == NULL)
+		goto out;
+
+	/* To see if the cache contains anything */
+	ret = stat(sdt_cache_path, &fs);
+	if (ret)
+		goto out;
+	/* Populate the hash list */
+	if (fs.st_size > 0)
+		ret = file_hash_list__populate(file_hash, cache);
+	fclose(cache);
+out:
+	return ret;
+}
+
+/**
+ * file_hash_list__cleanup: Frees up all the space taken by file_hash list
+ * @file_hash: file_hash table
+ */
+static void file_hash_list__cleanup(struct hash_table *file_hash)
+{
+	struct file_sdt_ent *file_pos;
+	struct hlist_head *ent_head;
+	struct hlist_node *tmp;
+	int i;
+
+	/* Go through all the entries */
+	for (i = 0; i < SDT_HASH_SIZE; i++) {
+		ent_head = &file_hash->ent[i];
+
+		hlist_for_each_entry_safe(file_pos, tmp, ent_head, file_list) {
+			/* Cleanup the corresponding SDT notes' list */
+			cleanup_sdt_note_list(&file_pos->sdt_list);
+			hlist_del(&file_pos->file_list);
+			free(file_pos);
+		}
+	}
+}
+
+
+/**
+ * add_to_hash_list: add an entry to file_hash_list
+ * @file_hash: file hash table
+ * @target: file name
+ *
+ * Finds out the build_id of @target, checks if @target is already present
+ * in file hash list. If not present, delete any stale entries with this
+ * file name (i.e., entries matching this file name but having older
+ * build ids). And then, adds the file entry to file hash list and also
+ * updates the SDT events in the event hash list.
+ */
+static int add_to_hash_list(struct hash_table *file_hash, const char *target)
+{
+	struct file_info *file;
+	int ret = -EBADF;
+	u8 build_id[BUILD_ID_SIZE];
+
+	LIST_HEAD(sdt_notes);
+
+	file = malloc(sizeof(*file));
+	if (!file)
+		return -ENOMEM;
+
+	file->name = realpath(target, NULL);
+	if (!file->name) {
+		pr_err("%s: Bad file name\n", target);
+		goto out;
+	}
+
+	if (filename__read_build_id(file->name, &build_id,
+				    sizeof(build_id)) < 0) {
+		pr_err("Couldn't read build-id in %s\n", file->name);
+		sdt_err(ret, file->name);
+		goto out;
+	}
+	build_id__sprintf(build_id, sizeof(build_id), file->sbuild_id);
+
+	/* File entry already exists ?*/
+	if (file_hash_list__entry_exists(file_hash, file)) {
+		pr_err("Error: SDT events for %s already exist\n",
+		       file->name);
+		ret = 0;
+		goto out;
+	}
+
+	/*
+	 * This should remove any stale entries (if any) from the file hash.
+	 * Stale entries will have the same file name but different build ids.
+	 */
+	ret = file_hash_list__remove(file_hash, file->name);
+	if (ret < 0)
+		goto out;
+	ret = get_sdt_note_list(&sdt_notes, file->name);
+	if (ret < 0)
+		sdt_err(ret, target);
+	/* Add the entry to file hash list */
+	ret = file_hash_list__add(file_hash, &sdt_notes, file);
+out:
+	free(file->name);
+	free(file);
+	return ret;
+}
+
+/**
+ * file_hash_list__flush: Flush the file_hash list to cache
+ * @file_hash: file_hash list
+ * @fcache: opened SDT events cache
+ *
+ * Iterate through all the entries of @file_hash and flush them
+ * onto fcache.
+ * The complete file hash list is flushed into the cache. Write the
+ * file entries for every ent of file_hash, alongwith the SDT notes. The
+ * delimiter used is DELIM.
+ */
+static void file_hash_list__flush(struct hash_table *file_hash,
+				  FILE *fcache)
+{
+	struct file_sdt_ent *file_pos;
+	struct list_head *sdt_head;
+	struct hlist_head *ent_head;
+	struct sdt_note *sdt_ptr;
+	int i;
+
+	/* Go through all entries */
+	for (i = 0; i < SDT_HASH_SIZE; i++) {
+		/* Obtain the list head */
+		ent_head = &file_hash->ent[i];
+
+		/* DELIM is used here as delimiter */
+		hlist_for_each_entry(file_pos, ent_head, file_list) {
+			fprintf(fcache, "%s%c%s\n", file_pos->name, DELIM,
+				file_pos->sbuild_id);
+			sdt_head = &file_pos->sdt_list;
+			list_for_each_entry(sdt_ptr, sdt_head, note_list) {
+				fprintf(fcache, "%%%s%c%s%c%lx%c%lx\n",
+					sdt_ptr->provider, DELIM,
+					sdt_ptr->name, DELIM,
+					sdt_ptr->addr.a64[0], DELIM,
+					sdt_ptr->addr.a64[2]);
+			}
+		}
+	}
+}
+
+/**
+ * flush_hash_list_to_cache: Flush everything from file_hash to disk
+ * @file_hash: file_hash list
+ *
+ * Opens a cache and calls file_hash_list__flush() to dump everything
+ * on to the cache. The cache file is to be opened in HOME env variable
+ * inside the directory ".debug". The path for the cache file should be
+ * then "/home/user/.debug/.sdt-cache
+ */
+static int flush_hash_list_to_cache(struct hash_table *file_hash)
+{
+	FILE *cache;
+	int ret;
+	struct stat buf;
+	char sdt_cache_path[PATH_MAX], sdt_dir[PATH_MAX], *val;
+
+	val = getenv("HOME");
+	if (val) {
+		scnprintf(sdt_dir, sizeof(sdt_dir), "%s/%s", val, SDT_CACHE_DIR);
+		scnprintf(sdt_cache_path, sizeof(sdt_cache_path), "%s/%s",
+			 sdt_dir, SDT_FILE_CACHE);
+	} else {
+		pr_err("Error: Couldn't get the user's home directory\n");
+		ret = -1;
+		goto out_err;
+	}
+	ret = stat(sdt_dir, &buf);
+	if (ret) {
+		ret = mkdir(sdt_dir, buf.st_mode);
+		if (ret) {
+			pr_err("Error: Couldn't create %s\n", sdt_dir);
+			goto out_err;
+		}
+	}
+
+	cache = fopen(sdt_cache_path, "w");
+	if (!cache) {
+		pr_err("Error in creating %s file\n", sdt_cache_path);
+		ret = -errno;
+		goto out_err;
+	}
+
+	file_hash_list__flush(file_hash, cache);
+	fclose(cache);
+out_err:
+	return ret;
+}
+
+/**
+ * add_sdt_events: Add SDT events
+ * @arg: filename
+ *
+ * Initializes a hash table 'file_hash', calls add_to_hash_list() to add
+ * SDT events of @arg to the cache and then cleans them up.
+ * 'file_hash' is a hash table which maintains all the information
+ * related to the files with the SDT events in them. The file name serves
+ * as the key to this hash list. Each entry of the file_hash table is a
+ * list head which contains a chain of 'file_list' entries. Each 'file_list'
+ * entry contains the list of SDT events found in that file. This hash
+ * serves as a mapping from file name to the SDT events.
+ */
+int add_sdt_events(const char *arg)
+{
+	struct hash_table file_hash;
+	int ret, val;
+
+	/* Initialize the file hash_list */
+	ret = file_hash_list__init(&file_hash);
+	if (ret < 0) {
+		pr_err("Error: Couldn't initialize the SDT hash tables\n");
+		goto out;
+	}
+	/* Try to add the events to the file hash_list */
+	ret = add_to_hash_list(&file_hash, arg);
+	if (ret > 0) {
+		val = flush_hash_list_to_cache(&file_hash);
+		if (val < 0) {
+			ret = val;
+			goto out;
+		}
+		printf("%4d events added for %s\n", ret, arg);
+		ret = 0;
+	}
+
+out:
+	file_hash_list__cleanup(&file_hash);
+	return ret;
+}

