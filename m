Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313AbaJPDVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 23:21:45 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:25919 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaJPDVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 23:21:44 -0400
Message-ID: <543F39A9.3030308@huawei.com>
Date: Thu, 16 Oct 2014 11:21:13 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        <zhangzhiqiang.zhang@huawei.com>, <peifeiyue@huawei.com>
Subject: Re: [PATCH] perf tools: fix incorrect header string
References: <1413343733-7973-1-git-send-email-wangnan0@huawei.com> <20141015151358.GK3198@kernel.org>
In-Reply-To: <20141015151358.GK3198@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.543F39C5.0124,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 42c5bab00416c5614985352a045f9653
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/15 23:13, Arnaldo Carvalho de Melo wrote:
> Em Wed, Oct 15, 2014 at 11:28:53AM +0800, Wang Nan escreveu:
>> Commit fbe96f29 (perf tools: Make perf.data more self-descriptive)
>> read '/proc/cpuinfo' to form cpu descriptor. For ARM, it finds
>> 'Processor' field. It is correct when the patch merged, but due to
>> commit b4b8f770 (ARM: kernel: update cpuinfo to print all online CPUs
>> features), the corresponding information becomes 'model name' field.
>>
>> This patch simply corrects it.
> 
> It doesn't :-)
> 
> It makes it work with kernels >= b4b8f770, and fail with older kernels.
> 
> We need to somehow figure out where the right information is regardless
> of the kernel.
> 
> - Arnaldo
>  

However it is a real problem. Look at output on arm platform at the
bottom of this mail, especially  "cpudesc", "total memory" and "cmdline" field.

By further debugging I found that the real problem resides in return value checking
when write header error. Please see my other patches:

https://lkml.org/lkml/2014/10/15/612
https://lkml.org/lkml/2014/10/15/611

I think at least one of them is required.

Thanks.

>> Signed-off-by: Wang Nan <wangnan0@huawei.com>
>> ---
>>  tools/perf/perf-sys.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/perf/perf-sys.h b/tools/perf/perf-sys.h
>> index 937e432..4293970 100644
>> --- a/tools/perf/perf-sys.h
>> +++ b/tools/perf/perf-sys.h
>> @@ -113,7 +113,7 @@
>>  #define mb()		((void(*)(void))0xffff0fa0)()
>>  #define wmb()		((void(*)(void))0xffff0fa0)()
>>  #define rmb()		((void(*)(void))0xffff0fa0)()
>> -#define CPUINFO_PROC	"Processor"
>> +#define CPUINFO_PROC	"model name"
>>  #endif
>>  
>>  #ifdef __aarch64__
>> -- 
>> 1.8.4



bash-4.2# perf record ls
...
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.001 MB perf.data (~36 samples) ]
bash-4.2# perf report --stdio --header
Error:
The perf.data file has no samples!
# ========
# captured on: Fri Sep 12 10:09:10 2014
# hostname : arma15el
# os release : 3.17.0+
# perf version : 3.10.53
# arch : armv7l
# nrcpus online : 4
# nrcpus avail : 1
# cpudesc : (null)
# total memory : 0 kB
# cmdline :
# event : name = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 1, precise_ip = 0
# pmu mappings: not available
# ========
#



