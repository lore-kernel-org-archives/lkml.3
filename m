Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbaJWLvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:51:43 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:48174 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbaJWLvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:51:38 -0400
Message-ID: <5448EBC3.70009@hitachi.com>
Date: Thu, 23 Oct 2014 20:51:31 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v3 2/5] perf/sdt: Add SDT events into a cache
References: <20141010104402.15506.73285.stgit@hemant-fedora> <20141010105758.15506.20442.stgit@hemant-fedora>
In-Reply-To: <20141010105758.15506.20442.stgit@hemant-fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hermant,

(2014/10/10 19:58), Hemant Kumar wrote:
> +
> +/**
> + * sdt_note__read: Parse SDT note info
> + * @data: string containing the SDT note's info
> + * @sdt_list: empty list
> + *
> + * Parse @data to find out SDT note name, provider, location and semaphore.
> + * All these data are separated by DELIM.
> + */
> +static int sdt_note__read(char *data, struct list_head *sdt_list)

It seems that you can simply use sscanf() instead of this code, like this.

n = sscanf(data, "%ms:%ms:%lx:%lx", &sn->provider, &sn->name,
           &sn->addr.a64[0], &sn->addr.a64[2]);
if (n != 4)
	goto error;


> +{
> +	struct sdt_note *sn;
> +	char *tmp, *ptr, delim[2];
> +	int ret = -EBADF, val;
> +
> +	/* Initialize the delimiter with DELIM */
> +	delim[0] = DELIM;
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
> + * file_name:build_id\n
> + * ...
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

And no, to read one-line, please use fgets instead of fscanf.

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

Ditto.

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
> + * To look for the cache file, look into the directory in HOME env variable.
> + */
> +static int file_hash_list__init(struct hash_table *file_hash)
> +{
> +	FILE *cache;
> +	int i, ret = 0;
> +	char sdt_cache_path[MAXPATHLEN], *val;
> +
> +	for (i = 0; i < SDT_HASH_SIZE; i++)
> +		INIT_HLIST_HEAD(&file_hash->ent[i]);
> +
> +	val = getenv("HOME");
> +	if (val)
> +		snprintf(sdt_cache_path, MAXPATHLEN-1, "%s/%s/%s",
> +			 val, SDT_CACHE_DIR, SDT_FILE_CACHE);
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
> +
> +/**
> + * file_hash_list__flush: Flush the file_hash list to cache
> + * @file_hash: file_hash list
> + * @fcache: opened SDT events cache
> + *
> + * Iterate through all the entries of @file_hash and flush them
> + * onto fcache.
> + * The complete file hash list is flushed into the cache. Write the
> + * file entries for every ent of file_hash, alongwith the SDT notes. The
> + * delimiter used is DELIM.
> + */
> +static void file_hash_list__flush(struct hash_table *file_hash,
> +				  FILE *fcache)
> +{
> +	struct file_sdt_ent *file_pos;
> +	struct list_head *sdt_head;
> +	struct hlist_head *ent_head;
> +	struct sdt_note *sdt_ptr;
> +	int i;
> +
> +	/* Go through all entries */
> +	for (i = 0; i < SDT_HASH_SIZE; i++) {
> +		/* Obtain the list head */
> +		ent_head = &file_hash->ent[i];
> +
> +		/* DELIM is used here as delimiter */
> +		hlist_for_each_entry(file_pos, ent_head, file_list) {
> +			fprintf(fcache, "%s%c", file_pos->name, DELIM);
> +			fprintf(fcache, "%s\n", file_pos->sbuild_id);

Here, you also should merge these 2 sequential fprintfs.

> +			sdt_head = &file_pos->sdt_list;
> +			list_for_each_entry(sdt_ptr, sdt_head, note_list) {
> +				fprintf(fcache, "%s%c%s%c%lx%c%lx\n",
> +					sdt_ptr->provider, DELIM,
> +					sdt_ptr->name, DELIM,
> +					sdt_ptr->addr.a64[0], DELIM,
> +					sdt_ptr->addr.a64[2]);
> +			}
> +			/* This marks the end of the SDT notes for a file */
> +			fprintf(fcache, "%c\n", DELIM);
> +		}
> +	}
> +}
> +
> +/**
> + * flush_hash_list_to_cache: Flush everything from file_hash to disk
> + * @file_hash: file_hash list
> + *
> + * Opens a cache and calls file_hash_list__flush() to dump everything
> + * on to the cache. The cache file is to be opened in HOME env variable
> + * inside a directory ".sdt".

I think we can share $HOME/.debug/ with buildid, which uses .debug/.build-id/*.
So, perhaps, $HOME/.debug/.sdt-cache will be better filename (not dirname).

Thank you,

> + */
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
> +
> +/**
> + * add_sdt_events: Add SDT events
> + * @arg: filename
> + *
> + * Initializes a hash table 'file_hash', calls add_to_hash_list() to add
> + * SDT events of @arg to the cache and then cleans them up.
> + * 'file_hash' is a hash table which maintains all the information
> + * related to the files with the SDT events in them. The file name serves
> + * as the key to this hash list. Each entry of the file_hash table is a
> + * list head which contains a chain of 'file_list' entries. Each 'file_list'
> + * entry contains the list of SDT events found in that file. This hash
> + * serves as a mapping from file name to the SDT events.
> + */
> +int add_sdt_events(const char *arg)
> +{
> +	struct hash_table file_hash;
> +	int ret, val;
> +
> +	/* Initialize the file hash_list */
> +	ret = file_hash_list__init(&file_hash);
> +	if (ret < 0) {
> +		pr_err("Error: Couldn't initialize the SDT hash tables\n");
> +		goto out;
> +	}
> +	/* Try to add the events to the file hash_list */
> +	ret = add_to_hash_list(&file_hash, arg);
> +	if (ret > 0) {
> +		val = flush_hash_list_to_cache(&file_hash);
> +		if (val < 0) {
> +			ret = val;
> +			goto out;
> +		}
> +		printf("%4d events added for %s\n", ret, arg);
> +		ret = 0;
> +	}
> +
> +out:
> +	file_hash_list__cleanup(&file_hash);
> +	return ret;
> +}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


