Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaHMO1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:27:53 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:64632 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaHMO1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:27:52 -0400
Date: Wed, 13 Aug 2014 15:27:48 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, Alessandro Zummo <a.zummo@towertech.it>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Mark Salter <msalter@redhat.com>, Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, rtc-linux@googlegroups.com
Subject: Re: [PATCH 4/5] efi x86: clear EFI_RUNTIME_SERVICES bit in case
 failures other than SetVirtualAddressMap
Message-ID: <20140813142748.GS15082@console-pimps.org>
References: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
 <1407823822-23829-4-git-send-email-dyoung@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407823822-23829-4-git-send-email-dyoung@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug, at 02:10:21PM, Dave Young wrote:
> If enter virtual mode failed due to some reason other than the efi call
> the EFI_RUNTIME_SERVICES bit in efi.flags should be cleared thus users
> of efi runtime services can check the bit and handle the case instead of
> assume efi runtime is ok.
> 
> Per Matt, if efi call SetVirtualAddressMap fails we will be not sure it's safe
> to make any assumptions about the state of the system. so kernel panics instead
> of clears EFI_RUNTIME_SERVICES bit.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/x86/platform/efi/efi.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

[...]

> @@ -882,8 +886,10 @@ static void __init __efi_enter_virtual_mode(void)
>  
>  void __init efi_enter_virtual_mode(void)
>  {
> -	if (efi_enabled(EFI_PARAVIRT))
> +	if (efi_enabled(EFI_PARAVIRT)) {
> +		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
>  		return;
> +	}

The EFI_PARAVIRT folks purposely do not set this bit, so there should be
no reason to clear it here.

-- 
Matt Fleming, Intel Open Source Technology Center
