Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797AbaJVK0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 06:26:41 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:52864 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaJVK0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 06:26:39 -0400
Message-ID: <54478657.5000207@linux.vnet.ibm.com>
Date: Wed, 22 Oct 2014 15:56:31 +0530
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Subject: Re: [PATCH v3 1/5] perf/sdt: ELF support for SDT
References: <20141010104402.15506.73285.stgit@hemant-fedora> <20141010105727.15506.99362.stgit@hemant-fedora> <87a94og74b.fsf@sejong.aot.lge.com>
In-Reply-To: <87a94og74b.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102210-0013-0000-0000-000001D374B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/22/2014 08:09 AM, Namhyung Kim wrote:
> Hi Hemant,
>
> On Fri, 10 Oct 2014 16:27:53 +0530, Hemant Kumar wrote:
>> This patch serves the initial support to identify and list SDT events in binaries.
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
>> Signed-off-by: Hemant Kumar <hemant@linux.vnet.ibm.com>
> Acked-by: Namhyung Kim <namhyung@kernel.org>
>
> Just a nitpick below..
>
>
>> +static int construct_sdt_notes_list(Elf *elf, struct list_head *sdt_notes)
>> +{
>> +	GElf_Ehdr ehdr;
>> +	Elf_Scn *scn = NULL;
>> +	Elf_Data *data;
>> +	GElf_Shdr shdr;
>> +	size_t shstrndx, next;
>> +	GElf_Nhdr nhdr;
>> +	size_t name_off, desc_off, offset;
>> +	int ret = 0;
>> +
>> +	if (gelf_getehdr(elf, &ehdr) == NULL) {
>> +		ret = -EBADF;
>> +		goto out_ret;
>> +	}
>> +	if (elf_getshdrstrndx(elf, &shstrndx) != 0) {
>> +		ret = -EBADF;
>> +		goto out_ret;
>> +	}
>> +
>> +	/* Look for the required section */
>> +	scn = elf_section_by_name(elf, &ehdr, &shdr, SDT_NOTE_SCN, NULL);
>> +	if (!scn) {
>> +		ret = -ENOENT;
>> +		goto out_ret;
>> +	}
>> +
>> +	if (!(shdr.sh_type == SHT_NOTE) || (shdr.sh_flags & SHF_ALLOC)) {
> I think the below is more readable:

Yes.

>
> 	if ((shdr.sh_type != SHT_NOTE) || (shdr.sh_flags & SHF_ALLOC)) {

Will change to this.

>
> Other than that, looks good to me!
>
> Thanks,
> Namhyung
>
>
>> +		ret = -ENOENT;
>> +		goto out_ret;
>> +	}
>> +
>> +	data = elf_getdata(scn, NULL);
>> +
>> +	/* Get the SDT notes */
>> +	for (offset = 0; (next = gelf_getnote(data, offset, &nhdr, &name_off,
>> +					      &desc_off)) > 0; offset = next) {
>> +		if (nhdr.n_namesz == sizeof(SDT_NOTE_NAME) &&
>> +		    !memcmp(data->d_buf + name_off, SDT_NOTE_NAME,
>> +			    sizeof(SDT_NOTE_NAME))) {
>> +			ret = populate_sdt_note(&elf, ((data->d_buf) + desc_off),
>> +						nhdr.n_descsz, nhdr.n_type,
>> +						sdt_notes);
>> +			if (ret < 0)
>> +				goto out_ret;
>> +		}
>> +	}
>> +	if (list_empty(sdt_notes))
>> +		ret = -ENOENT;
>> +
>> +out_ret:
>> +	return ret;
>> +}

-- 
Thanks,
Hemant Kumar

