Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbaLHKYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:24:44 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:61702 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbaLHKYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:24:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>, gnurou@gmail.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH] ARM: DMA: Fix kzalloc flags in __iommu_alloc_buffer()
Date: Mon, 08 Dec 2014 11:24 +0100
Message-ID: <10532762.PXKTQM8KjH@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418027967-12923-1-git-send-email-acourbot@nvidia.com>
References: <1418027967-12923-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:RTzG/5oXrfBQg2SxeE2/+javOtYU6h8mkuRwyDcksVHQsDdEk1w
 Mxp3ex3HN94YNrdk1KFdNFEo4Nakk9HzLdtmq+xAKN5fF1ppoadBX7fDT4wfSkpbWM9ytu7
 ygld7hJKLCf1QFG9i75BVVME1cWQuBKM6VigG2q6r3n3dSjPFjOzYwSXEAPHN0jeTCqhrg9
 RygEOO+hkXWCNkbTe2cgA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2014 17:39:27 Alexandre Courbot wrote:
> There doesn't seem to be any valid reason to allocate the pages array
> with the same flags as the buffer itself. Doing so can eventually lead
> to the following safeguard in mm/slab.c to be hit:
> 
> BUG_ON(flags & GFP_SLAB_BUG_MASK);
> 
> This happens when buffers are allocated with __GFP_DMA32 or
> __GFP_HIGHMEM.
> 
> Fix this by allocating the pages array with GFP_KERNEL to follow what is
> done elsewhere in this file. Using GFP_KERNEL in __iommu_alloc_buffer()
> is safe because atomic allocations are handled by __iommu_alloc_atomic().
> 

I think you need to carry over the GFP_ATOMIC flag if that is set by the
caller, but not the GFP_HIGHMEM or GFP_DMA32. Not sure if it's better
to mask out flags from the caller mask, or to start with GFP_KERNEL
and adding in extra bits.

	Arnd
