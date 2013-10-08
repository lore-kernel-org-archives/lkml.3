Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab3JHNEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:04:45 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:51463 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab3JHNEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:04:43 -0400
Message-ID: <525402CF.9060701@linux.vnet.ibm.com>
Date: Tue, 08 Oct 2013 18:34:15 +0530
From: Hemant <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v2 1/3] SDT markers listing by perf:
References: <20131007063911.11693.33624.stgit@hemant-fedora> <20131007064707.11693.27056.stgit@hemant-fedora> <87d2ngkuly.fsf@sejong.aot.lge.com>
In-Reply-To: <87d2ngkuly.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100813-7014-0000-0000-000003BB158D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2013 02:27 PM, Namhyung Kim wrote:
> Hi Hemant,

Hi and thanks for reviewing the patches...

>
> On Mon, 07 Oct 2013 12:17:57 +0530, Hemant Kumar wrote:
>> [...]
>> +static void cleanup_sdt_note_list(struct list_head *sdt_notes)
>> +{
>> +	struct sdt_note *tmp;
>> +	struct list_head *pos, *s;
>> +
>> +	list_for_each_safe(pos, s, sdt_notes) {
>> +		tmp = list_entry(pos, struct sdt_note, note_list);
> You might use list_for_each_entry_safe() instead.

Ok, will use that.

>
>> +		list_del(pos);
>> +		free(tmp->name);
>> +		free(tmp->provider);
>> +		free(tmp);
>> +	}
>> +}
>> +
>>   static int convert_to_probe_trace_events(struct perf_probe_event *pev,
>>   					  struct probe_trace_event **tevs,
>>   					  int max_tevs, const char *target)
>> @@ -2372,3 +2386,28 @@ out:
>>   		free(name);
>>   	return ret;
>>   }
>> +
>> +static void display_sdt_note_info(struct list_head *start)
>> +{
>> +	struct list_head *pos;
>> +	struct sdt_note *tmp;
>> +
>> +	list_for_each(pos, start) {
>> +		tmp = list_entry(pos, struct sdt_note, note_list);
> Ditto.  list_for_each_entry().

Ok...

>
>> +		printf("%%%s:%s\n", tmp->provider, tmp->name);
>> +	}
>> +}
>> +
>> +int show_sdt_notes(const char *target)
>> +{
>> +	struct list_head sdt_notes;
>> +	int ret = -1;
>> +
>> +	INIT_LIST_HEAD(&sdt_notes);
> You can use LIST_HEAD(sdt_notes) here.

Yes. Will use LIST_HEAD() instead.

>
>> +	ret = get_sdt_note_list(&sdt_notes, target);
>> +	if (!ret) {
>> +		display_sdt_note_info(&sdt_notes);
>> +		cleanup_sdt_note_list(&sdt_notes);
>> +	}
>> +	return ret;
>> +}
>> diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
>> index f9f3de8..b8a9347 100644
>> --- a/tools/perf/util/probe-event.h
>> +++ b/tools/perf/util/probe-event.h
>> @@ -133,7 +133,7 @@ extern int show_available_vars(struct perf_probe_event *pevs, int npevs,
>>   			       struct strfilter *filter, bool externs);
>>   extern int show_available_funcs(const char *module, struct strfilter *filter,
>>   				bool user);
>> -
>> +int show_sdt_notes(const char *target);
>>   /* Maximum index number of event-name postfix */
>>   #define MAX_EVENT_INDEX	1024
>>   
>> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
>> index 4b12bf8..6b17260 100644
>> --- a/tools/perf/util/symbol-elf.c
>> +++ b/tools/perf/util/symbol-elf.c
>> @@ -846,6 +846,182 @@ out_elf_end:
>>   	return err;
>>   }
>>   
>> +/*
>> + * Populate the name, type, offset in the SDT note structure and
>> + * ignore the argument fields (for now)
>> + */
>> +static struct sdt_note *populate_sdt_note(Elf **elf, const char *data,
>> +					  size_t len, int type)
>> +{
>> +	const char *provider, *name;
>> +	struct sdt_note *note;
>> +
>> +	/*
>> +	 * Three addresses need to be obtained :
>> +	 * Marker location, address of base section and semaphore location
>> +	 */
>> +	union {
>> +		Elf64_Addr a64[3];
>> +		Elf32_Addr a32[3];
>> +	} buf;
>> +
>> +	/*
>> +	 * dst and src are required for translation from file to memory
>> +	 * representation
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
>> +	/* Check the type of each of the notes */
>> +	if (type != SDT_NOTE_TYPE)
>> +		goto out_ret;
>> +
>> +	note = (struct sdt_note *)zalloc(sizeof(struct sdt_note));
>> +	if (note == NULL) {
>> +		pr_err("Memory allocation error\n");
>> +		goto out_ret;
>> +	}
>> +	INIT_LIST_HEAD(&note->note_list);
>> +
>> +	if (len < dst.d_size + 3)
>> +		goto out_free;
>> +
>> +	/* Translation from file representation to memory representation */
>> +	if (gelf_xlatetom(*elf, &dst, &src,
>> +			  elf_getident(*elf, NULL)[EI_DATA]) == NULL)
>> +		pr_debug("gelf_xlatetom : %s", elf_errmsg(-1));
> I doubt this translation is really needed as we only deal with SDTs on a
> local system only, right?

In case of SDTs on a local system, we don't need gelf_xlatetom().

>> +
>> +	/* Populate the fields of sdt_note */
>> +	provider = data + dst.d_size;
>> +
>> +	name = (const char *)memchr(provider, '\0', data + len - provider);
>> +	if (name++ == NULL)
>> +		goto out_free;
>> +	note->provider = strdup(provider);
>> +	note->name = strdup(name);
> You need to check the return value of strdup's and it should also be
> freed when an error occurres after this.

Missed that. Thanks for pointing that out.

>> [...]
>> +	/* Get the SDT notes */
>> +	for (offset = 0; (next = gelf_getnote(data, offset, &nhdr, &name_off,
>> +					      &desc_off)) > 0; offset = next) {
>> +		if (nhdr.n_namesz == sizeof(SDT_NOTE_NAME) &&
>> +		    !memcmp(data->d_buf + name_off, SDT_NOTE_NAME,
>> +			    sizeof(SDT_NOTE_NAME))) {
>> +			tmp = populate_sdt_note(&elf, (const char *)
>> +						((long)(data->d_buf) +
>> +						 (long)desc_off),
> It seems that data->d_buf is type of void *, so these casts can go away,
> I guess.

Yeah correct, we don't need these casts.

>> +						nhdr.n_descsz, nhdr.n_type);
>> +			if (!note && tmp)
>> +				note = tmp;
>> +			else if (tmp)
>> +				list_add_tail(&tmp->note_list,
>> +					      &(note->note_list));
>> +		}
>> +	}
>> +	if (tmp)
>> +		return &tmp->note_list;
> This list handling code looks very strange to me.  Why not just passing
> a list head and connect notes to it?
>

Yes it will be better to use list_head...

>> +out_err:
>> +	return NULL;
>> +}
>> +
>> +int get_sdt_note_list(struct list_head *head, const char *target)
>> +{
>> +	Elf *elf;
>> +	int fd, ret = -1;
>> +	struct list_head *tmp = NULL;
>> +
>> +	fd = open(target, O_RDONLY);
>> +	if (fd < 0) {
>> +		pr_err("Failed to open %s\n", target);
>> +		goto out_ret;
>> +	}
>> +
>> +	symbol__elf_init();
>> +	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
>> +	if (!elf) {
>> +		pr_err("%s: cannot read %s ELF file.\n", __func__, target);
>> +		goto out_close;
>> +	}
>> +	tmp = construct_sdt_notes_list(elf);
>> +	if (tmp) {
>> +		list_add(head, tmp);
> Look like the params are exchanged?
>
>    /**
>     * list_add - add a new entry
>     * @new: new entry to be added
>     * @head: list head to add it after
>     *
>     * Insert a new entry after the specified head.
>     * This is good for implementing stacks.
>     */
>    static inline void list_add(struct list_head *new, struct list_head *head)
>    {
>    	__list_add(new, head, head->next);
>    }
>


I guess they won't be exchanged... tmp will be added to head, right? 
Anyway, this won't be needed if we go with list_head in struct 
probe_point instead of sdt_note. Will make the required changes.

>> +		ret = 0;
>> +	}
>> +	elf_end(elf);
>> +
>> +out_close:
>> +	close(fd);
>> +out_ret:
>> +	return ret;
>> +}
>> +
>>   void symbol__elf_init(void)
>>   {
>>   	elf_version(EV_CURRENT);
>> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
>> index 5f720dc..037185c 100644
>> --- a/tools/perf/util/symbol.h
>> +++ b/tools/perf/util/symbol.h
>> @@ -197,6 +197,17 @@ struct symsrc {
>>   #endif
>>   };
>>   
>> +struct sdt_note {
>> +	char *name;
>> +	char *provider;
>> +	bool bit32;                 /* 32 or 64 bit flag */
>> +	union {
>> +		Elf64_Addr a64[3];
>> +		Elf32_Addr a32[3];
>> +	} addr;
>> +	struct list_head note_list;
>> +};
>> +
>>   void symsrc__destroy(struct symsrc *ss);
>>   int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
>>   		 enum dso_binary_type type);
>> @@ -247,4 +258,11 @@ void symbols__fixup_duplicate(struct rb_root *symbols);
>>   void symbols__fixup_end(struct rb_root *symbols);
>>   void __map_groups__fixup_end(struct map_groups *mg, enum map_type type);
>>   
>> +/* Specific to SDT notes */
>> +int get_sdt_note_list(struct list_head *head, const char *target);
>> +
>> +#define SDT_NOTE_TYPE 3
>> +#define NOTE_SCN ".note.stapsdt"
> What about SDT_NOTE_SCN for consistency?

Seems better. Will change to that.

-- 
Thanks
Hemant

