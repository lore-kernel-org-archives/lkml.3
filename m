Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbaFXFxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 01:53:49 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46219 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaFXFxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 01:53:48 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-82-53a912643815
Message-id: <53A91125.8020203@samsung.com>
Date: Tue, 24 Jun 2014 09:48:21 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, tetra2005@gmail.com, preobr@google.com,
        dvyukov@google.com, kcc@google.com, koct9i@gmail.com
Subject: Re: [PATCH] lib: idr: fix out-of-bounds pointer dereference
References: <1403530628-32306-1-git-send-email-a.ryabinin@samsung.com>
 <53A8D3B0.8090004@cn.fujitsu.com>
In-reply-to: <53A8D3B0.8090004@cn.fujitsu.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t/xy7opQiuDDdp3WVrMWb+GzWLCwzZ2
	i+3P3jJZrOx8wGqxYnUbq8XlXXPYLPatPM9k8e7ZZGaLX8uPMjpwevw/OInZY+esu+weCzaV
	emxa1cnmcWLGbxaPz5vkAtiiuGxSUnMyy1KL9O0SuDJ23lrIXjBXoeLv6Y+MDYzN4l2MnBwS
	AiYSM65MYYSwxSQu3FvP1sXIxSEksJRR4tvR3ywQTjOTxIPPu1lAqngFtCTu3l3NBGKzCKhK
	nFy4HcxmE9CT+DdrOxuILSoQIXGg7xkrRL2gxI/J94B6OThEBDQkrhwJA5nJLHCCUWLpr2ms
	IHFhAReJP2uTQcqFBLIkZu6+wA5icwKNPLVzL9hIZgF1iUnzFjFD2PISm9e8ZZ7AKDALyYZZ
	SMpmISlbwMi8ilE0tTS5oDgpPddQrzgxt7g0L10vOT93EyMkAr7sYFx8zOoQowAHoxIP74Vd
	K4KFWBPLiitzDzFKcDArifBafgEK8aYkVlalFuXHF5XmpBYfYmTi4JRqYNy6+nHL4S0HVL46
	7/U+z61zexLjmsWRK3xmrF1uxrz+2k2zSWlXH/6c5NJZ9f9R2MGE1KUdM6SK26dUHZ18f5dn
	Zn54gZb/1rBpwcXKVd5xa9Xkbt9zOXlmBYNVso6xD5ez/qS6t2LJDIYXWmdfOjj/xqEwDckj
	08XfPZnhLVOTPm1G2+Gs/9VKLMUZiYZazEXFiQA9ckYIXgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/14 05:26, Lai Jiangshan wrote:
> On 06/23/2014 09:37 PM, Andrey Ryabinin wrote:
>> I'm working on address sanitizer project for kernel. Recently we started
>> experiments with stack instrumentation, to detect out-of-bounds
>> read/write bugs on stack.
>>
>> Just after booting I've hit out-of-bounds read on stack in idr_for_each
>> (and in __idr_remove_all as well):
>>
>> 	struct idr_layer **paa = &pa[0];
>>
>> 	while (id >= 0 && id <= max) {
>> 		...
>> 		while (n < fls(id)) {
>> 			n += IDR_BITS;
>> 			p = *--paa; <--- here we are reading pa[-1] value.
>> 		}
>> 	}
> 
> I prefer to moving the loop-exit-condition-checking code down:
> 
> 	if (id < 0 || id > max)		/* only idr_get_next() needs this branch */
> 		return ...
> 
> 	for (;;) {			/* move out from here */
> 		...
> 		increase the @id;
> 		if (id < 0 || id > max)	/* move to here */
> 			break;
> 		while (n < fls(id)) {
> 			...
> 		}
> 	}
> 

This will work only for idr_for_each and idr_get_new, but not for __idr_remove_all, since we have to to free layers
in second loop:

		while (n < fls(id ^ bt_mask)) {
			if (p)
				free_layer(idp, p);
			n += IDR_BITS;
			p = *--paa;
		}



