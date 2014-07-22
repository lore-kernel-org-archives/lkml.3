Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbaGVLdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:33:51 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:41851 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaGVLdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:33:49 -0400
Message-ID: <53CE4C13.1000104@linux.vnet.ibm.com>
Date: Tue, 22 Jul 2014 17:03:39 +0530
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Subject: Re: [PATCH v2 1/3] perf/sdt : Listing of SDT markers by perf
References: <20140717054826.19995.61782.stgit@hemant-fedora> <20140717055341.19995.97042.stgit@hemant-fedora> <87vbqrjtyo.fsf@sejong.aot.lge.com>
In-Reply-To: <87vbqrjtyo.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072211-2674-0000-0000-0000010A42CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

On 07/21/2014 08:31 AM, Namhyung Kim wrote:
> Hi Hemant,
>
> On Thu, 17 Jul 2014 11:25:12 +0530, Hemant Kumar wrote:
>> This patch enables perf to list the SDT markers present in a system. It looks
>> in dsos given by ldconfig --print-cache and for other binaries, it looks into
>> the PATH environment variable. After preparing a list of the binaries, then
>> it starts searching for SDT markers in them.
>> To find the SDT markers, first an elf section named .note.stapsdt is searched
>> for. And then the SDT notes are retreived one by one from that section.
>> To counter the effect of prelinking, the section ".stapsdt.base" is searched.
>> If its found, then the location of the SDT marker is adjusted.
>>
>> All these markers' info is written into a cache file
>> "/var/cache/perf/perf-sdt.cache".
>> Since, the presence of SDT markers is quite common these days, hence, its better
>> to make them visible to a user easily. Also, creating a cache file will help a user
>> to probe (to be implemented) these markers without much hussle. This cache file will
>> hold most of the SDT markers.
>>
>> The format of each SDT cache entry is -
>>
>> %provider:marker:file_path:build_id:location:semaphore_loc
>>
>> % - marks the beginning of each entry.
>> provider - The provider name of the SDT marker.
>> marker - The marker name of the SDT marker.
>> file_path - Full/absolute path of the file in which this marker is present.
>> location : Adjusted location of the SDT marker inside the program.
>> semaphore_loc : The semaphore address if present otherwise 0x0.
>>
>> This format should help when probing will be implemented. The adjusted address
>> from the required entry can be directly used in probing if the build_id matches.
>>
>> To scan the system for SDT markers invoke :
>> # perf list sdt --scan
>>
>> "--scan" should be used for the first time and whenever there is any change in
>> the files containing the SDT markers. It looks into the common binaries available
>> in a system.
>>
>> And then use :
>> # perf list sdt
>>
>> This displays the list of SDT markers recorded in the SDT cache.
>> This shows the SDT markers present in the common binaries stored in the system,
>> present in PATH variable and the /lib/ and /lib64/ directories.
>>
>> Or use:
>> # perf list
>>
>> It should display all events including the SDT events.
>>
>> Signed-off-by : hemant@linux.vnet.ibm.com
> Missing your real name in the sob line.  (other patchse too)

Oops. Will add that!

>
>> ---
>>   tools/perf/Makefile.perf       |    1
>>   tools/perf/builtin-list.c      |    6
>>   tools/perf/util/parse-events.h |    3
>>   tools/perf/util/sdt.c          |  503 ++++++++++++++++++++++++++++++++++++++++
>>   tools/perf/util/symbol-elf.c   |  229 ++++++++++++++++++
>>   tools/perf/util/symbol.h       |   19 ++
>>   6 files changed, 760 insertions(+), 1 deletion(-)
>>   create mode 100644 tools/perf/util/sdt.c
>>
>> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
>> index 9670a16..e098dcd 100644
>> --- a/tools/perf/Makefile.perf
>> +++ b/tools/perf/Makefile.perf
>> @@ -373,6 +373,7 @@ LIB_OBJS += $(OUTPUT)util/stat.o
>>   LIB_OBJS += $(OUTPUT)util/record.o
>>   LIB_OBJS += $(OUTPUT)util/srcline.o
>>   LIB_OBJS += $(OUTPUT)util/data.o
>> +LIB_OBJS += $(OUTPUT)util/sdt.o
>>   
>>   LIB_OBJS += $(OUTPUT)ui/setup.o
>>   LIB_OBJS += $(OUTPUT)ui/helpline.o
>> diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
>> index 011195e..e1e654b 100644
>> --- a/tools/perf/builtin-list.c
>> +++ b/tools/perf/builtin-list.c
>> @@ -23,7 +23,7 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>>   		OPT_END()
>>   	};
>>   	const char * const list_usage[] = {
>> -		"perf list [hw|sw|cache|tracepoint|pmu|event_glob]",
>> +		"perf list [hw|sw|cache|tracepoint|pmu|event_glob|sdt]",
> Hmm.. I think it'd be better like below
>
> 		"perf list [hw|sw|cache|tracepoint|pmu|sdt|<event_glob>]",
>

Ok, looks good.

>>   		NULL
>>   	};
>>   
>> @@ -34,6 +34,8 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>>   
>>   	if (argc == 0) {
>>   		print_events(NULL, false);
>> +		printf("\n\nSDT events :\n");
>> +		sdt_cache__display();
> What about make print_events() to print SDT events also?

Hmm, alright.

>
>>   		return 0;
>>   	}
>>   
>> @@ -55,6 +57,8 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>>   			print_pmu_events(NULL, false);
>>   		else if (strcmp(argv[i], "--raw-dump") == 0)
>>   			print_events(NULL, true);
>> +		else if (strcmp(argv[i], "sdt") == 0)
>> +			print_sdt_events(argv[++i]);
> Please move this above the --raw-dump block, it's a special marker to
> help shell completion for event names so I'd like to keep it last.

