Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbaJVCjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 22:39:51 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:52720 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaJVCju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 22:39:50 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Subject: Re: [PATCH v3 1/5] perf/sdt: ELF support for SDT
References: <20141010104402.15506.73285.stgit@hemant-fedora>
	<20141010105727.15506.99362.stgit@hemant-fedora>
Date: Wed, 22 Oct 2014 11:39:48 +0900
In-Reply-To: <20141010105727.15506.99362.stgit@hemant-fedora> (Hemant Kumar's
	message of "Fri, 10 Oct 2014 16:27:53 +0530")
Message-ID: <87a94og74b.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hemant,

On Fri, 10 Oct 2014 16:27:53 +0530, Hemant Kumar wrote:
> This patch serves the initial support to identify and list SDT events in binaries.
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
> Signed-off-by: Hemant Kumar <hemant@linux.vnet.ibm.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Just a nitpick below..


> +static int construct_sdt_notes_list(Elf *elf, struct list_head *sdt_notes)
> +{
> +	GElf_Ehdr ehdr;
> +	Elf_Scn *scn = NULL;
> +	Elf_Data *data;
> +	GElf_Shdr shdr;
> +	size_t shstrndx, next;
> +	GElf_Nhdr nhdr;
> +	size_t name_off, desc_off, offset;
> +	int ret = 0;
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

I think the below is more readable:

	if ((shdr.sh_type != SHT_NOTE) || (shdr.sh_flags & SHF_ALLOC)) {

Other than that, looks good to me!

Thanks,
Namhyung


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
> +			ret = populate_sdt_note(&elf, ((data->d_buf) + desc_off),
> +						nhdr.n_descsz, nhdr.n_type,
> +						sdt_notes);
> +			if (ret < 0)
> +				goto out_ret;
> +		}
> +	}
> +	if (list_empty(sdt_notes))
> +		ret = -ENOENT;
> +
> +out_ret:
> +	return ret;
> +}
