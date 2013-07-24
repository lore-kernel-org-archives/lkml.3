Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268Ab3GXNdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 09:33:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47268 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab3GXNdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 09:33:01 -0400
Date: Wed, 24 Jul 2013 15:32:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] x86, AMD: cleanup: merge common code in early
 microcode loading
Message-ID: <20130724133254.GE30777@pd.tnic>
References: <20130723230026.394a5ee1@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130723230026.394a5ee1@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 11:00:26PM +0200, Torsten Kaiser wrote:
> Extract common checks and initialisations from load_ucode_ap() and
> save_microcode_in_initrd_amd() to load_microcode_amd_early().
> load_ucode_ap() gets a quick exit for !cpu, because for the BSP there is
> already a different function dealing with its update.
> 
> The original code already didn't anything, because without load_microcode_amd()
> getting called apply_microcode_amd() could not do anything.
> 
> Signed-off-by: Torsten Kaiser <just.for.lkml@googlemail.com>
> 
> --- a/arch/x86/kernel/microcode_amd_early.c	2013-07-22 06:22:32.000000000 +0200
> +++ b/arch/x86/kernel/microcode_amd_early.c	2013-07-23 20:00:04.889508712 +0200
> @@ -196,6 +196,23 @@ void __init load_ucode_amd_bsp(void)
>  	apply_ucode_in_initrd(cd.data, cd.size);
>  }
>  
> +static int load_microcode_amd_early(void)
> +{
> +	enum ucode_state ret;
> +	void *ucode;
> +
> +	if (ucode_loaded || !ucode_size || !initrd_start)
> +		return 0;
> +
> +	ucode = (void *)(initrd_start + ucode_offset);
> +	ret = load_microcode_amd(0, ucode, ucode_size);
> +	if (ret != UCODE_OK)
> +		return -EINVAL;
> +
> +	ucode_loaded = true;
> +	return 0;
> +}
> +
>  #ifdef CONFIG_X86_32
>  u8 amd_bsp_mpb[MPB_MAX_SIZE];
>  
> @@ -258,17 +275,13 @@ void load_ucode_amd_ap(void)
>  
>  	collect_cpu_info_amd_early(&cpu_data(cpu), ucode_cpu_info + cpu);
>  
> -	if (cpu && !ucode_loaded) {
> -		void *ucode;
> -
> -		if (!ucode_size || !initrd_start)
> -			return;
> +	/* BSP via load_ucode_amd_bsp() */
> +	if (!cpu)
> +		return;

Ok, this is really misleading. Fenghua, what's the reason for calling
load_ucode_ap() on the BSP too?

We have on the one hand:

x86_64_start_kernel
|->load_ucode_bsp

and on the other:

x86_64_start_kernel
|-> x86_64_start_reservations
    |-> start_kernel
        |-> trap_init
	    |-> cpu_init
	        |-> load_ucode_ap()

so we attempt to load the ucode twice on the BSP.

IMO, we should do this in cpu_init:

	if (cpu)
		load_ucode_ap();

no?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
