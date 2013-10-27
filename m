Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab3J0NeJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 09:34:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56564 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995Ab3J0NeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 09:34:08 -0400
Date: Sun, 27 Oct 2013 14:34:01 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andreas Werner <wernerandy@gmx.de>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        dave@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: MM: Add PAT Type write-through in combination with
 mtrr
Message-ID: <20131027133401.GB24817@pd.tnic>
References: <1382878525-3410-1-git-send-email-wernerandy@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1382878525-3410-1-git-send-email-wernerandy@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 01:55:25PM +0100, Andreas Werner wrote:
> This patch adds the Write-through memory type in combination with mtrr.
> If you call ioremap_cache to request cachable memory (write-back) the
> function tries to set the PAT to write-back only if the mtrr setting of
> the requested region is also marked as Write-Back.
> If the mttr regions are marked e.g. as Write-through or with other
> types, the function will always return UC- memory.
> 
> If you check the Intel document " IA-32 SDM vol 3a table Effective
> Memory Type", there
> are many other combinations possible.
> 
> This patch will only add the following combination:
>   PAT=Write-Back + MTRR=Write-Through = Effective Memory of
> Write-Through

And yet the code below returns WB for WT MTRR type which can't be
right since having a write-through mapping cannot be compatible with
write-back as the last caches writes into the cache instead of writing
them through to memory.

Why do you even care about WT? Are you trying to fix a bug or what?

> Tested on - Intel (R) Atom E680 (Tunnel Creek)
>           - Intel (R) Core(TM)2 Duo
> 
> Signed-off-by: Andreas Werner <wernerandy@gmx.de>
> ---
>  arch/x86/mm/pat.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index 6574388..9cfe107 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -149,10 +149,15 @@ static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
>  		u8 mtrr_type;
>  
>  		mtrr_type = mtrr_type_lookup(start, end);
> -		if (mtrr_type != MTRR_TYPE_WRBACK)
> -			return _PAGE_CACHE_UC_MINUS;
>  
> -		return _PAGE_CACHE_WB;
> +		switch (mtrr_type) {
> +		case MTRR_TYPE_WRBACK:
> +		case MTRR_TYPE_WRTHROUGH:
> +		  return _PAGE_CACHE_WB;
> +
> +		default:
> +		  return _PAGE_CACHE_UC_MINUS;
> +		}
>  	}
>  
>  	return req_type;

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
