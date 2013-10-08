Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab3JHIN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:13:29 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:48023 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab3JHINY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:13:24 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-c8-5253bea10d85
Message-id: <1381220000.16135.10.camel@AMDC1943>
Subject: Re: [PATCH] frontswap: enable call to invalidate area on swapoff
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Shaohua Li <shli@fusionio.com>,
        Minchan Kim <minchan@kernel.org>
Date: Tue, 08 Oct 2013 10:13:20 +0200
In-reply-to: <20131007150338.1fdee18b536bb1d9fe41a07b@linux-foundation.org>
References: <1381159541-13981-1-git-send-email-k.kozlowski@samsung.com>
 <20131007150338.1fdee18b536bb1d9fe41a07b@linux-foundation.org>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xa7oL9wUHGSxaI2QxZ/0aNotli58y
	WlzeNYfN4t6a/6wWy76+Z7c4tZzDgc3jSdNPZo9NqzrZPDZ9msTucWLGbxaPj09vsXh83iQX
	wBbFZZOSmpNZllqkb5fAlTFx10XWgsdcFW3P7zM3MF7n6GLk5JAQMJHYNGklI4QtJnHh3no2
	EFtIYCmjxLr/VV2MXED2Z0aJGT/fM4MkeAUMJHbPWQbWICzgKTFp8XewBjYBY4nNy5eA2SIC
	uhKrnu9iBmlmFljFKLFsIkgDBweLgKrEvdeBIDWcAt4SC2cuYoNY0AG04NdUsGZmAXWJSfMW
	MUNcpCSxu72THSIuL7F5zVuoIwQlfky+xzKBUWAWkpZZSMpmISlbwMi8ilE0tTS5oDgpPddI
	rzgxt7g0L10vOT93EyMkyL/uYFx6zOoQowAHoxIPr8DhoCAh1sSy4srcQ4wSHMxKIrwCRsFB
	QrwpiZVVqUX58UWlOanFhxiZODilGhgNL7y1t1l9NtTg/ZJcR7UHL/bX91zZvol3bcmnB8sv
	flUy69LPzc83vp6SoxR5tfJsBa+Mwz5vtvCaA1eXNBX8UBEVMPMX2/NigcSxD8226XLxt4J9
	np5YOtWIRy789rdu2XeKCSnXnKrmJUt9Yr69wmg1u/jMbruKSrkPNfHvxF25xG6GBCmxFGck
	GmoxFxUnAgB0ZqwSUAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2013-10-07 at 15:03 -0700, Andrew Morton wrote:
> On Mon, 07 Oct 2013 17:25:41 +0200 Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> 
> > During swapoff the frontswap_map was NULL-ified before calling
> > frontswap_invalidate_area(). However the frontswap_invalidate_area()
> > exits early if frontswap_map is NULL. Invalidate was never called during
> > swapoff.
> > 
> > This patch moves frontswap_map_set() in swapoff just after calling
> > frontswap_invalidate_area() so outside of locks
> > (swap_lock and swap_info_struct->lock). This shouldn't be a problem as
> > during swapon the frontswap_map_set() is called also outside of any
> > locks.
> > 
> 
> Ahem.  So there's a bunch of code in __frontswap_invalidate_area()
> which hasn't ever been executed and nobody noticed it.  So perhaps that
> code isn't actually needed?
> 
> More seriously, this patch looks like it enables code which hasn't been
> used or tested before.  How well tested was this?
> 
> Are there any runtime-visible effects from this change?

I tested zswap on x86 and x86-64 and there was no difference. This is
good as there shouldn't be visible anything because swapoff is unusing
all pages anyway:
	try_to_unuse(type, false, 0); /* force all pages to be unused */

I haven't tested other frontswap users.


Best regards,
Krzysztof Kozlowski



