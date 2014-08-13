Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbaHMCEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 22:04:21 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:36959 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbaHMCET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 22:04:19 -0400
Message-ID: <53EAC79F.4050705@gmail.com>
Date: Wed, 13 Aug 2014 04:04:15 +0200
From: Mario Kleiner <mario.kleiner.de@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?windows-1252?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        Jerome Glisse <j.glisse@gmail.com>,
        Thomas Hellstrom <thellstrom@vmware.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, kamal@canonical.com,
        LKML <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>, ben@decadent.org.uk,
        m.szyprowski@samsung.com
Subject: Re: CONFIG_DMA_CMA causes ttm performance problems/hangs.
References: <53E50C1B.9080507@gmail.com> <53E5B41B.3030009@vmware.com> <60bd3db2-4919-40c4-a4ff-1b7b043cadfc@email.android.com> <53E628FE.10808@vmware.com> <53E6E2CE.8070005@gmail.com> <53E75192.3070003@vmware.com> <53E7B39D.2060900@gmail.com> <53E896C9.5010501@vmware.com> <20140811151712.GA3541@gmail.com> <53EAC461.2060503@daenzer.net>
In-Reply-To: <53EAC461.2060503@daenzer.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 03:50 AM, Michel Dänzer wrote:
> On 12.08.2014 00:17, Jerome Glisse wrote:
>> On Mon, Aug 11, 2014 at 12:11:21PM +0200, Thomas Hellstrom wrote:
>>> On 08/10/2014 08:02 PM, Mario Kleiner wrote:
>>>> On 08/10/2014 01:03 PM, Thomas Hellstrom wrote:
>>>>> On 08/10/2014 05:11 AM, Mario Kleiner wrote:
>>>>>> The other problem is that probably TTM does not reuse pages from the
>>>>>> DMA pool. If i trace the __ttm_dma_alloc_page
>>>>>> <https://urldefense.proofpoint.com/v1/url?u=http://lxr.free-electrons.com/ident?i%3D__ttm_dma_alloc_page&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=l5Ago9ekmVFZ3c4M6eauqrJWGwjf6fTb%2BP3CxbBFkVM%3D%0A&m=QQSN6uVpEiw6RuWLAfK%2FKWBFV5HspJUfDh4Y2mUz%2FH4%3D%0A&s=7898522bba274e4dcc332735fbcf0c96e48918f60c2ee8e9a3e9c73ab3487bd0>
>>>>>> and
>>>>>> __ttm_dma_free_page
>>>>>> <https://urldefense.proofpoint.com/v1/url?u=http://lxr.free-electrons.com/ident?i%3D__ttm_dma_alloc_page&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=l5Ago9ekmVFZ3c4M6eauqrJWGwjf6fTb%2BP3CxbBFkVM%3D%0A&m=QQSN6uVpEiw6RuWLAfK%2FKWBFV5HspJUfDh4Y2mUz%2FH4%3D%0A&s=7898522bba274e4dcc332735fbcf0c96e48918f60c2ee8e9a3e9c73ab3487bd0>
>>>>>> calls for
>>>>>> those single page allocs/frees, then over a 20 second interval of
>>>>>> tracing and switching tabs in firefox, scrolling things around etc. i
>>>>>> find about as many alloc's as i find free's, e.g., 1607 allocs vs.
>>>>>> 1648 frees.
>>>>> This is because historically the pools have been designed to keep only
>>>>> pages with nonstandard caching attributes since changing page caching
>>>>> attributes have been very slow but the kernel page allocators have been
>>>>> reasonably fast.
>>>>>
>>>>> /Thomas
>>>> Ok. A bit more ftraceing showed my hang problem case goes through the
>>>> "if (is_cached)" paths, so the pool doesn't recycle anything and i see
>>>> it bouncing up and down by 4 pages all the time.
>>>>
>>>> But for the non-cached case, which i don't hit with my problem, could
>>>> one of you look at line 954...
>>>>
>>>> https://urldefense.proofpoint.com/v1/url?u=http://lxr.free-electrons.com/source/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c%23L954&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=l5Ago9ekmVFZ3c4M6eauqrJWGwjf6fTb%2BP3CxbBFkVM%3D%0A&m=QQSN6uVpEiw6RuWLAfK%2FKWBFV5HspJUfDh4Y2mUz%2FH4%3D%0A&s=e15c51805d429ee6d8960d6b88035e9811a1cdbfbf13168eec2fbb2214b99c60
>>>>
>>>>
>>>> ... and tell me why that unconditional npages = count; assignment
>>>> makes sense? It seems to essentially disable all recycling for the dma
>>>> pool whenever the pool isn't filled up to/beyond its maximum with free
>>>> pages? When the pool is filled up, lots of stuff is recycled, but when
>>>> it is already somewhat below capacity, it gets "punished" by not
>>>> getting refilled? I'd just like to understand the logic behind that line.
>>>>
>>>> thanks,
>>>> -mario
>>> I'll happily forward that question to Konrad who wrote the code (or it
>>> may even stem from the ordinary page pool code which IIRC has Dave
>>> Airlie / Jerome Glisse as authors)
>> This is effectively bogus code, i now wonder how it came to stay alive.
>> Attached patch will fix that.
> I haven't tested Mario's scenario specifically, but it survived piglit
> and the UE4 Effects Cave Demo (for which 1GB of VRAM isn't enough, so
> some BOs ended up in GTT instead with write-combined CPU mappings) on
> radeonsi without any noticeable issues.
>
> Tested-by: Michel Dänzer <michel.daenzer@amd.com>
>
>

I haven't tested the patch yet. For the original bug it won't help 
directly, because the super-slow allocations which cause the desktop 
stall are tt_cached allocations, so they go through the if (is_cached) 
code path which isn't improved by Jerome's patch. is_cached always 
releases memory immediately, so the tt_cached pool just bounces up and 
down between 4 and 7 pages. So this was an independent issue. The slow 
allocations i noticed were mostly caused by exa allocating new gem bo's, 
i don't know which path is taken by 3d graphics?

However, the fixed ttm path could indirectly solve the DMA_CMA stalls by 
completely killing CMA for its intended purpose. Typical CMA sizes are 
probably around < 100 MB (kernel default is 16 MB, Ubuntu config is 64 
MB), and the limit for the page pool seems to be more like 50% of all 
system RAM? Iow. if the ttm dma pool is allowed to grow that big with 
recycled pages, it probably will almost completely monopolize the whole 
CMA memory after a short amount of time. ttm won't suffer stalls if it 
essentially doesn't interact with CMA anymore after a warmup period, but 
actual clients which really need CMA (ie., hardware without 
scatter-gather dma etc.) will be starved of what they need as far as my 
limited understanding of the CMA goes.

So fwiw probably the fix to ttm will increase the urgency for the CMA 
people to come up with a fix/optimization for the allocator. Unless it 
doesn't matter if most desktop systems have CMA disabled by default, and 
ttm is mostly used by desktop graphics drivers (nouveau, radeon, vmgfx)? 
I only stumbled over the problem because the Ubuntu 3.16 mainline 
testing kernels are compiled with CMA on.

-mario

