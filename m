Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab3IDRiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:38:08 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:42668 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232Ab3IDRiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:38:05 -0400
Message-ID: <52276FF5.9050808@linux.vnet.ibm.com>
Date: Wed, 04 Sep 2013 23:07:57 +0530
From: Hemant <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, mingo@redhat.com,
        anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 1/2] SDT markers listing by perf
References: <20130903072944.4793.93584.stgit@hemant-fedora> <20130903073655.4793.20013.stgit@hemant-fedora> <87ioyht7e4.fsf@sejong.aot.lge.com>
In-Reply-To: <87ioyht7e4.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090417-5564-0000-0000-0000098FE508
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 12:12 PM, Namhyung Kim wrote:
> On Tue, 03 Sep 2013 13:06:55 +0530, Hemant Kumar wrote:
>
> [SNIP]
>
>> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
>> index e8a66f9..3d8dcdf 100644
>> --- a/tools/perf/builtin-probe.c
>> +++ b/tools/perf/builtin-probe.c
>> @@ -55,6 +55,7 @@ static struct {
>>   	bool show_funcs;
>>   	bool mod_events;
>>   	bool uprobes;
>> +	bool sdt;
>>   	int nevents;
>>   	struct perf_probe_event events[MAX_PROBES];
>>   	struct strlist *dellist;
>> @@ -325,6 +326,8 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>>   		     opt_set_filter),
>>   	OPT_CALLBACK('x', "exec", NULL, "executable|path",
>>   			"target executable name or path", opt_set_target),
>> +	OPT_BOOLEAN('S', "sdt", &params.sdt,
>> +		    "Show and probe on the SDT markers"),
> You need to add it to Documentation/perf-probe.txt too.  In addition if
> the --sdt option is only able to work with libelf, it should be wrapped
> into the #ifdef LIBELF_SUPPORT pair.
First of all, thanks for the review.
Yes, will add it to the Documentation. And, yes, it should be wrapped 
around #ifdef LIBELF_SUPPORT pair... Will do that in the next iteration.

>
> And I'm not sure that it's a good idea to have two behavior on a single
> option (S) - show and probe (add).  Maybe it can be separated into two
> or the S option can be used as a flag with existing --list and --add
> option?

Hmmm, I will have to think more on this issue. But I think, adding -S 
(--sdt) flag to the existing --list option will be a bit confusing. I 
thought of keeping the actions related to sdt markers separate. Let me 
do some more thinking on this issue.

