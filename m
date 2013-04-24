Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab3DXOog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:44:36 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39633 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131Ab3DXOod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:44:33 -0400
Message-ID: <5177EFCE.80104@intel.com>
Date: Wed, 24 Apr 2013 15:44:30 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Josh Boyer <jwboyer@redhat.com>
CC: Matthew Garrett <matthew.garrett@nebula.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efi: Check EFI revision in setup_efi_vars
References: <20130424143738.GB15272@hansolo.jdub.homelinux.org>
In-Reply-To: <20130424143738.GB15272@hansolo.jdub.homelinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/04/13 15:37, Josh Boyer wrote:
> We need to check the runtime sys_table for the EFI version the firmware
> specifies instead of just checking for a NULL QueryVariableInfo.  Older
> implementations of EFI don't have QueryVariableInfo but the runtime is
> a smaller structure, so the pointer to it may be pointing off into garbage.
> 
> This is apparently the case with several Apple firmwares that support EFI
> 1.10, and the current check causes them to no longer boot.  Fix based on
> a suggestion from Matthew Garrett.
> 
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> ---
>  arch/x86/boot/compressed/eboot.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index 8615f75..b46efbf 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -258,7 +258,9 @@ static efi_status_t setup_efi_vars(struct boot_params *params)
>  	u64 store_size, remaining_size, var_size;
>  	efi_status_t status;
>  
> -	if (!sys_table->runtime->query_variable_info)
> +	if (sys_table->runtime->hdr.revision < EFI_2_00_SYSTEM_TABLE_REVISION)
> +		return EFI_UNSUPPORTED;
> +	else if(!sys_table->runtime->query_variable_info)
>  		return EFI_UNSUPPORTED;
>  
>  	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
> 

Thanks Josh, that looks correct.

It's a small point, but does the check against NULL actually make sense?
I don't think we ever check other system table pointers against NULL.
