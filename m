Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaH2HW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 03:22:26 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:34186 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaH2HWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 03:22:25 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Subject: Re: [PATCH v4 1/3] perf/sdt : Raw SDT parsing functions
References: <20140827213745.13454.46266.stgit@hemant-fedora>
	<20140827214323.13454.46743.stgit@hemant-fedora>
Date: Fri, 29 Aug 2014 16:22:18 +0900
In-Reply-To: <20140827214323.13454.46743.stgit@hemant-fedora> (Hemant Kumar's
	message of "Thu, 28 Aug 2014 03:14:20 +0530")
Message-ID: <877g1rbw0l.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hemant,

On Thu, 28 Aug 2014 03:14:20 +0530, Hemant Kumar wrote:
> This patch serves as the initial support to identify and list SDT events in binaries.
> When programs containing SDT markers are compiled, gcc with the help of assembler
> directives identifies them and places them in the section ".note.stapsdt". To find these
> markers from the binaries, one needs to traverse through this section and parse the
> relevant details like the name, type and location of the marker. Also, the original
> location could be skewed due to the effect of prelinking. If that is the case, the
> locations need to be adjusted.
>
> The functions in this patch open a given ELF, find out the SDT section, parse the
> relevant details, adjust the location (if necessary) and populate them in a list.
>

[SNIP]
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
> +				ret = val;
> +				goto out_ret;
> +			}

It seems populate_sdt_note() can failed with other error than ENOMEM.
So I think it'd be better changing it like:

			ret = populate_sdt_note(...);
			if (ret < 0)
				goto out_ret;

			list_add_tail(...);


So no need to use the 'val' variable.


> +		}
> +	}
> +	if (list_empty(sdt_notes))
> +		ret = -ENOENT;
> +
> +out_ret:
> +	return ret;
> +}
> +
> +/*
> + * get_sdt_note_list() : Takes two arguments "head" and "target", where head
> + * is the head of the SDT events' list and "target" is the file name as to
> + * where the SDT events should be looked for. This opens the file, initializes
> + * the ELF and then calls construct_sdt_notes_list.
> + */
> +int get_sdt_note_list(struct list_head *head, const char *target)
> +{
> +	Elf *elf;
> +	int fd, ret;

Just a nitpick.  It'd be better setting ret to -EBADF IMHO.


> +
> +	fd = open(target, O_RDONLY);
> +	if (fd < 0)
> +		return -EBADF;
> +
> +	symbol__elf_init();

This is really need?  I guess it's not harmful but no need to call it
whenever we check sdt note in every file.  A single call to
simbole__init() can be placed in the cmd_list() instead.


> +	elf = elf_begin(fd, ELF_C_READ, NULL);
> +	if (!elf) {
> +		ret = -EBADF;
> +		goto out_close;
> +	}
> +	ret = construct_sdt_notes_list(elf, head);
> +	elf_end(elf);
> +
> +out_close:
> +	close(fd);
> +	return ret;
> +}
> +
> +/*
> + * is_an_elf() : Returns 'true' if the file is an elf and 'false' otherwise
> + */
> +bool is_an_elf(char *file)
> +{
> +	int fd;
> +	Elf *elf;
> +	bool ret = true;
> +
> +	fd = open(file, O_RDONLY);
> +	if (fd < 0) {
> +		ret = false;
> +		goto out_ret;
> +	}
> +
> +	symbol__elf_init();

Ditto.

Thanks,
Namhyung


> +	elf = elf_begin(fd, ELF_C_READ, NULL);
> +	if (!elf) {
> +		ret = false;
> +		goto out_close;
> +	}
> +	if (elf_kind(elf) != ELF_K_ELF)
> +		ret = false;
> +
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
> index 615c752..83be31a 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -294,4 +294,23 @@ int compare_proc_modules(const char *from, const char *to);
>  int setup_list(struct strlist **list, const char *list_str,
>  	       const char *list_name);
>  
> +struct sdt_note {
> +	char *name;
> +	char *provider;
> +	bool bit32;
> +	union {
> +		Elf64_Addr a64[3];
> +		Elf32_Addr a32[3];
> +	} addr;
> +	struct list_head note_list;
> +};
> +
> +int get_sdt_note_list(struct list_head *head, const char *target);
> +bool is_an_elf(char *file);
> +
> +#define SDT_BASE_SCN ".stapsdt.base"
> +#define SDT_NOTE_SCN  ".note.stapsdt"
> +#define SDT_NOTE_TYPE 3
> +#define SDT_NOTE_NAME "stapsdt"
> +
>  #endif /* __PERF_SYMBOL */
