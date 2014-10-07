Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbaJGCUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 22:20:05 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:48045 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaJGCUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 22:20:03 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Subject: Re: [PATCH v2 1/5] perf/sdt: ELF support for SDT
References: <20141001023723.28985.39736.stgit@hemant-fedora>
	<20141001024525.28985.95513.stgit@hemant-fedora>
Date: Tue, 07 Oct 2014 11:20:00 +0900
In-Reply-To: <20141001024525.28985.95513.stgit@hemant-fedora> (Hemant Kumar's
	message of "Wed, 01 Oct 2014 08:17:24 +0530")
Message-ID: <87mw98hb8v.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hemant,

On Wed, 01 Oct 2014 08:17:24 +0530, Hemant Kumar wrote:
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

Below are just few more nitpicks, other than that, looks good to me.


[SNIP]
> +	/* Get the SDT notes */
> +	for (offset = 0; (next = gelf_getnote(data, offset, &nhdr, &name_off,
> +					      &desc_off)) > 0; offset = next) {
> +		if (nhdr.n_namesz == sizeof(SDT_NOTE_NAME) &&
> +		    !memcmp(data->d_buf + name_off, SDT_NOTE_NAME,
> +			    sizeof(SDT_NOTE_NAME))) {
> +			ret = populate_sdt_note(&elf, ((data->d_buf) + desc_off),
> +						nhdr.n_descsz, nhdr.n_type,
> +						&tmp);
> +			if (ret < 0)
> +				goto out_ret;
> +			list_add_tail(&tmp->note_list, sdt_notes);

I think we can just pass the sdt_notes list into populate_sdt_note()
instead of passing a tmp pointer.


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
> +
> +	fd = open(target, O_RDONLY);
> +	if (fd < 0)
> +		return -EBADF;
> +
> +	elf = elf_begin(fd, ELF_C_READ, NULL);

You may want to use PERF_ELF_C_READ_MMAP. :)

Thanks,
Namhyung


> +	if (!elf) {
> +		ret = -EBADF;
> +		goto out_close;
> +	}
> +	ret = construct_sdt_notes_list(elf, head);
> +	elf_end(elf);
> +out_close:
> +	close(fd);
> +	return ret;
> +}
