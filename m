Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaJGGKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 02:10:08 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:49661 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaJGGKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 02:10:07 -0400
Message-ID: <543383AF.7060400@linux.vnet.ibm.com>
Date: Tue, 07 Oct 2014 11:39:51 +0530
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Subject: Re: [PATCH v2 1/5] perf/sdt: ELF support for SDT
References: <20141001023723.28985.39736.stgit@hemant-fedora> <20141001024525.28985.95513.stgit@hemant-fedora> <87mw98hb8v.fsf@sejong.aot.lge.com>
In-Reply-To: <87mw98hb8v.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100706-0009-0000-0000-000000658C99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

On 10/07/2014 07:50 AM, Namhyung Kim wrote:
> Hi Hemant,
>
> On Wed, 01 Oct 2014 08:17:24 +0530, Hemant Kumar wrote:
>> This patch serves as the basic support to identify and list SDT events in binaries.
>> When programs containing SDT markers are compiled, gcc with the help of assembler
>> directives identifies them and places them in the section ".note.stapsdt". To find
>> these markers from the binaries, one needs to traverse through this section and
>> parse the relevant details like the name, type and location of the marker. Also,
>> the original location could be skewed due to the effect of prelinking. If that is
>> the case, the locations need to be adjusted.
>>
>> The functions in this patch open a given ELF, find out the SDT section, parse the
>> relevant details, adjust the location (if necessary) and populate them in a list.
>>
>> Made the necessary changes as suggested by Namhyung Kim.
> Below are just few more nitpicks, other than that, looks good to me.
>
>
> [SNIP]
>> +	/* Get the SDT notes */
>> +	for (offset = 0; (next = gelf_getnote(data, offset, &nhdr, &name_off,
>> +					      &desc_off)) > 0; offset = next) {
>> +		if (nhdr.n_namesz == sizeof(SDT_NOTE_NAME) &&
>> +		    !memcmp(data->d_buf + name_off, SDT_NOTE_NAME,
>> +			    sizeof(SDT_NOTE_NAME))) {
>> +			ret = populate_sdt_note(&elf, ((data->d_buf) + desc_off),
>> +						nhdr.n_descsz, nhdr.n_type,
>> +						&tmp);
>> +			if (ret < 0)
>> +				goto out_ret;
>> +			list_add_tail(&tmp->note_list, sdt_notes);
> I think we can just pass the sdt_notes list into populate_sdt_note()
> instead of passing a tmp pointer.
>

Ok, will pass sdt_notes to populate_sdt_note.

>> +		}
>> +	}
>> +	if (list_empty(sdt_notes))
>> +		ret = -ENOENT;
>> +
>> +out_ret:
>> +	return ret;
>> +}
>> +
>> +/*
>> + * get_sdt_note_list() : Takes two arguments "head" and "target", where head
>> + * is the head of the SDT events' list and "target" is the file name as to
>> + * where the SDT events should be looked for. This opens the file, initializes
>> + * the ELF and then calls construct_sdt_notes_list.
>> + */
>> +int get_sdt_note_list(struct list_head *head, const char *target)
>> +{
>> +	Elf *elf;
>> +	int fd, ret;
>> +
>> +	fd = open(target, O_RDONLY);
>> +	if (fd < 0)
>> +		return -EBADF;
>> +
>> +	elf = elf_begin(fd, ELF_C_READ, NULL);
> You may want to use PERF_ELF_C_READ_MMAP. :)

Sure.

> Thanks,
> Namhyung
>
>
> [...]

-- 
Thanks,
Hemant Kumar

