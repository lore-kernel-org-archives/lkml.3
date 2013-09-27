Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3I0XqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 19:46:13 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:35373 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab3I0XqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 19:46:10 -0400
Date: Fri, 27 Sep 2013 17:46:07 -0600
From: Linn Crosetto <linn@hp.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: matt.fleming@intel.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, yinghai@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] x86: EFI stub support for large memory maps
Message-ID: <20130927234607.GA17867@oranje.fc.hp.com>
References: <1378487056-9857-1-git-send-email-linn@hp.com>
 <1379901548-70954-1-git-send-email-linn@hp.com>
 <20130925125840.GK21381@console-pimps.org>
 <20130925224541.GT13098@oranje.fc.hp.com>
 <20130926113400.GM21381@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926113400.GM21381@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 12:34:00PM +0100, Matt Fleming wrote:
> > I might add the following to your merge for semantic reasons:
> > 
> > diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> > index 04b228d..a7677ba 100644
> > --- a/arch/x86/boot/compressed/eboot.c
> > +++ b/arch/x86/boot/compressed/eboot.c
> > @@ -730,6 +730,8 @@ get_map:
> >         boot_params->alt_mem_k = 32 * 1024;
> >  
> >         status = setup_e820(boot_params, e820ext, e820ext_size);
> > +       if (status != EFI_SUCCESS)
> > +               return status;
> >  
> >         return EFI_SUCCESS;
> 
> Aha, nice catch! Though if setup_e820() fails we should be jumping to
> the 'free_mem_map' label so we don't leak the memory map, like so,
> 
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index 04b228d..602950b 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -730,8 +730,8 @@ get_map:
>  	boot_params->alt_mem_k = 32 * 1024;
>  
>  	status = setup_e820(boot_params, e820ext, e820ext_size);
> -
> -	return EFI_SUCCESS;
> +	if (status == EFI_SUCCESS)
> +		return status;
>  
>  free_mem_map:
>  	efi_call_phys1(sys_table->boottime->free_pool, mem_map);

Given that we have already successfully called exit_boot_services, can we still
make this call to free_pool?
