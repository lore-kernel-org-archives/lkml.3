Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbaJVEl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 00:41:29 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:54883 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaJVEl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 00:41:27 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Subject: Re: [PATCH v3 2/5] perf/sdt: Add SDT events into a cache
References: <20141010104402.15506.73285.stgit@hemant-fedora>
	<20141010105758.15506.20442.stgit@hemant-fedora>
Date: Wed, 22 Oct 2014 13:41:25 +0900
In-Reply-To: <20141010105758.15506.20442.stgit@hemant-fedora> (Hemant Kumar's
	message of "Fri, 10 Oct 2014 16:28:24 +0530")
Message-ID: <8761fcg1hm.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2014 16:28:24 +0530, Hemant Kumar wrote:
> This patch adds a new sub-command to perf : sdt-cache.
> sdt-cache command can be used to add SDT events.
> When user invokes "perf sdt-cache add <file-name>", a hash table/list is
> created named as file_hash list. A typical entry in a file_hash table looks
> like:
>
>                 file hash      file_sdt_ent     file_sdt_ent
>                 |---------|   ---------------   -------------
>                 | hlist ==|===|=>file_list =|===|=>file_list=|==..
>     key = 644 =>|         |   | sbuild_id   |   | sbuild_id  |
>                 |---------|   | name        |   | name       |
>                 |         |   | sdt_list    |   | sdt_list   |
>     key = 645 =>| hlist   |   |   ||        |   |    ||      |
>                 |---------|   ---------------   --------------
>                     ||            ||                 || Connected to SDT notes
>                           ---------------
>                           |  note_list  |
>                           |  name       |sdt_note
>                           |  provider   |
>                           -----||--------
>                   connected to other SDT notes
>
> Each entry of the file_hash table is an hlist which connects to file_list
> in file_sdt_ent. file_sdt_ent is allocated per file whenever a file is
> mapped to file_hash list. File name serves as the key to this hash table.
> If a file is added to this hash list, a file_sdt_ent is allocated and a
> list of SDT events in that file is created and assigned to sdt_list of
> file_sdt_ent.
>
> Example usage :
> # ./perf sdt-cache --add /home/user_app
>
>     4 events added for /home/user_app
>
> # ./perf sdt-cache --add /lib64/libc.so.6
>
>     8 events added for /usr/lib64/libc-2.16.so
>
> Signed-off-by: Hemant Kumar <hemant@linux.vnet.ibm.com>

[SNIP]
> +static int file_hash_list__remove(struct hash_table *file_hash,
> +				   const char *target)
> +{
> +	struct file_sdt_ent *fse;
> +	struct hlist_head *ent_head;
> +	struct list_head *sdt_head;
> +	struct hlist_node *tmp1;
> +	char *res_path;
> +	int key, nr_del = 0;
> +
> +	res_path = realpath(target, NULL);
> +	if (!res_path)
> +		return -ENOMEM;
> +
> +	key = get_hash_key(target);
> +	ent_head = &file_hash->ent[key];
> +
> +	/* Got the file hash entry */
> +	hlist_for_each_entry_safe(fse, tmp1, ent_head, file_list) {
> +		sdt_head = &fse->sdt_list;
> +		if (strcmp(res_path, fse->name))
> +			continue;
> +
> +		/* Got the file list entry, now start removing */
> +		nr_del = cleanup_sdt_note_list(sdt_head);
> +		hlist_del(&fse->file_list);
> +		list_del(&fse->sdt_list);

It seems you don't need to call list_del() here.  And what about just
calling cleanup_sdt_note_list(&fse->sdt_list) instead?


> +		free(fse);
> +	}
> +	free(res_path);
> +	return nr_del;
> +}

