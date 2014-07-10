Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaGJHso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 03:48:44 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57544 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaGJHsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 03:48:42 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-de-53be45571ab5
Message-id: <53BE4412.6030707@samsung.com>
Date: Thu, 10 Jul 2014 11:43:14 +0400
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
Subject: Re: [RFC/PATCH RESEND -next 12/21] mm: util: move krealloc/kzfree to
 slab_common.c
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1404905415-9046-13-git-send-email-a.ryabinin@samsung.com>
 <alpine.DEB.2.11.1407090931350.1384@gentwo.org>
In-reply-to: <alpine.DEB.2.11.1407090931350.1384@gentwo.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t/xa7rhrvuCDeYcULH4vXcmq8Wc9WvY
	LJbPmctkMeFhG7vFyu5mNovtz94yWazsfMBqsenxNVaLP7t2MFlc3jWHzeLemv+sFrcv81pc
	OrCAyaJl3wUmi7bP/1gt9q08D2Qt2chksfjIbWaLd88mM1ts3jSV2eLHhsesDqIeLc09bB77
	Dxd57Jx1l91jwaZSj02rOtk8Nn2axO7R9fYKk8e7c+fYPU7M+M3isXlJvcfHp7dYPN7vu8rm
	cWbBEXaPz5vkAviiuGxSUnMyy1KL9O0SuDJmzH7BWrCTs2Lp9E+MDYw/2bsYOTkkBEwk2h89
	ZoKwxSQu3FvP1sXIxSEksJRRYuPHrywQTjOTRMO8M8wgVbwCWhIPPh8H6ubgYBFQlbjSmQUS
	ZhPQk/g3azsbiC0qECFxoO8ZK0S5oMSPyfdYQGwRoPLrM0+DLWAWuMwq0f3iKivIHGGBWIl7
	K7Ihdm1hlJjwrQXsIk4BG4kFJ76AXcosoCOxv3UaG4QtL7F5zVvmCYwCs5DsmIWkbBaSsgWM
	zKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQqL4yw7GxcesDjEKcDAq8fBq1O4OFmJNLCuu
	zD3EKMHBrCTCu81uX7AQb0piZVVqUX58UWlOavEhRiYOTqkGxunFbsZ10xx8l65JN/m5WviX
	3W8j5+y5X+fW5UtY3ZA7P/tEgfcrI6U3yaELmz0SEt/qrtkl4izzd7fG9rtBs/j+O7FEf/GW
	jfx+302wxmPqR5ed6dOXuV1e/G9RAK9urIWa+FyP6Z+vOL/UNWvg4kjl8agXKZx0afvkTQdP
	XfKqP3vytrT4UyWW4oxEQy3mouJEAOr35zHAAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/14 18:32, Christoph Lameter wrote:
> On Wed, 9 Jul 2014, Andrey Ryabinin wrote:
> 
>> To avoid false positive reports in kernel address sanitizer krealloc/kzfree
>> functions shouldn't be instrumented. Since we want to instrument other
>> functions in mm/util.c, krealloc/kzfree moved to slab_common.c which is not
>> instrumented.
>>
>> Unfortunately we can't completely disable instrumentation for one function.
>> We could disable compiler's instrumentation for one function by using
>> __atribute__((no_sanitize_address)).
>> But the problem here is that memset call will be replaced by instumented
>> version kasan_memset since currently it's implemented as define:
> 
> Looks good to me and useful regardless of the sanitizer going in.
> 
> Acked-by: Christoph Lameter <cl@linux.com>
> 

I also noticed in mm/util.c:

	/* Tracepoints definitions. */
	EXPORT_TRACEPOINT_SYMBOL(kmalloc);
	EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
	EXPORT_TRACEPOINT_SYMBOL(kmalloc_node);
	EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc_node);
	EXPORT_TRACEPOINT_SYMBOL(kfree);
	EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);

Should I send another patch to move this to slab_common.c?


