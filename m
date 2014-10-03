Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaJCMrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:47:33 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58747 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbaJCMr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:47:28 -0400
Message-ID: <542E9AD8.9010000@hitachi.com>
Date: Fri, 03 Oct 2014 21:47:20 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v1 2/5] perf/sdt: Add SDT events into a cache
References: <20140930152055.6698.82709.stgit@hemant-fedora> <20140930153150.6698.12852.stgit@hemant-fedora>
In-Reply-To: <20140930153150.6698.12852.stgit@hemant-fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/01 0:32), Hemant Kumar wrote:
> This patch adds a new sub-command to perf : sdt-cache.

When I ran perf without option, sdt-cache did not appear. You should update
command-list.txt and add Documentation/perf-sdt-cache.txt, so that sdt-cache is
shown (Note that perf build automatically extracts NAME line and embeds it as a
help message). Maybe commit ef12a141 is good to refer :)

> sdt-cache command can be used to add, remove and dump SDT events.
> This patch adds support to only "add" the SDT events. The rest of the
> patches add support to rest of them.

You don't need to describe dump and remove in this patch. How about below?

  perf-sdt-cache command manages SDT events in applications. This adds
  "perf sdt-cache --add <file>" to add SDT events in given file to local
  cache.


> When user invokes "perf sdt-cache add <file-name>", two hash tables are
> created: file_hash list and event_hash list. A typical entry in a file_hash
> table looks like:
>             file hash      file_sdt_ent     file_sdt_ent
>             |---------|   ---------------   -------------
>             | list  ==|===|=>file_list =|===|=>file_list=|==..
> key = 644 =>|         |   | sbuild_id   |   | sbuild_id  |
>             |---------|   | name        |   | name       |
>             |	      |   | sdt_list    |   | sdt_list   |
> key = 645 =>| list    |   |   ||        |   |    ||      |
>             |---------|   ---------------   --------------
> 	        ||            ||                 || Connected to SDT notes
> 	                  ---------------
> 			  |  note_list  |
> 		  sdt_note|  name       |
> 			  |  provider	|
>          		  -----||--------
> 		  connected to other SDT notes

Hmm, why don't you use hlist for file_hash.list?

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

IMO, when succeeding to add events, it may not need the last "!", since
it is eye-catching too much (as like as we get an error).

[...]
> diff --git a/tools/perf/util/sdt.c b/tools/perf/util/sdt.c
> new file mode 100644
> index 0000000..0b56210
> --- /dev/null
> +++ b/tools/perf/util/sdt.c
> @@ -0,0 +1,665 @@
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

37 seems to a magic number :) how about defining it as HASH_PRIME_BASE?

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
> +
> +	list_for_each_entry_safe(pos, tmp, sdt_notes, note_list) {
> +		list_del(&pos->note_list);
> +		free(pos->name);
> +		free(pos->provider);
> +		free(pos);
> +	}
> +}

Hmm, since the list is created in tools/perf/util/symbol-elf.c, it is better
to be defined in the same file, and same patch(1/1).

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

This should be also in symbol-elf.c or symbol.h. Moreover, since there is no sdt_events
data structure, the function name looks a bit odd.

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
> +
> +	if (list_empty(ent_head))
> +		return 0;
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

You can use cleanup_sdt_note_list() here. If you need to count nr_del, modify
cleanup_sdt_note_list() to return the number.

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

I'm not sure why this is needed.

> +	for (i = 0; (src[i] != delim) && !(src + i > end) ; i++)
> +		target[i] = src[i];
> +
> +	return i + 1;
> +}

Anyway, this may be replaced with strchr(3) or strtok_r(3) and strncpy(3).

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

Hmm, shouldn't we check the end of the sdt note?

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

Why don't you use while(ptr < end) {} here ?

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

This should return an error code, since there are lots of error paths.

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

At first step, you don't need to take care of the speed.

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

NO_MOD is too generic. I'd like to suggest that this returns the number of
modified(added) entries.

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

Hmm, this format is horrible. Please use more sscanf-readable format, so that
we can simplify the reader-side code. e.g.

<number>:\n
<file>:<buildid>\n
<provider>:<name>:<addr>:<sem>\n
:\n
<number>:\n
...
Then, you can use fscanf(), or a combination of fgets() and sscanf().
We don't need to care about the loading speed at this point.


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

Again, MOD and NO_MOD is too general.

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
> +#define SDT_CACHE_DIR "/var/cache/perf/"
> +#define SDT_FILE_CACHE "perf-sdt-file.cache"
> +#define SDT_EVENT_CACHE "perf-sdt-event.cache"

Hmm, this should be treated as same as buildid_dir. Please see util/config.c.

Thank you,

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
> 
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


