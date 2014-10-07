Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaJGC77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 22:59:59 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45416 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaJGC75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 22:59:57 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Subject: Re: [PATCH v2 2/5] perf/sdt: Add SDT events into a cache
References: <20141001023723.28985.39736.stgit@hemant-fedora>
	<20141001024734.28985.15086.stgit@hemant-fedora>
Date: Tue, 07 Oct 2014 11:59:54 +0900
In-Reply-To: <20141001024734.28985.15086.stgit@hemant-fedora> (Hemant Kumar's
	message of "Wed, 01 Oct 2014 08:17:48 +0530")
Message-ID: <87iojwh9ed.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Oct 2014 08:17:48 +0530, Hemant Kumar wrote:
> This patch adds a new sub-command to perf : sdt-cache.
> sdt-cache command can be used to add, remove and dump SDT events.
> This patch adds support to only "add" the SDT events. The rest of the
> patches add support to rest of them.
>
> When user invokes "perf sdt-cache add <file-name>", two hash tables are
> created: file_hash list and event_hash list. A typical entry in a file_hash
> table looks like:
>             file hash      file_sdt_ent     file_sdt_ent
>             |---------|   ---------------   -------------
>             | list  ==|===|=>file_list =|===|=>file_list=|==..
> key = 644 =>|         |   | sbuild_id   |   | sbuild_id  |
>             |---------|   | name        |   | name       |
>             |	        |   | sdt_list    |   | sdt_list   |
> key = 645 =>| list    |   |   ||        |   |    ||      |
>             |---------|   ---------------   --------------
> 	          ||            ||                 || Connected to SDT notes
> 	                  ---------------
> 			  |  note_list  |
> 		  sdt_note|  name       |
> 			  |  provider	|
>          		  ------||-------
> 		  connected to other SDT notes
>
>
> Each entry of the file_hash table is a list which connects to file_list in
> file_sdt_ent. file_sdt_ent is allocated per file whenever a file is mapped
> to file_hash list. File name serves as the key to this hash table.
> If a file is added to this hash list, a file_sdt_ent is allocated and a
> list of SDT events in that file is created and assigned to sdt_list of
> file_sdt_ent.
>
> Example usage :
> # ./perf sdt-cache --add /home/user_app
>
> 4 events added for /home/user_app!
>
> # ./perf sdt-cache --add /lib64/libc.so.6
>
> 8 events added for /usr/lib64/libc-2.16.so!
>
> Signed-off-by: Hemant Kumar <hemant@linux.vnet.ibm.com>
> ---
>  tools/perf/Makefile.perf       |    3 
>  tools/perf/builtin-sdt-cache.c |   59 ++++
>  tools/perf/builtin.h           |    1 
>  tools/perf/perf.c              |    1 
>  tools/perf/util/parse-events.h |    2 
>  tools/perf/util/probe-event.h  |    1 
>  tools/perf/util/sdt.c          |  666 ++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/sdt.h          |   30 ++
>  8 files changed, 763 insertions(+)
>  create mode 100644 tools/perf/builtin-sdt-cache.c
>  create mode 100644 tools/perf/util/sdt.c
>  create mode 100644 tools/perf/util/sdt.h
>
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index 262916f..09b3325 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -274,6 +274,7 @@ LIB_H += util/run-command.h
>  LIB_H += util/sigchain.h
>  LIB_H += util/dso.h
>  LIB_H += util/symbol.h
> +LIB_H += util/sdt.h
>  LIB_H += util/color.h
>  LIB_H += util/values.h
>  LIB_H += util/sort.h
> @@ -339,6 +340,7 @@ LIB_OBJS += $(OUTPUT)util/sigchain.o
>  LIB_OBJS += $(OUTPUT)util/dso.o
>  LIB_OBJS += $(OUTPUT)util/symbol.o
>  LIB_OBJS += $(OUTPUT)util/symbol-elf.o
> +LIB_OBJS += $(OUTPUT)util/sdt.o
>  LIB_OBJS += $(OUTPUT)util/color.o
>  LIB_OBJS += $(OUTPUT)util/pager.o
>  LIB_OBJS += $(OUTPUT)util/header.o
> @@ -458,6 +460,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-timechart.o
>  BUILTIN_OBJS += $(OUTPUT)builtin-top.o
>  BUILTIN_OBJS += $(OUTPUT)builtin-script.o
>  BUILTIN_OBJS += $(OUTPUT)builtin-probe.o
> +BUILTIN_OBJS += $(OUTPUT)builtin-sdt-cache.o

