Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaJCLjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 07:39:41 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51383 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaJCLji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 07:39:38 -0400
Message-ID: <542E8AF3.2030206@hitachi.com>
Date: Fri, 03 Oct 2014 20:39:31 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v2 1/5] perf/sdt: ELF support for SDT
References: <20141001023723.28985.39736.stgit@hemant-fedora> <20141001024525.28985.95513.stgit@hemant-fedora>
In-Reply-To: <20141001024525.28985.95513.stgit@hemant-fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/01 11:47), Hemant Kumar wrote:
> This patch serves as the basic support to identify and list SDT events in binaries.
> When programs containing SDT markers are compiled, gcc with the help of assembler
> directives identifies them and places them in the section ".note.stapsdt". To find
> these markers from the binaries, one needs to traverse through this section and
> parse the relevant details like the name, type and location of the marker. Also,
> the original location could be skewed due to the effect of prelinking. If that is
> the case, the locations need to be adjusted.
> 
> The functions in this patch open a given ELF, find out the SDT section, parse the
> relevant details, adjust the location (if necessary) and populate them in a list.
> 
> Made the necessary changes as suggested by Namhyung Kim.

Looks almost good!
I have some comments, please see below.

> 
> Signed-off-by: Hemant Kumar <hemant@linux.vnet.ibm.com>
> ---
>  tools/perf/util/symbol-elf.c |  207 ++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/symbol.h     |   19 ++++
>  2 files changed, 226 insertions(+)
> 
> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
> index 2a92e10..9702167 100644
> --- a/tools/perf/util/symbol-elf.c
> +++ b/tools/perf/util/symbol-elf.c
> @@ -1672,6 +1672,213 @@ void kcore_extract__delete(struct kcore_extract *kce)
>  	unlink(kce->extract_filename);
>  }
>  
> +/*
> + * populate_sdt_note() : Responsible for parsing the section .note.stapsdt and
> + * after adjusting the note's location, returns that to the calling functions.
> + */
> +static int populate_sdt_note(Elf **elf, const char *data, size_t len, int type,
> +			     struct sdt_note **note)
> +{
> +	const char *provider, *name;
> +	struct sdt_note *tmp = NULL;
> +	GElf_Ehdr ehdr;
> +	GElf_Addr base_off = 0;
> +	GElf_Shdr shdr;
> +	int ret = -1;

-1 is not an error code. maybe, -EINVAL is better.

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
> +		printf("gelf_xlatetom : %s\n", elf_errmsg(-1));

pr_err? and shouldn't it goes to out_free_note?

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
> +	if (elf_section_by_name(*elf, &ehdr, &shdr, SDT_BASE_SCN, NULL)) {
> +		base_off = shdr.sh_offset;
> +		if (base_off) {
> +			if (tmp->bit32)
> +				tmp->addr.a32[0] = tmp->addr.a32[0] + base_off -
> +					tmp->addr.a32[1];
> +			else
> +				tmp->addr.a64[0] = tmp->addr.a64[0] + base_off -
> +					tmp->addr.a64[1];
> +		}
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

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


