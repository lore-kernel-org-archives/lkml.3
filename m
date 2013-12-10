Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab3LJMPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 07:15:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:34324 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab3LJMPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 07:15:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,865,1378882800"; 
   d="scan'208";a="441666583"
Message-ID: <52A707A2.5020802@intel.com>
Date: Tue, 10 Dec 2013 14:22:58 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Ben Cheng <bccheng@google.com>,
        David Ahern <dsahern@gmail.com>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL 00/21] perf/core improvements and fixes
References: <1386617830-18926-1-git-send-email-acme@infradead.org> <20131210111229.GB26659@gmail.com> <20131210114421.GI8098@ghostprotocols.net> <52A70558.90808@intel.com> <20131210121042.GK8098@ghostprotocols.net>
In-Reply-To: <20131210121042.GK8098@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/13 14:10, Arnaldo Carvalho de Melo wrote:
> Em Tue, Dec 10, 2013 at 02:13:12PM +0200, Adrian Hunter escreveu:
>> On 10/12/13 13:44, Arnaldo Carvalho de Melo wrote:
>>> Em Tue, Dec 10, 2013 at 12:12:29PM +0100, Ingo Molnar escreveu:
>>>>
>>>> Hm, I've unpulled it because 'perf top' crashes on exit, in 
>>>> dso__delete():
>>>
>>> 495		if (dso->sname_alloc)
>>> 496			free((char *)dso->short_name)
>>>
>>> Yeah, must be that basename() patch from Stephane, I'll work on a fix
>>> and resubmit this batch, thanks for the report.
>>
>> The problem is sname_alloc is not maintained.  Perhaps it should be
>> set in dso__set_short_name() e.g.
> 
> Yeah, sounds better than having all callers manage that thing, quickie,
> was this with Stephane's patch applied?

Yes it was at
	e993d10caeb6dca690dbaf86e1981ba240d1414a
	perf symbols: fix bug in usage of the basename() function

