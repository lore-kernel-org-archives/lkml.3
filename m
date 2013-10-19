Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab3JSP14 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 11:27:56 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:53227 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab3JSP1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 11:27:54 -0400
Message-ID: <5262A4F6.3000609@hitachi.com>
Date: Sun, 20 Oct 2013 00:27:50 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v3 1/3] SDT markers listing by perf:
References: <20131018143714.10452.83494.stgit@hemant-fedora> <20131018144231.10452.65885.stgit@hemant-fedora>
In-Reply-To: <20131018144231.10452.65885.stgit@hemant-fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/18 23:44), Hemant Kumar wrote:
> This patch will enable perf to list all the sdt markers present
> in an elf file. The markers are present in the .note.stapsdt section
> of the elf. We can traverse through this section and collect the
> required info about the markers.
> We can use '-M/--markers' with perf to view the SDT notes.
> 
> Currently, the sdt notes which have their semaphores enabled, are being
> ignored silently. But, they will be supported soon.
> 
> Wrapping this inside #ifdef LIBELF_SUPPORT pair is not required,
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
>  tools/perf/builtin-probe.c    |   41 ++++++++
>  tools/perf/util/probe-event.c |   35 +++++++
>  tools/perf/util/probe-event.h |    1 
>  tools/perf/util/symbol-elf.c  |  211 +++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/symbol.h      |   18 +++
>  5 files changed, 304 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> index 89acc17..2450613 100644
> --- a/tools/perf/builtin-probe.c
> +++ b/tools/perf/builtin-probe.c
> @@ -55,6 +55,8 @@ static struct {
>  	bool show_funcs;
>  	bool mod_events;
>  	bool uprobes;
> +	bool exec;
> +	bool sdt;
>  	int nevents;
>  	struct perf_probe_event events[MAX_PROBES];
>  	struct strlist *dellist;
> @@ -171,8 +173,10 @@ static int opt_set_target(const struct option *opt, const char *str,
>  	int ret = -ENOENT;
>  
>  	if  (str && !params.target) {
> -		if (!strcmp(opt->long_name, "exec"))
> +		if (!strcmp(opt->long_name, "exec")) {
>  			params.uprobes = true;
> +			params.exec = true;
> +		}
>  #ifdef HAVE_DWARF_SUPPORT
>  		else if (!strcmp(opt->long_name, "module"))
>  			params.uprobes = false;
> @@ -325,6 +329,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>  		     opt_set_filter),
>  	OPT_CALLBACK('x', "exec", NULL, "executable|path",
>  			"target executable name or path", opt_set_target),
> +	OPT_BOOLEAN('M', "markers", &params.sdt, "Show proba-able sdt notes"),
>  	OPT_END()
>  	};
>  	int ret;
> @@ -347,7 +352,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>  		params.max_probe_points = MAX_PROBES;
>  
>  	if ((!params.nevents && !params.dellist && !params.list_events &&
> -	     !params.show_lines && !params.show_funcs))
> +	     !params.show_lines && !params.show_funcs && !params.sdt))
>  		usage_with_options(probe_usage, options);
>  
>  	/*
> @@ -355,6 +360,38 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
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
> +		if (params.mod_events) {
> +			pr_err("Error: Don't use --markers with --add/--del.\n");
> +			usage_with_options(probe_usage, options);
> +		}
> +		if (!params.exec) {
> +			pr_err("Error: Always use --exec with --markers.\n");
> +			usage_with_options(probe_usage, options);
> +		}
> +		if (!params.target) {
> +			pr_err("Error: Please specify a target binary!\n");
> +			usage_with_options(probe_usage, options);
> +		}
> +		ret = show_sdt_notes(params.target);
> +		if (ret < 0) {
> +			pr_err("  Error : Failed to find SDT markers in %s !"
> +			       " (%d)\n", params.target, ret);
> +		}
> +		return ret;
> +	}
>  	if (params.list_events) {
>  		if (params.mod_events) {
>  			pr_err("  Error: Don't use --list with --add/--del.\n");
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 779b2da..c228fe6 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -1909,6 +1909,18 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
>  	return ret;
>  }
>  
> +static void cleanup_sdt_note_list(struct list_head *sdt_notes)
> +{
> +	struct sdt_note *tmp, *pos;
> +
> +	list_for_each_entry_safe(pos, tmp, sdt_notes, note_list) {
> +		list_del(&pos->note_list);
> +		free(pos->name);
> +		free(pos->provider);
> +		free(pos);
> +	}
> +}
> +
>  static int convert_to_probe_trace_events(struct perf_probe_event *pev,
>  					  struct probe_trace_event **tevs,
>  					  int max_tevs, const char *target)
> @@ -2372,3 +2384,26 @@ out:
>  		free(name);
>  	return ret;
>  }
> +
> +static void display_sdt_note_info(struct list_head *start)
> +{
> +	struct sdt_note *pos;
> +
> +	list_for_each_entry(pos, start, note_list) {
> +		printf("%%%s:%s\n", pos->provider, pos->name);
> +	}
> +}
> +
> +int show_sdt_notes(const char *target)
> +{
> +	int ret;
> +	LIST_HEAD(sdt_notes);
> +
> +	ret = get_sdt_note_list(&sdt_notes, target);
> +	if (!list_empty(&sdt_notes)) {
> +		if (!ret)

Hmm, why don't you check the ret first? And I think the
empty check should be done in display_sdt_note_info() and
cleanup_sdt_note_list() (anyway, since both uses list_for_each*()
it is already done).

> +			display_sdt_note_info(&sdt_notes);
> +		cleanup_sdt_note_list(&sdt_notes);
> +	}
> +	return ret;
> +}

Others are good for me. :)

Thank you!

> diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
> index f9f3de8..32de5a3 100644
> --- a/tools/perf/util/probe-event.h
> +++ b/tools/perf/util/probe-event.h
> @@ -133,6 +133,7 @@ extern int show_available_vars(struct perf_probe_event *pevs, int npevs,
>  			       struct strfilter *filter, bool externs);
>  extern int show_available_funcs(const char *module, struct strfilter *filter,
>  				bool user);
> +int show_sdt_notes(const char *target);
>  
>  /* Maximum index number of event-name postfix */
>  #define MAX_EVENT_INDEX	1024
> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
> index eed0b96..828ecad 100644
> --- a/tools/perf/util/symbol-elf.c
> +++ b/tools/perf/util/symbol-elf.c
> @@ -1613,6 +1613,217 @@ void kcore_extract__delete(struct kcore_extract *kce)
>  	unlink(kce->extract_filename);
>  }
>  
> +/*
> + * Populate the name, type, offset in the SDT note structure and
> + * ignore the argument fields (for now)
> + */
> +static int populate_sdt_note(Elf **elf, const char *data, size_t len, int type,
> +			     struct sdt_note **note)
> +{
> +	const char *provider, *name;
> +	struct sdt_note *tmp = NULL;
> +	int ret = -1;
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
> +		goto out_err;
> +
> +	tmp = (struct sdt_note *)zalloc(sizeof(struct sdt_note));
> +	if (tmp == NULL) {
> +		ret = -ENOMEM;
> +		goto out_err;
> +	}
> +	INIT_LIST_HEAD(&tmp->note_list);
> +
> +	if (len < dst.d_size + 3)
> +		goto out_free_note;
> +
> +	/* Translation from file representation to memory representation */
> +	if (gelf_xlatetom(*elf, &dst, &src,
> +			  elf_getident(*elf, NULL)[EI_DATA]) == NULL)
> +		pr_debug("gelf_xlatetom : %s", elf_errmsg(-1));
> +
> +	/* Populate the fields of sdt_note */
> +	provider = data + dst.d_size;
> +
> +	name = (const char *)memchr(provider, '\0', data + len - provider);
> +	if (name++ == NULL)
> +		goto out_free_note;
> +	tmp->provider = strdup(provider);
> +	if (!tmp->provider) {
> +		ret = -ENOMEM;
> +		goto out_free_note;
> +	}
> +	tmp->name = strdup(name);
> +	if (!tmp->name) {
> +		ret = -ENOMEM;
> +		goto out_free_prov;
> +	}
> +
> +	/* Obtain the addresses and ignore notes with semaphores set*/
> +	if (gelf_getclass(*elf) == ELFCLASS32) {
> +		if (buf.a32[2] != 0)
> +			goto out_free_name;
> +		tmp->addr.a32[0] = buf.a32[0];
> +		tmp->addr.a32[1] = buf.a32[1];
> +		tmp->addr.a32[2] = buf.a32[2];
> +		tmp->bit32 = true;
> +	} else {
> +		if (buf.a64[2] != 0)
> +			goto out_free_name;
> +		tmp->addr.a64[0] = buf.a64[0];
> +		tmp->addr.a64[1] = buf.a64[1];
> +		tmp->addr.a64[2] = buf.a64[2];
> +		tmp->bit32 = false;
> +	}
> +	*note = tmp;
> +	return 0;
> +
> +out_free_name:
> +	free(tmp->name);
> +out_free_prov:
> +	free(tmp->provider);
> +out_free_note:
> +	free(tmp);
> +out_err:
> +	return ret;
> +}
> +
> +static int construct_sdt_notes_list(Elf *elf, struct list_head *sdt_notes)
> +{
> +	GElf_Ehdr ehdr;
> +	Elf_Scn *scn = NULL;
> +	Elf_Data *data;
> +	GElf_Shdr shdr;
> +	size_t shstrndx;
> +	size_t next;
> +	GElf_Nhdr nhdr;
> +	size_t name_off, desc_off, offset;
> +	struct sdt_note *tmp = NULL;
> +	int ret = 0, val = 0;
> +
> +	if (gelf_getehdr(elf, &ehdr) == NULL) {
> +		ret = -EBADF;
> +		pr_debug("Can't get elf header!");
> +		goto out_ret;
> +	}
> +	if (elf_getshdrstrndx(elf, &shstrndx) != 0) {
> +		ret = -EBADF;
> +		pr_debug("getshdrstrndx failed\n");
> +		goto out_ret;
> +	}
> +
> +	/*
> +	 * Look for section type = SHT_NOTE, flags = no SHF_ALLOC
> +	 * and name = .note.stapsdt
> +	 */
> +	scn = elf_section_by_name(elf, &ehdr, &shdr, SDT_NOTE_SCN, NULL);
> +	if (!scn) {
> +		ret = -ENOENT;
> +		pr_debug("Can't get section .note.stapsdt\n");
> +		goto out_ret;
> +	}
> +	if (!(shdr.sh_type == SHT_NOTE) || (shdr.sh_flags & SHF_ALLOC)) {
> +		ret = -ENOENT;
> +		goto out_ret;
> +	}
> +
> +	data = elf_getdata(scn, NULL);
> +
> +	/* Get the SDT notes */
> +	for (offset = 0; (next = gelf_getnote(data, offset, &nhdr, &name_off,
> +					      &desc_off)) > 0; offset = next) {
> +		if (nhdr.n_namesz == sizeof(SDT_NOTE_NAME) &&
> +		    !memcmp(data->d_buf + name_off, SDT_NOTE_NAME,
> +			    sizeof(SDT_NOTE_NAME))) {
> +			val = populate_sdt_note(&elf, ((data->d_buf) + desc_off),
> +						nhdr.n_descsz, nhdr.n_type,
> +						&tmp);
> +			if (!val)
> +				list_add_tail(&tmp->note_list, sdt_notes);
> +			if (val == -ENOMEM) {
> +				ret = -ENOMEM;
> +				goto out_ret;
> +			}
> +		}
> +	}
> +	if (!sdt_notes)
> +		ret = -ENOENT;
> +
> +out_ret:
> +	return ret;
> +}
> +
> +static int sdt_err(int val, const char *target)
> +{
> +	switch (-val) {
> +	case 0:
> +		break;
> +	case ENOENT:
> +		/* Absence of SDT markers isn't an error */
> +		val = 0;
> +		printf("%s : No SDT markers found!\n", target);
> +		break;
> +	case EBADF:
> +		pr_err("%s : Bad file name\n", target);
> +		break;
> +	default:
> +		pr_err("%s\n", strerror(val));
> +	}
> +	return val;
> +}
> +
> +int get_sdt_note_list(struct list_head *head, const char *target)
> +{
> +	Elf *elf;
> +	int fd, ret;
> +
> +	fd = open(target, O_RDONLY);
> +	if (fd < 0) {
> +		pr_err("%s : %s\n", target, strerror(errno));
> +		return -errno;
> +	}
> +
> +	symbol__elf_init();
> +	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
> +	if (!elf) {
> +		ret = -EBADF;
> +		pr_debug("%s : %s\n", target, elf_errmsg(elf_errno()));
> +		goto out_close;
> +	}
> +	ret = construct_sdt_notes_list(elf, head);
> +	elf_end(elf);
> +
> +out_close:
> +	close(fd);
> +	return sdt_err(ret, target);
> +}
> +
>  void symbol__elf_init(void)
>  {
>  	elf_version(EV_CURRENT);
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index 07de8fe..b78397b 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -198,6 +198,17 @@ struct symsrc {
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
> @@ -273,4 +284,11 @@ void kcore_extract__delete(struct kcore_extract *kce);
>  int kcore_copy(const char *from_dir, const char *to_dir);
>  int compare_proc_modules(const char *from, const char *to);
>  
> +/* Specific to SDT notes */
> +int get_sdt_note_list(struct list_head *head, const char *target);
> +
> +#define SDT_NOTE_TYPE 3
> +#define SDT_NOTE_SCN ".note.stapsdt"
> +#define SDT_NOTE_NAME "stapsdt"
> +
>  #endif /* __PERF_SYMBOL */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


