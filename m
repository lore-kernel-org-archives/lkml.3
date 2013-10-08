Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab3JHNJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:09:00 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:44119 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab3JHNI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:08:58 -0400
Message-ID: <525403D8.1010204@linux.vnet.ibm.com>
Date: Tue, 08 Oct 2013 18:38:40 +0530
From: Hemant <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v2 2/3] Support for perf to probe into SDT markers:
References: <20131007063911.11693.33624.stgit@hemant-fedora> <20131007064806.11693.23845.stgit@hemant-fedora> <878uy4ku2b.fsf@sejong.aot.lge.com>
In-Reply-To: <878uy4ku2b.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100813-9574-0000-0000-000009FA3D68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2013 02:39 PM, Namhyung Kim wrote:
> [...]
> +
> +		tmp = strdup(ptr);
> +		if (!tmp)
> +			return -ENOMEM;
> These -ENOMEM returning should free all memory region allocated
> previously.

Yes, missed that.

>
>> +		pev->point.note->name = tmp;
>> +		pev->group = pev->point.note->provider;
>> +		if (!pev->event)
>> +			pev->event = pev->point.note->name;
>> +		pev->sdt = true;
>> +		return 0;
>> +	}
>>   	ptr = strpbrk(arg, ";:+@%");
>>   	if (ptr) {
>>   		nc = *ptr;
>> @@ -1270,6 +1299,13 @@ static char *synthesize_perf_probe_point(struct perf_probe_point *pp)
>>   		ret = e_snprintf(buf, MAX_CMDLEN, "%s%s%s%s%s", pp->function,
>>   				 offs, pp->retprobe ? "%return" : "", line,
>>   				 file);
>> +	else if (pp->note)
>> +		if (pp->note->bit32)
>> +			ret = e_snprintf(buf, MAX_CMDLEN, "0x%x",
>> +					 pp->note->addr.a32[0]);
>> +		else
>> +			ret = e_snprintf(buf, MAX_CMDLEN, "0x%lx",
>> +					 pp->note->addr.a64[0]);
> This kind of code tends to cause 32/64-bit build problem.  Did you test
> it on a 32-bit system too?  Anyway, I think things like below should
> work:
>
> 		unsigned long long addr;
>
> 		if (pp->note->bit32)
> 			addr = pp->note->addr.a32[0];
> 		else
> 			addr = pp->note->addr.a64[0];
>
> 		ret = e_snprintf(buf, MAX_CMDLEN, "0x%llx", addr);
>

Looks better, thanks, will make the required changes.

>>   	else
>>   		ret = e_snprintf(buf, MAX_CMDLEN, "%s%s", file, line);
>>   	if (ret <= 0)
>> @@ -1923,6 +1959,19 @@ static void cleanup_sdt_note_list(struct list_head *sdt_notes)
>>   	}
>>   }
>>   
>> +static int try_to_find_sdt_notes(struct perf_probe_event *pev,
>> +				 const char *target)
>> +{
>> +	struct list_head sdt_notes;
>> +	int ret = -1;
>> +
>> +	INIT_LIST_HEAD(&sdt_notes);
> You can use just LIST_HEAD(sdt_notes) here.
>

Ok.

>> +	ret = search_sdt_note(pev->point.note, &sdt_notes, target);
>> +	if (!list_empty(&sdt_notes))
>> +		cleanup_sdt_note_list(&sdt_notes);
>> +	return ret;
>> +}
>> +
>>   static int convert_to_probe_trace_events(struct perf_probe_event *pev,
>>   					  struct probe_trace_event **tevs,
>>   					  int max_tevs, const char *target)
>> @@ -1930,11 +1979,20 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
>>   	struct symbol *sym;
>>   	int ret = 0, i;
>>   	struct probe_trace_event *tev;
>> +	char *buf;
>>   
>> -	/* Convert perf_probe_event with debuginfo */
>> -	ret = try_to_find_probe_trace_events(pev, tevs, max_tevs, target);
>> -	if (ret != 0)
>> -		return ret;	/* Found in debuginfo or got an error */
>> +	if (pev->sdt) {
>> +		ret = try_to_find_sdt_notes(pev, target);
>> +		if (ret)
>> +			return ret;
>> +	} else {
>> +		/* Convert perf_probe_event with debuginfo */
>> +		ret = try_to_find_probe_trace_events(pev, tevs, max_tevs,
>> +						     target);
>> +		/* Found in debuginfo or got an error */
>> +		if (ret != 0)
>> +			return ret;
>> +	}
>>   
>>   	/* Allocate trace event buffer */
>>   	tev = *tevs = zalloc(sizeof(struct probe_trace_event));
>> @@ -1942,10 +2000,25 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
>>   		return -ENOMEM;
>>   
>>   	/* Copy parameters */
>> -	tev->point.symbol = strdup(pev->point.function);
>> -	if (tev->point.symbol == NULL) {
>> -		ret = -ENOMEM;
>> -		goto error;
>> +	if (pev->sdt) {
>> +		buf = (char *)zalloc(sizeof(char) * MAX_CMDLEN);
>> +		if (!buf) {
>> +			ret = -ENOMEM;
>> +			goto error;
>> +		}
>> +		if (pev->point.note->bit32)
>> +			sprintf(buf, "0x%x",
>> +				(unsigned)pev->point.note->addr.a32[0]);
>> +		else
>> +			sprintf(buf, "0x%lx",
>> +				(unsigned long)pev->point.note->addr.a64[0]);
> Please see my comment above.

Ok. Will change that too.

>
>> +		tev->point.symbol = buf;
>> +	} else {
>> +		tev->point.symbol = strdup(pev->point.function);
>> +		if (tev->point.symbol == NULL) {
>> +			ret = -ENOMEM;
>> +			goto error;
>> +		}
>>   	}
>>   
>>   	if (target) {
>> diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
>> index b8a9347..4bd50cc 100644
>> --- a/tools/perf/util/probe-event.h
>> +++ b/tools/perf/util/probe-event.h
>> @@ -47,6 +47,7 @@ struct perf_probe_point {
>>   	bool		retprobe;	/* Return probe flag */
>>   	char		*lazy_line;	/* Lazy matching pattern */
>>   	unsigned long	offset;		/* Offset from function entry */
>> +	struct sdt_note *note;
> I guess what you need is a 'struct list_head'.

Yes, struct list_head will be a better choice in struct perf_probe_point.

>
>>   };
>>   
>>   /* Perf probe probing argument field chain */
>> @@ -72,6 +73,7 @@ struct perf_probe_event {
>>   	struct perf_probe_point	point;	/* Probe point */
>>   	int			nargs;	/* Number of arguments */
>>   	bool			uprobes;
>> +	bool                    sdt;
>>   	struct perf_probe_arg	*args;	/* Arguments */
>>   };
>>   
>> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
>> index 6b17260..d0e7a66 100644
>> --- a/tools/perf/util/symbol-elf.c
>> +++ b/tools/perf/util/symbol-elf.c
>> @@ -1022,6 +1022,86 @@ out_ret:
>>   	return ret;
>>   }
>>   
>> +static void adjust_note_addr(struct sdt_note *tmp, struct sdt_note *key,
>> +			     Elf *elf)
>> +{
>> +	GElf_Ehdr ehdr;
>> +	GElf_Addr base_off = 0;
>> +	GElf_Shdr shdr;
>> +
>> +	if (!gelf_getehdr(elf, &ehdr)) {
>> +		pr_debug("%s : cannot get elf header.\n", __func__);
>> +		return;
>> +	}
>> +
>> +	/*
>> +	 * Find out the .stapsdt.base section.
>> +	 * This scn will help us to handle prelinking (if present).
>> +	 * Compare the retrieved file offset of the base section with the
>> +	 * base address in the description of the SDT note. If its different,
>> +	 * then accordingly, adjust the note location.
>> +	 */
>> +	if (elf_section_by_name(elf, &ehdr, &shdr, SDT_BASE, NULL))
>> +		base_off = shdr.sh_offset;
>> +	if (base_off) {
>> +		if (tmp->bit32)
>> +			key->addr.a32[0] = tmp->addr.a32[0] + base_off -
>> +				tmp->addr.a32[1];
>> +		else
>> +			key->addr.a64[0] = tmp->addr.a64[0] + base_off -
>> +				tmp->addr.a64[1];
>> +	}
>> +	key->bit32 = tmp->bit32;
>> +}
>> +
>> +int search_sdt_note(struct sdt_note *key, struct list_head *sdt_notes,
>> +		    const char *target)
>> +{
>> +	Elf *elf;
>> +	int fd, ret = -1;
>> +	struct list_head *pos = NULL, *head = NULL;
>> +	struct sdt_note *tmp = NULL;
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
>> +		pr_err("%s : can't read %s ELF file.\n", __func__, target);
>> +		goto out_close;
>> +	}
>> +
>> +	head = construct_sdt_notes_list(elf);
>> +	if (!head)
>> +		goto out_end;
>> +
>> +	list_add(sdt_notes, head);
> This list code looks strange.
>

Won't need that after making the required changes.

>> +
>> +	/* Iterate through the notes and retrieve the required note */
>> +	list_for_each(pos, sdt_notes) {
>> +		tmp = list_entry(pos, struct sdt_note, note_list);
>> +		if (!strcmp(key->name, tmp->name) &&
>> +		    !strcmp(key->provider, tmp->provider)) {
>> +			adjust_note_addr(tmp, key, elf);
>> +			ret = 0;
>> +			break;
>> +		}
>> +	}
>> +	if (ret)
>> +		printf("%%%s:%s not found!\n", key->provider, key->name);
>> +
>> +out_end:
>> +	elf_end(elf);
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
>> index 037185c..0b0545b 100644
>> --- a/tools/perf/util/symbol.h
>> +++ b/tools/perf/util/symbol.h
>> @@ -260,9 +260,12 @@ void __map_groups__fixup_end(struct map_groups *mg, enum map_type type);
>>   
>>   /* Specific to SDT notes */
>>   int get_sdt_note_list(struct list_head *head, const char *target);
>> +int search_sdt_note(struct sdt_note *key, struct list_head *head,
>> +		    const char *target);
>>   
>>   #define SDT_NOTE_TYPE 3
>>   #define NOTE_SCN ".note.stapsdt"
>>   #define SDT_NOTE_NAME "stapsdt"
>> +#define SDT_BASE ".stapsdt.base"
> What about SDT_BASE_SCN ?

Seems better.

-- 
Thanks
Hemant

