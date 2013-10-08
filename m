Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab3JHLjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 07:39:52 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51141 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab3JHLjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 07:39:51 -0400
Message-ID: <5253EF03.5090502@hitachi.com>
Date: Tue, 08 Oct 2013 20:39:47 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v2 1/3] SDT markers listing by perf:
References: <20131007063911.11693.33624.stgit@hemant-fedora> <20131007064707.11693.27056.stgit@hemant-fedora>
In-Reply-To: <20131007064707.11693.27056.stgit@hemant-fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/07 15:47), Hemant Kumar wrote:
> @@ -325,6 +326,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>  		     opt_set_filter),
>  	OPT_CALLBACK('x', "exec", NULL, "executable|path",
>  			"target executable name or path", opt_set_target),
> +	OPT_BOOLEAN('S', "markers", &params.sdt, "Show probe-able sdt notes"),

BTW, "-S" for short of "--markers" option is a bit odd. Would we better use -M ? :)

[...]
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

You have to ensure params.target is set before use it.

> +		if (ret < 0) {
> +			pr_err("  Error : Failed to find SDT markers!"
> +			       "(%d)\n", ret);
> +		}
> +		return ret;
> +	}
>  	if (params.list_events) {
>  		if (params.mod_events) {
>  			pr_err("  Error: Don't use --list with --add/--del.\n");

[...]
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

No need to state out of memory for each place...
If you hit an out of memory for such small piece, you'd better
abort execution. For that purpose, I recommend you to return
errno from each function, and caller must check it.

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
> +
> +	/* Populate the fields of sdt_note */
> +	provider = data + dst.d_size;
> +
> +	name = (const char *)memchr(provider, '\0', data + len - provider);
> +	if (name++ == NULL)
> +		goto out_free;
> +	note->provider = strdup(provider);
> +	note->name = strdup(name);
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

This also would better return errno.

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

Why you don't use pr_err() here ? :)
And also, as I commented, I'd like to know which binary doesn't have SDT markers,
at least with -v (verbose) option.

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
> +out_err:
> +	return NULL;
> +}
> +

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


