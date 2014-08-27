Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933706AbaH0KbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 06:31:03 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:64855 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933374AbaH0KbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 06:31:00 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of: Fix memory block alignment in
 early_init_dt_add_memory_arch()
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
In-Reply-To: <1408547431-24001-1-git-send-email-geert+renesas@glider.be>
References: <1408547431-24001-1-git-send-email-geert+renesas@glider.be>
Date: Wed, 27 Aug 2014 11:30:48 +0100
Message-Id: <20140827103048.80BBBC409CB@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2014 17:10:31 +0200, Geert Uytterhoeven <geert+renesas@glider.be> wrote:
> If a memory block is not aligned to PAGE_SIZE, its base address must be
> rounded up, not down, and its size must be reduced.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Looks reasonable. What is the situation that exposed this problem?
Should size be checked for page alignment also?

g.

> ---
>  drivers/of/fdt.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index f46a24ffa3fe..95fa81b8ca19 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -928,7 +928,11 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
>  void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
>  {
>  	const u64 phys_offset = __pa(PAGE_OFFSET);
> -	base &= PAGE_MASK;
> +
> +	if (!PAGE_ALIGNED(base)) {
> +		size -= PAGE_SIZE - (base & ~PAGE_MASK);
> +		base = PAGE_ALIGN(base);
> +	}
>  	size &= PAGE_MASK;
>  
>  	if (base > MAX_PHYS_ADDR) {
> -- 
> 1.9.1
> 

