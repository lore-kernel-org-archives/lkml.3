Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbaLBSWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:22:22 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:38975 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbaLBSWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:22:21 -0500
Date: Tue, 2 Dec 2014 10:22:17 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Huang Shijie <shijie8@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH] mtd: gpmi: properly handle bitflips in erased pages
Message-ID: <20141202182217.GL21347@ld-irv-0074>
References: <1417461159-2972-1-git-send-email-boris.brezillon@free-electrons.com>
 <20141201194139.GI21347@ld-irv-0074>
 <20141201211818.4e97f2e2@bbrezillon>
 <20141201233748.GJ21347@ld-irv-0074>
 <20141202092858.57341105@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141202092858.57341105@bbrezillon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 09:28:58AM +0100, Boris Brezillon wrote:
> On Mon, 1 Dec 2014 15:37:48 -0800 Brian Norris <computersforpeace@gmail.com> wrote:
> > On Mon, Dec 01, 2014 at 09:18:18PM +0100, Boris Brezillon wrote:
> > > On Mon, 1 Dec 2014 11:41:39 -0800 Brian Norris <computersforpeace@gmail.com> wrote:
> > > > On Mon, Dec 01, 2014 at 08:12:39PM +0100, Boris Brezillon wrote:
> > > > > Brian, I really like the idea of having a generic implementation for this
> > > > > feature (using read_page_raw) as you suggested here [1], but this implies
> > > > > having a temporary buffer to store the page read in raw mode and keep the page
> > > > > read in normal (HW ECC engine eanbled) mode, and I'm not sure we want to
> > > > > allocate more buffers than we already have.
> > > > 
> > > > Why does this require an additional buffer? If we've already noticed an
> > > > ECC error, we're expected to return raw data anyway, so what's the
> > > > problem with clobbering the original data with a raw version of the
> > > > data?
> > > 
> > > Well in the GPMI particular case (and more generally all NAND
> > > controllers which do not support subpage write) this is true, but if you
> > > can do subpage write, then you might have a bit flip in a specific
> > > chunk which is still empty, while other chunks are written and are
> > > expecting standard ECC correction.
> > > In this case you want to keep the 3 chunks with  standard ECC correction
> > > and only one in raw mode with 'erased page bitflips' fixed.
> > 
> > So the problem's not really with subpage write, exactly; the problem is
> > for drivers that support subpage write, we don't have a way to perform a
> > raw subpage read without touching the other subpages.
> 
> Yes, that's what I was trying to explain :-), and the only solution I
> see to address that is to have 2 buffers and then pick the most
> appropriate data for a given chunk.

We actually sort of have two buffers already in nand_do_read_ops();
ops->databuf and chip->buffers->databuf. The former can be pretty small,
but we could technically copy in any data that is "correct" to
ops->databuf, and then clobber chip->buffers->databuf with raw data.

But this may be more work than it's worth.

> Do you think we should focus on support for "non subpage write"
> controllers first, and then find an alternative for these controllers
> if someone really needs it ?

I think that may be alright. It doesn't look trivial to try to do an
erased subpage check on the subpage-programmed case anyway, at least in
generic code. We'd have to further understand what the OOB-per-subpage
partitioning is, and that information isn't currently in our ecclayout.

Brian
