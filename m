Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaKJTGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:06:23 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33521 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbaKJTGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:06:21 -0500
Date: Mon, 10 Nov 2014 20:06:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Chen Yucong <slaoub@gmail.com>
Cc: tony.luck@intel.com, ak@linux.intel.com, aravind.gopalakrishnan@amd.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] x86, mce: support memory error recovery for both
 UCNA and Deferred error in machine_check_poll
Message-ID: <20141110190617.GJ4359@pd.tnic>
References: <1415410821-15063-1-git-send-email-slaoub@gmail.com>
 <1415410821-15063-3-git-send-email-slaoub@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1415410821-15063-3-git-send-email-slaoub@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2014 at 09:40:21AM +0800, Chen Yucong wrote:
> Uncorrected no action required (UCNA) - is a uncorrected recoverable
> machine check error that is not signaled via a machine check exception
> and, instead, is reported to system software as a corrected machine
> check error. UCNA errors indicate that some data in the system is
> corrupted, but the data has not been consumed and the processor state
> is valid and you may continue execution on this processor. UCNA errors
> require no action from system software to continue execution. Note that
> UCNA errors are supported by the processor only when IA32_MCG_CAP[24]
> (MCG_SER_P) is set.
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
>                                                 -- AMD64 APM Volume 2
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
> index 453e9bf..4b6e4cdf 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -575,6 +575,41 @@ static void mce_read_aux(struct mce *m, int i)
>  	}
>  }
>  
> +static bool memory_error(struct mce *m)
> +{
> +	struct cpuinfo_x86 *c = &boot_cpu_data;
> +
> +	if (c->x86_vendor == X86_VENDOR_AMD) {
> +		/*
> +		 * AMD BKDGs - Machine Check Error Codes
> +		 *
> +		 * Bit 8 of ErrCode[15:0] of MCi_STATUS is used for indicating
> +		 * a memory-specific error. Note that this field encodes info-
> +		 * rmation about memory-hierarchy level involved in the error.
> +		 */
> +		return (m->status & 0xff00) == BIT(8);

Grrr, you copied this from a patch of mine, correct?

So if you copy it why did you go and change it up and break it on top of
that?! Testing bit 8 is wrong!

NAK!

Before you go and "fix" this again, wait for me to clear up something
else before you even go do that. I'll let you know.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
