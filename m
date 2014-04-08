Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254AbaDHNNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:13:50 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54671 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932233AbaDHNNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:13:47 -0400
Date: Tue, 8 Apr 2014 14:13:11 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Jay Foad <jay.foad@gmail.com>
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: VFP: Fix emulation of multiply accumulate
 instructions
Message-ID: <20140408131256.GA5637@e103592.cambridge.arm.com>
References: <1395852549-2745-1-git-send-email-jay.foad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395852549-2745-1-git-send-email-jay.foad@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 04:49:09PM +0000, Jay Foad wrote:
> The emulation for single and double precision multiply accumulate
> instructions correctly normalised any denormal values in the operand
> registers, but failed to normalise the destination (accumulator)
> register.
> 
> This fixes https://bugzilla.kernel.org/show_bug.cgi?id=70501
> 
> Signed-off-by: Jay Foad <jay.foad@gmail.com>

Reviewed-by: Dave Martin <Dave.Martin@arm.com>

This appears to be clean and straightforward, so if nobody else has
commented on this by the time -rc1 comes out, I suggest you rebase it
and send it to the patch system.  (See
http://www.arm.linux.org.uk/developer/patches/info.php for details
-- make sure you read it carefully.)

Has this issue been hitting real-world users of the kernel, or is
this fixing a latent bug?

Cheers
---Dave

> ---
>  arch/arm/vfp/vfpdouble.c | 2 ++
>  arch/arm/vfp/vfpsingle.c | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/arch/arm/vfp/vfpdouble.c b/arch/arm/vfp/vfpdouble.c
> index 6cac43bd1d86..423f56dd4028 100644
> --- a/arch/arm/vfp/vfpdouble.c
> +++ b/arch/arm/vfp/vfpdouble.c
> @@ -866,6 +866,8 @@ vfp_double_multiply_accumulate(int dd, int dn, int dm, u32 fpscr, u32 negate, ch
>  		vdp.sign = vfp_sign_negate(vdp.sign);
>  
>  	vfp_double_unpack(&vdn, vfp_get_double(dd));
> +	if (vdn.exponent == 0 && vdn.significand)
> +		vfp_double_normalise_denormal(&vdn);
>  	if (negate & NEG_SUBTRACT)
>  		vdn.sign = vfp_sign_negate(vdn.sign);
>  
> diff --git a/arch/arm/vfp/vfpsingle.c b/arch/arm/vfp/vfpsingle.c
> index b252631b406b..4f96c1617aae 100644
> --- a/arch/arm/vfp/vfpsingle.c
> +++ b/arch/arm/vfp/vfpsingle.c
> @@ -915,6 +915,8 @@ vfp_single_multiply_accumulate(int sd, int sn, s32 m, u32 fpscr, u32 negate, cha
>  	v = vfp_get_float(sd);
>  	pr_debug("VFP: s%u = %08x\n", sd, v);
>  	vfp_single_unpack(&vsn, v);
> +	if (vsn.exponent == 0 && vsn.significand)
> +		vfp_single_normalise_denormal(&vsn);
>  	if (negate & NEG_SUBTRACT)
>  		vsn.sign = vfp_sign_negate(vsn.sign);
>  
> -- 
> 1.8.3.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
