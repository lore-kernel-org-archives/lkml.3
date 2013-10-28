Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab3J1MwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 08:52:13 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49447 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755037Ab3J1MwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:52:12 -0400
Date: Mon, 28 Oct 2013 12:48:51 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Simon Baatz <gmbnomis@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ming Lei <tom.leiming@gmail.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Tejun Heo <tj@kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: ARM/kirkwood: v3.12-rc6: kernel BUG at mm/util.c:390!
Message-ID: <20131028124851.GD5354@mbp>
References: <20131024200730.GB17447@blackmetal.musicnaut.iki.fi>
 <20131026143617.GA14034@mudshark.cambridge.arm.com>
 <20131027195115.208f40f3@tom-ThinkPad-T410>
 <20131027125036.GJ17447@blackmetal.musicnaut.iki.fi>
 <CACVXFVP2B3=82m_+DfA_oAEW86c=oxQ52G+yj5ncTU1DzP26Bw@mail.gmail.com>
 <20131027135344.GD16735@n2100.arm.linux.org.uk>
 <20131027141817.GA13436@schnuecks.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131027141817.GA13436@schnuecks.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 02:18:17PM +0000, Simon Baatz wrote:
> On Sun, Oct 27, 2013 at 01:53:44PM +0000, Russell King - ARM Linux wrote:
> > On Sun, Oct 27, 2013 at 09:16:53PM +0800, Ming Lei wrote:
> > > On Sun, Oct 27, 2013 at 8:50 PM, Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
> > > >
> > So...
> > 
> > flush_kernel_dcache_page() is expected to take a struct page pointer.
> > This struct page pointer is part of the kernel's array of struct pages
> > which identifies every single physical page under the control of the
> > kernel.
> > 
> > Arguably, it should not crash if passed a page which has been allocated
> > to the slab cache; as this is not a page cache page,
> > flush_kernel_dcache_page() should merely ignore the call to it and
> > simply return on these.  So this makes total sense:
> 
> In this respect, flush_kernel_dcache_page() is following
> flush_dcache_page(). For example in crypto/scatterwalk.c:
> 
> static void scatterwalk_pagedone(struct scatter_walk *walk, int out,
>                                  unsigned int more)
> {
>         if (out) {
>                 struct page *page;
> 
>                 page = sg_page(walk->sg) + ((walk->offset - 1) >>
> PAGE_SHIFT);
>                 if (!PageSlab(page))
>                         flush_dcache_page(page);
>         }
> ... 
> 
> 
> or in drivers/ata/libata-sff.c:
> 
> ...
>         if (!do_write && !PageSlab(page))
>                 flush_dcache_page(page);
> ...
> 
> 
> (Probably, both cases should have used
> flush_kernel_dcache_page() in the first place). If we say that this
> check belongs in flush_kernel_dcache_page() we should also put it
> into flush_dcache_page(), no?

According to cachetlb.txt, flush_dcache_page() is only called on page
cache pages, so this excludes the PageSlab() check.

For flush_kernel_dcache_page() it says "when the kernel modifies and
user page" and my reading is that this applies to either page cache
or anonymous pages but not slab pages, so I would add such check to the
caller.

-- 
Catalin