[SNIP]
> +static int sdt_note__read(char *data, struct list_head *sdt_list)
> +{
> +	struct sdt_note *sn;
> +	char *tmp, *ptr, delim[2];
> +	int ret = -EBADF, val;
> +
> +	/* Initialize the delimiter with DELIM */
> +	delim[0] = DELIM;

What about delim[1] then?


> +	sn = malloc(sizeof(*sn));
> +	if (!sn) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	INIT_LIST_HEAD(&sn->note_list);
> +
> +	/* Provider name */
> +	ptr = strtok_r(data, delim, &tmp);
> +	if (!ptr)
> +		goto out;
> +	sn->provider = strdup(ptr);
> +	if (!sn->provider) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	/* Marker name */
> +	ptr = strtok_r(NULL, delim, &tmp);
> +	if (!ptr)
> +		goto out;
> +	sn->name = strdup(ptr);
> +	if (!sn->name) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	/* Location */
> +	ptr = strtok_r(NULL, delim, &tmp);
> +	if (!ptr)
> +		goto out;
> +	val = sscanf(ptr, "%lx", &sn->addr.a64[0]);
> +	if (val == EOF)
> +		goto out;
> +	/* Sempahore */
> +	ptr = strtok_r(NULL, delim, &tmp);
> +	if (!ptr)
> +		goto out;
> +	val = sscanf(ptr, "%lx", &sn->addr.a64[2]);
> +	if (val == EOF)
> +		goto out;
> +	/* Add to the SDT list */
> +	list_add(&sn->note_list, sdt_list);
> +	ret = 0;
> +out:
> +	return ret;
> +}
> +
> +/**
> + * file_hash_list__populate: Fill up the file hash table
> + * @file_hash: empty file hash table
> + * @cache: FILE * to read from
> + *
> + * Parse @cache for file_name and its SDT events.
> + * The format of the cache is :
> + *
> + * file_name:build_id\n
> + * provider:marker:location:semaphore\n

You seem forgot to add a file delimiter before new file.

      :\n
> + * file_name:build_id\n
> + * ...

Anyway IMHO it's bit uncomfortable.  How about changing the format same
as it dumps?  A line starts with '%' is a sdt description, otherwise
file info:

file_name1:build_id\n
%provide:marker1:location:semaphore\n
%provide:marker2:location:semaphore\n
%...
file_name2:build_id\n
%...

And we can deal with it by usual fgets/getline and strtok.

Oh, it's just a suggestion..


> + *
> + * Parse according to the above format. Find out the file_name and build_id
> + * first and then use sdt_note__read() to parse the SDT note info.
> + * Find out the hash key from the file_name and use that to add this new
> + * entry to file hash.
> + */
> +static int file_hash_list__populate(struct hash_table *file_hash, FILE *cache)
> +{
> +	struct file_sdt_ent *fse;
> +	int key, val, ret = -EBADF;
> +	char data[2 * PATH_MAX], *ptr, *tmp;
> +
> +	for (val = fscanf(cache, "%s", data); val != EOF;
> +	     val = fscanf(cache, "%s", data)) {
> +		fse = malloc(sizeof(*fse));
> +		if (!fse) {
> +			ret = -ENOMEM;
> +			break;
> +		}
> +		INIT_LIST_HEAD(&fse->sdt_list);
> +		INIT_HLIST_NODE(&fse->file_list);
> +
> +		/* First line is file name and build id */
> +		ptr = strtok_r(data, ":", &tmp);
> +		if (!ptr)
> +			break;
> +		strcpy(fse->name, ptr);
> +		ptr = strtok_r(NULL, ":", &tmp);
> +		if (!ptr)
> +			break;
> +		strcpy(fse->sbuild_id, ptr);
> +
> +		/* Now, try to get the SDT notes for that file */
> +		while ((fscanf(cache, "%s", data)) != EOF) {
> +			if (!strcmp(data, ":"))
> +				break;
> +			ret = sdt_note__read(data, &fse->sdt_list);
> +			if (ret < 0)
> +				goto out;
> +		}
> +		key = get_hash_key(fse->name);
> +		hlist_add_head(&fse->file_list, &file_hash->ent[key]);
> +		ret = 0;
> +	}
> +out:
> +	return ret;
> +}
> +
> +/**
> + * file_hash_list__init: Initializes the file hash list
> + * @file_hash: empty file_hash
> + *
> + * Initializes the ent's of file_hash and opens the cache file.

What is the ent's?

> + * To look for the cache file, look into the directory in HOME env variable.
> + */
> +static int file_hash_list__init(struct hash_table *file_hash)
> +{
> +	FILE *cache;
> +	int i, ret = 0;
> +	char sdt_cache_path[MAXPATHLEN], *val;

s/MAXPATHLEN/PATH_MAX/ ?

> +
> +	for (i = 0; i < SDT_HASH_SIZE; i++)
> +		INIT_HLIST_HEAD(&file_hash->ent[i]);
> +
> +	val = getenv("HOME");
> +	if (val)
> +		snprintf(sdt_cache_path, MAXPATHLEN-1, "%s/%s/%s",
> +			 val, SDT_CACHE_DIR, SDT_FILE_CACHE);

Then you can use scnprintf(sdt_cache_path, sizeof(sdt_cache_path), ...).


> +	else {
> +		pr_err("Error: Couldn't get user's home directory\n");
> +		ret = -1;
> +		goto out;
> +	}
> +
> +	cache = fopen(sdt_cache_path, "r");
> +	if (cache == NULL)
> +		goto out;
> +
> +	/* Populate the hash list */
> +	ret = file_hash_list__populate(file_hash, cache);
> +	fclose(cache);
> +out:
> +	return ret;
> +}
> +
> +/**
> + * file_hash_list__cleanup: Frees up all the space taken by file_hash list
> + * @file_hash: file_hash table
> + */
> +static void file_hash_list__cleanup(struct hash_table *file_hash)
> +{
> +	struct file_sdt_ent *file_pos;
> +	struct list_head *sdt_head;
> +	struct hlist_head *ent_head;
> +	struct hlist_node *tmp;
> +	int i;
> +
> +	/* Go through all the entries */
> +	for (i = 0; i < SDT_HASH_SIZE; i++) {
> +		ent_head = &file_hash->ent[i];
> +
> +		hlist_for_each_entry_safe(file_pos, tmp, ent_head, file_list) {
> +			sdt_head = &file_pos->sdt_list;
> +
> +			/* Cleanup the corresponding SDT notes' list */
> +			cleanup_sdt_note_list(sdt_head);
> +			hlist_del(&file_pos->file_list);
> +			list_del(&file_pos->sdt_list);

Ditto.  Don't call list_del() but call cleanup_sdt_note_list directly.


> +			free(file_pos);
> +		}
> +	}
> +}
> +
> +
> +/**
> + * add_to_hash_list: add an entry to file_hash_list
> + * @file_hash: file hash table
> + * @target: file name
> + *
> + * Finds out the build_id of @target, checks if @target is already present
> + * in file hash list. If not present, delete any stale entries with this
> + * file name (i.e., entries matching this file name but having older
> + * build ids). And then, adds the file entry to file hash list and also
> + * updates the SDT events in the event hash list.
> + */
> +static int add_to_hash_list(struct hash_table *file_hash, const char *target)
> +{
> +	struct file_info *file;
> +	int ret = -EBADF;
> +	u8 build_id[BUILD_ID_SIZE];
> +
> +	LIST_HEAD(sdt_notes);
> +
> +	file = malloc(sizeof(*file));
> +	if (!file)
> +		return -ENOMEM;
> +
> +	file->name = realpath(target, NULL);
> +	if (!file->name) {
> +		pr_err("%s: Bad file name\n", target);
> +		goto out;
> +	}
> +
> +	symbol__elf_init();

No need to call symbol__elf_init() here since we already called it in
cmd_sdt_cache().


> +	if (filename__read_build_id(file->name, &build_id,
> +				    sizeof(build_id)) < 0) {
> +		pr_err("Couldn't read build-id in %s\n", file->name);
> +		sdt_err(ret, file->name);
> +		goto out;
> +	}
> +	build_id__sprintf(build_id, sizeof(build_id), file->sbuild_id);
> +
> +	/* File entry already exists ?*/
> +	if (file_hash_list__entry_exists(file_hash, file)) {
> +		pr_err("Error: SDT events for %s already exist\n",
> +		       file->name);
> +		ret = 0;
> +		goto out;
> +	}
> +
> +	/*
> +	 * This should remove any stale entries (if any) from the file hash.
> +	 * Stale entries will have the same file name but different build ids.
> +	 */
> +	ret = file_hash_list__remove(file_hash, file->name);
> +	if (ret < 0)
> +		goto out;
> +	ret = get_sdt_note_list(&sdt_notes, file->name);
> +	if (ret < 0)
> +		sdt_err(ret, target);
> +	/* Add the entry to file hash list */
> +	ret = file_hash_list__add(file_hash, &sdt_notes, file);
> +out:
> +	free(file->name);
> +	free(file);
> +	return ret;
> +}

