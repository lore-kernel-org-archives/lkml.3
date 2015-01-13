Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbbAMIhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 03:37:52 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:27518 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbbAMIhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 03:37:51 -0500
Message-ID: <54B4D925.3020906@huawei.com>
Date: Tue, 13 Jan 2015 16:36:53 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: <jolsa@kernel.org>, <namhyung@kernel.org>, <a.p.zijlstra@chello.nl>,
        <paulus@samba.org>, <mingo@redhat.com>, <acme@kernel.org>,
        <masami.hiramatsu.pt@hitachi.com>, <jean.pihet@linaro.org>,
        <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>
Subject: Re: [PATCH] perf: fix dwarf unwind using libunwind.
References: <1421117677-51536-1-git-send-email-wangnan0@huawei.com> <20150113071059.GA32634@krava.brq.redhat.com>
In-Reply-To: <20150113071059.GA32634@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.54B4D942.00C7,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 6f15500137421ca8af6131aff662dd31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/13 15:10, Jiri Olsa wrote:
> On Tue, Jan 13, 2015 at 10:54:37AM +0800, Wang Nan wrote:
> 
> SNIP
> 
>>  
>> +static int elf_is_exec(int fd, const char *name)
>> +{
>> +	Elf *elf;
>> +	GElf_Ehdr ehdr;
>> +	int retval = 0;
>> +
>> +	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
>> +	if (elf == NULL)
>> +		return 0;
>> +	if (gelf_getehdr(elf, &ehdr) == NULL)
>> +		goto out;
>> +
>> +	retval = (ehdr.e_type == ET_EXEC);
>> +
>> +out:
>> +	elf_end(elf);
>> +	pr_debug("unwind: elf_is_exec(%s): %d\n", name, retval);
>> +	return retval;
>> +
>> +}
> 
> yuou need to add stub for 'NO_LIBUNWIND_DEBUG_FRAME=1', otherwise:
> 
>   CC       util/dwarf-aux.o
>   CC       util/unwind-libunwind.o
> util/unwind-libunwind.c:188:12: error: ‘elf_is_exec’ defined but not used [-Werror=unused-function]
>  static int elf_is_exec(int fd, const char *name)
>             ^
> cc1: all warnings being treated as errors
> make[1]: *** [util/unwind-libunwind.o] Error 1
> make[1]: *** Waiting for unfinished jobs....
> make: *** [all] Error 2
> 
> jirka
> 

Thanks. I haven't test NO_LIBUNWIND_DEBUG_FRAME=1 case.

I found that it is possible to utilize map->dso->adjust_symbols for this propose so
we don't need to introduce another function to check ehdr.e_type. However
map->dso->adjust_symbols checks not only ET_EXEC but also ET_REL. What do you think?

I'd like to check it and post another patch.

>> +
>>  struct table_entry {
>>  	u32 start_ip_offset;
>>  	u32 fde_offset;
>> @@ -322,8 +343,12 @@ find_proc_info(unw_addr_space_t as, unw_word_t ip, unw_proc_info_t *pi,
>>  #ifndef NO_LIBUNWIND_DEBUG_FRAME
>>  	/* Check the .debug_frame section for unwinding info */
>>  	if (!read_unwind_spec_debug_frame(map->dso, ui->machine, &segbase)) {
>> +		int fd = dso__data_fd(map->dso, ui->machine);
>> +		int is_exec = elf_is_exec(fd, map->dso->name);
>> +		unw_word_t base = is_exec ? 0 : map->start;
>> +
>>  		memset(&di, 0, sizeof(di));
>> -		if (dwarf_find_debug_frame(0, &di, ip, 0, map->dso->name,
>> +		if (dwarf_find_debug_frame(0, &di, ip, base, map->dso->name,
>>  					   map->start, map->end))
>>  			return dwarf_search_unwind_table(as, ip, &di, pi,
>>  							 need_unwind_info, arg);
>> -- 
>> 1.8.4
>>


