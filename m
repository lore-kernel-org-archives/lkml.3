Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbaIZOXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:23:24 -0400
Received: from resqmta-ch2-05v.sys.comcast.net ([69.252.207.37]:36624 "EHLO
	resqmta-ch2-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754548AbaIZOXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:23:21 -0400
Date: Fri, 26 Sep 2014 09:22:54 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Dmitry Vyukov <dvyukov@google.com>
cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 09/13] mm: slub: add kernel address sanitizer support
 for slub allocator
In-Reply-To: <CACT4Y+a0DMk8vyCcesrsKt7rXVDD2LZsfnGemJAgeRiVbMxxxw@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1409260918460.32028@gentwo.org>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com> <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com> <1411562649-28231-10-git-send-email-a.ryabinin@samsung.com>
 <CACT4Y+a0DMk8vyCcesrsKt7rXVDD2LZsfnGemJAgeRiVbMxxxw@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2014, Dmitry Vyukov wrote:

> > +       depends on SLUB_DEBUG
>
>
> What does SLUB_DEBUG do? I think that generally we don't want any
> other *heavy* debug checks to be required for kasan.

SLUB_DEBUG includes the capabilties for debugging. It does not switch
debug on by default. SLUB_DEBUG_ON will results in a kernel that boots
with active debugging. Without SLUB_DEBUG_ON a kernel parameter activates
debugging.

> > +{
> > +       unsigned long size = cache->size;
> > +       unsigned long rounded_up_size = round_up(size, KASAN_SHADOW_SCALE_SIZE);
> > +
>
> Add a comment saying that SLAB_DESTROY_BY_RCU objects can be "legally"
> used after free.

Add "within the rcu period"

> >  static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
> > @@ -1416,8 +1426,10 @@ static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
> >                 setup_object(s, page, p);
> >                 if (likely(idx < page->objects))
> >                         set_freepointer(s, p, p + s->size);
>
> Sorry, I don't fully follow this code, so I will just ask some questions.
> Can we have some slab padding after last object in this case as well?

This is the free case. If poisoing is enabled then the object will be
overwritten on free. Padding is used depending on the need to align the
object and is optional. Redzoning will occur if requested. Are you asking
for redzoning?

> kasan_mark_slab_padding poisons only up to end of the page. Can there
> be multiple pages that we need to poison?

If there is a higher order page then only the end portion needs to be
poisoned. Objects may straddle order 0 boundaries then.

