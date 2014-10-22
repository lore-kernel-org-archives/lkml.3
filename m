Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbaJVHtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:49:49 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:30839 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaJVHtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:49:47 -0400
Message-ID: <54476175.3070406@huawei.com>
Date: Wed, 22 Oct 2014 15:49:09 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Waiman Long <Waiman.Long@hp.com>,
        <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] perf tools: makes CPUINFO_PROC to array for different
 kernel version
References: <1413428923-80073-1-git-send-email-wangnan0@huawei.com> <87wq7seh8d.fsf@sejong.aot.lge.com>
In-Reply-To: <87wq7seh8d.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/22 14:44, Namhyung Kim wrote:
> Hi Wang,
> 
> On Thu, 16 Oct 2014 11:08:43 +0800, Wang Nan wrote:
>> After kerne 3.7 (commit b4b8f770eb10a1bccaf8aa0ec1956e2dd7ed1e0a),
>> /proc/cpuinfo replcae 'Processor' to 'model name'. This patch makes
>> CPUINFO_PROC to an array and provides two choices for ARM, make it
>> compatible for different kernel version.
>>
>> Signed-off-by: Wang Nan <wangnan0@huawei.com>
>> -static int write_cpudesc(int fd, struct perf_header *h __maybe_unused,
>> -		       struct perf_evlist *evlist __maybe_unused)
>> +static int __write_cpudesc(int fd, struct perf_header *h __maybe_unused,
>> +		       struct perf_evlist *evlist __maybe_unused, const char *cpuinfo_proc)
> 
> You don't need to pass @h and @evlist if they're not used.
> 
> 
>>  {
>> -#ifndef CPUINFO_PROC
>> -#define CPUINFO_PROC NULL
>> -#endif
>>  	FILE *file;
>>  	char *buf = NULL;
>>  	char *s, *p;
>> -	const char *search = CPUINFO_PROC;
>> +	const char *search = cpuinfo_proc;
>>  	size_t len = 0;
>>  	int ret = -1;
>>  
>> @@ -640,6 +637,23 @@ done:
>>  	return ret;
>>  }
>>  
>> +static int write_cpudesc(int fd, struct perf_header *h __maybe_unused,
>> +		       struct perf_evlist *evlist __maybe_unused)
>> +{
>> +#ifndef CPUINFO_PROC
>> +#define CPUINFO_PROC {"model name", }
>> +#endif
>> +	const char *cpuinfo_procs[] = CPUINFO_PROC;
>> +	unsigned int i;
> 
> Please put a blank line between declaration and the function body.
> 
> Other than that, looks good to me.
> 
> Thanks,
> Namhyung
> 

I posted a v2 patch, please refer to https://lkml.org/lkml/2014/10/22/85 .

Thanks.

> 
>> +	for (i = 0; i < ARRAY_SIZE(cpuinfo_procs); i++) {
>> +		int ret;
>> +		ret = __write_cpudesc(fd, h, evlist, cpuinfo_procs[i]);
>> +		if (ret >= 0)
>> +			return ret;
>> +	}
>> +	return -1;
>> +}
>> +
>>  static int write_nrcpus(int fd, struct perf_header *h __maybe_unused,
>>  			struct perf_evlist *evlist __maybe_unused)
>>  {


