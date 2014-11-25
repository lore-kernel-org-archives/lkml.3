Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbaKYNSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:18:16 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29942 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbaKYNSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:18:12 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-f0-547481916896
Message-id: <5474818E.7030704@samsung.com>
Date: Tue, 25 Nov 2014 16:18:06 +0300
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Dmitry Chernenkov <dmitryc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v7 08/12] mm: slub: add kernel address sanitizer support
 for slub allocator
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1416852146-9781-1-git-send-email-a.ryabinin@samsung.com>
 <1416852146-9781-9-git-send-email-a.ryabinin@samsung.com>
 <CAA6XgkETqmoDFi7Kdi9o3DTE-3=CT5imdCydFjvh83EayHHfpQ@mail.gmail.com>
In-reply-to: <CAA6XgkETqmoDFi7Kdi9o3DTE-3=CT5imdCydFjvh83EayHHfpQ@mail.gmail.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t/xa7oTG0tCDNrO8Fj83juT1WLO+jVs
	FkeufWe3uP7tDaPFp5cPGC22XG9isnj+8CG7xYSHbewW0zaKW6zsbmaz2P7sLZPFys4HrBaX
	d81hs7i35j+rRdvnf0BiyUYmi8VHbjNbvHs2mdni6qqD7BY/NjxmdRDxmL/zI6PHzll32T0W
	bCr1WLznJZPHplWdbB6bPk1i9+h6e4XJ48SM3yweT65MZ/L4+PQWi8f7fVfZPD5vkvM40fKF
	NYA3issmJTUnsyy1SN8ugSvj5ba8gu18FZ9aH7E3ML7h7mLk5JAQMJG4dv8CE4QtJnHh3no2
	EFtIYCmjxMpt0V2MXEB2M5PErLMLwYp4BbQk5p9cxgxiswioSuz+shusgU1AT+LfrO1gtqhA
	hMSVNXMYIeoFJX5MvscCYosA9Z7/8IAVZCizwB1WiVO/ZrKCJIQFEiUWvV7CCLGthUni5Zzr
	7F2MHBycAsESG7olQExmAXWJKVNyQcqZBeQlNq95yzyBUWAWkhWzEKpmIalawMi8ilE0tTS5
	oDgpPddQrzgxt7g0L10vOT93EyMkXr/sYFx8zOoQowAHoxIPr0FiSYgQa2JZcWXuIUYJDmYl
	Ed7caqAQb0piZVVqUX58UWlOavEhRiYOTqkGRoa7c/vlr6gzJJfc2591Y6vF2riMb4qXPQ6x
	fdQtW2q0UOCHZGJUXaqrdgaXc5+jnHveofvCovodDd7TBfyuaUe69TrfnK7Kv1ninW3orkkf
	uHn3THnKzK0j8qLv0KEXh1VOeHk48SY/umN4n3GqozLjorJ1ZXvLlTL3sVdOPGy9W2T7xq6r
	SizFGYmGWsxFxYkAy1FHfbUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 03:17 PM, Dmitry Chernenkov wrote:
> FYI, when I backported Kasan to 3.14, in kasan_mark_slab_padding()
> sometimes a negative size of padding was generated.

I don't see how this could happen if pointers passed to kasan_mark_slab_padding() are correct.

Negative padding would mean that (object + s->size) is crossing slab page boundary.
This is either slub allocator bug (very unlikely), or some pointers passed to kasan_mark_slab_padding()
not correct.

Or maybe I'm missing something?

> This started
> working when the patch below was applied:
> 
> @@ -262,12 +264,11 @@ void kasan_free_pages(struct page *page,
> unsigned int order)
>  void kasan_mark_slab_padding(struct kmem_cache *s, void *object,
>   struct page *page)
>  {
> - unsigned long object_end = (unsigned long)object + s->size;
> - unsigned long padding_start = round_up(object_end,
> - KASAN_SHADOW_SCALE_SIZE);
> - unsigned long padding_end = (unsigned long)page_address(page) +
> - (PAGE_SIZE << compound_order(page));
> - size_t size = padding_end - padding_start;
> + unsigned long page_start = (unsigned long) page_address(page);
> + unsigned long page_end = page_start + (PAGE_SIZE << compound_order(page));
> + unsigned long padding_start = round_up(page_end - s->reserved,
> + KASAN_SHADOW_SCALE_SIZE);
> + size_t size = page_end - padding_start;
> 
>   kasan_poison_shadow((void *)padding_start, size, KASAN_SLAB_PADDING);
>  }
> 
> Also, in kasan_slab_free you poison the shadow with FREE not just the
> object space, but also redzones. This is inefficient and will mistake
> right out-of-bounds error for the next object with use-after-free.
> This is fixed here
> https://github.com/google/kasan/commit/4b3238be392ba0bc56bbc934ac545df3ff840782
> , please patch.
> 

Makes sense.


> 
> LGTM
> 



