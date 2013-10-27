Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab3J0Mus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 08:50:48 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:35548 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab3J0Mur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 08:50:47 -0400
Date: Sun, 27 Oct 2013 14:50:36 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, gmbnomis@gmail.com,
        catalin.marinas@arm.com,
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
Message-ID: <20131027125036.GJ17447@blackmetal.musicnaut.iki.fi>
References: <20131024200730.GB17447@blackmetal.musicnaut.iki.fi>
 <20131026143617.GA14034@mudshark.cambridge.arm.com>
 <20131027195115.208f40f3@tom-ThinkPad-T410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131027195115.208f40f3@tom-ThinkPad-T410>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Oct 27, 2013 at 07:51:15PM +0800, Ming Lei wrote:
> On Sat, 26 Oct 2013 15:36:17 +0100
> Will Deacon <will.deacon@arm.com> wrote:
> 
> > On Thu, Oct 24, 2013 at 09:07:30PM +0100, Aaro Koskinen wrote:
> > 
> > > [   36.477203] Backtrace:
> > > [   36.535603] [<c009237c>] (page_mapping+0x0/0x50) from [<c0010dd8>] (flush_kernel_dcache_page+0x14/0x98)
> > > [   36.661070] [<c0010dc4>] (flush_kernel_dcache_page+0x0/0x98) from [<c0172b60>] (sg_miter_stop+0xc8/0x10c)
> > > [   36.792813]  r4:df8a9a64 r3:00000003
> > > [   36.857524] [<c0172a98>] (sg_miter_stop+0x0/0x10c) from [<c0172f20>] (sg_miter_next+0x14/0x13c)
> > 
> > ... assumedly for scatter/gather DMA. How is your block driver allocating
> > its buffers? If you're using the DMA API, I can't see how this would happen.
> 
> Lots of SCSI commands(inquiry, ...) pass kmalloc buffer to block layer,
> then the sg buffer copy helpers and flush_kernel_dcache_page() may see
> slab page.
> 
> That has been here from commit b1adaf65ba03( [SCSI] block: add sg buffer copy
> helper functions).

On ARM v3.9 or older kernels do not trigger this BUG, at seems it only
started to appear with the following commit (bisected):

commit 1bc39742aab09248169ef9d3727c9def3528b3f3
Author: Simon Baatz <gmbnomis@gmail.com>
Date:   Mon Jun 10 21:10:12 2013 +0100

    ARM: 7755/1: handle user space mapped pages in flush_kernel_dcache_page

A.
