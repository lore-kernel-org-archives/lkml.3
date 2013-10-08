Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab3JHI5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:57:52 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:45585 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab3JHI5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:57:48 -0400
X-AuditID: 9c93017d-b7c3aae000004019-b4-5253c909e635
From: Namhyung Kim <namhyung@kernel.org>
To: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v2 1/3] SDT markers listing by perf:
References: <20131007063911.11693.33624.stgit@hemant-fedora>
	<20131007064707.11693.27056.stgit@hemant-fedora>
Date: Tue, 08 Oct 2013 17:57:45 +0900
In-Reply-To: <20131007064707.11693.27056.stgit@hemant-fedora> (Hemant Kumar's
	message of "Mon, 07 Oct 2013 12:17:57 +0530")
Message-ID: <87d2ngkuly.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hemant,

On Mon, 07 Oct 2013 12:17:57 +0530, Hemant Kumar wrote:
> This patch will enable perf to list all the sdt markers present
> in an elf file. The markers are present in the .note.stapsdt section
> of the elf. We can traverse through this section and collect the
> required info about the markers.
> We can use '-S/--markers' with perf to view the SDT notes.
>
> Currently, the sdt notes which have their semaphores enabled, are being
> ignored silently. But, they will be supported soon.
>
> I think wrapping this inside #ifdef LIBELF_SUPPORT pair is not required,
> because, if NO_LIBELF = 1, then 'probe' command of perf is itself disabled.
>
> Usage:
> perf probe --markers -x /lib64/libc.so.6
>
> Output :
> %libc:setjmp
> %libc:longjmp
> %libc:longjmp_target
> %libc:lll_futex_wake
> %libc:lll_lock_wait_private
> %libc:longjmp
> %libc:longjmp_target
> %libc:lll_futex_wake
>
> Signed-off-by: Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com>
> ---
>  tools/perf/builtin-probe.c    |   24 +++++-
>  tools/perf/util/probe-event.c |   39 +++++++++
>  tools/perf/util/probe-event.h |    2 
>  tools/perf/util/symbol-elf.c  |  176 +++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/symbol.h      |   18 ++++
>  5 files changed, 257 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> index e8a66f9..cbd2383 100644
> --- a/tools/perf/builtin-probe.c
> +++ b/tools/perf/builtin-probe.c
> @@ -55,6 +55,7 @@ static struct {
>  	bool show_funcs;
>  	bool mod_events;
>  	bool uprobes;
> +	bool sdt;
>  	int nevents;
>  	struct perf_probe_event events[MAX_PROBES];
>  	struct strlist *dellist;
> @@ -325,6 +326,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>  		     opt_set_filter),
>  	OPT_CALLBACK('x', "exec", NULL, "executable|path",
>  			"target executable name or path", opt_set_target),
> +	OPT_BOOLEAN('S', "markers", &params.sdt, "Show probe-able sdt notes"),
>  	OPT_END()
>  	};
>  	int ret;
> @@ -347,7 +349,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>  		params.max_probe_points = MAX_PROBES;
>  
>  	if ((!params.nevents && !params.dellist && !params.list_events &&
> -	     !params.show_lines && !params.show_funcs))
> +	     !params.show_lines && !params.show_funcs && !params.sdt))
>  		usage_with_options(probe_usage, options);
>  
>  	/*
> @@ -355,6 +357,26 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>  	 */
>  	symbol_conf.try_vmlinux_path = (symbol_conf.vmlinux_name == NULL);
>  
> +	if (params.sdt) {
> +		if (params.show_lines) {
> +			pr_err("Error: Don't use --markers with --lines.\n");
> +			usage_with_options(probe_usage, options);
> +		}
> +		if (params.show_vars) {
> +			pr_err("Error: Don't use --markers with --vars.\n");
> +			usage_with_options(probe_usage, options);
> +		}
> +		if (params.show_funcs) {
> +			pr_err("Error: Don't use --markers with --funcs.\n");
> +			usage_with_options(probe_usage, options);
> +		}
> +		ret = show_sdt_notes(params.target);
> +		if (ret < 0) {
> +			pr_err("  Error : Failed to find SDT markers!"
> +			       "(%d)\n", ret);
> +		}
> +		return ret;
> +	}
>  	if (params.list_events) {
>  		if (params.mod_events) {
>  			pr_err("  Error: Don't use --list with --add/--del.\n");
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index aa04bf9..4e94092 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -1909,6 +1909,20 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
>  	return ret;
>  }
>  
> +static void cleanup_sdt_note_list(struct list_head *sdt_notes)
> +{
> +	struct sdt_note *tmp;
> +	struct list_head *pos, *s;
> +
> +	list_for_each_safe(pos, s, sdt_notes) {
> +		tmp = list_entry(pos, struct sdt_note, note_list);

You might use list_for_each_entry_safe() instead.


> +		list_del(pos);
> +		free(tmp->name);
> +		free(tmp->provider);
> +		free(tmp);
> +	}
> +}
> +
>  static int convert_to_probe_trace_events(struct perf_probe_event *pev,
>  					  struct probe_trace_event **tevs,
>  					  int max_tevs, const char *target)
> @@ -2372,3 +2386,28 @@ out:
>  		free(name);
>  	return ret;
>  }
> +
> +static void display_sdt_note_info(struct list_head *start)
> +{
> +	struct list_head *pos;
> +	struct sdt_note *tmp;
> +
> +	list_for_each(pos, start) {
> +		tmp = list_entry(pos, struct sdt_note, note_list);

Ditto.  list_for_each_entry().


> +		printf("%%%s:%s\n", tmp->provider, tmp->name);
> +	}
> +}
> +
> +int show_sdt_notes(const char *target)
> +{
> +	struct list_head sdt_notes;
> +	int ret = -1;
> +
> +	INIT_LIST_HEAD(&sdt_notes);

You can use LIST_HEAD(sdt_notes) here.


> +	ret = get_sdt_note_list(&sdt_notes, target);
> +	if (!ret) {
> +		display_sdt_note_info(&sdt_notes);
> +		cleanup_sdt_note_list(&sdt_notes);
> +	}
> +	return ret;
> +}
> diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
> index f9f3de8..b8a9347 100644
> --- a/tools/perf/util/probe-event.h
> +++ b/tools/perf/util/probe-event.h
> @@ -133,7 +133,7 @@ extern int show_available_vars(struct perf_probe_event *pevs, int npevs,
>  			       struct strfilter *filter, bool externs);
>  extern int show_available_funcs(const char *module, struct strfilter *filter,
>  				bool user);
> -
> +int show_sdt_notes(const char *target);
>  /* Maximum index number of event-name postfix */
>  #define MAX_EVENT_INDEX	1024
>  
> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
> index 4b12bf8..6b17260 100644
> --- a/tools/perf/util/symbol-elf.c
> +++ b/tools/perf/util/symbol-elf.c
> @@ -846,6 +846,182 @@ out_elf_end:
>  	return err;
>  }
>  
> +/*
> + * Populate the name, type, offset in the SDT note structure and
> + * ignore the argument fields (for now)
> + */
> +static struct sdt_note *populate_sdt_note(Elf **elf, const char *data,
> +					  size_t len, int type)
> +{
> +	const char *provider, *name;
> +	struct sdt_note *note;
> +
> +	/*
> +	 * Three addresses need to be obtained :
> +	 * Marker location, address of base section and semaphore location
> +	 */
> +	union {
> +		Elf64_Addr a64[3];
> +		Elf32_Addr a32[3];
> +	} buf;
> +
> +	/*
> +	 * dst and src are required for translation from file to memory
> +	 * representation
> +	 */
> +	Elf_Data dst = {
> +		.d_buf = &buf, .d_type = ELF_T_ADDR, .d_version = EV_CURRENT,
> +		.d_size = gelf_fsize((*elf), ELF_T_ADDR, 3, EV_CURRENT),
> +		.d_off = 0, .d_align = 0
> +	};
> +
> +	Elf_Data src = {
> +		.d_buf = (void *) data, .d_type = ELF_T_ADDR,
> +		.d_version = EV_CURRENT, .d_size = dst.d_size, .d_off = 0,
> +		.d_align = 0
> +	};
> +
> +	/* Check the type of each of the notes */
> +	if (type != SDT_NOTE_TYPE)
> +		goto out_ret;
> +
> +	note = (struct sdt_note *)zalloc(sizeof(struct sdt_note));
> +	if (note == NULL) {
> +		pr_err("Memory allocation error\n");
> +		goto out_ret;
> +	}
> +	INIT_LIST_HEAD(&note->note_list);
> +
> +	if (len < dst.d_size + 3)
> +		goto out_free;
> +
> +	/* Translation from file representation to memory representation */
> +	if (gelf_xlatetom(*elf, &dst, &src,
> +			  elf_getident(*elf, NULL)[EI_DATA]) == NULL)
> +		pr_debug("gelf_xlatetom : %s", elf_errmsg(-1));

I doubt this translation is really needed as we only deal with SDTs on a
local system only, right?

> +
> +	/* Populate the fields of sdt_note */
> +	provider = data + dst.d_size;
> +
> +	name = (const char *)memchr(provider, '\0', data + len - provider);
> +	if (name++ == NULL)
> +		goto out_free;
> +	note->provider = strdup(provider);
> +	note->name = strdup(name);

You need to check the return value of strdup's and it should also be
freed when an error occurres after this.

> +
> +	/* Obtain the addresses and ignore notes with semaphores set*/
> +	if (gelf_getclass(*elf) == ELFCLASS32) {
> +		note->addr.a32[0] = buf.a32[0];
> +		note->addr.a32[1] = buf.a32[1];
> +		note->addr.a32[2] = buf.a32[2];
> +		note->bit32 = true;
> +		if (buf.a32[2] != 0)
> +			goto out_free;
> +	} else {
> +		note->addr.a64[0] = buf.a64[0];
> +		note->addr.a64[1] = buf.a64[1];
> +		note->addr.a64[2] = buf.a64[2];
> +		note->bit32 = false;
> +		if (buf.a64[2] != 0)
> +			goto out_free;
> +	}
> +	return note;
> +
> +out_free:
> +	free(note);
> +out_ret:
> +	return NULL;
> +}
> +
> +static struct list_head *construct_sdt_notes_list(Elf *elf)
> +{
> +	GElf_Ehdr ehdr;
> +	Elf_Scn *scn = NULL;
> +	Elf_Data *data;
> +	GElf_Shdr shdr;
> +	size_t shstrndx;
> +	size_t next;
> +	GElf_Nhdr nhdr;
> +	size_t name_off, desc_off, offset;
> +	struct sdt_note *tmp = NULL, *note = NULL;
> +
> +	if (gelf_getehdr(elf, &ehdr) == NULL) {
> +		pr_debug("%s: Can't get elf header.\n", __func__);
> +		goto out_err;
> +	}
> +	if (elf_getshdrstrndx(elf, &shstrndx) != 0) {
> +		pr_debug("getshdrstrndx failed\n");
> +		goto out_err;
> +	}
> +
> +	/*
> +	 * Look for section type = SHT_NOTE, flags = no SHF_ALLOC
> +	 * and name = .note.stapsdt
> +	 */
> +	scn = elf_section_by_name(elf, &ehdr, &shdr, NOTE_SCN, NULL);
> +	if (!scn) {
> +		printf("SDT markers not present!\n");
> +		goto out_err;
> +	}
> +	if (!(shdr.sh_type == SHT_NOTE) || (shdr.sh_flags & SHF_ALLOC))
> +		goto out_err;
> +
> +	data = elf_getdata(scn, NULL);
> +
> +	/* Get the SDT notes */
> +	for (offset = 0; (next = gelf_getnote(data, offset, &nhdr, &name_off,
> +					      &desc_off)) > 0; offset = next) {
> +		if (nhdr.n_namesz == sizeof(SDT_NOTE_NAME) &&
> +		    !memcmp(data->d_buf + name_off, SDT_NOTE_NAME,
> +			    sizeof(SDT_NOTE_NAME))) {
> +			tmp = populate_sdt_note(&elf, (const char *)
> +						((long)(data->d_buf) +
> +						 (long)desc_off),

It seems that data->d_buf is type of void *, so these casts can go away,
I guess.

> +						nhdr.n_descsz, nhdr.n_type);
> +			if (!note && tmp)
> +				note = tmp;
> +			else if (tmp)
> +				list_add_tail(&tmp->note_list,
> +					      &(note->note_list));
> +		}
> +	}
> +	if (tmp)
> +		return &tmp->note_list;

This list handling code looks very strange to me.  Why not just passing
a list head and connect notes to it?


> +out_err:
> +	return NULL;
> +}
> +
> +int get_sdt_note_list(struct list_head *head, const char *target)
> +{
> +	Elf *elf;
> +	int fd, ret = -1;
> +	struct list_head *tmp = NULL;
> +
> +	fd = open(target, O_RDONLY);
> +	if (fd < 0) {
> +		pr_err("Failed to open %s\n", target);
> +		goto out_ret;
> +	}
> +
> +	symbol__elf_init();
> +	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
> +	if (!elf) {
> +		pr_err("%s: cannot read %s ELF file.\n", __func__, target);
> +		goto out_close;
> +	}
> +	tmp = construct_sdt_notes_list(elf);
> +	if (tmp) {
> +		list_add(head, tmp);

Look like the params are exchanged?

  /**
   * list_add - add a new entry
   * @new: new entry to be added
   * @head: list head to add it after
   *
   * Insert a new entry after the specified head.
   * This is good for implementing stacks.
   */
  static inline void list_add(struct list_head *new, struct list_head *head)
  {
  	__list_add(new, head, head->next);
  }


> +		ret = 0;
> +	}
> +	elf_end(elf);
> +
> +out_close:
> +	close(fd);
> +out_ret:
> +	return ret;
> +}
> +
>  void symbol__elf_init(void)
>  {
>  	elf_version(EV_CURRENT);
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index 5f720dc..037185c 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -197,6 +197,17 @@ struct symsrc {
>  #endif
>  };
>  
> +struct sdt_note {
> +	char *name;
> +	char *provider;
> +	bool bit32;                 /* 32 or 64 bit flag */
> +	union {
> +		Elf64_Addr a64[3];
> +		Elf32_Addr a32[3];
> +	} addr;
> +	struct list_head note_list;
> +};
> +
>  void symsrc__destroy(struct symsrc *ss);
>  int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
>  		 enum dso_binary_type type);
> @@ -247,4 +258,11 @@ void symbols__fixup_duplicate(struct rb_root *symbols);
>  void symbols__fixup_end(struct rb_root *symbols);
>  void __map_groups__fixup_end(struct map_groups *mg, enum map_type type);
>  
> +/* Specific to SDT notes */
> +int get_sdt_note_list(struct list_head *head, const char *target);
> +
> +#define SDT_NOTE_TYPE 3
> +#define NOTE_SCN ".note.stapsdt"

What about SDT_NOTE_SCN for consistency?

Thanks,
Namhyung


> +#define SDT_NOTE_NAME "stapsdt"
> +
>  #endif /* __PERF_SYMBOL */
