Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaGJJ3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:29:48 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64285 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaGJJ3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:29:45 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-3a-53be5d06a4e8
Message-id: <53BE5BC1.6050802@samsung.com>
Date: Thu, 10 Jul 2014 13:24:17 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org
Subject: Re: [RFC/PATCH RESEND -next 15/21] mm: slub: add kernel address
 sanitizer hooks to slub allocator
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1404905415-9046-16-git-send-email-a.ryabinin@samsung.com>
 <alpine.DEB.2.11.1407090947020.1384@gentwo.org>
In-reply-to: <alpine.DEB.2.11.1407090947020.1384@gentwo.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t/xa7pssfuCDc5eULL4vXcmq8Wc9WvY
	LJbPmctkMeFhG7vFyu5mNovtz94yWazsfMBqsenxNVaLP7t2MFlc3jWHzeLemv+sFrcv81pc
	OrCAyaJl3wUmi7bP/1gt9q08D2Qt2chksfjIbWaLd88mM1ts3jSV2eLHhsesDqIeLc09bB77
	Dxd57Jx1l91jwaZSj02rOtk8Nn2axO7R9fYKk8e7c+fYPU7M+M3isXlJvcfHp7dYPN7vu8rm
	cWbBEXaPz5vkAviiuGxSUnMyy1KL9O0SuDJWnX3PXvCLs6JrxSWmBsZeji5GTg4JAROJd382
	MULYYhIX7q1n62Lk4hASWMooce9WFyuE08wkMaf/AitIFa+AlsTurp/sIDaLgKrEinefmUBs
	NgE9iX+ztrOB2KICERIH+p5B1QtK/Jh8jwXEFgGqvz7zNNgGZoHLrBLdL64CFXFwCAvkSGzZ
	GgyxbAujxIxNl8FO4hSwkXjeegnMZhbQkdjfOo0NwpaX2LzmLfMERoFZSHbMQlI2C0nZAkbm
	VYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghcfx1B+PSY1aHGAU4GJV4eF/s3hMsxJpYVlyZ
	e4hRgoNZSYR3m92+YCHelMTKqtSi/Pii0pzU4kOMTBycUg2Mnqz2QVI/9go08qVZ7PZ0kmMw
	S/vLoPG3cyVHaHmasw3r3ca9C9jCpPdObVhpe3WOx+mzZkaumb80nwc/Cmg90sz+snJ357O5
	1XI9UuH/9UU4UzsFt83bVv/ffyHPt5mySxc+MAg49VjYM0sj8rLJ4hv3DqpcnMwqdyTBR9tw
	5b9/B75O07uhxFKckWioxVxUnAgAwl18Z8ECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/14 18:48, Christoph Lameter wrote:
> On Wed, 9 Jul 2014, Andrey Ryabinin wrote:
> 
>> With this patch kasan will be able to catch bugs in memory allocated
>> by slub.
>> Allocated slab page, this whole page marked as unaccessible
>> in corresponding shadow memory.
>> On allocation of slub object requested allocation size marked as
>> accessible, and the rest of the object (including slub's metadata)
>> marked as redzone (unaccessible).
>>
>> We also mark object as accessible if ksize was called for this object.
>> There is some places in kernel where ksize function is called to inquire
>> size of really allocated area. Such callers could validly access whole
>> allocated memory, so it should be marked as accessible by kasan_krealloc call.
> 
> Do you really need to go through all of this? Add the hooks to
> kmem_cache_alloc_trace() instead and use the existing instrumentation
> that is there for other purposes?
> 

I could move kasan_kmalloc hooks kmem_cache_alloc_trace(), and I think it will look better.
Hovewer I will require two hooks instead of one (for CONFIG_TRACING=y and CONFIG_TRACING=n).

Btw, seems I broke CONFIG_SL[AO]B configurations in this patch by  introducing __ksize function
which used in krealloc now.
