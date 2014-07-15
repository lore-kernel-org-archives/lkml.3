Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbaGOJkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:40:12 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:21688 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbaGOJkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:40:07 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-a3-53c4f6f4f2ca
Message-id: <53C4F5A9.6030202@samsung.com>
Date: Tue, 15 Jul 2014 13:34:33 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org
Subject: Re: [RFC/PATCH RESEND -next 20/21] fs: dcache: manually unpoison dname
 after allocation to shut up kasan's reports
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1404905415-9046-21-git-send-email-a.ryabinin@samsung.com>
 <20140715061219.GK11317@js1304-P5Q-DELUXE>
In-reply-to: <20140715061219.GK11317@js1304-P5Q-DELUXE>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t/xa7pfvh0JNpj2Ttji996ZrBZz1q9h
	s7j+7Q2jxYSHbewWK7ub2Sy2P3vLZLGy8wGrxabH11gt/uzawWRxedccNot7a/6zWty+zGtx
	6cACJouWfReYLNo+/2O12LfyPJC1ZCOTxeIjt5kt3j2bzGyxedNUZosfGx6zOoh6tDT3sHns
	nHWX3WPBplKPTas62Tw2fZrE7tH19gqTx7tz59g9Tsz4zeLx5Mp0Jo/NS+o9Pj69xeLxft9V
	No8zC46we3zeJBfAF8Vlk5Kak1mWWqRvl8CVsfXLTvaCbqGKVT0/WBoYz/N1MXJySAiYSMxt
	2cUIYYtJXLi3nq2LkYtDSGApo8TCiQ+YIZxmJomec1dYQKp4BbQkbs2/ANbBIqAqsffxTVYQ
	m01AT+LfrO1sILaoQITEgb5nrBD1ghI/Jt8D6xUR0JBYvWoz2FBmgfOsEvdf/WICSQgL1Eq8
	OfuGHWLbekaJ96uOgXVzCphLrJ13jx3EZhbQkdjfOo0NwpaX2LzmLfMERoFZSJbMQlI2C0nZ
	AkbmVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghsfxlB+PiY1aHGAU4GJV4eCvEDgcLsSaW
	FVfmHmKU4GBWEuG9/elIsBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGP/0NV6a4rm3hC2XKnRpy
	WE6BbZ7RbYHrW5YdE3pzVmRlVY5Qff+Ro8xyUcmtJ6/u3VV7ZPd5Ns+fMwUsTRyKlqqvs/aS
	Lq5vf2SmELspNXBdkHr8wpPTj71++KTm8bWnrDd990c4bc6q2ae2YPvvrU5b512winq2iLP6
	c8mNn2fYZpu5S4ddUWIpzkg01GIuKk4EAAriqGDDAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/14 10:12, Joonsoo Kim wrote:
> On Wed, Jul 09, 2014 at 03:30:14PM +0400, Andrey Ryabinin wrote:
>> We need to manually unpoison rounded up allocation size for dname
>> to avoid kasan's reports in __d_lookup_rcu.
>> __d_lookup_rcu may validly read a little beyound allocated size.
> 
> If it read a little beyond allocated size, IMHO, it is better to
> allocate correct size.
> 
> kmalloc(name->len + 1, GFP_KERNEL); -->
> kmalloc(roundup(name->len + 1, sizeof(unsigned long ), GFP_KERNEL);
> 
> Isn't it?
> 

It's not needed here because kmalloc always roundup allocation size.

This out of bound access happens in dentry_string_cmp() if CONFIG_DCACHE_WORD_ACCESS=y.
dentry_string_cmp() relays on fact that kmalloc always round up allocation size,
in other words it's by design.

That was discussed some time ago here - https://lkml.org/lkml/2013/10/3/493.
Since filesystem's maintainer don't want to add needless round up here, I'm not going to do it.

I think this patch needs only more detailed description why we not simply allocate more.
Also I think it would be better to rename unpoisoin_shadow to something like kasan_mark_allocated().


> Thanks.
> 
>>
>> Reported-by: Dmitry Vyukov <dvyukov@google.com>
>> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
>> ---
>>  fs/dcache.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/dcache.c b/fs/dcache.c
>> index b7e8b20..dff64f2 100644
>> --- a/fs/dcache.c
>> +++ b/fs/dcache.c
>> @@ -38,6 +38,7 @@
>>  #include <linux/prefetch.h>
>>  #include <linux/ratelimit.h>
>>  #include <linux/list_lru.h>
>> +#include <linux/kasan.h>
>>  #include "internal.h"
>>  #include "mount.h"
>>  
>> @@ -1412,6 +1413,8 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
>>  			kmem_cache_free(dentry_cache, dentry); 
>>  			return NULL;
>>  		}
>> +		unpoison_shadow(dname,
>> +				roundup(name->len + 1, sizeof(unsigned long)));
>>  	} else  {
>>  		dname = dentry->d_iname;
>>  	}	
>> -- 
>> 1.8.5.5
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