[SNIP]
> +static int flush_hash_list_to_cache(struct hash_table *file_hash)
> +{
> +	FILE *cache;
> +	int ret;
> +	struct stat buf;
> +	char sdt_cache_path[MAXPATHLEN], sdt_dir[MAXPATHLEN], *val;
> +
> +	val = getenv("HOME");
> +	if (val) {
> +		snprintf(sdt_dir, MAXPATHLEN-1, "%s/%s", val, SDT_CACHE_DIR);
> +		snprintf(sdt_cache_path, MAXPATHLEN-1, "%s/%s",
> +			 sdt_dir, SDT_FILE_CACHE);

Ditto.  s/MAXPATHLEN/PATH_MAX/g and use scnprintf().

Thanks,
Namhyung


> +	} else {
> +		pr_err("Error: Couldn't get the user's home directory\n");
> +		ret = -1;
> +		goto out_err;
> +	}
> +	ret = stat(sdt_dir, &buf);
> +	if (ret) {
> +		ret = mkdir(sdt_dir, buf.st_mode);
> +		if (ret) {
> +			pr_err("Error: Couldn't create %s\n", sdt_dir);
> +			goto out_err;
> +		}
> +	}
> +
> +	cache = fopen(sdt_cache_path, "w");
> +	if (!cache) {
> +		pr_err("Error in creating %s file\n", sdt_cache_path);
> +		ret = -errno;
> +		goto out_err;
> +	}
> +
> +	file_hash_list__flush(file_hash, cache);
> +	fclose(cache);
> +out_err:
> +	return ret;
> +}
