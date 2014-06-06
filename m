Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaFFOVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:21:50 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16946 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaFFOVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:21:49 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-35-5391ce7ab889
Message-id: <5391CD5A.20503@samsung.com>
Date: Fri, 06 Jun 2014 18:16:58 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, dvyukov@google.com, koct9i@gmail.com
Subject: Re: [PATCH] mm: rmap: fix use-after-free in __put_anon_vma
References: <1402054255-4930-1-git-send-email-a.ryabinin@samsung.com>
 <20140606115620.GS3213@twins.programming.kicks-ass.net>
In-reply-to: <20140606115620.GS3213@twins.programming.kicks-ass.net>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/xa7pV5yYGG3y9z2ExZ/0aNosJD9vY
	LVZ2PmC1uLxrDpvFvTX/WS2O9x5gsnjU95bdgd1j56y77B4LNpV6bF6h5bHp0yR2jxMzfrN4
	fN4kF8AWxWWTkpqTWZZapG+XwJUx7c5l5oLrvBUT2g+zNDD+5+pi5OSQEDCRWDXhBiuELSZx
	4d56ti5GLg4hgaWMEldPTWWCcJqZJKa1/2QGqeIV0JDof3wfyObgYBFQlXj5WBUkzCagJ/Fv
	1nY2kLCoQITE4wtCENWCEj8m32MBsUUENCVWtt0Hm88ssJNR4tmFHiaQhLCAs8TDj+uZQHqF
	BOolds1UBglzCrhIbHh/H6yEWUBdYtK8RcwQtrzE5jVvmScwCsxCsmIWkrJZSMoWMDKvYhRN
	LU0uKE5KzzXSK07MLS7NS9dLzs/dxAgJ9K87GJceszrEKMDBqMTDm/F+QrAQa2JZcWXuIUYJ
	DmYlEV625onBQrwpiZVVqUX58UWlOanFhxiZODilGhgDEpQehZ6qnv0i+2MzQ9a0KvVov1Nv
	J5lOUcgXO6LcsL/1EO/t9T+lpB3zt+2qe9yXfe5iwMOX65UP6vVcz+tTSdA0PzLL28SsfM6E
	65tmnJ241Mrlqdv89puHZx++oVRbYaby71jZvRWZD/8flrJ/xnP/3A2d/PR+pa27Y7WUXiSJ
	Z24QdPigxFKckWioxVxUnAgAF8xraVICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/14 15:56, Peter Zijlstra wrote:
> On Fri, Jun 06, 2014 at 03:30:55PM +0400, Andrey Ryabinin wrote:
>> While working address sanitizer for kernel I've discovered use-after-free
>> bug in __put_anon_vma.
>> For the last anon_vma, anon_vma->root freed before child anon_vma.
>> Later in anon_vma_free(anon_vma) we are referencing to already freed anon_vma->root
>> to check rwsem.
>> This patch puts freeing of child anon_vma before freeing of anon_vma->root.
> 
> Yes, I think that is right indeed.
> 
> Very hard to hit, but valid since not all callers hold rcu_read_lock().
> 
>>
>> Cc: stable@vger.kernel.org # v3.0+
>> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
>> ---
>>  mm/rmap.c | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 9c3e773..161bffc7 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1564,10 +1564,11 @@ void __put_anon_vma(struct anon_vma *anon_vma)
>>  {
>>  	struct anon_vma *root = anon_vma->root;
>>  
>> -	if (root != anon_vma && atomic_dec_and_test(&root->refcount))
>> +	if (root != anon_vma && atomic_dec_and_test(&root->refcount)) {
>> +		anon_vma_free(anon_vma);
>>  		anon_vma_free(root);
>> -
>> -	anon_vma_free(anon_vma);
>> +	} else
>> +		anon_vma_free(anon_vma);
>>  }
> 
> Why not simply move the freeing of anon_vma before the root, like:
> 
> 	anon_vma_free(anon_vma);
> 	if (root != anon_vma && atomic_dec_and_test(&root->refcount))
> 		anon_vma_free(root);
> 
> ?
> 

IMO It looks more logical to decrement root's refcounter before freeing child vma.
In fact I wasn't completely sure that it is safe to do so. But after some digging,
now it looks safe to me.







