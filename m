Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbaLIW5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 17:57:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbaLIWuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 17:50:40 -0500
Date: Tue, 9 Dec 2014 14:50:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Ingo Molnar <mingo@kernel.org>, <dave@sr71.net>,
        Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-tip-commits@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH V2] x86/mm: Fix zone ranges boot printout
Message-Id: <20141209145038.6253a2b99379bfb1255fa95e@linux-foundation.org>
In-Reply-To: <54866C18.1050203@huawei.com>
References: <54866C18.1050203@huawei.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2014 11:27:20 +0800 Xishi Qiu <qiuxishi@huawei.com> wrote:

> Changelog:
> V2:
> 	-fix building warnings of min(...).
>
> ...
>
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -674,10 +674,12 @@ void __init zone_sizes_init(void)
>  	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
>  
>  #ifdef CONFIG_ZONE_DMA
> -	max_zone_pfns[ZONE_DMA]		= MAX_DMA_PFN;
> +	max_zone_pfns[ZONE_DMA]		= min_t(unsigned long,
> +						max_low_pfn, MAX_DMA_PFN);

MAX_DMA_PFN has type int.

>  #endif
>  #ifdef CONFIG_ZONE_DMA32
> -	max_zone_pfns[ZONE_DMA32]	= MAX_DMA32_PFN;
> +	max_zone_pfns[ZONE_DMA32]	= min_t(unsigned long,
> +						max_low_pfn, MAX_DMA32_PFN);

MAX_DMA32_PFN has type UL (I think?) so there's no need for min_t here.

>  #endif
>  	max_zone_pfns[ZONE_NORMAL]	= max_low_pfn;
>  #ifdef CONFIG_HIGHMEM


Let's try to get the types correct, rather than hacking around fixing
up fallout from earlier incorrect type choices?

What is the type of a pfn?  Unsigned long, generally, when we bother
thinking about it.

So how about we make MAX_DMA_PFN have type UL?  I assume that fixes the
warning?

If we do this, we should also be able to undo the min_t hackery in
arch/x86/kernel/e820.c:memblock_find_dma_reserve().

