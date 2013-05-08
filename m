Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab3EHMht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 08:37:49 -0400
Received: from mx2.parallels.com ([199.115.105.18]:52594 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab3EHMhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 08:37:48 -0400
Message-ID: <518A474D.9010801@parallels.com>
Date: Wed, 8 May 2013 16:38:37 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Tony Lindgren <tony@atomide.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [GIT PULL] SLAB changes for v3.10
References: <alpine.LFD.2.03.1305070936320.2383@kernel.org> <20130508003022.GS28721@atomide.com> <20130508042422.GU28721@atomide.com> <20130508051602.GV28721@atomide.com> <CAOJsxLEB2gSWefNHNeKfxv9Hp=H9PG0bGgTcUPE4abz3fv_fxw@mail.gmail.com> <518A3DDC.1090905@parallels.com> <CAOJsxLEjqNA1wbZta568McFnEb_nbnGF1_9kEhOJkFTX-CobaA@mail.gmail.com>
In-Reply-To: <CAOJsxLEjqNA1wbZta568McFnEb_nbnGF1_9kEhOJkFTX-CobaA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 04:26 PM, Pekka Enberg wrote:
> On Wed, May 8, 2013 at 2:58 PM, Glauber Costa <glommer@parallels.com> wrote:
>> My first guess is that it hit a NULL cache. Being a NULL pointer
>> dereference, the thing among all that has the biggest chances of being
>> NULL and accessed unconditionally is the cache pointer itself.
>>
>> Due to the size being too big. But if that were the case, he would have
>> hit the WARN_ON recently introduced:
>>
>>                 if (WARN_ON_ONCE(size > KMALLOC_MAX_SIZE))
>>                         return NULL;
>>
>>
>> Is this WARN hit ?
> 
> I doubt it:
> 
> [    0.000000] r7 : 00000000  r6 : 600001d3  r5 : 00000000  r4 : 00008000
> [    0.000000] r3 : 00000050  r2 : c06ec000  r1 : c06f77c8  r0 : c00eda9c
> 
> [    0.000000] [<c00edab4>] (kmem_cache_alloc_trace+0x50/0x178) from
> [<c0086958>] (alloc_desc+0x24/0xb4)
> 
> It's the kzalloc_node() in kernel/irq/irqdesc.c::alloc_desc() and
> AFAICT based on r4 it's a 32 KB allocation. It's more likely that
> KMALLOC_SHIFT_HIGH is less than 25 and because kmalloc_index() doesn't
> respect it, we return a pointer to an uninitialized kmalloc cache.
> 

Exactly, but then the index is calculated from the size. If we are
allocating with a size that would lead to an invalid index, we should
WARN. If this is not happening, that WARN is really really badly placed.


