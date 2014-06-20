Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794AbaFTDdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 23:33:32 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:56826 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143AbaFTDda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 23:33:30 -0400
Date: Thu, 19 Jun 2014 23:33:27 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Laura Abbott <lauraa@codeaurora.org>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2] of: Check for phys_addr_t overflows in
 early_init_dt_add_memory_arch
In-Reply-To: <1403234018-10942-1-git-send-email-lauraa@codeaurora.org>
Message-ID: <alpine.LFD.2.11.1406192329400.16842@knanqh.ubzr>
References: <1403234018-10942-1-git-send-email-lauraa@codeaurora.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Laura Abbott wrote:

> The common early_init_dt_add_memory_arch takes the base and size
> of a memory region as u64 types. The function never checks if
> the base and size can actually fit in a phys_addr_t which may
> be smaller than 64-bits. This may result in incorrect memory
> being passed to memblock_add if the memory falls outside the
> range of phys_addr_t. Add range checks for the base and size if
> phys_addr_t is smaller than u64.
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
> v2: Switched to sizeof(phys_addr_t) < sizeof(u64) instead of macros.
> Sending to right e-mails/mailing lists this time.
> 
>  drivers/of/fdt.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index c4cddf0..b777d8f 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -880,6 +880,21 @@ void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
>  	const u64 phys_offset = __pa(PAGE_OFFSET);
>  	base &= PAGE_MASK;
>  	size &= PAGE_MASK;
> +
> +	if (sizeof(phys_addr_t) < sizeof(u64)) {
> +		if (base > ULONG_MAX) {
> +			pr_warning("Ignoring memory block 0x%llx - 0x%llx\n",
> +					base, base + size);
> +			return;
> +		}
> +
> +		if (base + size > ULONG_MAX) {
> +			pr_warning("Ignoring memory range 0x%lx - 0x%llx\n",
> +					ULONG_MAX, base + size);
> +			size = ULONG_MAX - base;
> +		}
> +	}
> +
>  	if (base + size < phys_offset) {
>  		pr_warning("Ignoring memory block 0x%llx - 0x%llx\n",
>  			   base, base + size);
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
