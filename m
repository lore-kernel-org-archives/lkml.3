Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbaI1IPo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 04:15:44 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36643 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaI1IPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 04:15:41 -0400
Message-ID: <1411892131.2029.136.camel@cyc>
Subject: Re: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before
 machine_check_poll() resets it
From: Chen Yucong <slaoub@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
Date: Sun, 28 Sep 2014 16:15:31 +0800
In-Reply-To: <1411460354.25617.3.camel@debian>
References: <1411438561-24319-1-git-send-email-slaoub@gmail.com>
	 <1411460354.25617.3.camel@debian>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-23 at 16:19 +0800, Chen Yucong wrote:
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
> +
>  			/*
>  			 * Log the machine check that caused the threshold
>  			 * event.
> @@ -314,7 +326,6 @@ static void amd_threshold_interrupt(void)
>  
>  			if (high & MASK_OVERFLOW_HI) {
>  				rdmsrl(address, m.misc);
> -				rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);
>  				m.bank = K8_MCE_THRESHOLD_BASE
>  				       + bank * NR_BLOCKS
>  				       + block;
Hi Andi,

Can you review the above patch?

thx!
cyc

