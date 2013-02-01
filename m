Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030178Ab3BAOEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 09:04:53 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:32946 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab3BAOEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 09:04:51 -0500
Date: Fri, 1 Feb 2013 14:02:18 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Minchan Kim <minchan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Sealey <matt@genesi-usa.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: Re: [PATCH] zsmalloc: Fix TLB coherency and build problem
Message-ID: <20130201140218.GN23505@n2100.arm.linux.org.uk>
References: <1359334808-19794-1-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359334808-19794-1-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 10:00:08AM +0900, Minchan Kim wrote:
> @@ -663,7 +661,7 @@ static inline void __zs_unmap_object(struct mapping_area *area,
>  
>  	flush_cache_vunmap(addr, end);
>  	unmap_kernel_range_noflush(addr, PAGE_SIZE * 2);
> -	local_flush_tlb_kernel_range(addr, end);
> +	flush_tlb_kernel_range(addr, end);

void unmap_kernel_range_noflush(unsigned long addr, unsigned long size)
{
        vunmap_page_range(addr, addr + size);
}

void unmap_kernel_range(unsigned long addr, unsigned long size)
{
        unsigned long end = addr + size;

        flush_cache_vunmap(addr, end);
        vunmap_page_range(addr, end);
        flush_tlb_kernel_range(addr, end);
}

So, given the above, what would be different between:

	unsigned long end = addr + (PAGE_SIZE * 2);

	flush_cache_vunmap(addr, end);
	unmap_kernel_range_noflush(addr, PAGE_SIZE * 2);
	flush_tlb_kernel_range(addr, end);

(which is what it becomes after your change) and

	unmap_kernel_range(addr, PAGE_SIZE * 2);

?
