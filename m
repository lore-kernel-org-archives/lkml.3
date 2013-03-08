Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237Ab3CHF5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 00:57:35 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:52672 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab3CHF5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 00:57:34 -0500
Date: Thu, 7 Mar 2013 21:57:29 -0800
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 05/14] x86, ACPI: Find acpi tables in initrd early at
 head_32.S/head64.c
Message-ID: <20130308055729.GG14556@mtj.dyndns.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
 <1362718720-27048-6-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362718720-27048-6-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 08:58:31PM -0800, Yinghai Lu wrote:
> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> index 73afd11..ca08f0e 100644
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -149,6 +149,10 @@ ENTRY(startup_32)
>  	call load_ucode_bsp
>  #endif
>  
> +#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
> +	call x86_acpi_override_find
> +#endif

The function is always defined.  We can probalby lose ifdef here?

Also, does it really have to be called from head_32.S?  No way this
can be done after entering C code?  It would be great if you can
explain overall design choices in the head message (and important
patches).

> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 668e658..d43545a 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -424,6 +424,32 @@ static void __init reserve_initrd(void)
>  }
>  #endif /* CONFIG_BLK_DEV_INITRD */
>  
> +#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
> +void __init x86_acpi_override_find(void)
> +{
> +	unsigned long ramdisk_image, ramdisk_size;
> +	unsigned char *p = NULL;
> +
> +#ifdef CONFIG_X86_32
> +	struct boot_params *boot_params_p;
> +
> +	boot_params_p = (struct boot_params *)__pa_symbol(&boot_params);
> +	ramdisk_image = boot_params_p->hdr.ramdisk_image;
> +	ramdisk_size  = boot_params_p->hdr.ramdisk_size;
> +	p = (unsigned char *)ramdisk_image;
> +	acpi_initrd_override_find(p, ramdisk_size, true);
> +#else
> +	ramdisk_image = get_ramdisk_image();
> +	ramdisk_size  = get_ramdisk_size();
> +	if (ramdisk_image)
> +		p = __va(ramdisk_image);
> +	acpi_initrd_override_find(p, ramdisk_size, false);
> +#endif
> +}
> +#else
> +void __init x86_acpi_override_find(void) { }

And add a comment here why we're not doing static inline for the dummy
function?

Thanks.

-- 
tejun