Oh! will move that.

>
>>   		else {
>>   			char *sep = strchr(argv[i], ':'), *s;
>>   			int sep_idx;
>
> [SNIP]
>> +/*
>> + * Finds out the libraries present in a system as shown by the command
>> + * "ldconfig --print-cache". Uses "=>" and '/' to find out the start of a
>> + * dso path.
>> + */
> If we received the list of libraries from user directly, it can go
> away IMHO.
>

I may be wrong but I think until we close the pipe, the data will stay,
right?

>> +static char *parse_lib_name(char *str)
>> +{
>> +	char *ptr, *q, *r;
>> +
>> +	while (str != NULL) {
>> +		/* look for "=>" and then '/' */
>> +		ptr = strstr(str, "=>");
>> +		if (ptr) {
>> +			ptr++;
>> +			q = strchr(ptr, '/');
>> +			if (!q)
>> +				return NULL;
>> +			r = strchr(ptr, '\n');
>> +			*r = '\0';
>> +			return q;
>> +		} else if (ptr == NULL) {
>> +			return NULL;
>> +		} else {
>> +			str = ptr + 1;
>> +			continue;
>> +		}
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>> +/*
>> + * Checks if a path is already present in the list.
>> + * Returns 'true' if present and 'false' otherwise.
>> + */
>> +static bool is_present_in_list(struct list_head *path_list, char *path)
>> +{
>> +	struct path_list *tmp;
>> +
>> +	list_for_each_entry(tmp, path_list, list) {
>> +		if (!strcmp(path, tmp->path))
>> +			return true;
>> +	}
> As Andi pointed out, you can use a hashtable for this.

Ok, will use a hashtable for this.

>
>> +
>> +	return false;
>> +}
>> +
>> +static inline void append_path(char *path, struct list_head *list)
>> +{
>> +	char *res_path = NULL;
>> +	struct path_list *tmp = NULL;
>> +
>> +	res_path = (char *)malloc(sizeof(char) * PATH_MAX);
>> +
>> +	if (!res_path)
>> +		return;
>> +
>> +	memset(res_path, '\0', PATH_MAX);
>> +
>> +	if (realpath(path, res_path) && !is_present_in_list(list, res_path)) {
>> +		tmp = (struct path_list *) malloc(sizeof(struct path_list));
> Hmm... why not reusing res_path and make struct path_list to just have a
> pointer?  Also you can use readpath(path, NULL) rather than allocating
> a PATH_MAX buffer and zero'ing it (can use calloc for it anyway).
>

Ah! ok, will make the changes.

>> +		if (!tmp) {
>> +			free(res_path);
>> +			return;
>> +		}
>> +		strcpy(tmp->path, res_path);
>> +		list_add(&(tmp->list), list);
>> +		if (res_path)
>> +			free(res_path);
>> +	}
>> +}
>
> [SNIP]
>> +/*
>> + * Go through all the files inside "path".
>> + * But don't go into sub-directories.
>> + */
>> +static void walk_through_dir(char *path)
>> +{
>> +	struct dirent *entry;
>> +	DIR *dir;
>> +	struct stat sb;
>> +	int ret = 0;
>> +	char *swd;
>> +
>> +	dir = opendir(path);
>> +	if (!dir)
>> +		return;
>> +
>> +	/* save the current working directory */
>> +	swd = getcwd(NULL, 0);
>> +	if (!swd) {
>> +		pr_err("getcwd : error");
>> +		return;
>> +	}
>> +
>> +	ret = chdir(path);
>> +	if (ret) {
>> +		pr_err("chdir : error in %s", path);
>> +		return;
>> +	}
> Is this really needed?  I guess opendir() already covers possible
> failure cases, if not, we might use stat() anyway.
>
>
>> +	while ((entry = readdir(dir)) != NULL) {
>> +
>> +		ret = stat(entry->d_name, &sb);
>> +		if (ret == -1) {
>> +			pr_debug("%s : error in stat!\n", entry->d_name);
>> +			continue;
>> +		}
>> +
>> +		/* Not pursuing sub-directories */
>> +		if ((sb.st_mode & S_IFMT) != S_IFDIR)
>> +			if (sb.st_mode & S_IXUSR)
>> +				append_path(entry->d_name, &execs.list);
>> +	}
>> +
>> +	closedir(dir);
>> +
>> +	/* return to the saved working directory */
>> +	ret = chdir(swd);
>> +	if (ret) {
>> +		pr_err("chdir : error");
>> +		return;
>> +	}
>> +}
>
> [SNIP]
>> --- a/tools/perf/util/symbol-elf.c
>> +++ b/tools/perf/util/symbol-elf.c
>> @@ -1619,6 +1619,235 @@ void kcore_extract__delete(struct kcore_extract *kce)
>>   	unlink(kce->extract_filename);
>>   }
>>   
> Like I said earlier in a different thread, the below code can be a
> sepatate change.

Ok, will move that to a separate patch.

Thanks a lot for the review!

>
>
>> +static int populate_sdt_note(Elf **elf, const char *data, size_t len, int type,
>> +			     struct sdt_note **note)
>> +{
>> +	const char *provider, *name;
>> +	struct sdt_note *tmp = NULL;
>> +	GElf_Ehdr ehdr;
>> +	GElf_Addr base_off = 0;
>> [SNIP]

-- 
Thanks,
Hemant Kumar

