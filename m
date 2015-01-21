Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbbAUAHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:07:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbbAUAHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:07:40 -0500
Date: Tue, 20 Jan 2015 16:07:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: josh@joshtriplett.org
Cc: Kim Phillips <kim.phillips@freescale.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Rik van Riel <riel@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Jens Axboe <axboe@fb.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 2/2] mm: fix undefined reference to `.kernel_map_pages'
 on PPC builds
Message-Id: <20150120160738.edfe64806cc8b943beb1dfa0@linux-foundation.org>
In-Reply-To: <20150120230150.GA14475@cloud>
References: <20150120140200.aa7ba0eb28d95e456972e178@freescale.com>
	<20150120230150.GA14475@cloud>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015 15:01:50 -0800 josh@joshtriplett.org wrote:

> On Tue, Jan 20, 2015 at 02:02:00PM -0600, Kim Phillips wrote:
> > It's possible to configure DEBUG_PAGEALLOC without PAGE_POISONING on
> > ppc.  Fix building the generic kernel_map_pages() implementation in
> > this case:
> > 
> >   LD      init/built-in.o
> > mm/built-in.o: In function `free_pages_prepare':
> > mm/page_alloc.c:770: undefined reference to `.kernel_map_pages'
> > mm/built-in.o: In function `prep_new_page':
> > mm/page_alloc.c:933: undefined reference to `.kernel_map_pages'
> > mm/built-in.o: In function `map_pages':
> > mm/compaction.c:61: undefined reference to `.kernel_map_pages'
> > make: *** [vmlinux] Error 1
> > 
> > Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> > ---
> >  mm/Makefile | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/mm/Makefile b/mm/Makefile
> > index 4bf586e..2956467 100644
> > --- a/mm/Makefile
> > +++ b/mm/Makefile
> > @@ -46,6 +46,7 @@ obj-$(CONFIG_SLOB) += slob.o
> >  obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
> >  obj-$(CONFIG_KSM) += ksm.o
> >  obj-$(CONFIG_PAGE_POISONING) += debug-pagealloc.o
> > +obj-$(CONFIG_DEBUG_PAGEALLOC) += debug-pagealloc.o
> 
> Does it work correctly to list the same object file twice?  Doesn't seem
> like it would.  Shouldn't this do something like the following instead:
> 
> ifneq ($(CONFIG_DEBUG_PAGEALLOC)$(CONFIG_PAGE_POISONING),)
> obj-y += debug-pagealloc.o
> endif
> 

I expect it's a Kconfig problem.  DEBUG_PAGEALLOC should be selecting
PAGE_POISONING.

config DEBUG_PAGEALLOC
	bool "Debug page memory allocations"
	depends on DEBUG_KERNEL
	depends on !HIBERNATION || ARCH_SUPPORTS_DEBUG_PAGEALLOC && !PPC && !SPARC
	depends on !KMEMCHECK
	select PAGE_EXTENSION
	select PAGE_POISONING if !ARCH_SUPPORTS_DEBUG_PAGEALLOC

Culprits cc'ed!
