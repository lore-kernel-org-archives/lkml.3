Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbaKRSO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:14:28 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:60592 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263AbaKRSO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:14:26 -0500
Date: Tue, 18 Nov 2014 18:14:12 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC 3/3] ARM: reduce size of page table directory for
 short mode
Message-ID: <20141118181412.GO28279@e104818-lin.cambridge.arm.com>
References: <20141118165313.9958.1242.stgit@buzz>
 <20141118165325.9958.84370.stgit@buzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118165325.9958.84370.stgit@buzz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 03:53:25PM +0000, Konstantin Khlebnikov wrote:
> Virtual memory above PAGE_OFFSET is covered by TTBR1 which always points
> to swapper_pg_dir, thus size of the rest pgd tables might be reduced.
> Of course idmap_pgd must be full 16k because it's used without split.
> It seems nobody accesses pgd entries above PAGE_OFFSET via pgd_offset(),
> all access is done via pgd_offset_k() which refers directly to init_mm.

We did a similar trick on arm64 with swapper_pg_dir only containing the
kernel mappings while pgd_alloc() only allocates enough for the user
memory map. We just need to sort out the potential A9 issue (I'll do
some digging tomorrow).

> This patch saves 8k per process for 2G/2G split (12k for 1G/3G split)
> and kills source of frequent order-2 allocations. Unfortunately most
> commonly used 3G/1G mode isn't supported, because first part must be
> power of two. LPAE supports this mode, but it's pgd is already tiny.

Actually, with LPAE you can save a pmd and pte allocated for the vectors
page at 0xffff0000. So you can save 8K per task here. Similarly with the
classic MMU, you can save another 4K for the vectors page pte.

-- 
Catalin
