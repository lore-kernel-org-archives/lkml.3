Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab3JXKZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 06:25:44 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:43684 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab3JXKZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 06:25:43 -0400
Message-ID: <5268F59F.6030506@linux.vnet.ibm.com>
Date: Thu, 24 Oct 2013 15:55:35 +0530
From: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
References: <20131023044511.1886.82571.stgit@hemant-fedora> <20131023050502.1886.15779.stgit@hemant-fedora> <5268B3EE.5060603@hitachi.com>
In-Reply-To: <5268B3EE.5060603@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102410-1618-0000-0000-000004DB7598
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/24/2013 11:15 AM, Masami Hiramatsu wrote:
> (2013/10/23 14:05), Hemant Kumar wrote:
>> This allows perf to probe into the sdt markers/notes present in
>> the libraries and executables. We try to find the associated location
>> and handle prelinking (since, stapsdt notes section is not allocated
>> during runtime). Prelinking is handled with the help of base
>> section which is allocated during runtime. This address can be compared
>> with the address retrieved from the notes' description. If its different,
>> we can take this difference and then add to the note's location.
>>
>> We can use existing '-a/--add' option to add events for sdt markers.
>> Also, we can add multiple events at once using the same '-a' option.
>>
>> Usage:
>> perf probe -x /lib64/libc.so.6 -a 'my_event=%libc:setjmp'
>>
>> Output:
>> Added new event:
>>    libc:my_event        (on 0x35981)
>>
>> You can now use it in all perf tools, such as:
>>
>>      perf record -e libc:my_event -aR sleep 1
>>
>>
>> Signed-off-by: Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com>
> Almost! please check below comments :)

:) Thanks again for reviewing the patches.

>
>>   static int convert_to_probe_trace_events(struct perf_probe_event *pev,
>>   					  struct probe_trace_event **tevs,
>>   					  int max_tevs, const char *target)
>> @@ -1916,11 +1975,23 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
>>   	struct symbol *sym;
>>   	int ret = 0, i;
>>   	struct probe_trace_event *tev;
>> +	char *buf;
>> +	unsigned long long addr;
>>   
>> -	/* Convert perf_probe_event with debuginfo */
>> -	ret = try_to_find_probe_trace_events(pev, tevs, max_tevs, target);
>> -	if (ret != 0)
>> -		return ret;	/* Found in debuginfo or got an error */
>> +	if (pev->sdt) {
>> +		ret = -EBADF;
>> +		if (pev->uprobes)
>> +			ret = try_to_find_sdt_notes(pev, target);
>> +		if (ret)
>> +			return ret;
>> +	} else {
>> +		/* Convert perf_probe_event with debuginfo */
>> +		ret = try_to_find_probe_trace_events(pev, tevs, max_tevs,
>> +						     target);
>> +		/* Found in debuginfo or got an error */
>> +		if (ret != 0)
>> +			return ret;
> These "ret != 0" checkers can be merged.
>
> [...]

Indeed, they can be merged.

>> +int search_sdt_note(struct sdt_note *key, const char *target)
>> +{
>> +	Elf *elf;
>> +	int fd, ret;
>> +	bool found = false;
>> +	struct sdt_note *pos = NULL;
>> +	LIST_HEAD(sdt_notes);
>> +
>> +	fd = open(target, O_RDONLY);
>> +	if (fd < 0) {
>> +		pr_err("%s : %s\n", target, strerror(errno));
>> +		return -errno;
>> +	}
>> +
>> +	symbol__elf_init();
>> +	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
>> +	if (!elf) {
>> +		ret = -EBADF;
>> +		pr_debug("Can't read the elf of %s\n", target);
>> +		goto out_close;
>> +	}
>> +
>> +	ret = construct_sdt_notes_list(elf, &sdt_notes);
>> +	if (ret)
>> +		goto out_end;
>> +
>> +	/* Iterate through the notes and retrieve the required note */
>> +	list_for_each_entry(pos, &sdt_notes, note_list) {
>> +		if (!strcmp(key->name, pos->name) &&
>> +		    !strcmp(key->provider, pos->provider)) {
>> +			adjust_note_addr(pos, key, elf);
>> +			found = true;
>> +			break;
>> +		}
>> +	}
>> +	if (!found) {
>> +		printf("%%%s:%s not found in %s!\n", key->provider, key->name,
>> +		       target);
>> +		return -ENOENT;
> Here, you skipped the closing process. maybe ret = -ENOENT is enough here.

Yeah, I have missed this. But I think ret = -ENOENT is not enough. We 
shouldn't go to sdt_err() for this case. We can return -ENOENT and print 
the error.

>> +	}
>> +
>> +out_end:
>> +	elf_end(elf);
>> +out_close:
>> +	close(fd);
>> +	ret = sdt_err(ret, target);
> It seems the sdt_err is only for the return value of contruct_sdt_notes_list(),
> thus it is better to integrate it.

Yeah it'll be better to integrate it.

>
>> +	if (!ret && list_empty(&sdt_notes))
>> +		ret = -ENOENT;
> I think this can be removed, because it always be false (caught by previous !found).

I wrote this check for 'no markers present' case. Anyways, the result is 
the same, so,
I guess we can eliminate this (since, its covered by the 'found' check).

>
>> +	cleanup_sdt_note_list(&sdt_notes);
>> +	return ret;
>> +}
>

I think it'll be better to move the check for found : if (!found) {} 
after cleanup_sdt_notes().

-- 
Thanks
Hemant Kumar

