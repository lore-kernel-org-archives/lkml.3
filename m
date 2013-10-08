Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab3JHUI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:08:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3JHUIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:08:55 -0400
Date: Tue, 8 Oct 2013 13:08:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: linux-mm@kvack.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Shaohua Li <shli@fusionio.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH] frontswap: enable call to invalidate area on swapoff
Message-Id: <20131008130853.96139b79a0a4d3aaacc79ed2@linux-foundation.org>
In-Reply-To: <1381220000.16135.10.camel@AMDC1943>
References: <1381159541-13981-1-git-send-email-k.kozlowski@samsung.com>
	<20131007150338.1fdee18b536bb1d9fe41a07b@linux-foundation.org>
	<1381220000.16135.10.camel@AMDC1943>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Oct 2013 10:13:20 +0200 Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:

> On pon, 2013-10-07 at 15:03 -0700, Andrew Morton wrote:
> > On Mon, 07 Oct 2013 17:25:41 +0200 Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> > 
> > > During swapoff the frontswap_map was NULL-ified before calling
> > > frontswap_invalidate_area(). However the frontswap_invalidate_area()
> > > exits early if frontswap_map is NULL. Invalidate was never called during
> > > swapoff.
> > > 
> > > This patch moves frontswap_map_set() in swapoff just after calling
> > > frontswap_invalidate_area() so outside of locks
> > > (swap_lock and swap_info_struct->lock). This shouldn't be a problem as
> > > during swapon the frontswap_map_set() is called also outside of any
> > > locks.
> > > 
> > 
> > Ahem.  So there's a bunch of code in __frontswap_invalidate_area()
> > which hasn't ever been executed and nobody noticed it.  So perhaps that
> > code isn't actually needed?
> > 
> > More seriously, this patch looks like it enables code which hasn't been
> > used or tested before.  How well tested was this?
> > 
> > Are there any runtime-visible effects from this change?
> 
> I tested zswap on x86 and x86-64 and there was no difference. This is
> good as there shouldn't be visible anything because swapoff is unusing
> all pages anyway:
> 	try_to_unuse(type, false, 0); /* force all pages to be unused */
> 
> I haven't tested other frontswap users.

So is that code in __frontswap_invalidate_area() unneeded?
