Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab3FMQCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:02:06 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:33055 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab3FMQCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:02:04 -0400
Subject: Re: [PATCH] x86, efi: retry ExitBootServices() on failure
From: joeyli <jlee@suse.com>
To: Zach Bobroff <zacharyb@ami.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg59@srcf.ucam.org>, Zach Bobroff <zacharyb@ami.com>,
        stable@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Jan Beulich <JBeulich@suse.com>
In-Reply-To: <1370933558-10128-1-git-send-email-matt@console-pimps.org>
References: <1370933558-10128-1-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Jun 2013 00:00:33 +0800
Message-ID: <1371139233.6523.272.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zach, 

於 二，2013-06-11 於 07:52 +0100，Matt Fleming 提到：
> From: Zach Bobroff <zacharyb@ami.com>
> 
> ExitBootServices is absolutely supposed to return a failure if any
> ExitBootServices event handler changes the memory map.  Basically the
> get_map loop should run again if ExitBootServices returns an error the
> first time.  I would say it would be fair that if ExitBootServices gives
> an error the second time then Linux would be fine in returning control
> back to BIOS.
> 
> The second change is the following line:
> 
> again:
>         size += sizeof(*mem_map) * 2;
> 
> Originally you were incrementing it by the size of one memory map entry.
> The issue here is all related to the low_alloc routine you are using.
> In this routine you are making allocations to get the memory map itself.
> Doing this allocation or allocations can affect the memory map by more
> than one record.
> 
> [ mfleming - changelog, code style ]
> Signed-off-by: Zach Bobroff <zacharyb@ami.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/x86/boot/compressed/eboot.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index 35ee62f..7c6e5d9 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -1037,18 +1037,20 @@ static efi_status_t exit_boot(struct boot_params *boot_params,
>  	efi_memory_desc_t *mem_map;
>  	efi_status_t status;
>  	__u32 desc_version;
> +	bool called_exit = false;
>  	u8 nr_entries;
>  	int i;
>  
>  	size = sizeof(*mem_map) * 32;
>  
>  again:
> -	size += sizeof(*mem_map);
> +	size += sizeof(*mem_map) * 2;
>  	_size = size;
>  	status = low_alloc(size, 1, (unsigned long *)&mem_map);

Can we know why increased the size of double *mem_map is big enough?
Does there have any real guarantee to be sufficient?

And, why would doubling the increment be necessary here, but not in
__get_map()?

>  	if (status != EFI_SUCCESS)
>  		return status;
>  
> +get_map:

The get_map label is being placed such that the size doesn't
get adjusted anymore, yet it is supposed to deal with an allocation
having happened during ExitBootServices(), which could have
grown the map.

Why doesn't direct goto 'again' label?

>  	status = efi_call_phys5(sys_table->boottime->get_memory_map, &size,
>  				mem_map, &key, &desc_size, &desc_version);
>  	if (status == EFI_BUFFER_TOO_SMALL) {
> @@ -1074,8 +1076,20 @@ again:
>  	/* Might as well exit boot services now */
>  	status = efi_call_phys2(sys_table->boottime->exit_boot_services,
>  				handle, key);
> -	if (status != EFI_SUCCESS)
> -		goto free_mem_map;
> +	if (status != EFI_SUCCESS) {
> +		/*
> +		 * ExitBootServices() will fail if any of the event
> +		 * handlers change the memory map. In which case, we
> +		 * must be prepared to retry, but only once so that
> +		 * we're guaranteed to exit on repeated failures instead
> +		 * of spinning forever.
> +		 */
> +		if (called_exit)
> +			goto free_mem_map;
> +
> +		called_exit = true;

Why a single retry is having reasonable guarantees to work when the
original one failed (nothing prevents an event handler to do another
allocation the next time through).

Why not retry 3, 4, 5 or even unlimited times?

> +		goto get_map;
> +	}
>  
>  	/* Historic? */
>  	boot_params->alt_mem_k = 32 * 1024;


Thanks a lot!
Joey Lee