Hmm.. did you test it without libelf support?  I guess we need to guard
those files under the feature test.


>  BUILTIN_OBJS += $(OUTPUT)builtin-kmem.o
>  BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
>  BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o


[SNIP]
> --- a/tools/perf/perf.c
> +++ b/tools/perf/perf.c
> @@ -52,6 +52,7 @@ static struct cmd_struct commands[] = {
>  	{ "sched",	cmd_sched,	0 },
>  #ifdef HAVE_LIBELF_SUPPORT
>  	{ "probe",	cmd_probe,	0 },
> +	{ "sdt-cache",  cmd_sdt_cache,  0 },
>  #endif

Like here..


>  	{ "kmem",	cmd_kmem,	0 },
>  	{ "lock",	cmd_lock,	0 },
> diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
> index df094b4..e6efe2c 100644
> --- a/tools/perf/util/parse-events.h
> +++ b/tools/perf/util/parse-events.h
> @@ -109,4 +109,6 @@ extern int is_valid_tracepoint(const char *event_string);
>  
>  extern int valid_debugfs_mount(const char *debugfs);
>  
> +int add_sdt_events(const char *file);
> +
>  #endif /* __PERF_PARSE_EVENTS_H */
> diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
> index e01e994..f1ddca6 100644
> --- a/tools/perf/util/probe-event.h
> +++ b/tools/perf/util/probe-event.h
> @@ -5,6 +5,7 @@
>  #include "intlist.h"
>  #include "strlist.h"
>  #include "strfilter.h"
> +#include "sdt.h"
>  
>  extern bool probe_event_dry_run;
>  
> diff --git a/tools/perf/util/sdt.c b/tools/perf/util/sdt.c
> new file mode 100644
> index 0000000..9a39d36
> --- /dev/null
> +++ b/tools/perf/util/sdt.c
> @@ -0,0 +1,666 @@
> +/*
> + * util/sdt.c
> + * This contains the relevant functions needed to find the SDT events
> + * in a binary and adding them to a cache.
> + *
> + * TODOS:
> + * - Listing SDT events in most of the binaries present in the system.
> + * - Looking into directories provided by the user for binaries with SDTs,
> + * etc.
> + * - Support SDT event arguments.
> + * - Support SDT event semaphores.
> + */
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <errno.h>
> +#include <string.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
> +#include <limits.h>
> +#include <sys/mman.h>
> +#include <fcntl.h>
> +
> +#include "parse-events.h"
> +#include "probe-event.h"
> +#include "linux/list.h"
> +#include "symbol.h"
> +#include "build-id.h"
> +#include "debug.h"
> +
> +struct file_info {
> +	char *name;                             /* File name */
> +	char sbuild_id[BUILD_ID_SIZE * 2 + 1];  /* Build id of the file */
> +};
> +
> +/**
> + * get_hash_key: calculates the key to hash tables
> + * @str: input string
> + *
> + * adds the ascii values for all the chars in @str, multiplies with a prime
> + * and finds the modulo with HASH_TABLE_SIZE.
> + *
> + * Return : An integer key
> + */
> +static unsigned get_hash_key(const char *str)
> +{
> +	unsigned value = 0, key;
> +	unsigned c;
> +
> +	for (c = 0; str[c] != '\0'; c++)
> +		value += str[c];
> +
> +	key = (value * 37) % HASH_TABLE_SIZE;
> +
> +	return key;
> +}
> +
> +/**
> + * sdt_err: print SDT related error
> + * @val: error code
> + * @target: input file
> + *
> + * Display error corresponding to @val for file @target
> + */
> +static int sdt_err(int val, const char *target)
> +{
> +	switch (-val) {
> +	case 0:
> +		break;
> +	case ENOENT:
> +		/* Absence of SDT markers */
> +		pr_err("%s: No SDT events found\n", target);
> +		break;
> +	case EBADF:
> +		pr_err("%s: Bad file name\n", target);
> +		break;
> +	default:
> +		pr_err("%s\n", strerror(val));

Please don't add strerror() anymore - use (GNU-style) strerror_r()
instead.


> +	}
> +
> +	return val;
> +}
> +
> +/**
> + * cleanup_sdt_note_list : free the sdt notes' list
> + * @sdt_notes: sdt notes' list
> + *
> + * Free up the SDT notes in @sdt_notes.
> + */
> +static void cleanup_sdt_note_list(struct list_head *sdt_notes)
> +{
> +	struct sdt_note *tmp, *pos;
> +
> +	if (list_empty(sdt_notes))
> +		return;

Not needed.


> +
> +	list_for_each_entry_safe(pos, tmp, sdt_notes, note_list) {
> +		list_del(&pos->note_list);
> +		free(pos->name);
> +		free(pos->provider);
> +		free(pos);
> +	}
> +}
> +
> +/**
> + * file_list_entry__init: Initialize a file_list_entry
> + * @fse: file_list_entry
> + * @file: file information
> + *
> + * Initializes @fse with the build id of a @file.
> + */
> +static void file_list_entry__init(struct file_sdt_ent *fse,
> +				 struct file_info *file)
> +{
> +	strcpy(fse->sbuild_id, file->sbuild_id);
> +	INIT_LIST_HEAD(&fse->file_list);
> +	INIT_LIST_HEAD(&fse->sdt_list);
> +}
> +
> +/**
> + * sdt_events__get_count: Counts the number of sdt events
> + * @start: list_head to sdt_notes list
> + *
> + * Returns the number of SDT notes in a list
> + */
> +static int sdt_events__get_count(struct list_head *start)
> +{
> +	struct sdt_note *sdt_ptr;
> +	int count = 0;
> +
> +	list_for_each_entry(sdt_ptr, start, note_list) {
> +		count++;
> +	}
> +	return count;
> +}
> +
> +/**
> + * file_hash_list__add: add an entry to file_hash_list
> + * @sdt_notes: list of sdt_notes
> + * @file: file name and build id
> + * @file_hash: hash table for file and sdt notes
> + *
> + * Get the key corresponding to @file->name. Fetch the entry
> + * for that key. Build a file_list_entry fse, assign the SDT notes
> + * to it and then assign fse to the fetched entry into the hash.
> + */
> +static int file_hash_list__add(struct list_head *sdt_notes,
> +				struct file_info *file,
> +				struct hash_list *file_hash)
> +{
> +	struct file_sdt_ent *fse;
> +	struct list_head *ent_head;
> +	int key, nr_evs;
> +
> +	key = get_hash_key(file->name);
> +	ent_head = &file_hash->ent[key].list;
> +
> +	/* Initialize the file entry */
> +	fse = (struct file_sdt_ent *)malloc(sizeof(struct file_sdt_ent));

You can use following style instead (for other call-sites too).  It's
shorter and easier to change.

	fse = malloc(sizeof(*fse));


> +	if (!fse)
> +		return -ENOMEM;
> +	file_list_entry__init(fse, file);
> +	nr_evs = sdt_events__get_count(sdt_notes);
> +	list_splice(sdt_notes, &fse->sdt_list);
> +
> +	printf("%d events added for %s\n", nr_evs, file->name);
> +	strcpy(fse->name, file->name);
> +
> +	/* Add the file to the file hash entry */
> +	list_add(&fse->file_list, ent_head);
> +
> +	return MOD;

What is MOD?


> +}
> +
> +/**
> + * file_hash_list__remove: Remove a file entry from the file_hash table
> + * @file_hash: file_hash_table
> + * @target: file name
> + *
> + * Removes the entries from file_hash table corresponding to @target.
> + * Gets the key from @target. Also frees up the SDT events for that
> + * file.
> + */
> +static int file_hash_list__remove(struct hash_list *file_hash,
> +				   const char *target)
> +{
> +	struct file_sdt_ent *fse, *tmp1;
> +	struct list_head *sdt_head, *ent_head;
> +	struct sdt_note *sdt_ptr, *tmp2;
> +
> +	char *res_path;
> +	int key, nr_del = 0;
> +
> +	key = get_hash_key(target);
> +	ent_head = &file_hash->ent[key].list;
> +
> +	res_path = realpath(target, NULL);
> +	if (!res_path)
> +		return -ENOMEM;

Why did you get hash key before getting realpath()?

Also it seems you need to free res_path at the end.


> +
> +	if (list_empty(ent_head))
> +		return 0;

Not needed.


> +
> +	/* Got the file hash entry */
> +	list_for_each_entry_safe(fse, tmp1, ent_head, file_list) {
> +		sdt_head = &fse->sdt_list;
> +		if (strcmp(res_path, fse->name))
> +			continue;
> +
> +		/* Got the file list entry, now start removing */
> +		list_for_each_entry_safe(sdt_ptr, tmp2, sdt_head, note_list) {
> +			list_del(&sdt_ptr->note_list);
> +			free(sdt_ptr->name);
> +			free(sdt_ptr->provider);
> +			free(sdt_ptr);
> +			nr_del++;
> +		}
> +		list_del(&fse->file_list);
> +		list_del(&fse->sdt_list);
> +		free(fse);
> +	}
> +
> +	return nr_del;
> +}
> +/**
> + * file_hash_list__entry_exists: Checks if a file is already present
> + * @file_hash: file_hash table
> + * @file: file name and build id to check
> + *
> + * Obtains the key from @file->name, fetches the correct entry,
> + * and goes through the chain to find out the correct file list entry.
> + * Compares the build id, if they match, return true, else, false.
> + */
> +static bool file_hash_list__entry_exists(struct hash_list *file_hash,
> +					  struct file_info *file)
> +{
> +	struct file_sdt_ent *fse;
> +	struct list_head *ent_head;
> +	int key;
> +
> +	key = get_hash_key(file->name);
> +	ent_head = &file_hash->ent[key].list;
> +	if (list_empty(ent_head))
> +		return false;

Not needed.


> +
> +	list_for_each_entry(fse, ent_head, file_list) {
> +		if (!strcmp(file->name, fse->name)) {
> +			if (!strcmp(file->sbuild_id, fse->sbuild_id))
> +				return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +
> +/**
> + * copy_delim: copy till a character
> + * @src: source string
> + * @target: dest string
> + * @delim: till this character
> + * @len: length of @target
> + * @end: end of @src
> + *
> + * Returns the number of chars copied.
> + * NOTE: We need @end as @src may or may not be terminated by NULL
> + */
> +static int copy_delim(char *src, char *target, char delim, size_t len,
> +		      char *end)
> +{
> +	int i;
> +
> +	memset(target, '\0', len);
> +	for (i = 0; (src[i] != delim) && !(src + i > end) ; i++)
> +		target[i] = src[i];
> +
> +	return i + 1;
> +}
> +
> +/**
> + * sdt_note__read: Parse SDT note info
> + * @ptr: raw data
> + * @sdt_list: empty list
> + * @end: end of the raw data
> + *
> + * Parse @ptr to find out SDT note name, provider, location and semaphore.
> + * All these data are separated by DELIM.
> + */
> +static void sdt_note__read(char **ptr, struct list_head *sdt_list, char *end)
> +{
> +	struct sdt_note *sn;
> +	char addr[MAX_ADDR];
> +	int len = 0;
> +
> +	while (1) {
> +		sn = (struct sdt_note *)malloc(sizeof(struct sdt_note));
> +		if (!sn)
> +			return;
> +		INIT_LIST_HEAD(&sn->note_list);
> +		sn->name = (char *)malloc(PATH_MAX);
> +		if (!sn->name)
> +			return;
> +		sn->provider = (char *)malloc(PATH_MAX);
> +		if (!sn->provider)
> +			return;

Hmm.. this seems too much..  Why not use a local temp buffer for
copy_delim() and then strdup() for real provider and name?


> +		/* Extract the provider name */
> +		len = copy_delim(*ptr, sn->provider, DELIM, PATH_MAX, end);
> +		*ptr += len;
> +
> +		/* Extract the note name */
> +		len = copy_delim(*ptr, sn->name, DELIM, PATH_MAX, end);
> +		*ptr += len;
> +
> +		/* Extract the note's location */
> +		len = copy_delim(*ptr, addr , DELIM, MAX_ADDR, end);
> +		*ptr += len;
> +		sscanf(addr, "%lx", &sn->addr.a64[0]);
> +
> +		/* Extract the sem location */
> +		len = copy_delim(*ptr, addr , DELIM, MAX_ADDR, end);
> +		*ptr += len;
> +		sscanf(addr, "%lx", &sn->addr.a64[2]);
> +		list_add(&sn->note_list, sdt_list);
> +
> +		/* If the entries for this file are finished */
> +		if (**ptr == DELIM)
> +			break;
> +	}
> +}
> +
> +/**
> + * file_hash_list__populate: Fill up the file hash table
> + * @file_hash: empty file hash table
> + * @data: raw cache data
> + * @size: size of data
> + *
> + * Find out the end of data with help of @size. Start parsing @data.
> + * In the outer loop, it reads the 'key' delimited by "::-". In the inner
> + * loop, it reads the file name, build id and calls sdt_note__read() to
> + * read the SDT notes. Multiple entries for the same key are delimited
> + * by "::". Then, it assigns the file name, build id and SDT notes to the
> + * list entry corresponding to 'key'.

Do we really need to save 'key' in the cache file?  It's an
implementation detail and can be changed later IMHO.  Why not just
saving file name and calculate hash key at runtime?

Also I think it'd be better having a single line for each SDT note
entry.  It's more human-readable and easier to deal with.


> + */
> +static void file_hash_list__populate(struct hash_list *file_hash, char *data,
> +				     off_t size)
> +{
> +	struct list_head *ent_head;
> +	struct file_sdt_ent *fse;
> +	char *end, tmp[PATH_MAX], *ptr;
> +	int key, len = 0;
> +
> +	end = data + size - 1;
> +	ptr = data;
> +	if (ptr == end)
> +		return;
> +	do {
> +		/* Obtain the key */
> +		len = copy_delim(ptr, tmp, DELIM, PATH_MAX, end);
> +		ptr += len;
> +		key = atoi(tmp);
> +		/* Obtain the file_hash list entry */
> +		ent_head = &file_hash->ent[key].list;
> +		while (1) {
> +			fse = (struct file_sdt_ent *)
> +				malloc(sizeof(struct file_sdt_ent));
> +			if (!fse)
> +				return;
> +			INIT_LIST_HEAD(&fse->file_list);
> +			INIT_LIST_HEAD(&fse->sdt_list);
> +			/* Obtain the file name */
> +			len = copy_delim(ptr, fse->name, DELIM,
> +					 sizeof(fse->name), end);
> +			ptr += len;
> +			/* Obtain the build id */
> +			len = copy_delim(ptr, fse->sbuild_id, DELIM,
> +					 sizeof(fse->sbuild_id), end);
> +			ptr += len;
> +			sdt_note__read(&ptr, &fse->sdt_list, end);
> +
> +			list_add(&fse->file_list, ent_head);
> +
> +			/* Check for another file entry */
> +			if ((*ptr++ == DELIM) && (*ptr == '-'))
> +				break;
> +		}
> +		if (ptr == end)
> +			break;
> +		else
> +			ptr++;
> +
> +	} while (1);
> +}
> +
> +/**
> + * file_hash_list__init: Initializes the file hash list
> + * @file_hash: empty file_hash
> + *
> + * Opens the cache file, reads the data into 'data' and calls
> + * file_hash_list__populate() to populate the above hash list.
> + */
> +static void file_hash_list__init(struct hash_list *file_hash)
> +{
> +	struct stat sb;
> +	char *data;
> +	int fd, i, ret;
> +
> +	for (i = 0; i < HASH_TABLE_SIZE; i++)
> +		INIT_LIST_HEAD(&file_hash->ent[i].list);
> +
> +	fd = open(SDT_CACHE_DIR SDT_FILE_CACHE, O_RDONLY);
> +	if (fd == -1)
> +		return;
> +
> +	ret = fstat(fd, &sb);
> +	if (ret == -1) {
> +		pr_err("fstat : error\n");
> +		return;
> +	}
> +
> +	if (!S_ISREG(sb.st_mode)) {
> +		pr_err("%s is not a regular file\n", SDT_CACHE_DIR
> +		       SDT_FILE_CACHE);
> +		return;
> +	}
> +	/* Is size of the cache zero ?*/
> +	if (!sb.st_size)
> +		return;
> +	/* Read the data */
> +	data = mmap(0, sb.st_size, PROT_READ, MAP_SHARED, fd, 0);
> +	if (data == MAP_FAILED) {
> +		pr_err("Error in mmap\n");
> +		return;
> +	}
> +
> +	ret = madvise(data, sb.st_size, MADV_SEQUENTIAL);
> +	if (ret == -1)
> +		pr_debug("Error in madvise\n");
> +	ret = close(fd);
> +	if (ret == -1) {
> +		pr_err("Error in close\n");
> +		return;
> +	}
> +
> +	/* Populate the hash list */
> +	file_hash_list__populate(file_hash, data, sb.st_size);
> +	ret = munmap(data, sb.st_size);
> +	if (ret == -1)
> +		pr_err("Error in munmap\n");
> +}
> +
> +/**
> + * file_hash_list__cleanup: Free up all the space for file_hash list
> + * @file_hash: file_hash table
> + */
> +static void file_hash_list__cleanup(struct hash_list *file_hash)
> +{
> +	struct file_sdt_ent *file_pos, *tmp;
> +	struct list_head *ent_head, *sdt_head;
> +	int i;
> +
> +	/* Go through all the entries */
> +	for (i = 0; i < HASH_TABLE_SIZE; i++) {
> +		ent_head = &file_hash->ent[i].list;
> +		if (list_empty(ent_head))
> +			continue;

Not needed.


> +
> +		list_for_each_entry_safe(file_pos, tmp, ent_head, file_list) {
> +			sdt_head = &file_pos->sdt_list;
> +			/* Cleanup the corresponding SDT notes' list */
> +			cleanup_sdt_note_list(sdt_head);
> +			list_del(&file_pos->file_list);
> +			list_del(&file_pos->sdt_list);
> +			free(file_pos);
> +		}
> +	}
> +}
> +
> +/**
> + * add_to_hash_list: add an entry to file_hash_list
> + * @file_hash: file hash table
> + * @target: file name
> + *
> + * Does a sanity check for the @target, finds out its build id,
> + * checks if @target is already present in file hash list. If not present,
> + * delete any stale entries with this file name (i.e., entries matching this
> + * file name but having older build ids). And then, adds the file entry to
> + * file hash list and also updates the SDT events in the event hash list.
> + */
> +static int add_to_hash_list(struct hash_list *file_hash, const char *target)
> +{
> +	struct file_info *file;
> +	int ret = 0;

Maybe it'd be better to initialize it to -EBADF.


> +	u8 build_id[BUILD_ID_SIZE];
> +
> +	LIST_HEAD(sdt_notes);
> +
> +	file = (struct file_info *)malloc(sizeof(struct file_info));
> +	if (!file)
> +		return -ENOMEM;
> +
> +	file->name = realpath(target, NULL);
> +	if (!file->name) {
> +		ret = -EBADF;
> +		pr_err("%s: Bad file name!\n", target);
> +		goto out;
> +	}
> +
> +	symbol__elf_init();
> +	if (filename__read_build_id(file->name, &build_id,
> +				    sizeof(build_id)) < 0) {
> +		pr_err("Couldn't read build-id in %s\n", file->name);
> +		ret = -EBADF;
> +		sdt_err(ret, file->name);
> +		goto out;
> +	}
> +	build_id__sprintf(build_id, sizeof(build_id), file->sbuild_id);
> +	/* File entry already exists ?*/
> +	if (file_hash_list__entry_exists(file_hash, file)) {
> +		pr_err("Error: SDT events for %s already exist!",
> +		       file->name);
> +		ret = NO_MOD;
> +		goto out;
> +	}
> +
> +	/*
> +	 * This will also remove any stale entries (if any) from the event hash.
> +	 * Stale entries will have the same file name but older build ids.
> +	 */
> +	file_hash_list__remove(file_hash, file->name);
> +	ret = get_sdt_note_list(&sdt_notes, file->name);
> +	if (!ret) {
> +		/* Add the entry to file hash list */
> +		ret = file_hash_list__add(&sdt_notes, file, file_hash);
> +	} else {
> +		sdt_err(ret, target);
> +	}
> +
> +out:
> +	free(file->name);
> +	free(file);
> +	return ret;
> +}
> +
> +/**
> + * file_hash_list__flush: Flush the file_hash list to cache
> + * @file_hash: file_hash list
> + * @fcache: opened SDT events cache
> + *
> + * Iterate through all the entries of @file_hash and flush them
> + * onto fcache.
> + * The complete file hash list is flushed into the cache. First
> + * write the key for non-empty entry and then file entries for that
> + * key, and then the SDT notes. The delimiter used is ':'.
> + */
> +static void file_hash_list__flush(struct hash_list *file_hash,
> +				  FILE *fcache)
> +{
> +	struct file_sdt_ent *file_pos;
> +	struct list_head *ent_head, *sdt_head;
> +	struct sdt_note *sdt_ptr;
> +	int i;
> +
> +	/* Go through all entries */
> +	for (i = 0; i < HASH_TABLE_SIZE; i++) {
> +		/* Obtain the list head */
> +		ent_head = &file_hash->ent[i].list;
> +		/* Empty ? */
> +		if (list_empty(ent_head))
> +			continue;
> +		/* ':' are used here as delimiters */

Wouldn't it be better using DELIM for consistency then?


> +		fprintf(fcache, "%d:", i);
> +		list_for_each_entry(file_pos, ent_head, file_list) {
> +			fprintf(fcache, "%s:", file_pos->name);
> +			fprintf(fcache, "%s:", file_pos->sbuild_id);
> +			sdt_head = &file_pos->sdt_list;
> +			list_for_each_entry(sdt_ptr, sdt_head, note_list) {
> +				fprintf(fcache, "%s:%s:%lx:%lx:",
> +					sdt_ptr->provider, sdt_ptr->name,
> +					sdt_ptr->addr.a64[0],
> +					sdt_ptr->addr.a64[2]);
> +			}
> +			fprintf(fcache, ":");
> +		}
> +		/* '-' marks the end of entries for that key */
> +		fprintf(fcache, "-");
> +	}
> +
> +}
> +
> +/**
> + * flush_hash_list_to_cache: Flush everything from file_hash to disk
> + * @file_hash: file_hash list
> + *
> + * Opens a cache and calls file_hash_list__flush() to dump everything
> + * on to the cache.
> + */
> +static void flush_hash_list_to_cache(struct hash_list *file_hash)
> +{
> +	FILE *cache;
> +	int ret;
> +	struct stat buf;
> +
> +	ret = stat(SDT_CACHE_DIR, &buf);
> +	if (ret) {
> +		ret = mkdir(SDT_CACHE_DIR, buf.st_mode);
> +		if (ret) {
> +			pr_err("%s : %s\n", SDT_CACHE_DIR, strerror(errno));

Ditto.  Please use strerror_r().


> +			return;
> +		}
> +	}
> +
> +	cache = fopen(SDT_CACHE_DIR SDT_FILE_CACHE, "w");
> +	if (!cache) {
> +		pr_err("Error in creating %s file!\n",
> +		       SDT_CACHE_DIR SDT_FILE_CACHE);
> +		return;
> +	}
> +
> +	file_hash_list__flush(file_hash, cache);
> +	fclose(cache);
> +}
> +
> +/**
> + * add_sdt_events: Add SDT events
> + * @arg: filename
> + *
> + * Initializes a hash table 'file_hash', calls add_to_hash_list() to add SDT
> + * events of @arg to the cache and then cleans them up.
> + * 'file_hash' list is a hash table which maintains all the information
> + * related to the files with the SDT events in them. The file name serves as the
> + * key to this hash list. Each entry of the file_hash table is a list head
> + * which contains a chain of 'file_list' entries. Each 'file_list' entry contains
> + * the list of SDT events found in that file. This hash serves as a mapping
> + * from file name to the SDT events. 'file_hash' is used to add/del SDT events
> + * to the SDT cache.
> + */
> +int add_sdt_events(const char *arg)
> +{
> +	struct hash_list file_hash;
> +	int ret;
> +
> +	if (!arg) {
> +		pr_err("Error : File Name must be specified with \"--add\""
> +		       "option!\n"
> +	       "Usage :\n  perf sdt-cache --add <file-name>\n");

I think this message should be a part of the builtin-sdt-cache.c file.
Also please don't wrap lines (especially for string literals) just to
fit to the 80 column limit.


> +		return -1;
> +	}
> +	/* Initialize the file hash_list */
> +	file_hash_list__init(&file_hash);
> +
> +	/* Try to add the events to the file hash_list */
> +	ret = add_to_hash_list(&file_hash, arg);
> +	switch (ret) {
> +	case MOD:
> +		/* file hash table is dirty, flush it */
> +		flush_hash_list_to_cache(&file_hash);
> +	case NO_MOD:
> +		/* file hash isn't dirty, do not flush */
> +		file_hash_list__cleanup(&file_hash);
> +		ret = 0;
> +		break;
> +	default:
> +		file_hash_list__cleanup(&file_hash);
> +	}
> +	return ret;
> +}
> diff --git a/tools/perf/util/sdt.h b/tools/perf/util/sdt.h
> new file mode 100644
> index 0000000..4ed27d7
> --- /dev/null
> +++ b/tools/perf/util/sdt.h
> @@ -0,0 +1,30 @@
> +#include "build-id.h"
> +
> +#define HASH_TABLE_SIZE 2063

Hmm.. look like an unusual size of a hash table.


> +#define SDT_CACHE_DIR "/var/cache/perf/"
> +#define SDT_FILE_CACHE "perf-sdt-file.cache"
> +#define SDT_EVENT_CACHE "perf-sdt-event.cache"
> +
> +#define DELIM ':'
> +#define MAX_ADDR 17
> +
> +#define MOD 1
> +#define NO_MOD 2
> +
> +struct file_sdt_ent {
> +	char name[PATH_MAX];                    /* file name */
> +	char sbuild_id[BUILD_ID_SIZE * 2 + 1];  /* Build id of the file */
> +	struct list_head file_list;
> +	struct list_head sdt_list;              /* SDT notes in this file */
> +
> +};
> +
> +/* hash table entry */
> +struct hash_ent {
> +	struct list_head list;
> +};
> +
> +/* Hash table struct */
> +struct hash_list {
> +	struct hash_ent ent[HASH_TABLE_SIZE];
> +};
