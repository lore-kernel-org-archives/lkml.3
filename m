Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693AbaGOJ5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:57:07 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22643 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758430AbaGOJ5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:57:01 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-af-53c4fae5ebbe
Message-id: <53C4F99B.5010007@samsung.com>
Date: Tue, 15 Jul 2014 13:51:23 +0400
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
Subject: Re: [RFC/PATCH RESEND -next 14/21] mm: slub: kasan: disable kasan when
 touching unaccessible memory
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1404905415-9046-15-git-send-email-a.ryabinin@samsung.com>
 <20140715060405.GI11317@js1304-P5Q-DELUXE> <53C4DA54.3010502@samsung.com>
 <20140715081852.GL11317@js1304-P5Q-DELUXE>
In-reply-to: <20140715081852.GL11317@js1304-P5Q-DELUXE>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t/xK7pPfx0JNri9QtXi996ZrBZz1q9h
	s7j+7Q2jxYSHbewWK7ub2Sy2P3vLZLGy8wGrxabH11gt/uzawWRxedccNot7a/6zWty+zGtx
	6cACJouWfReYLNo+/2O12LfyPJC1ZCOTxeIjt5kt3j2bzGyxedNUZosfGx6zOoh6tDT3sHns
	nHWX3WPBplKPTas62Tw2fZrE7tH19gqTx7tz59g9Tsz4zeLx5Mp0Jo/NS+o9Pj69xeLxft9V
	No8zC46we3zeJBfAF8Vlk5Kak1mWWqRvl8CVcXD6cbaCY1IVay82sjcwHhftYuTkkBAwkZj7
	5xEbhC0mceHeeiCbi0NIYCmjxLtbz9ghnGYmifW7XzGDVPEKaEm82nUFrINFQFWi++h/sDib
	gJ7Ev1nbweKiAhESB/qesULUC0r8mHyPBcQWEdCQWL1qMzPIUGaB86wS91/9YgJJCAvkSew4
	380Kse03o8SGs1/ZQRKcAuYSM3bcAetmFtCR2N86jQ3ClpfYvOYt8wRGgVlIlsxCUjYLSdkC
	RuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCGx/HUH49JjVocYBTgYlXh4b0w7EizEmlhW
	XJl7iFGCg1lJhPf2J6AQb0piZVVqUX58UWlOavEhRiYOTqkGxjs6559NM965zSNjmbqBUDer
	3EOrIp0SU7HggntnVxZZ5AvdmvD096qnX/+Vyeptyv3VHL0/PDPO1vOoW3G0fKta9u9bCyWD
	lqUxKrG35Re8+/RQ+axWk6t86P9vy0SO/Qj+uD1faObUCW85N3xy5L10Yob4xS+3fTa893qZ
	c6bg2avZU46d2qnEUpyRaKjFXFScCACMQDpowwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/14 12:18, Joonsoo Kim wrote:
> On Tue, Jul 15, 2014 at 11:37:56AM +0400, Andrey Ryabinin wrote:
>> On 07/15/14 10:04, Joonsoo Kim wrote:
>>> On Wed, Jul 09, 2014 at 03:30:08PM +0400, Andrey Ryabinin wrote:
>>>> Some code in slub could validly touch memory marked by kasan as unaccessible.
>>>> Even though slub.c doesn't instrumented, functions called in it are instrumented,
>>>> so to avoid false positive reports such places are protected by
>>>> kasan_disable_local()/kasan_enable_local() calls.
>>>>
>>>> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
>>>> ---
>>>>  mm/slub.c | 21 +++++++++++++++++++--
>>>>  1 file changed, 19 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/mm/slub.c b/mm/slub.c
>>>> index 6ddedf9..c8dbea7 100644
>>>> --- a/mm/slub.c
>>>> +++ b/mm/slub.c
>>>> @@ -560,8 +560,10 @@ static void print_tracking(struct kmem_cache *s, void *object)
>>>>  	if (!(s->flags & SLAB_STORE_USER))
>>>>  		return;
>>>>  
>>>> +	kasan_disable_local();
>>>>  	print_track("Allocated", get_track(s, object, TRACK_ALLOC));
>>>>  	print_track("Freed", get_track(s, object, TRACK_FREE));
>>>> +	kasan_enable_local();
>>>
>>> I don't think that this is needed since print_track() doesn't call
>>> external function with object pointer. print_track() call pr_err(), but,
>>> before calling, it retrieve t->addrs[i] so memory access only occurs
>>> in slub.c.
>>>
>> Agree.
>>
>>>>  }
>>>>  
>>>>  static void print_page_info(struct page *page)
>>>> @@ -604,6 +606,8 @@ static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
>>>>  	unsigned int off;	/* Offset of last byte */
>>>>  	u8 *addr = page_address(page);
>>>>  
>>>> +	kasan_disable_local();
>>>> +
>>>>  	print_tracking(s, p);
>>>>  
>>>>  	print_page_info(page);
>>>> @@ -632,6 +636,8 @@ static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
>>>>  		/* Beginning of the filler is the free pointer */
>>>>  		print_section("Padding ", p + off, s->size - off);
>>>>  
>>>> +	kasan_enable_local();
>>>> +
>>>>  	dump_stack();
>>>>  }
>>>
>>> And, I recommend that you put this hook on right place.
>>> At a glance, the problematic function is print_section() which have
>>> external function call, print_hex_dump(), with object pointer.
>>> If you disable kasan in print_section, all the below thing won't be
>>> needed, I guess.
>>>
>>
>> Nope, at least memchr_inv() call in slab_pad_check will be a problem.
>>
>> I think putting disable/enable only where we strictly need them might be a problem for future maintenance of slub.
>> If someone is going to add a new function call somewhere, he must ensure that it this call won't be a problem
>> for kasan.
> 
> I don't agree with this.
> 
> If someone is going to add a slab_pad_check() in other places in
> slub.c, we should disable/enable kasan there, too. This looks same
> maintenance problem to me. Putting disable/enable only where we
> strictly need at least ensures that we don't need to care when using
> slub internal functions.
> 
> And, if memchr_inv() is problem, I think that you also need to add hook
> into validate_slab_cache().
> 
> validate_slab_cache() -> validate_slab_slab() -> validate_slab() ->
> check_object() -> check_bytes_and_report() -> memchr_inv()
> 
> Thanks.
> 

Ok, you convinced me. I'll do it.


