Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbaGXLhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:37:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54714 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbaGXLhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:37:31 -0400
Date: Thu, 24 Jul 2014 13:37:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 5/8] x86, microcode, intel: don't use fields from unknown
 format header
Message-ID: <20140724113726.GL19239@pd.tnic>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-6-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406146251-8540-6-git-send-email-hmh@hmh.eng.br>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 05:10:48PM -0300, Henrique de Moraes Holschuh wrote:
> We must make sure the microcode has a known header format before
> we attempt to access its Total Size or Data Size fields through
> get_totalsize() or get_datasize().

Well, this is a pretty weak check but I'm all for being as defensive as
possible with the microcode loader so yes, let's do it.

However, I'd carve it out from microcode_sanity_check() in a separate
function called

static bool microcode_check_header(struct microcode_header_intel *hdr);

and do the ->hdrver and -> ldrver checks in it. In two places to be exact...

> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> ---
>  arch/x86/kernel/cpu/microcode/intel.c       |    5 +++++
>  arch/x86/kernel/cpu/microcode/intel_early.c |    3 +++
>  arch/x86/kernel/cpu/microcode/intel_lib.c   |   11 ++++++-----
>  3 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
> index a51cb19..61d430e 100644
> --- a/arch/x86/kernel/cpu/microcode/intel.c
> +++ b/arch/x86/kernel/cpu/microcode/intel.c
> @@ -199,6 +199,11 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
>  		if (get_ucode_data(&mc_header, ucode_ptr, sizeof(mc_header)))
>  			break;
>  
> +		if (mc_header.hdrver != 1) {
> +			pr_err("error! Unknown microcode update format\n");
> +			break;
> +		}

... here ...

> +
>  		mc_size = get_totalsize(&mc_header);
>  		if (!mc_size || mc_size > leftover) {
>  			pr_err("error! Bad data in microcode data file\n");
> diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
> index b88343f..c1bf915f 100644
> --- a/arch/x86/kernel/cpu/microcode/intel_early.c
> +++ b/arch/x86/kernel/cpu/microcode/intel_early.c
> @@ -324,6 +324,9 @@ get_matching_model_microcode(int cpu, unsigned long start,
>  	while (leftover) {
>  		mc_header = (struct microcode_header_intel *)ucode_ptr;
>  
> +		if (mc_header->hdrver != 1)
> +			break;
> +

... and here. I.e., everytime we're looking at a mc_header from userspace.

>  		mc_size = get_totalsize(mc_header);
>  		if (!mc_size || mc_size > leftover ||
>  			microcode_sanity_check(ucode_ptr, 0) < 0)
> diff --git a/arch/x86/kernel/cpu/microcode/intel_lib.c b/arch/x86/kernel/cpu/microcode/intel_lib.c
> index ce69320..95c2d19 100644
> --- a/arch/x86/kernel/cpu/microcode/intel_lib.c
> +++ b/arch/x86/kernel/cpu/microcode/intel_lib.c
> @@ -52,6 +52,12 @@ int microcode_sanity_check(void *mc, int print_err)
>  	int sum, orig_sum, ext_sigcount = 0, i;
>  	struct extended_signature *ext_sig;
>  
> +	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
> +		if (print_err)
> +			pr_err("error! Unknown microcode update format\n");
> +		return -EINVAL;
> +	}
> +
>  	total_size = get_totalsize(mc_header);
>  	data_size = get_datasize(mc_header);
>  
> @@ -61,11 +67,6 @@ int microcode_sanity_check(void *mc, int print_err)
>  		return -EINVAL;
>  	}
>  
> -	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
> -		if (print_err)
> -			pr_err("error! Unknown microcode update format\n");
> -		return -EINVAL;
> -	}

This one is then redundant.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
