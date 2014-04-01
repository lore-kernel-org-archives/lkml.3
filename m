Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaDAMqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:46:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:27122 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaDAMqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 08:46:14 -0400
Date: Tue, 1 Apr 2014 08:46:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jungseok Lee <jays.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, sungjinn.chung@samsung.com,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH] swiotlb: Correct kernel command line handler
Message-ID: <20140401124606.GA7135@phenom.dumpdata.com>
References: <011801cf4d4c$f7ba51f0$e72ef5d0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <011801cf4d4c$f7ba51f0$e72ef5d0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 10:51:58AM +0900, Jungseok Lee wrote:
> This patch corrects kernel command line handler when io_tlb_nslabs
> is set to 0.
> 
> A current implementation allocates default size memory (64MB) when
> 0 is given to io_tlb_nslabs ("swiotlb=0") by kernel command line.
> In other words, memory is allocated unintentionally.

What are the other IOMMUs that end up taking over the DMA ops?
Or do you end up with no DMA ops?

> 
> Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
> Signed-off-by: Sungjinn Chung <sungjinn.chung@samsung.com>
> ---
>  lib/swiotlb.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index b604b83..9fe9f71 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -55,6 +55,8 @@
>  
>  int swiotlb_force;
>  
> +static int swiotlb_no_use;
> +
>  /*
>   * Used to do a quick range check in swiotlb_tbl_unmap_single and
>   * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
> @@ -102,6 +104,8 @@ setup_io_tlb_npages(char *str)
>  		io_tlb_nslabs = simple_strtoul(str, &str, 0);
>  		/* avoid tail segment of size < IO_TLB_SEGSIZE */
>  		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
> +		if (!io_tlb_nslabs)
> +			swiotlb_no_use = 1;
>  	}
>  	if (*str == ',')
>  		++str;
> @@ -212,7 +216,7 @@ swiotlb_init(int verbose)
>  	unsigned char *vstart;
>  	unsigned long bytes;
>  
> -	if (!io_tlb_nslabs) {
> +	if (!swiotlb_no_use && !io_tlb_nslabs) {
>  		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
>  		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
>  	}
> @@ -244,7 +248,7 @@ swiotlb_late_init_with_default_size(size_t default_size)
>  	unsigned int order;
>  	int rc = 0;
>  
> -	if (!io_tlb_nslabs) {
> +	if (!swiotlb_no_use && !io_tlb_nslabs) {
>  		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
>  		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
>  	}
> -- 
> 1.7.10.4
> 
> 
