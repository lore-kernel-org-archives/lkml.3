Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaIXOiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:38:52 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37373 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaIXOit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:38:49 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of: fdt: fix memory range check
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        devicetree@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <1411466349-14166-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1411466349-14166-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Wed, 24 Sep 2014 15:38:44 +0100
Message-Id: <20140924143844.B2218C40738@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014 10:59:09 +0100, Srinivas Kandagatla <srinivas.kandagatla@linaro.org> wrote:
> In cases where board has below memory DT node
> 
> memory{
> 	device_type = "memory";
> 	reg = <0x80000000 0x80000000>;
> };
> 
> Check on the memory range in fdt.c will always fail because it is
> comparing MAX_PHYS_ADDR with base + size, in fact it should compare
> it with base + size - 1.
> 
> This issue was originally noticed on Qualcomm IFC6410 board.
> Without this patch kernel shows up noticed unnecessary warnings
> 
> [    0.000000] Machine model: Qualcomm APQ8064/IFC6410
> [    0.000000] Ignoring memory range 0xffffffff - 0x100000000
> [    0.000000] cma: Reserved 64 MiB at ab800000
> 
> as a result the size get reduced to 0x7fffffff which looks wrong.
> 
> This patch fixes the check involved in generating this warning and
> as a result it also fixes the wrong size calculation.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
>  drivers/of/fdt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index 79cb831..3f5736c 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -937,7 +937,7 @@ void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
>  		return;
>  	}
>  
> -	if (base + size > MAX_PHYS_ADDR) {
> +	if (base + size - 1 > MAX_PHYS_ADDR) {
>  		pr_warning("Ignoring memory range 0x%lx - 0x%llx\n",
>  				ULONG_MAX, base + size);
>  		size = MAX_PHYS_ADDR - base;

By that logic, the above two lines need to be repaired also:

		pr_warning("Ignoring memory range 0x%lx - 0x%llx\n",
				MAX_PHYS_ADDR + 1, base + size);
		size = MAX_PHYS_ADDR - base + 1;

I've fixed it up and applied, thanks.

g.

