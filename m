Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3GXPzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:55:35 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:50006 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab3GXPzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:55:32 -0400
Date: Wed, 24 Jul 2013 21:25:10 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Chen Gong <gong.chen@linux.intel.com>
Subject: Re: [PATCH] x86/mce: Pay no attention to 'F' bit in MCACOD when
 parsing 'UC' errors.
Message-ID: <20130724155510.GA29756@naverao1-tp.watson.ibm.com>
References: <0104420@agluck-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0104420@agluck-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072415-8878-0000-0000-000008181AD2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/07/23 01:34PM, Tony Luck wrote:
> The 0x1000 bit of the MCACOD field of machine check MCi_STATUS
> registers is only defined for corrected errors (where it means
> that hardware may be filtering errors see SDM section 15.9.2.1).
> 
> For uncorrected errors it may, or may not be set - so we should mask
> it out when checking for the architecturaly defined recoverable
> error signatures (see SDM 15.9.3.1 and 15.9.3.2)
> 
> While fixing this - I also noticed a bug introduced by
>   commit 33d7885b594e169256daef652e8d3527b2298e75
>   x86/mce: Update MCE severity condition check
> where we were including MCACOD bits in the check for the
> unaffected thread(s) during a machine check.

Good catch!

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/include/asm/mce.h                | 3 ++-
>  arch/x86/kernel/cpu/mcheck/mce-severity.c | 8 ++++----
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> index fa5f71e..a528f28 100644
> --- a/arch/x86/include/asm/mce.h
> +++ b/arch/x86/include/asm/mce.h
> @@ -33,10 +33,11 @@
>  #define MCI_STATUS_S	 (1ULL<<56)  /* Signaled machine check */
>  #define MCI_STATUS_AR	 (1ULL<<55)  /* Action required */
>  #define MCACOD		  0xffff     /* MCA Error Code */
> +#define MCACOD_UC	  0xefff     /* MCA Error Code - for UC errors */

How about just changing MCACOD to 0xefff? I don't think we ever care
about the 'F' bit, so we could simplify this by just changing MCACOD.

Regards,
Naveen

>  
>  /* Architecturally defined codes from SDM Vol. 3B Chapter 15 */
>  #define MCACOD_SCRUB	0x00C0	/* 0xC0-0xCF Memory Scrubbing */
> -#define MCACOD_SCRUBMSK	0xfff0
> +#define MCACOD_SCRUBMSK	0xeff0
>  #define MCACOD_L3WB	0x017A	/* L3 Explicit Writeback */
>  #define MCACOD_DATA	0x0134	/* Data Load */
>  #define MCACOD_INSTR	0x0150	/* Instruction Fetch */
> diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
> index e2703520..7f6ab4e 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
> @@ -111,17 +111,17 @@ static struct severity {
>  #ifdef	CONFIG_MEMORY_FAILURE
>  	MCESEV(
>  		KEEP, "Action required but unaffected thread is continuable",
> -		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR),
> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR, MCI_UC_SAR|MCI_ADDR),
>  		MCGMASK(MCG_STATUS_RIPV, MCG_STATUS_RIPV)
>  		),
>  	MCESEV(
>  		AR, "Action required: data load error in a user process",
> -		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD_UC, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
>  		USER
>  		),
>  	MCESEV(
>  		AR, "Action required: instruction fetch error in a user process",
> -		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_INSTR),
> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD_UC, MCI_UC_SAR|MCI_ADDR|MCACOD_INSTR),
>  		USER
>  		),
>  #endif
> @@ -137,7 +137,7 @@ static struct severity {
>  		),
>  	MCESEV(
>  		AO, "Action optional: last level cache writeback error",
> -		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCACOD, MCI_UC_S|MCACOD_L3WB)
> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCACOD_UC, MCI_UC_S|MCACOD_L3WB)
>  		),
>  	MCESEV(
>  		SOME, "Action optional: unknown MCACOD",
> -- 
> 1.8.1.4
> 

