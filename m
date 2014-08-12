Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbaHLGw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:52:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:37985 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaHLGwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 02:52:47 -0400
Message-ID: <53E9B9B3.1050504@infradead.org>
Date: Mon, 11 Aug 2014 23:52:35 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dave Young <dyoung@redhat.com>, Matt Fleming <matt.fleming@intel.com>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, Alessandro Zummo <a.zummo@towertech.it>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Mark Salter <msalter@redhat.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH 1/5] efi: move noefi early param code out of x86 arch
 code
References: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
In-Reply-To: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/14 23:10, Dave Young wrote:
> noefi param can be used for arches other than X86 later, thus move it out of
> x86 platform code.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/x86/platform/efi/efi.c | 10 +---------
>  drivers/firmware/efi/efi.c  | 13 +++++++++++++
>  include/linux/efi.h         |  1 +
>  3 files changed, 15 insertions(+), 9 deletions(-)

This line in Documentation/kernel-parameters.txt needs to be updated:

	noefi		[X86] Disable EFI runtime services support.


> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 850da94..dd7aaa1 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -70,14 +70,6 @@ static efi_config_table_type_t arch_tables[] __initdata = {
>  
>  u64 efi_setup;		/* efi setup_data physical address */
>  
> -static bool disable_runtime __initdata = false;
> -static int __init setup_noefi(char *arg)
> -{
> -	disable_runtime = true;
> -	return 0;
> -}
> -early_param("noefi", setup_noefi);
> -
>  int add_efi_memmap;
>  EXPORT_SYMBOL(add_efi_memmap);
>  
> @@ -492,7 +484,7 @@ void __init efi_init(void)
>  	if (!efi_runtime_supported())
>  		pr_info("No EFI runtime due to 32/64-bit mismatch with kernel\n");
>  	else {
> -		if (disable_runtime || efi_runtime_init())
> +		if (efi_runtime_disabled() || efi_runtime_init())
>  			return;
>  	}
>  	if (efi_memmap_init())
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 64ecbb5..c8f01a7 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -41,6 +41,19 @@ struct efi __read_mostly efi = {
>  };
>  EXPORT_SYMBOL(efi);
>  
> +static bool disable_runtime;
> +static int __init setup_noefi(char *arg)
> +{
> +	disable_runtime = true;
> +	return 0;
> +}
> +early_param("noefi", setup_noefi);
> +
> +bool efi_runtime_disabled(void)
> +{
> +	return disable_runtime;
> +}
> +
>  static struct kobject *efi_kobj;
>  static struct kobject *efivars_kobj;
>  
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 45cb4ff..06d7c03 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1227,4 +1227,5 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
>  				  unsigned long *load_addr,
>  				  unsigned long *load_size);
>  
> +bool efi_runtime_disabled(void);
>  #endif /* _LINUX_EFI_H */
> 


-- 
~Randy
