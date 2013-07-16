Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab3GPKIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 06:08:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:59668 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339Ab3GPKIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 06:08:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,676,1367996400"; 
   d="scan'208";a="346365512"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.jf.intel.com>, h.mitake@gmail.com,
        kirill.shutemov@linux.jf.intel.com
In-Reply-To: <1373675551-18684-1-git-send-email-andi@firstfloor.org>
References: <1373675551-18684-1-git-send-email-andi@firstfloor.org>
Subject: RE: [PATCH] perf, tools, bench: Fix memcpy benchmark for large sizes
Content-Transfer-Encoding: 7bit
Message-Id: <20130716101100.C2A70E0090@blue.fi.intel.com>
Date: Tue, 16 Jul 2013 13:11:00 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> glibc calloc() has an optimization to not explicitely memset()
> very large calloc allocations that just came from mmap(),
> because they are known to be zero.
> 
> This could result in the perf memcpy benchmark reading only from
> the zero page, which gives unrealistic results.
> 
> Always call memset explicitly on the source area to avoid this problem.
> 
> Cc: h.mitake@gmail.com
> Cc: kirill.shutemov@linux.intel.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/bench/mem-memcpy.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
> index 93c83e3..690f75f 100644
> --- a/tools/perf/bench/mem-memcpy.c
> +++ b/tools/perf/bench/mem-memcpy.c
> @@ -117,6 +117,8 @@ static void alloc_mem(void **dst, void **src, size_t length)
>  	*src = zalloc(length);
>  	if (!src)
>  		die("memory allocation failed - maybe length is too large?\n");
> +	/* Make sure to always replace the zero pages even if MMAP_THRESH is crossed */
> +	memset(src, 0, length);

It should be memset(*src, 0, length) instead.

There's fix for wrong memory allocation fail check in v3.11-rc1.

-- 
 Kirill A. Shutemov
