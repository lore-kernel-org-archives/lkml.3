Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab3JaW1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 18:27:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab3JaW1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 18:27:46 -0400
Date: Thu, 31 Oct 2013 15:27:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Simon Baatz <gmbnomis@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Catalin Marinas <catalin.marinas@arm.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Tejun Heo <tj@kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] lib/scatterlist.c: don't flush_kernel_dcache_page on
 slab page
Message-Id: <20131031152745.821d2b5dbe93e2ca69d45264@linux-foundation.org>
In-Reply-To: <1382977205-26268-1-git-send-email-ming.lei@canonical.com>
References: <1382977205-26268-1-git-send-email-ming.lei@canonical.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Oct 2013 00:20:05 +0800 Ming Lei <ming.lei@canonical.com> wrote:

> Commit b1adaf65ba03([SCSI] block: add sg buffer copy helper functions)
> introduces two sg buffer copy helpers, and calls flush_kernel_dcache_page()
> on pages in SG list after these pages are written to.
> 
> Unfortunately, the commit may introduce a potential bug:
> 
> 	- Before sending some SCSI commands, kmalloc() buffer may be
> 	passed to block layper, so flush_kernel_dcache_page() can
> 	see a slab page finally
> 
> 	- According to cachetlb.txt, flush_kernel_dcache_page() is
> 	only called on "a user page", which surely can't be a slab page.
> 
> 	- ARCH's implementation of flush_kernel_dcache_page() may
> 	use page mapping information to do optimization so page_mapping()
> 	will see the slab page, then VM_BUG_ON() is triggered.
> 
> Aaro Koskinen reported the bug on ARM/kirkwood when DEBUG_VM is enabled,
> and this patch fixes the bug by adding test of '!PageSlab(miter->page)'
> before calling flush_kernel_dcache_page().

We should work out which kernel(s) need this patch.  b1adaf65ba03 was
merged in 2008, so presumably some more recent patch has exposed the
problem, but I don't know what one that was.

Help me out here?
