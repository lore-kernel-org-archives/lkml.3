Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751068AbaLPFra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 00:47:30 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:43706 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaLPFr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 00:47:29 -0500
Message-ID: <548FC75E.5010602@huawei.com>
Date: Tue, 16 Dec 2014 13:47:10 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@kernel.org>, <ak@linux.intel.com>, <lizefan@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: fix building warning on ARM 32.
References: <1418695810-74455-1-git-send-email-wangnan0@huawei.com> <20141216044909.GA20215@sejong>
In-Reply-To: <20141216044909.GA20215@sejong>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A010201.548FC76E.0167,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 1e3ed97c67674dd95e36f64920e62e18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/16 12:49, Namhyung Kim wrote:
> Hi Wang,
> 
> On Tue, Dec 16, 2014 at 10:10:10AM +0800, Wang Nan wrote:
>> Commit 85c116a6c introduces asprintf() call and matches '%ld' to a u64
>> argument, which is incorrect on ARM.
>>
>>    CC       /home/wn/util/srcline.o
>>  util/srcline.c: In function 'get_srcline':
>>  util/srcline.c:297:6: error: format '%ld' expects argument of type 'long int', but argument 4 has type 'u64' [-Werror=format]
>>  cc1: all warnings being treated as errors
>>  make[1]: *** [/home/wn/util/srcline.o] Error 1
> 
> Hmm.. shouldn't it be %PRIu64 instead?
> 

It is a difference between two addresses, and I believe the value should not be very large.

Anyway, I'll follow your advise if you prefer to use %PRIu64.

In addition, addr is 'unsigned long addr', sym->start is 'u64', the type if
this expression is more or less obscure to readers. By investigating all caller
of get_srcline(), I find that the type of 'addr' should be 'u64', not 'unsigned long'.
So I'll post another patch which fixes param list of get_srcline() also.

Thanks.

> Thanks,
> Namhyung
> 
> 
>>
>> Signed-off-by: Wang Nan <wangnan0@huawei.com>
>> ---
>>  tools/perf/util/srcline.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
>> index e73b6a5..42cb642 100644
>> --- a/tools/perf/util/srcline.c
>> +++ b/tools/perf/util/srcline.c
>> @@ -294,7 +294,7 @@ out:
>>  	}
>>  	if (sym) {
>>  		if (asprintf(&srcline, "%s+%ld", show_sym ? sym->name : "",
>> -					addr - sym->start) < 0)
>> +					(long int)(addr - sym->start)) < 0)
>>  			return SRCLINE_UNKNOWN;
>>  	} else if (asprintf(&srcline, "%s[%lx]", dso->short_name, addr) < 0)
>>  		return SRCLINE_UNKNOWN;
>> -- 
>> 1.8.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/


