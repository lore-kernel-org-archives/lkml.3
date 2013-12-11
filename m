Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab3LKBh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:37:29 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:26260 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab3LKBh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:37:28 -0500
Message-ID: <52A7C16A.9040106@huawei.com>
Date: Wed, 11 Dec 2013 09:35:38 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>, Linn Crosetto <linn@hp.com>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH] mm,x86: fix span coverage in e820_all_mapped()
References: <52A6D9B0.7040506@huawei.com> <CAE9FiQUd+sU4GEq0687u8+26jXJiJVboN90+L7svyosmm+V1Rg@mail.gmail.com>
In-Reply-To: <CAE9FiQUd+sU4GEq0687u8+26jXJiJVboN90+L7svyosmm+V1Rg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/11 5:06, Yinghai Lu wrote:

> On Tue, Dec 10, 2013 at 1:06 AM, Xishi Qiu <qiuxishi@huawei.com> wrote:
>> In the following case, e820_all_mapped() will return 1.
>> A < start < B-1 and B < end < C, it means <start, end> spans two regions.
>> <start, end>:           [start - end]
>> e820 addr:          ...[A - B-1][B - C]...
> 
> should be [start, end) right?
> and
> [A, B),[B, C)
> 

Hi Yinghai,

It is right, in this case the function will return 1.

>>
>> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
>> ---
>>  arch/x86/kernel/e820.c |   15 +++------------
>>  1 files changed, 3 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
>> index 174da5f..31ecab2 100644
>> --- a/arch/x86/kernel/e820.c
>> +++ b/arch/x86/kernel/e820.c
>> @@ -85,20 +85,11 @@ int __init e820_all_mapped(u64 start, u64 end, unsigned type)
>>
>>                 if (type && ei->type != type)
>>                         continue;
>> -               /* is the region (part) in overlap with the current region ?*/
>> +               /* is the region (part) in overlap with the current region ? */
>>                 if (ei->addr >= end || ei->addr + ei->size <= start)
>>                         continue;
>> -
>> -               /* if the region is at the beginning of <start,end> we move
>> -                * start to the end of the region since it's ok until there
>> -                */
>> -               if (ei->addr <= start)
>> -                       start = ei->addr + ei->size;
> 
> so in your case new start will be B ?
> 
> next run will be C
> 
>> -               /*
>> -                * if start is now at or beyond end, we're done, full
>> -                * coverage
>> -                */
>> -               if (start >= end)
> 
> 
>> +               /* is the region full coverage of <start, end> ? */
>> +               if (ei->addr <= start && ei->addr + ei->size >= end)
>>                         return 1;
>>         }
>>         return 0;
> 
> also e820 should be sanitized already to have [A,C).
> 

Yes, it should be sanitized already, but maybe someone will change the e820
to support some feature, so this function will be a potential bomb.

> or you are talking about [A,B), [B+1, C)
> first run start will be B,  and next run with [B+1, ...), that will be
> skipped...
> will not return 1.
> 
> so old code should be ok.
> 

In this case, old code is right, but I discuss in another one that
you wrote above.

Thanks,
Xishi Qiu

> Thanks
> 
> Yinghai
> 
> .
> 



