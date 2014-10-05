Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaJEISB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 04:18:01 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:60032 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaJEIR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 04:17:56 -0400
Message-ID: <5430FEA9.3090405@linux.vnet.ibm.com>
Date: Sun, 05 Oct 2014 13:47:45 +0530
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v2 1/5] perf/sdt: ELF support for SDT
References: <20141001023723.28985.39736.stgit@hemant-fedora> <20141001024525.28985.95513.stgit@hemant-fedora> <542E8AF3.2030206@hitachi.com>
In-Reply-To: <542E8AF3.2030206@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100508-0013-0000-0000-0000004E6D8C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/03/2014 05:09 PM, Masami Hiramatsu wrote:
> (2014/10/01 11:47), Hemant Kumar wrote:
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
> Looks almost good!
> I have some comments, please see below.

Ok.

>> Signed-off-by: Hemant Kumar <hemant@linux.vnet.ibm.com>
>> ---
>>   tools/perf/util/symbol-elf.c |  207 ++++++++++++++++++++++++++++++++++++++++++
>>   tools/perf/util/symbol.h     |   19 ++++
>>   2 files changed, 226 insertions(+)
>>
>> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
>> index 2a92e10..9702167 100644
>> --- a/tools/perf/util/symbol-elf.c
>> +++ b/tools/perf/util/symbol-elf.c
>> @@ -1672,6 +1672,213 @@ void kcore_extract__delete(struct kcore_extract *kce)
>>   	unlink(kce->extract_filename);
>>   }
>>   
>> +/*
>> + * populate_sdt_note() : Responsible for parsing the section .note.stapsdt and
>> + * after adjusting the note's location, returns that to the calling functions.
>> + */
>> +static int populate_sdt_note(Elf **elf, const char *data, size_t len, int type,
>> +			     struct sdt_note **note)
>> +{
>> +	const char *provider, *name;
>> +	struct sdt_note *tmp = NULL;
>> +	GElf_Ehdr ehdr;
>> +	GElf_Addr base_off = 0;
>> +	GElf_Shdr shdr;
>> +	int ret = -1;
> -1 is not an error code. maybe, -EINVAL is better.

Sure, will change this to EINVAL.

>> +	int i;
>> +
>> +	union {
>> +		Elf64_Addr a64[3];
>> +		Elf32_Addr a32[3];
>> +	} buf;
>> +
>> +	Elf_Data dst = {
>> +		.d_buf = &buf, .d_type = ELF_T_ADDR, .d_version = EV_CURRENT,
>> +		.d_size = gelf_fsize((*elf), ELF_T_ADDR, 3, EV_CURRENT),
>> +		.d_off = 0, .d_align = 0
>> +	};
>> +	Elf_Data src = {
>> +		.d_buf = (void *) data, .d_type = ELF_T_ADDR,
>> +		.d_version = EV_CURRENT, .d_size = dst.d_size, .d_off = 0,
>> +		.d_align = 0
>> +	};
>> +
>> +	/* Check the type of each of the notes */
>> +	if (type != SDT_NOTE_TYPE)
>> +		goto out_err;
>> +
>> +	tmp = (struct sdt_note *)calloc(1, sizeof(struct sdt_note));
>> +	if (!tmp) {
>> +		ret = -ENOMEM;
>> +		goto out_err;
>> +	}
>> +
>> +	INIT_LIST_HEAD(&tmp->note_list);
>> +
>> +	if (len < dst.d_size + 3)
>> +		goto out_free_note;
>> +
>> +	/* Translation from file representation to memory representation */
>> +	if (gelf_xlatetom(*elf, &dst, &src,
>> +			  elf_getident(*elf, NULL)[EI_DATA]) == NULL)
>> +		printf("gelf_xlatetom : %s\n", elf_errmsg(-1));
> pr_err? and shouldn't it goes to out_free_note?

Yes it should go to out_free_note. Will make the change.

>> [...]
>>
>>

Thank You for reviewing this patch.

-- 
Thanks,
Hemant Kumar

