Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaHLKrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 06:47:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48078 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939AbaHLKrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 06:47:22 -0400
Date: Tue, 12 Aug 2014 11:46:27 +0100
From: Will Deacon <will.deacon@arm.com>
To: Dave Young <dyoung@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Subject: Re: [PATCH 3/5] efi arm64: do not enter virtual mode in case booting
 with efi=noruntime or noefi
Message-ID: <20140812104627.GI29013@arm.com>
References: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
 <1407823822-23829-3-git-send-email-dyoung@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407823822-23829-3-git-send-email-dyoung@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 07:10:20AM +0100, Dave Young wrote:
> In case efi runtime disabled via noefi kernel cmdline arm64_enter_virtual_mode
> should error out.
> 
> At the same time move early_memunmap(memmap.map, mapsize) to the beginning of
> the function or it will leak early mem.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/arm64/kernel/efi.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index e72f310..324cdd1 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -386,7 +386,10 @@ static int __init arm64_enter_virtual_mode(void)
>  	int count = 0;
>  	unsigned long flags;
>  
> -	if (!efi_enabled(EFI_BOOT)) {
> +	mapsize = memmap.map_end - memmap.map;
> +	early_memunmap(memmap.map, mapsize);
> +
> +	if (!efi_enabled(EFI_BOOT) || efi_runtime_disabled()) {

Hmm, is this right? We only set EFI_BOOT if we find EFI parameters in the
DT (see efi_init -> uefi_init), so you run the risk of unmapping something
we never mapped here.

Furthermore, there seems to be a leak in uefi_init anyway, as we return
-EINVAL if the signature of the EFI table doesn't match without unmapping it
first.

Will
