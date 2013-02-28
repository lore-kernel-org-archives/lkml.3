Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760436Ab3B1VFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 16:05:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41475 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab3B1VFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 16:05:42 -0500
Message-ID: <512FC697.3090608@zytor.com>
Date: Thu, 28 Feb 2013 13:05:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: hpa@sgi.com, Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Revert commit 5dcd14ecd4 - breaks EFI boot with SLES11 elilo.efi
References: <20130228205206.GC3438@sgi.com>
In-Reply-To: <20130228205206.GC3438@sgi.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 12:52 PM, Robin Holt wrote:
> If I revert that commit (5dcd14ecd4), It completes boot fine.  With that
> commit applied, by ACPI tables (as well as much else) seems to be
> completely messed up.  The ACPI XSDT table is removed, all the SRAT
> is gone.  Much of the remaining ACPI table is messed up.  Some of the
> EFI memory map is whacked.
> 
> If I change the following, things work:
> diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
> index 5b5e9cb..85337ab 100644
> --- a/arch/x86/include/asm/bootparam_utils.h
> +++ b/arch/x86/include/asm/bootparam_utils.h
> @@ -19,9 +19,11 @@ static void sanitize_boot_params(struct boot_params *boot_params)
>  {
>         if (boot_params->sentinel) {
>                 /*fields in boot_params are not valid, clear them */
> +#if 0
>                 memset(&boot_params->olpc_ofw_header, 0,
>                        (char *)&boot_params->alt_mem_k -
>                         (char *)&boot_params->olpc_ofw_header);
> +#endif
>                 memset(&boot_params->kbd_status, 0,
>                        (char *)&boot_params->hdr -
>                        (char *)&boot_params->kbd_status);
> 

Sounds like ELILO needs to be fixed to pass the boot_params correctly.

To support existing ELILO, it would be good to know exactly *which*
fields ELILO pass in as garbage (because it does, that is why ->sentinel
is nonzero) and use its bootloader ID to apply the proper brainwhack for
the legacy versions.

	-hpa

