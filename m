Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaI3HZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:25:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38602 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbaI3HZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:25:57 -0400
Date: Tue, 30 Sep 2014 09:25:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chen Yucong <slaoub@gmail.com>
Cc: tony.luck@intel.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before
 machine_check_poll() resets it
Message-ID: <20140930072553.GA4639@pd.tnic>
References: <1411438561-24319-1-git-send-email-slaoub@gmail.com>
 <1411460354.25617.3.camel@debian>
 <20140929120546.GB6495@pd.tnic>
 <1412037578.21488.11.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1412037578.21488.11.camel@debian>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 08:39:38AM +0800, Chen Yucong wrote:
> machine_check_poll() will scan all banks, so I think we can move it out
> of the loop body.

Ok.

> From: Chen Yucong
> 
> machine_check_poll() will reset IA32_MCi_STATUS register to zero.
> So we need to save the content of IA32_MCi_STATUS MSRs before
> calling machine_check_poll() for logging threshold interrupt event.
> 
> mce_setup() does not gather the content of IA32_MCG_STATUS, so it
> should be read explicitly. And we also need to save MSR_IA32_MCx_ADDR
> if MCI_STATUS_ADDRV bit field is valid.  
> 
> Signed-off-by: Chen Yucong <slaoub@gmail.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce_amd.c |   21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> index f8c56bd..f5a5beb 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> @@ -274,6 +274,7 @@ static void amd_threshold_interrupt(void)
>  	struct mce m;
>  
>  	mce_setup(&m);
> +	rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus);
>  
>  	/* assume first bank caused it */
>  	for (bank = 0; bank < mca_cfg.banks; ++bank) {
> @@ -305,24 +306,28 @@ static void amd_threshold_interrupt(void)
>  			     (high & MASK_LOCKED_HI))
>  				continue;
>  
> -			/*
> -			 * Log the machine check that caused the threshold
> -			 * event.
> -			 */
> -			machine_check_poll(MCP_TIMESTAMP,
> -					this_cpu_ptr(&mce_poll_banks));
> -
>  			if (high & MASK_OVERFLOW_HI) {
>  				rdmsrl(address, m.misc);
>  				rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);
> +				if (m.status & MCI_STATUS_ADDRV)
> +					rdmsrl(MSR_IA32_MCx_ADDR(bank), m.addr);
>  				m.bank = K8_MCE_THRESHOLD_BASE
>  				       + bank * NR_BLOCKS
>  				       + block;
>  				mce_log(&m);
> -				return;
> +
> +				wrmsrl(MSR_IA32_MCx_STATUS(bank), 0);

No, machine_check_poll will clear it anyway and now you're adding a
purely useless MSR write here which costs.

> +				goto log_mcheck;

Why goto? It will hit that machine_check_poll below even without it...

> +
> +log_mcheck:
> +	/*
> +	 * Log the machine check that caused the threshold event.
> +	 */
> +	machine_check_poll(MCP_TIMESTAMP,
> +				this_cpu_ptr(&mce_poll_banks));
>  }

Of course, the more important question is: how are you testing your patches?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
