Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbaI2MFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 08:05:52 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52702 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbaI2MFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 08:05:50 -0400
Date: Mon, 29 Sep 2014 14:05:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chen Yucong <slaoub@gmail.com>
Cc: tony.luck@intel.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before
 machine_check_poll() resets it
Message-ID: <20140929120546.GB6495@pd.tnic>
References: <1411438561-24319-1-git-send-email-slaoub@gmail.com>
 <1411460354.25617.3.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1411460354.25617.3.camel@debian>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 04:19:14PM +0800, Chen Yucong wrote:
> machine_check_poll() will reset IA32_MCi_STATUS register to zero.
> So we need to save the content of IA32_MCi_STATUS MSRs before
> calling machine_check_poll() for logging threshold interrupt event.
> 
> mce_setup() does not gather the content of IA32_MCG_STATUS, so it
> should be read explicitly.
> 
> Signed-off-by: Chen Yucong <slaoub@gmail.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce_amd.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> index f8c56bd..9148b4d 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> @@ -275,6 +275,12 @@ static void amd_threshold_interrupt(void)
>  
>  	mce_setup(&m);
>  
> +	/*
> +	 * mce_setup() can't gather the content of IA32_MCG_STATUS,
> +	 * so it should be read explicitly.
> +	 */

No need for that comment.

> +	rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus);
> +
>  	/* assume first bank caused it */
>  	for (bank = 0; bank < mca_cfg.banks; ++bank) {
>  		if (!(per_cpu(bank_map, m.cpu) & (1 << bank)))
> @@ -305,6 +311,12 @@ static void amd_threshold_interrupt(void)
>  			     (high & MASK_LOCKED_HI))
>  				continue;
>  
> +			/*
> +			 * machine_check_poll() will reset IA32_MCi_STATUS
> +			 * register to zero, save it for use later.
> +			 */
> +			rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);

Actually, to be more future-proof, I'd like to do the AMD-specific
logging first, i.e. before machine_check_poll() so that any future
changes there don't influence what we do in mce_amd.c.

So please move the machine_check_poll() call behind the

	if (high & MASK_OVERFLOW_HI) {

test and drop the return.

But the patch makes sense so good catch!

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
