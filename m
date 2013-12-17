Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab3LQIJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 03:09:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab3LQIJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 03:09:21 -0500
Date: Tue, 17 Dec 2013 16:08:42 +0800
From: Dave Young <dyoung@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com, akpm@linux-foundation.org,
        mingo@kernel.org, msalter@redhat.com, leif.lindholm@linaro.org
Subject: Re: [PATCH v7 09/14] efi: passing kexec necessary efi data via
 setup_data
Message-ID: <20131217080842.GA13339@dhcp-16-126.nay.redhat.com>
References: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
 <1387186235-15972-10-git-send-email-dyoung@redhat.com>
 <20131217080140.GB12621@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217080140.GB12621@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Boris

Does this version looks good to you? Only mapping once in print_efi_memmap..

BTW, forgot to remove 'Re:' in subject.

Please let me know if there's any other issues or need I resend the series.

Most changes vs previous version are below:

> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index b1fff8e..5438083 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -78,6 +78,8 @@ static __initdata efi_config_table_type_t arch_tables[] = {
>  
>  static void *efi_runtime_map;
>  static int nr_efi_runtime_map;
> +u64 efi_setup;		/* efi setup_data physical address */
> +u32 efi_data_len;	/* efi setup_data payload length */
>  

[snip]

> +
> +static void get_nr_runtime_map(void)
> +{
> +	if (!efi_setup)
> +		return;
> +
> +	nr_efi_runtime_map = (efi_data_len - sizeof(struct efi_setup_data)) /
> +			     sizeof(efi_memory_desc_t);
> +}
> +
>  void __init efi_init(void)
>  {
>  	efi_char16_t *c16;
> @@ -638,6 +719,7 @@ void __init efi_init(void)
>  	int i = 0;
>  	void *tmp;
>  
> +	get_nr_runtime_map();
>  #ifdef CONFIG_X86_32
>  	if (boot_params.efi_info.efi_systab_hi ||
>  	    boot_params.efi_info.efi_memmap_hi) {
> @@ -676,6 +758,9 @@ void __init efi_init(void)
>  
		efi.systab->hdr.revision >> 16,
[snip]

>  
>  	/*
> diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
> index 7b3ec6e..249b183 100644
> --- a/arch/x86/platform/efi/efi_32.c
> +++ b/arch/x86/platform/efi/efi_32.c
> @@ -48,6 +48,7 @@ void __init efi_map_region(efi_memory_desc_t *md)
>  }
>  
>  void __init efi_map_region_fixed(efi_memory_desc_t *md) {}
> +void __init parse_efi_setup(u64 phys_addr, u32 data_len) {}
>  
>  void efi_call_phys_prelog(void)
>  {
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index ff08cb1..324b651 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -228,3 +228,9 @@ void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
>  
>  	return (void __iomem *)__va(phys_addr);
>  }
> +
> +void __init parse_efi_setup(u64 phys_addr, u32 data_len)
> +{
> +	efi_setup = phys_addr + sizeof(struct setup_data);
> +	efi_data_len = data_len - sizeof(struct setup_data);
> +}
> -- 
> 1.8.3.1
> 
