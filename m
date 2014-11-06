Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaKFPtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:49:01 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56290 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbaKFPs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:48:58 -0500
Date: Thu, 6 Nov 2014 16:48:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: Chen Yucong <slaoub@gmail.com>
Cc: tony.luck@intel.com, ak@linux.intel.com, aravind.gopalakrishnan@amd.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] x86, mce: support memory error recovery for both
 UCNA and Deferred error in machine_check_poll
Message-ID: <20141106154853.GE4318@pd.tnic>
References: <1415162873-1874-1-git-send-email-slaoub@gmail.com>
 <1415162873-1874-3-git-send-email-slaoub@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1415162873-1874-3-git-send-email-slaoub@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 12:47:53PM +0800, Chen Yucong wrote:
> Uncorrected no action required (UCNA) - is a UCR error that is not

Please explain "UCR" if you're using it out of the rest of the SDM text.

> signaled via a machine check exception and, instead, is reported to
> system software as a corrected machine check error. UCNA errors indicate
> that some data in the system is corrupted, but the data has not been
> consumed and the processor state is valid and you may continue execution
> on this processor. UCNA errors require no action from system software
> to continue execution. Note that UCNA errors are supported by the
> processor only when IA32_MCG_CAP[24] (MCG_SER_P) is set.
>                                                -- Intel SDM Volume 3B
> 
> Deferred errors are errors that cannot be corrected by hardware, but
> do not cause an immediate interruption in program flow, loss of data
> integrity, or corruption of processor state. These errors indicate
> that data has been corrupted but not consumed. Hardware writes information
> to the status and address registers in the corresponding bank that
> identifies the source of the error if deferred errors are enabled for
> logging. Deferred errors are not reported via machine check exceptions;
> they can be seen by polling the MCi_STATUS registers.
>                                                 -- ADM64 APM Volume 2
						     ^^^

Please try to spell "AMD" correctly. Your first patch has "ADM" too.

> 
> Above two items, both UCNA and Deferred errors belong to detected
> errors, but they can't be corrected by hardware, and this is very
> similar to Software Recoverable Action Optional (SRAO) errors.
> Therefore, we can take some actions that have been used for handling
> SRAO errors to handle UCNA and Deferred errors.


> 
> Signed-off-by: Chen Yucong <slaoub@gmail.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   50 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 453e9bf..37f7649 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -575,6 +575,46 @@ static void mce_read_aux(struct mce *m, int i)
>  	}
>  }
>  
> +static bool mem_deferred_error(struct mce *m)
> +{
> +	int severity;
> +	struct cpuinfo_x86 *c = &boot_cpu_data;
> +
> +	severity = mce_severity(m, mca_cfg.tolerant, NULL, false);
> +
> +	if (c->x86_vendor == X86_VENDOR_AMD) {
> +		/*
> +		 * AMD BKDGs - Machine Check Error Codes
> +		 *
> +		 * Bit 8 of ErrCode[15:0] of MCi_STATUS is used for indicating
> +		 * a memory-specific error. Note that this field encodes info-
> +		 * rmation about memory-hierarchy level involved in the error.
> +		 */
> +		if (severity == MCE_DEFERRED_SEVERITY)
> +			return  (m->status & 0xff00) == BIT(8);
> +	} else if (c->x86_vendor == X86_VENDOR_INTEL) {
> +		/*
> +		 * Intel SDM Volume 3B - 15.9.2 Compound Error Codes
> +		 *
> +		 * Bit 7 of the MCACOD field of IA32_MCi_STATUS is used for
> +		 * indicating a memory error. Bit 8 is used for indicating a
> +		 * cache hierarchy error. The combination of bit 2 and bit 3
> +		 * is used for indicating a `generic' cache hierarchy error
> +		 * But we can't just blindly check the above bits, because if
> +		 * bit 11 is set, then it is a bus/interconnect error - and
> +		 * either way the above bits just gives more detail on what
> +		 * bus/interconnect error happened. Note that bit 12 can be
> +		 * ignored, as it's the "filter" bit.
> +		 */
> +		if (severity == MCE_UCNA_SEVERITY)
> +			return (m->status & 0xef80) == BIT(7) ||
> +			       (m->status & 0xef00) == BIT(8) ||
> +			       (m->status & 0xeffc) == 0xc;
> +	}
> +
> +	return false;
> +}

This function is combining deferred and memory error checks. Please do
this differently:

	if (memory_error(m))
		if (deferred_error(m))
			blabla

so that the memory_error() function can be used in other code paths
separately.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