>
>
>>   	OPT_END()
>>   	};
>>   	int ret;
>> @@ -355,6 +358,28 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>>   	 */
>>   	symbol_conf.try_vmlinux_path = (symbol_conf.vmlinux_name == NULL);
>>   
>> +	if (params.sdt) {
>> +		if (params.show_lines) {
>> +			pr_err("  Error: Don't use --sdt with --line.\n");
>> +			usage_with_options(probe_usage, options);
>> +		}
>> +		if (params.show_vars) {
>> +			pr_err(" Error: Don't use --sdt with --vars.\n");
>> +			usage_with_options(probe_usage, options);
>> +		}
>> +		if (params.show_funcs) {
>> +			pr_err("  Error: Don't use --sdt with --funcs.\n");
>> +			usage_with_options(probe_usage, options);
>> +		}
>> +		if (params.list_events) {
>> +			ret = show_available_markers(params.target);
>> +			if (ret < 0)
>> +				pr_err("  Error: Failed to show markers."
>> +				       " (%d)\n", ret);
>> +			return ret;
>> +		}
>> +	}
>> +
>>   	if (params.list_events) {
>>   		if (params.mod_events) {
>>   			pr_err("  Error: Don't use --list with --add/--del.\n");
>> @@ -382,6 +407,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>>   			       ret);
>>   		return ret;
>>   	}
>> +
>>   	if (params.show_funcs) {
>>   		if (params.nevents != 0 || params.dellist) {
>>   			pr_err("  Error: Don't use --funcs with"
>> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
>> index aa04bf9..7f846f9 100644
>> --- a/tools/perf/util/probe-event.c
>> +++ b/tools/perf/util/probe-event.c
>> @@ -2372,3 +2372,9 @@ out:
>>   		free(name);
>>   	return ret;
>>   }
>> +
>> +int show_available_markers(const char *target)
>> +{
>> +	setup_pager();
>> +	return list_markers(target);
>> +}
> Did you build it with NO_LIBELF=1 ?  I guess not.  At least you need a
> dummy list_markers() function which just returns -1 for such case.

No, I didn't. Ok, will add one dummy list_markers() function in the next 
iteration.

>
>
>> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
>> index 4b12bf8..f3630f2 100644
>> --- a/tools/perf/util/symbol-elf.c
>> +++ b/tools/perf/util/symbol-elf.c
>> @@ -846,6 +846,211 @@ out_elf_end:
>>   	return err;
>>   }
>>   
>> +/* Populate the name, type, offset and argument fields in the note structure */
>> +static struct sdt_note *populate_note(Elf **elf, const char *data, size_t len,
>> +				      int type)
> Hmm.. I think the name needs to be changed more specific like
> populate_sdt_note() or something?

Hmm, seems reasonable. Will do that.

>
>
>> +{
>> +	const char *provider, *name, *args;
>> +	struct sdt_note *note;
>> +
>> +	/*
>> +	 * There are 3 address values to be obtained: marker offset, base address
>> +	 * and semaphore
>> +	 */
>> +	union {
>> +		Elf64_Addr a64[3];
>> +		Elf32_Addr a32[3];
>> +	} buf;
>> +
>> +	/*
>> +	 * dst and src (of Elf_Data) are required for translation from file
>> +	 * to memory representation
>> +	 */
>> +	Elf_Data dst = {
>> +		.d_buf = &buf, .d_type = ELF_T_ADDR, .d_version = EV_CURRENT,
>> +		.d_size = gelf_fsize((*elf), ELF_T_ADDR, 3, EV_CURRENT),
>> +		.d_off = 0, .d_align = 0
>> +	};
>> +
>> +	Elf_Data src = {
>> +		.d_buf = (void *) data, .d_type = ELF_T_ADDR,
>> +		.d_version = EV_CURRENT, .d_size = dst.d_size, .d_off = 0,
>> +		.d_align = 0
>> +	};
>> +
>> +	if (type != SDT_NOTE_TYPE)
>> +		goto out_ret;
>> +
>> +	note = zalloc(sizeof(struct sdt_note));
>> +	if (note == NULL) {
>> +		pr_err("memory allocation error\n");
>> +		goto out_ret;
>> +	}
>> +	note->next = NULL;
>> +
>> +	if (len < dst.d_size + 3)
>> +		goto out_free;
>> +	/*
>> +	 * Translating from file representation to memory representation
>> +	 * Data now points to the address (offset)
>> +	 */
>> +	if (gelf_xlatetom((*elf), &dst, &src,
>> +			  elf_getident((*elf), NULL)[EI_DATA]) == NULL)
>> +		pr_debug("gelf_xlatetom : %s", elf_errmsg(-1));
>> +
>> +	/* Populate the fields of sdt_note */
>> +	provider = data + dst.d_size;
>> +
>> +	name = (const char *)memchr(provider, '\0', data + len - provider);
>> +	if (name++ == NULL)
>> +		goto out_ret;
>> +
>> +	args = (const char *)memchr(name, '\0', data + len - name);
>> +	if (args++ == NULL ||
>> +	    memchr(args, '\0', data + len - name) != data + len - 1)
>> +		goto out_ret;
>> +	note->provider = provider;
>> +	note->name = name;
>> +
>> +	/* Three addr's for location, base and semaphore addresses */
>> +	note->addr.a64[0] = (buf.a64[0]);
>> +	note->addr.a64[1] = (buf.a64[1]);
>> +	note->addr.a64[2] = (buf.a64[2]);
>> +	return note;
>> +
>> +out_free:
>> +	free(note);
>> +out_ret:
>> +	return NULL;
>> +}
>> +
>> +/*
>> + * Traverse the elf of the object, find out the .note.stapsdt section
>> + * and accordingly initialize the notes' list head
>> + */
>> +static struct sdt_note *get_elf_markers(Elf *elf, bool *exe, bool probe)
> Ditto.  How about get_sdt_markers() or get_sdt_notes()?  I can see that
> there are places those 'marker' and 'note' are used here and there.  If
> they indicate same thing it'd better to unify the term.

Yes, unifying them will be a better approach. Will modify these.

>
>
>> +{
>> +	Elf_Scn *scn = NULL;
>> +	Elf_Data *data;
>> +	GElf_Shdr shdr;
>> +	GElf_Ehdr ehdr;
>> +	size_t  shstrndx;
>> +	size_t next;
>> +	GElf_Nhdr nhdr;
>> +	size_t name_off, desc_off, offset;
>> +	struct sdt_note *note = NULL, *tmp, *head = NULL;
>> +
>> +	if (gelf_getehdr(elf, &ehdr) == NULL) {
>> +		pr_debug("%s: cannot get elf header.\n", __func__);
>> +		goto out_end;
>> +	}
>> +
>> +	if (elf_getshdrstrndx(elf, &shstrndx) != 0) {
>> +		pr_debug("getshdrstrndx failed\n");
>> +		goto out_end;
>> +	}
>> +
>> +	/* library or exec */
>> +	if (probe) {
>> +		if (ehdr.e_type == ET_EXEC)
>> +			*exe = true;
>> +	}
>> +
>> +	/*
>> +	 * Look for Section type = SHT_NOTE, flags = no SHF_ALLOC
>> +	 * and name = .note.stapsdt
>> +	 */
>> +	scn = elf_section_by_name(elf, &ehdr, &shdr, NOTE_SCN, NULL);
>> +	if (scn == NULL) {
>> +		pr_err("%s section not found!\n", NOTE_SCN);
>> +		goto out_end;
>> +	}
>> +
>> +	if (!(shdr.sh_type == SHT_NOTE) || (shdr.sh_flags & SHF_ALLOC))
>> +		goto out_end;
>> +
>> +	data = elf_getdata(scn, NULL);
>> +
>> +	/* Get the notes */
>> +	for (offset = 0; (next = gelf_getnote(data, offset, &nhdr, &name_off,
>> +					      &desc_off)) > 0; offset = next) {
>> +		tmp = populate_note(&elf, (const char *)((long)(data->d_buf) +
>> +							 (long)desc_off),
>> +				    nhdr.n_descsz, nhdr.n_type);
> Shouldn't we check the name of note being "stapsdt" as well as version
> (type) 3?

Since, we are already fetching the section NOTE_SCN (".note.stapsdt") 
and then we check for the type being SHT_NOTE and SHF_ALLOC, is it 
required to do the same for the individual notes?

Thanks
Hemant
>
> Thanks,
> Namhyung
>
>
>> +		/* For first note */
>> +		if (!head) {
>> +			note = tmp;
>> +			head = note;
>> +			continue;
>> +		}
>> +		note->next = tmp;
>> +		note = note->next;
>> +	}
>> +
>> +	if (!head)
>> +		pr_err("No markers found\n");
>> +
>> +out_end:
>> +	return head;
>> +}
>> +
>> +static void print_notes(struct sdt_note *start)
>> +{
>> +	struct sdt_note *temp;
>> +	int c;
>> +
>> +	for (temp = start, c = 0; temp != NULL; temp = temp->next, c++)
>> +		printf("%s:%s\n", temp->provider, temp->name);
>> +
>> +	printf("\nTotal markers = %d\n", c);
>> +}
>> +
>> +int list_markers(const char *name)
>> +{
>> +	int fd, ret = -1;
>> +	Elf *elf;
>> +	struct sdt_note *head = NULL;
>> +
>> +	fd = open(name, O_RDONLY);
>> +	if (fd < 0) {
>> +		pr_err("Failed to open %s\n", name);
>> +		goto out_ret;
>> +	}
>> +
>> +	symbol__elf_init();
>> +	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
>> +	if (elf == NULL) {
>> +		pr_err("%s: cannot read %s ELF file.\n", __func__, name);
>> +		goto out_close;
>> +	}
>> +
>> +	head = get_elf_markers(elf, NULL, false);
>> +	if (head) {
>> +		print_notes(head);
>> +		cleanup_notes(head);
>> +		ret = 0;
>> +	} else {
>> +		pr_err("No SDT markers found in %s\n", name);
>> +	}
>> +	elf_end(elf);
>> +
>> +out_close:
>> +	close(fd);
>> +out_ret:
>> +	return ret;
>> +}
>> +
>> +void cleanup_notes(struct sdt_note *start)
>> +{
>> +	struct sdt_note *tmp;
>> +
>> +	while (start) {
>> +		tmp = start->next;
>> +		free(start);
>> +		start = tmp;
>> +	}
>> +}
>> +
>>   void symbol__elf_init(void)
>>   {
>>   	elf_version(EV_CURRENT);
>> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
>> index 5f720dc..f2d17b7 100644
>> --- a/tools/perf/util/symbol.h
>> +++ b/tools/perf/util/symbol.h
>> @@ -197,6 +197,17 @@ struct symsrc {
>>   #endif
>>   };
>>   
>> +/* Note structure */
>> +struct sdt_note {
>> +	const char *name;
>> +	const char *provider;
>> +	union {
>> +		Elf64_Addr a64[3];
>> +		Elf32_Addr a32[3];
>> +	} addr;
>> +	struct sdt_note *next;
>> +};
>> +
>>   void symsrc__destroy(struct symsrc *ss);
>>   int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
>>   		 enum dso_binary_type type);
>> @@ -247,4 +258,12 @@ void symbols__fixup_duplicate(struct rb_root *symbols);
>>   void symbols__fixup_end(struct rb_root *symbols);
>>   void __map_groups__fixup_end(struct map_groups *mg, enum map_type type);
>>   
>> +/* For SDT markers */
>> +int show_available_markers(const char *module);
>> +int list_markers(const char *name);
>> +void cleanup_notes(struct sdt_note *start);
>> +
>> +#define SDT_NOTE_TYPE 3
>> +#define NOTE_SCN ".note.stapsdt"
>> +
>>   #endif /* __PERF_SYMBOL */

