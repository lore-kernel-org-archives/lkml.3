Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaG1Pcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:32:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54213 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbaG1PcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:32:00 -0400
Date: Mon, 28 Jul 2014 17:31:57 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 7/8] x86, microcode, intel: forbid some incorrect metadata
Message-ID: <20140728153157.GC5350@pd.tnic>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-8-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406146251-8540-8-git-send-email-hmh@hmh.eng.br>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 05:10:50PM -0300, Henrique de Moraes Holschuh wrote:
> Ensure that both the microcode data_size and total_size fields are a
> multiple of the dword size (4 bytes).  The Intel SDM vol 3A (order code
> 253668-051US, June 2014) requires this to be true, and the driver code
> assumes it will be true.
> 
> Add a comment to the code stating that it is best if we continue to
> refrain from ensuring that total_size is a multiple of 1024 bytes.  The
> reason to never add that check is non-obvious.
> 
> Refuse a microcode with a revision of zero, we reserve that for the
> factory-provided microcode.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> ---
>  arch/x86/kernel/cpu/microcode/intel_lib.c |   21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/microcode/intel_lib.c b/arch/x86/kernel/cpu/microcode/intel_lib.c
> index 95c2d19..050cd4f 100644
> --- a/arch/x86/kernel/cpu/microcode/intel_lib.c
> +++ b/arch/x86/kernel/cpu/microcode/intel_lib.c
> @@ -61,12 +61,22 @@ int microcode_sanity_check(void *mc, int print_err)
>  	total_size = get_totalsize(mc_header);
>  	data_size = get_datasize(mc_header);
>  
> -	if (data_size + MC_HEADER_SIZE > total_size) {
> +	if ((data_size % DWSIZE) || (total_size % DWSIZE) ||
> +	    (data_size + MC_HEADER_SIZE > total_size)) {
>  		if (print_err)
> -			pr_err("error! Bad data size in microcode data file\n");
> +			pr_err("error! Bad data size or total size in microcode data file\n");
>  		return -EINVAL;
>  	}
>  
> +	/*
> +	 * DO NOT add a check for total_size to be a multiple of 1024.
> +	 *
> +	 * While there is a requirement that total_size be a multiple of 1024
> +	 * (Intel SDM vol 3A, section 9.11.1, table 9-6, page 9-29), it clashes
> +	 * with the "delete extended signature table" procedure described for
> +	 * the Checksum[n] field in the same table 9-6, at page 9-30).

Why? I don't see anything wrong with doing

->total_size % 1024

as an additional sanity check. It's a whole another question how much it
would catch but it doesn't hurt to do it as part of us being defensive.

> +	/* check some of the metadata */
> +	if (mc_header->rev == 0) { /* reserved for silicon microcode */
> +		if (print_err)
> +			pr_err("error! Restricted revision 0 in microcode data file\n");
> +		return -EINVAL;
> +	}

What is "factory-provided" microcode? What is this check supposed to
accomplish?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
