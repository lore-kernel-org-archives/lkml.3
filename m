Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaJERfB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 13:35:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47088 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbaJERfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 13:35:00 -0400
Date: Sun, 5 Oct 2014 19:34:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 1/8] x86, microcode, intel: forbid some incorrect metadata
Message-ID: <20141005173453.GC9377@pd.tnic>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-2-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1410197875-19252-2-git-send-email-hmh@hmh.eng.br>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 02:37:47PM -0300, Henrique de Moraes Holschuh wrote:
> The Intel SDM vol 3A, section 9.11.1, and also table 9-6, requires that
> the Data Size field be a multiple of 4 bytes.  All of the microcode
> update header structures are dword-based, so the Total Size field must
> also be a multiple of the dword size.
> 
> Ensure that data_size is a multiple of the dword size (4 bytes).  The
> driver code assumes this to be true for both data_size and total_size,
> and will not work correctly otherwise.
> 
> Futhermore, require that total_size be a multiple of 1024, as per the
> Intel SDM, vol 3A, section 9.11.1, page 9-28; table 9-6, page 9-29, and
> others.  Test added by request of Borislav Petkov.
> 
> Also refuse a microcode update with a microcode revision of zero.
> According to the Intel SDM, vol 3A, section 9.11.7, page 9-36, a
> microcode revision of zero is special:
> 
>     "CPUID returns a value in a model specific register in addition to
>     its usual register return values.  The semantics of CPUID cause it
>     to deposit an update ID value in the 64-bit model-specific register
>     at address 08BH (IA32_BIOS_SIGN_ID).  If no update is present in the
>     processor, the value in the MSR remains unmodified.  The BIOS must
>     pre-load a zero into the MSR before executing CPUID.  If a read of
>     the MSR at 8BH still returns zero after executing CPUID, this
>     indicates that no update is present."
> 
> This effectively reserves revision zero to mean "no microcode update
> installed on the processor": the microcode loader cannot differentiate
> sucess from failure when updating microcode to the same revision as the
> one currently installed on the processor, and this would always happen
> to updates to revision zero in the BIOS/UEFI loader.
> 
> There is every reason to be paranoid about any microcode update with a
> revision of zero, as Intel will never release such a microcode update.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> ---
>  arch/x86/kernel/cpu/microcode/intel_lib.c |   25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/microcode/intel_lib.c b/arch/x86/kernel/cpu/microcode/intel_lib.c
> index ce69320..25915e3 100644
> --- a/arch/x86/kernel/cpu/microcode/intel_lib.c
> +++ b/arch/x86/kernel/cpu/microcode/intel_lib.c
> @@ -55,9 +55,10 @@ int microcode_sanity_check(void *mc, int print_err)
>  	total_size = get_totalsize(mc_header);
>  	data_size = get_datasize(mc_header);
>  
> -	if (data_size + MC_HEADER_SIZE > total_size) {
> +	if ((data_size % DWSIZE) || (total_size % 1024) ||
> +	    (data_size + MC_HEADER_SIZE > total_size)) {
>  		if (print_err)
> -			pr_err("error! Bad data size in microcode data file\n");
> +			pr_err("error: bad data size or total size in microcode data file\n");

Shorten:

	pr_err("error: bad data/total size in microcode data file\n");

>  		return -EINVAL;
>  	}
>  
> @@ -83,6 +84,26 @@ int microcode_sanity_check(void *mc, int print_err)
>  		ext_sigcount = ext_header->count;
>  	}
>  
> +	/*
> +	 * A version 1 loader cannot differentiate failure from success when
> +	 * attempting a microcode update to the same revision as the one
> +	 * currently installed.  The loader is supposed to never attempt a
> +	 * same-version update (or a microcode downgrade, for that matter).
> +	 *
> +	 * This will always cause issues for microcode updates to revision zero
> +	 * in the UEFI/BIOS microcode loader: the processor reports a revision
> +	 * of zero when it is running without any microcode updates installed,
> +	 * such as after a reset/power up.
> +	 *
> +	 * Intel will never issue a microcode update with a revision of zero
> +	 * for the version 1 loader.  Reject it.
> +	 */

This comment is too long. How about this instead:

	/*
	 * 0 is not a valid microcode revision as it is used to denote the
	 * failure of a microcode update, see MSR 0x8b (IA32_BIOS_SIGN_ID):
	 *
	 * "It is required that this register field be pre-loaded with zero
	 * prior to executing the CPUID, function 1. If the field remains
	 * equal to zero, then there is no microcode update loaded. Another
	 * non-zero value will be the signature."
	 */

This is one of those seldom times where the documentation is actually clear. :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
