Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaBYG4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 01:56:13 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:55646 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaBYG4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 01:56:12 -0500
X-AuditID: 9c93016f-b7ccbae000002de4-6c-530c3e8ab790
From: Namhyung Kim <namhyung@kernel.org>
To: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Subject: Re: [RFC PATCH v1 1/2] perf/sdt : Listing of SDT markers by perf
References: <20140224090833.7998.5416.stgit@hemant-fedora>
	<20140224091449.7998.25624.stgit@hemant-fedora>
Date: Tue, 25 Feb 2014 15:56:09 +0900
In-Reply-To: <20140224091449.7998.25624.stgit@hemant-fedora> (Hemant Kumar's
	message of "Mon, 24 Feb 2014 14:45:43 +0530")
Message-ID: <87vbw3vfxy.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hemant,

On Mon, 24 Feb 2014 14:45:43 +0530, Hemant Kumar wrote:
> This patch enables perf to list the SDT markers present in a system. It looks
> in dsos given by ldconfig --print-cache and for other binaries, it looks into
> the PATH environment variable. After preparing a list of the binaries, then
> it starts searching for SDT markers in them.
> To find the SDT markers, first an elf section named .note.stapsdt is searched
> for. And then the SDT notes are retreived one by one from that section.
> To counter the effect of prelinking, the section ".stapsdt.base" is searched.
> If its found, then the location of the SDT marker is adjusted.
>
> All these markers' info is written into a cache file
> "/var/cache/perf/perf-sdt.cache".
> Since, the presence of SDT markers is quite common these days, hence, its better
> to make them visible to a user easily. Also, creating a cache file will help a user
> to probe (to be implemented) these markers without much hussle. This cache file will
> hold most of the SDT markers.
> The format of each entry is -
>
> %provider : marker : file_path : build_id : location : semaphore_loc
>
> % - marks the beginning of each entry.
> provider - The provider name of the SDT marker.
> marker - The marker name of the SDT marker.
> file_path - Full/absolute path of the file in which this marker is present.
> location : Adjusted location of the SDT marker inside the program.
> semaphore_loc : The semaphore address if present otherwise 0x0.
>
> This format should help when probing will be implemented. The adjusted address
> from the required entry can be directly used in probing if the build_id matches.
>
> To use this feature, invoke :
> # perf list sdt --scan
>
> "--scan" should be used for the first time and whenever there is any change in
> the files containing the SDT markers.
>
> And then use :
> # perf list sdt
>
> This displays a list of SDT markers (read from the cache file) present in most of
> the dsos and other binaries.

The default action of perf list (with no argument) prints all available
events on the system - so it should also print SDT markers IMHO.

>
> However, not all the SDT markers are present in the cache file. Only the ELFs
> present in the directories in PATH variable are looked into.
> An individual file argument can be given to "perf list" to find out the SDT markers
> present in that file. Usage is as below :
>
> # perf list sdt /home/hemant/tmp
>
> /home/hemant/tmp:
> %user : foo
> %user : bar
>
> Signed-off-by : hkshaw@linux.vnet.ibm.com
> ---

[SNIP]
> +/*
> + * Finds out the libraries present in a system as shown by the command
> + * "ldconfig --print-cache". Uses "=>" and '/' to find out the start of a
> + * dso path.
> + */
> +static void parse_lib_name(char *str, char *path)
> +{
> +	char *ptr, *q, *r;
> +	char c = '=';
> +
> +	while (str != NULL) {
> +		/* look for "=>" and then '/' */
> +		ptr = strchr(str, c);
> +		if (ptr && (*(ptr + 1) == '>')) {

Hmm.. why not searching "=>" by strstr() then?


> +			ptr++;
> +			q = strchr(ptr, '/');
> +			if (!q)
> +				return;
> +			r = strchr(ptr, '\n');
> +			*r = '\0';
> +			strcpy(path, q);
> +			return;
> +		} else if (ptr == NULL) {
> +			return;
> +		} else {
> +			str = ptr + 1;
> +			continue;
> +		}
> +	}
> +}

[SNIP]
> +	/*
> +	 * Take a line from the o/p of ldconfig and
> +	 * parse it to find a library path
> +	 */
> +	while (getline(&line, &len, fp) != -1) {
> +		memset(path, '\0', PATH_MAX);
> +		parse_lib_name(line, path);
> +		if (strcmp(path, ""))

I think it'd better changing the parse_lib_name to return a value
instead of checking whether the path is an empty string.


> +			append_path(path, &lib_list.list);
> +	}
> +	/* line and fp no more required */
> +	free(line);
> +	pclose(fp);
> +
> +	/* Find and write the SDT markers in the perf-sdt cache*/
> +	flush_sdt_list(&lib_list.list, cache);
> +
> +	cleanup_path_list(&lib_list.list);
> +	return;
> +}

