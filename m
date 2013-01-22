Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab3AVVLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:11:45 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:46675 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab3AVVK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:10:58 -0500
X-Auth-Info: YxXqL1szkM0XbgcE2kW4+0P6IUgPefFPHJqE2u4TTMY=
Date: Tue, 22 Jan 2013 22:10:49 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/2] powerpc/5200: Fix size to request_mem_region() call
Message-ID: <20130122221049.0bc73953@crub>
In-Reply-To: <1358473200-17886-1-git-send-email-grant.likely@secretlab.ca>
References: <1358473200-17886-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Fri, 18 Jan 2013 01:39:59 +0000
Grant Likely <grant.likely@secretlab.ca> wrote:

> The Bestcomm driver requests a memory region larger than the one
> described in the device tree. This is due to an extra undocumented field
> in the bestcomm register structure. This hasn't been a problem up to
> now, but there is a patch pending to make the DT platform_bus support
> code use platform_device_add() which tightens the rules and provides
> extra checks for drivers to stay within the specified register regions.
> 
> Alternately, I could have removed the extra field from the structure,
> but I'm not sure if it is still needed for resume to work. Better be
> safe and leave it in.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Anatolij Gustschin <agust@denx.de>
> ---
>  arch/powerpc/sysdev/bestcomm/bestcomm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

There is a patch moving this driver to drivers/dma,

http://patchwork.ozlabs.org/patch/191153/

I've applied it to my 5xxx next branch.

> diff --git a/arch/powerpc/sysdev/bestcomm/bestcomm.c b/arch/powerpc/sysdev/bestcomm/bestcomm.c
> index d913063..81c3314 100644
> --- a/arch/powerpc/sysdev/bestcomm/bestcomm.c
> +++ b/arch/powerpc/sysdev/bestcomm/bestcomm.c
> @@ -414,7 +414,7 @@ static int mpc52xx_bcom_probe(struct platform_device *op)
>  		goto error_sramclean;
>  	}
>  
> -	if (!request_mem_region(res_bcom.start, sizeof(struct mpc52xx_sdma),
> +	if (!request_mem_region(res_bcom.start, resource_size(&res_bcom),
>  				DRIVER_NAME)) {
>  		printk(KERN_ERR DRIVER_NAME ": "
>  			"Can't request registers region\n");

similar change is needed for release_mem_region() in error path
and in driver's remove() function.

Thanks,

Anatolij
