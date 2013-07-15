Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab3GOIMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 04:12:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:13628 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366Ab3GOIMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 04:12:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,667,1367996400"; 
   d="scan'208";a="331446081"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.jf.intel.com>, h.mitake@gmail.com,
        kirill.shutemov@linux.jf.intel.com
In-Reply-To: <1373675551-18684-1-git-send-email-andi@firstfloor.org>
References: <1373675551-18684-1-git-send-email-andi@firstfloor.org>
Subject: RE: [PATCH] perf, tools, bench: Fix memcpy benchmark for large sizes
Content-Transfer-Encoding: 7bit
Message-Id: <20130715081532.52D85E0090@blue.fi.intel.com>
Date: Mon, 15 Jul 2013 11:15:32 +0300 (EEST)
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

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

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
>  }
>  
>  static u64 do_memcpy_cycle(memcpy_t fn, size_t len, bool prefault)
> -- 
> 1.8.1.4

-- 
 Kirill A. Shutemov