> 
>>
>> Despite the fact that after this dereference we are exiting out of loop and
>> never use p, such behaviour is undefined and should be avoided.
>>
>> Fix this by moving pointer derference to the beggining of the loop, right
>> before we will use it.
>>
>> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
>> ---
>>  lib/idr.c | 25 ++++++++++++++-----------
>>  1 file changed, 14 insertions(+), 11 deletions(-)
>>
>> diff --git a/lib/idr.c b/lib/idr.c
>> index 39158ab..50be3fa 100644
>> --- a/lib/idr.c
>> +++ b/lib/idr.c
>> @@ -590,26 +590,27 @@ static void __idr_remove_all(struct idr *idp)
>>  	struct idr_layer **paa = &pa[0];
>>  
>>  	n = idp->layers * IDR_BITS;
>> -	p = idp->top;
>> +	*paa = idp->top;
>>  	RCU_INIT_POINTER(idp->top, NULL);
>>  	max = idr_max(idp->layers);
>>  
>>  	id = 0;
>>  	while (id >= 0 && id <= max) {
>> +		p = *paa;
>>  		while (n > IDR_BITS && p) {
>>  			n -= IDR_BITS;
>> -			*paa++ = p;
>>  			p = p->ary[(id >> n) & IDR_MASK];
>> +			*++paa = p;
>>  		}
>>  
>>  		bt_mask = id;
>>  		id += 1 << n;
>>  		/* Get the highest bit that the above add changed from 0->1. */
>>  		while (n < fls(id ^ bt_mask)) {
>> -			if (p)
>> -				free_layer(idp, p);
>> +			if (*paa)
>> +				free_layer(idp, *paa);
>>  			n += IDR_BITS;
>> -			p = *--paa;
>> +			--paa;
>>  		}
>>  	}
>>  	idp->layers = 0;
>> @@ -692,15 +693,16 @@ int idr_for_each(struct idr *idp,
>>  	struct idr_layer **paa = &pa[0];
>>  
>>  	n = idp->layers * IDR_BITS;
>> -	p = rcu_dereference_raw(idp->top);
>> +	*paa = rcu_dereference_raw(idp->top);
>>  	max = idr_max(idp->layers);
>>  
>>  	id = 0;
>>  	while (id >= 0 && id <= max) {
>> +		p = *paa;
>>  		while (n > 0 && p) {
>>  			n -= IDR_BITS;
>> -			*paa++ = p;
>>  			p = rcu_dereference_raw(p->ary[(id >> n) & IDR_MASK]);
>> +			*++paa = p;
>>  		}
>>  
>>  		if (p) {
>> @@ -712,7 +714,7 @@ int idr_for_each(struct idr *idp,
>>  		id += 1 << n;
>>  		while (n < fls(id)) {
>>  			n += IDR_BITS;
>> -			p = *--paa;
>> +			--paa;
>>  		}
>>  	}
>>  
>> @@ -740,17 +742,18 @@ void *idr_get_next(struct idr *idp, int *nextidp)
>>  	int n, max;
>>  
>>  	/* find first ent */
>> -	p = rcu_dereference_raw(idp->top);
>> +	p = *paa = rcu_dereference_raw(idp->top);
>>  	if (!p)
>>  		return NULL;
>>  	n = (p->layer + 1) * IDR_BITS;
>>  	max = idr_max(p->layer + 1);
>>  
>>  	while (id >= 0 && id <= max) {
>> +		p = *paa;
>>  		while (n > 0 && p) {
>>  			n -= IDR_BITS;
>> -			*paa++ = p;
>>  			p = rcu_dereference_raw(p->ary[(id >> n) & IDR_MASK]);
>> +			*++paa = p;
>>  		}
>>  
>>  		if (p) {
>> @@ -768,7 +771,7 @@ void *idr_get_next(struct idr *idp, int *nextidp)
>>  		id = round_up(id + 1, 1 << n);
>>  		while (n < fls(id)) {
>>  			n += IDR_BITS;
>> -			p = *--paa;
>> +			--paa;
>>  		}
>>  	}
>>  	return NULL;
> 
> 

