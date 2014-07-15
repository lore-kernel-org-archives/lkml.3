Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889AbaGOMNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:13:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:12478 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758376AbaGOMNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:13:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,665,1400050800"; 
   d="scan'208";a="562022545"
Message-ID: <53C51A8C.7050304@intel.com>
Date: Tue, 15 Jul 2014 15:11:56 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 08/41] perf tools: Fix missing label symbols
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com> <1405332185-4050-9-git-send-email-adrian.hunter@intel.com> <20140714203835.GB18133@kernel.org>
In-Reply-To: <20140714203835.GB18133@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 11:38 PM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jul 14, 2014 at 01:02:32PM +0300, Adrian Hunter escreveu:
>> label symbols are missing because elf_sec__is_a() fails
>> to find the section because the section strings do not
>> match the section headers because the sections headers
>> are from the 'runtime' object and the sections strings
>> are from the 'symbol source' object.
>>
>> Fix by getting the section strings from the 'runtime'
>> object so that they match the section headers.
> 
> Would be great to have a 'perf test' entry that fail when looking for
> those 'label symbols', i.e. looking for one such symbol in vmlinux that
> we know is always there, in some written in stone area of the kernel,
> where this label vanishing is unlikely to happen.
> 
> Can you elaborate on the case that fails? So that I can test it here,
> and then after the fix, check that it indeed fixes the problem? I may
> well write that test myself and insert it in my branch just before this
> one.

It fails with "_start" which is a label in /lib/x86_64-linux-gnu/ld-2.17.so.
It is where the program starts so it is not a function, and it is the first
user space address of an exec'ed process.

If you do:

	perf record --per-thread -T -e branches:u -c1 -d -- uname

Then, assuming the old BTS driver doesn't lose the data, it should be
pretty much the first branch.

	pref script | head

> 
> - Arnaldo
>  
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/util/symbol-elf.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
>> index 6864661..8c96817 100644
>> --- a/tools/perf/util/symbol-elf.c
>> +++ b/tools/perf/util/symbol-elf.c
>> @@ -732,7 +732,7 @@ int dso__load_sym(struct dso *dso, struct map *map,
>>  	if (symstrs == NULL)
>>  		goto out_elf_end;
>>  
>> -	sec_strndx = elf_getscn(elf, ehdr.e_shstrndx);
>> +	sec_strndx = elf_getscn(runtime_ss->elf, runtime_ss->ehdr.e_shstrndx);
>>  	if (sec_strndx == NULL)
>>  		goto out_elf_end;
>>  
>> -- 
>> 1.8.3.2
> 
> 