[SNIP]
> +static int populate_sdt_note(Elf **elf, const char *data, size_t len, int type,
> +			     struct sdt_note **note)
> +{
> +	const char *provider, *name;
> +	struct sdt_note *tmp = NULL;
> +	GElf_Ehdr ehdr;
> +	GElf_Addr base_off = 0;
> +	GElf_Shdr shdr;
> +	int ret = -1;
> +	int i;
> +
> +	union {
> +		Elf64_Addr a64[3];
> +		Elf32_Addr a32[3];
> +	} buf;
> +
> +	Elf_Data dst = {
> +		.d_buf = &buf, .d_type = ELF_T_ADDR, .d_version = EV_CURRENT,
> +		.d_size = gelf_fsize((*elf), ELF_T_ADDR, 3, EV_CURRENT),
> +		.d_off = 0, .d_align = 0
> +	};
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
> +	tmp = (struct sdt_note *)calloc(1, sizeof(struct sdt_note));
> +	if (!tmp) {
> +		ret = -ENOMEM;
> +		goto out_err;
> +	}
> +
> +	INIT_LIST_HEAD(&tmp->note_list);
> +
> +	if (len < dst.d_size + 3)
> +		goto out_free_note;
> +
> +	/* Translation from file representation to memory representation */
> +	if (gelf_xlatetom(*elf, &dst, &src,
> +			  elf_getident(*elf, NULL)[EI_DATA]) == NULL)

Do we really need this xlate function?  It seems elf_getdata() already
did necessary conversions so only thing we need to do is checking its
class and read out the addresses in a proper length, no?


> +		printf("gelf_xlatetom : %s\n", elf_errmsg(-1));
> +
> +	/* Populate the fields of sdt_note */
> +	provider = data + dst.d_size;
> +
> +	name = (const char *)memchr(provider, '\0', data + len - provider);
> +	if (name++ == NULL)
> +		goto out_free_note;
> +
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
> +	/* Obtain the addresses */
> +	if (gelf_getclass(*elf) == ELFCLASS32) {
> +		for (i = 0; i < 3; i++)
> +			tmp->addr.a32[i] = buf.a32[i];
> +		tmp->bit32 = true;
> +	} else {
> +		for (i = 0; i < 3; i++)
> +			tmp->addr.a64[i] = buf.a64[i];
> +		tmp->bit32 = false;
> +	}
> +
> +	/* Now Adjust the prelink effect */
> +	if (!gelf_getehdr(*elf, &ehdr)) {
> +		pr_debug("%s : cannot get elf header.\n", __func__);
> +		ret = -EBADF;
> +		goto out_free_name;
> +	}
> +
> +	/*
> +	 * Find out the .stapsdt.base section.
> +	 * This scn will help us to handle prelinking (if present).
> +	 * Compare the retrieved file offset of the base section with the
> +	 * base address in the description of the SDT note. If its different,
> +	 * then accordingly, adjust the note location.
> +	 */
> +	if (elf_section_by_name(*elf, &ehdr, &shdr, SDT_BASE_SCN, NULL))
> +		base_off = shdr.sh_offset;
> +	if (base_off) {

Why not moving this block under the above if block?


> +		if (tmp->bit32)
> +			tmp->addr.a32[0] = tmp->addr.a32[0] + base_off -
> +				tmp->addr.a32[1];
> +		else
> +			tmp->addr.a64[0] = tmp->addr.a64[0] + base_off -
> +				tmp->addr.a64[1];
> +	}
> +
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
> +	size_t shstrndx, next;
> +	GElf_Nhdr nhdr;
> +	size_t name_off, desc_off, offset;
> +	struct sdt_note *tmp = NULL;
> +	int ret = 0, val = 0;
> +
> +	if (gelf_getehdr(elf, &ehdr) == NULL) {
> +		ret = -EBADF;
> +		goto out_ret;
> +	}
> +	if (elf_getshdrstrndx(elf, &shstrndx) != 0) {
> +		ret = -EBADF;
> +		goto out_ret;
> +	}
> +
> +	/* Look for the required section */
> +	scn = elf_section_by_name(elf, &ehdr, &shdr, SDT_NOTE_SCN, NULL);
> +	if (!scn) {
> +		ret = -ENOENT;
> +		goto out_ret;
> +	}
> +
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
> +				ret = val;
> +				goto out_ret;
> +			}
> +		}
> +	}
> +	if (!sdt_notes)

Did you mean list_empty(sdt_notes) ? :)

Thanks,
Namhyung


> +		Ret = -ENOENT;
> +
> +out_ret:
> +	return ret;
> +}
