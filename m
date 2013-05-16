Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab3EPRj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 13:39:27 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:47055 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752873Ab3EPRj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 13:39:26 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18gDuYMnDswS31FSyCWkXfm
Date: Thu, 16 May 2013 10:39:24 -0700
From: Tony Lindgren <tony@atomide.com>
To: Vincent =?utf-8?Q?Stehl=C3=A9?= <vincent.stehle@laposte.net>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent =?utf-8?Q?Stehl=C3=A9?= <v-stehle@ti.com>, trivial@kernel.org
Subject: Re: [PATCH, v2] ARM: omap2: gpmc: fix compilation warning
Message-ID: <20130516173923.GA5600@atomide.com>
References: <20130508222639.GM32546@atomide.com>
 <1368552043-3764-1-git-send-email-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1368552043-3764-1-git-send-email-vincent.stehle@laposte.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vincent Stehlé <vincent.stehle@laposte.net> [130514 10:26]:
> From: Vincent Stehlé <v-stehle@ti.com>
> 
> Fix the following compilation warning:
> 
>   arch/arm/mach-omap2/gpmc.c: In function 'gpmc_probe_generic_child':
>   arch/arm/mach-omap2/gpmc.c:1477:4: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' [-Wformat]
> 
> Signed-off-by: Vincent Stehlé <v-stehle@ti.com>
> Cc: trivial@kernel.org
> ---
> 
> Tony wrote:
> > You should just change the format for dev_err instead of the casting.
> 
> Hi,
> 
> Sorry for the late answer; it seems this is a bit more complicated after all,
> as res.start can be 32b or 64b in LPAE. The common solution seems to be: cast
> to long long in all cases and print accordingly. Would you like this better?

Oh OK. In this case the GPMC is always within the 32-bit address space.

But considering that similar issue will be there for other code with
LPAE, how about add something generic to arch/arm/include/asm/io.h like:

#define PHYS_ADDR32(x)	((__force u32)(x))
#define PHYS_ADDR64(x)	((__force u64)(x))

Or maybe something like that already exists.

Regards,

Tony

>  arch/arm/mach-omap2/gpmc.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
> index 6c4da12..e74501e 100644
> --- a/arch/arm/mach-omap2/gpmc.c
> +++ b/arch/arm/mach-omap2/gpmc.c
> @@ -1473,8 +1473,8 @@ static int gpmc_probe_generic_child(struct platform_device *pdev,
>  	 */
>  	ret = gpmc_cs_remap(cs, res.start);
>  	if (ret < 0) {
> -		dev_err(&pdev->dev, "cannot remap GPMC CS %d to 0x%x\n",
> -			cs, res.start);
> +		dev_err(&pdev->dev, "cannot remap GPMC CS %d to 0x%llx\n",
> +			cs, (long long)res.start);
>  		goto err;
>  	}
>  
> -- 
> 1.7.10.4
> 
