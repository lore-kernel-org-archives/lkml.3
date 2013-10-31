Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab3JaWyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 18:54:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab3JaWyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 18:54:43 -0400
Date: Thu, 31 Oct 2013 15:54:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Simon Baatz <gmbnomis@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Tejun Heo <tj@kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] lib/scatterlist.c: don't flush_kernel_dcache_page on
 slab page
Message-Id: <20131031155441.b194be26818e6f3a0150bc73@linux-foundation.org>
In-Reply-To: <20131031224927.GK17447@blackmetal.musicnaut.iki.fi>
References: <1382977205-26268-1-git-send-email-ming.lei@canonical.com>
	<20131031152745.821d2b5dbe93e2ca69d45264@linux-foundation.org>
	<20131031224927.GK17447@blackmetal.musicnaut.iki.fi>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Nov 2013 00:49:27 +0200 Aaro Koskinen <aaro.koskinen@iki.fi> wrote:

> Hi,
> 
> On Thu, Oct 31, 2013 at 03:27:45PM -0700, Andrew Morton wrote:
> > On Tue, 29 Oct 2013 00:20:05 +0800 Ming Lei <ming.lei@canonical.com> wrote:
> > 
> > > Commit b1adaf65ba03([SCSI] block: add sg buffer copy helper functions)
> > > introduces two sg buffer copy helpers, and calls flush_kernel_dcache_page()
> > > on pages in SG list after these pages are written to.
> > > 
> > > Unfortunately, the commit may introduce a potential bug:
> > > 
> > > 	- Before sending some SCSI commands, kmalloc() buffer may be
> > > 	passed to block layper, so flush_kernel_dcache_page() can
> > > 	see a slab page finally
> > > 
> > > 	- According to cachetlb.txt, flush_kernel_dcache_page() is
> > > 	only called on "a user page", which surely can't be a slab page.
> > > 
> > > 	- ARCH's implementation of flush_kernel_dcache_page() may
> > > 	use page mapping information to do optimization so page_mapping()
> > > 	will see the slab page, then VM_BUG_ON() is triggered.
> > > 
> > > Aaro Koskinen reported the bug on ARM/kirkwood when DEBUG_VM is enabled,
> > > and this patch fixes the bug by adding test of '!PageSlab(miter->page)'
> > > before calling flush_kernel_dcache_page().
> > 
> > We should work out which kernel(s) need this patch.  b1adaf65ba03 was
> > merged in 2008, so presumably some more recent patch has exposed the
> > problem, but I don't know what one that was.
> > 
> > Help me out here?
> 
> On ARM, this problem started to appear after
> 1bc39742aab09248169ef9d3727c9def3528b3f3 (ARM: 7755/1: handle user space
> mapped pages in flush_kernel_dcache_page) and that was tagged for 3.2+
> stable kernels.
> 

OK, thanks.  I added

Cc: <stable@vger.kernel.org>    [3.2+]

to the changelog.

I guess I should get this and a few other things into Linus today, as
3.12 is nigh.