> 
> I think it should be done as a prep, then apply a modified version of
> Stephanes, that doesn't deal with the alloc flag (more than using 'true'
> to say it is a malloc'ed chunk).
> 
> - Arnaldo
>  
>> diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
>> index 9fae484..54ed980 100644
>> --- a/tools/perf/util/dso.c
>> +++ b/tools/perf/util/dso.c
>> @@ -379,7 +379,7 @@ struct dso *dso__kernel_findnew(struct machine *machine,
>> const char *name,
>>  	 * processing we had no idea this was the kernel dso.
>>  	 */
>>  	if (dso != NULL) {
>> -		dso__set_short_name(dso, short_name);
>> +		dso__set_short_name(dso, short_name, false);
>>  		dso->kernel = dso_type;
>>  	}
>>
>> @@ -394,10 +394,13 @@ void dso__set_long_name(struct dso *dso, char *name)
>>  	dso->long_name_len = strlen(name);
>>  }
>>
>> -void dso__set_short_name(struct dso *dso, const char *name)
>> +void dso__set_short_name(struct dso *dso, const char *name, bool sname_alloc)
>>  {
>>  	if (name == NULL)
>>  		return;
>> +	if (dso->sname_alloc)
>> +		free((char *)dso->short_name);
>> +	dso->sname_alloc = sname_alloc;
>>  	dso->short_name = name;
>>  	dso->short_name_len = strlen(name);
>>  }
>> @@ -426,12 +429,7 @@ static void dso__set_basename(struct dso *dso)
>>  	if (!base)
>>  		return;
>>
>> -	if (dso->sname_alloc)
>> -		free((char *)dso->short_name);
>> -	else
>> -		dso->sname_alloc = 1;
>> -
>> -	dso__set_short_name(dso, base);
>> +	dso__set_short_name(dso, base, true);
>>  }
>>
>>  int dso__name_len(const struct dso *dso)
>> @@ -467,7 +465,7 @@ struct dso *dso__new(const char *name)
>>  		int i;
>>  		strcpy(dso->name, name);
>>  		dso__set_long_name(dso, dso->name);
>> -		dso__set_short_name(dso, dso->name);
>> +		dso__set_short_name(dso, dso->name, false);
>>  		for (i = 0; i < MAP__NR_TYPES; ++i)
>>  			dso->symbols[i] = dso->symbol_names[i] = RB_ROOT;
>>  		dso->cache = RB_ROOT;
>> diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
>> index 384f2d9..166463e 100644
>> --- a/tools/perf/util/dso.h
>> +++ b/tools/perf/util/dso.h
>> @@ -110,7 +110,7 @@ static inline void dso__set_loaded(struct dso *dso, enum
>> map_type type)
>>  struct dso *dso__new(const char *name);
>>  void dso__delete(struct dso *dso);
>>
>> -void dso__set_short_name(struct dso *dso, const char *name);
>> +void dso__set_short_name(struct dso *dso, const char *name, bool sname_alloc);
>>  void dso__set_long_name(struct dso *dso, char *name);
>>
>>  int dso__name_len(const struct dso *dso);
>>
>>
>>>
>>> - Arnaldo
>>>  
>>>> [Thread 0x7ffff70df700 (LWP 29561) exited]
>>>> *** Error in `/fast/mingo/tip/tools/perf/perf': munmap_chunk(): invalid pointer: 0x0000000000587371 ***
>>>> ======= Backtrace: =========
>>>> /lib64/libc.so.6[0x3e5907bbe7]
>>>> /fast/mingo/tip/tools/perf/perf(dso__delete+0xd9)[0x46da89]
>>>> /fast/mingo/tip/tools/perf/perf(machines__exit+0xad)[0x482e7d]
>>>> /fast/mingo/tip/tools/perf/perf(perf_session__delete+0xb6)[0x488c66]
>>>> /fast/mingo/tip/tools/perf/perf(cmd_top+0xf44)[0x4345f4]
>>>> /fast/mingo/tip/tools/perf/perf[0x419f95]
>>>> /fast/mingo/tip/tools/perf/perf(main+0x600)[0x419830]
>>>> /lib64/libc.so.6(__libc_start_main+0xf5)[0x3e59021b45]
>>>> /fast/mingo/tip/tools/perf/perf[0x4198fd]
>>>> ======= Memory map: ========
>>>>
>>>> Program received signal SIGABRT, Aborted.
>>>> 0x0000003e590359e9 in raise () from /lib64/libc.so.6
>>>> Missing separate debuginfos, use: debuginfo-install audit-libs-2.3.2-1.fc19.x86_64 bzip2-libs-1.0.6-8.fc19.x86_64 elfutils-libelf-0.156-5.fc19.x86_64 elfutils-libs-0.156-5.fc19.x86_64 glibc-2.17-19.fc19.x86_64 libgcc-4.8.2-1.fc19.x86_64 libunwind-1.1-2.fc19.x86_64 nss-softokn-freebl-3.15.2-2.fc19.x86_64 numactl-libs-2.0.8-4.fc19.x86_64 perl-libs-5.16.3-266.fc19.x86_64 python-libs-2.7.5-9.fc19.x86_64 slang-2.2.4-8.fc19.x86_64 xz-libs-5.1.2-4alpha.fc19.x86_64 zlib-1.2.7-10.fc19.x86_64
>>>> (gdb) 
>>>> (gdb) bt
>>>> #0  0x0000003e590359e9 in raise () from /lib64/libc.so.6
>>>> #1  0x0000003e590370f8 in abort () from /lib64/libc.so.6
>>>> #2  0x0000003e59075d17 in __libc_message () from /lib64/libc.so.6
>>>> #3  0x0000003e5907bbe7 in malloc_printerr () from /lib64/libc.so.6
>>>> #4  0x000000000046da89 in dso__delete (dso=0x8e46f0) at util/dso.c:496
>>>> #5  0x0000000000482e7d in dsos__delete (dsos=0x8e4490) at util/machine.c:72
>>>> #6  machine__exit (machine=<optimized out>) at util/machine.c:103
>>>> #7  machines__exit (machines=machines@entry=0x8e4438) at util/machine.c:123
>>>> #8  0x0000000000488c66 in perf_session__delete (session=0x8e4360) at util/session.c:155
>>>> #9  0x00000000004345f4 in __cmd_top (top=0x7fffffffb140) at builtin-top.c:985
>>>> #10 cmd_top (argc=<optimized out>, argv=<optimized out>, prefix=<optimized out>) at builtin-top.c:1210
>>>> #11 0x0000000000419f95 in run_builtin (p=p@entry=0x7ece88 <commands+264>, argc=argc@entry=2, argv=argv@entry=0x7fffffffe420) at perf.c:319
>>>> #12 0x0000000000419830 in handle_internal_command (argv=0x7fffffffe420, argc=2) at perf.c:376
>>>> #13 run_argv (argv=0x7fffffffe220, argcp=0x7fffffffe22c) at perf.c:420
>>>> #14 main (argc=2, argv=0x7fffffffe420) at perf.c:529
>>>> (gdb) 
>>>>
>>>> Running it on an up-to-date installation of Fedora 19.
>>>>
>>>> Thanks,
>>>>
>>>> 	Ingo
>>>
>>>
> 
> 

