Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaHMIOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:14:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbaHMIOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:14:46 -0400
Date: Wed, 13 Aug 2014 16:13:47 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, Alessandro Zummo <a.zummo@towertech.it>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Mark Salter <msalter@redhat.com>, Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, rtc-linux@googlegroups.com
Subject: Re: [PATCH 2/5] efi: add kernel param efi=noruntime
Message-ID: <20140813081347.GA3977@darkstar.nay.redhat.com>
References: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
 <1407823822-23829-2-git-send-email-dyoung@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407823822-23829-2-git-send-email-dyoung@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/14 at 02:10pm, Dave Young wrote:
> noefi kernel param means actually disabling efi runtime, Per suggestion from
> Leif Lindholm efi=noruntime should be better. But since noefi is already used
> in X86 thus just adding another param efi=noruntime for same purpose.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  Documentation/kernel-parameters.txt |  4 +++-
>  arch/x86/platform/efi/efi.c         | 12 ------------
>  drivers/firmware/efi/efi.c          | 22 ++++++++++++++++++++++
>  3 files changed, 25 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index a8eb6af..09d8c54 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -992,11 +992,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			Format: {"off" | "on" | "skip[mbr]"}
>  
>  	efi=		[EFI]
> -			Format: { "old_map" }
> +			Format: { "old_map" | "noruntime" }
>  			old_map [X86-64]: switch to the old ioremap-based EFI
>  			runtime services mapping. 32-bit still uses this one by
>  			default.
>  
> +			noruntime : disable EFI runtime services support
> +
>  	efi_no_storage_paranoia [EFI; X86]
>  			Using this parameter you can use more than 50% of
>  			your efi variable storage. Use this parameter only if
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index dd7aaa1..eae91be 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -929,15 +929,3 @@ u64 efi_mem_attributes(unsigned long phys_addr)
>  	}
>  	return 0;
>  }
> -
> -static int __init parse_efi_cmdline(char *str)
> -{
> -	if (*str == '=')
> -		str++;
> -
> -	if (!strncmp(str, "old_map", 7))
> -		set_bit(EFI_OLD_MEMMAP, &efi.flags);
> -
> -	return 0;
> -}
> -early_param("efi", parse_efi_cmdline);
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index c8f01a7..f3ec3f2 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -24,6 +24,7 @@
>  #include <linux/of_fdt.h>
>  #include <linux/io.h>
>  #include <linux/platform_device.h>
> +#include <asm/efi.h>
>  
>  struct efi __read_mostly efi = {
>  	.mps        = EFI_INVALID_TABLE_ADDR,
> @@ -54,6 +55,27 @@ bool efi_runtime_disabled(void)
>  	return disable_runtime;
>  }
>  
> +static int __init parse_efi_cmdline(char *str)
> +{
> +	if (*str == '=')
> +		str++;
> +
> +#ifdef CONFIG_X86
> +	if (!strncmp(str, "old_map", 7)) {
> +		set_bit(EFI_OLD_MEMMAP, &efi.flags);
> +		goto out;
> +	}
> +#endif
> +	if (!strncmp(str, "noruntime", 9)) {
> +		disable_runtime = true;
> +		goto out;
> +	}
> +

For sharing functions I moved old_map here, but rethinking about it maybe
it's better to keep it in arch code.

Matt, I see you have some code for libstub option parsing, I will rebase
on your efi/next and I'm thinking to add a generic function for parsing
params like below (for old_map, but libstub can not use it):

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index c90d3cd..c73a7df5 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -932,26 +932,8 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 
 static int __init parse_efi_cmdline(char *str)
 {
-	if (*str == '=')
-		str++;
-
-	while (*str) {
-		if (!strncmp(str, "old_map", 7)) {
-			set_bit(EFI_OLD_MEMMAP, &efi.flags);
-			str += strlen("old_map");
-		}
-
-		/*
-		 * Skip any options we don't understand. Presumably
-		 * they apply to the EFI boot stub.
-		 */
-		while (*str && *str != ',')
-			str++;
-
-		/* If we hit a delimiter, skip it */
-		if (*str == ',')
-			str++;
-	}
+	if (parse_option_str(str, "old_map"))
+		set_bit(EFI_OLD_MEMMAP, &efi.flags);
 
 	return 0;
 }
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4c52907..d612718 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -407,6 +407,7 @@ int vsscanf(const char *, const char *, va_list);
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
+extern bool parse_option_str(const char *str, const char *option);
 
 extern int core_kernel_text(unsigned long addr);
 extern int core_kernel_data(unsigned long addr);
diff --git a/lib/cmdline.c b/lib/cmdline.c
index d4932f7..f384125 100644
--- a/lib/cmdline.c
+++ b/lib/cmdline.c
@@ -155,3 +155,32 @@ unsigned long long memparse(const char *ptr, char **retptr)
 	return ret;
 }
 EXPORT_SYMBOL(memparse);
+
+/**
+ *	parse_option_str - Parse a string and check an option is set or not 
+ *	@str: String to be parsed
+ *	@option: the option name
+ *
+ *	This function parses a string containing a comma-separated
+ *	list of strings like a=b,c.
+ *
+ *	Return true if there's such option in the string, or return false.
+ */
++bool parse_option_str(const char *str, const char *option)
+{
+	while (*str) {
+		if (!strncmp(str, option, strlen(option))) {
+			str += strlen(option);
+			if (!*str || *str == ',')
+				return true;
+		}
+
+		while (*str && *str != ',')
+			str++;
+
+		if (*str == ',')
+			str++;
+	}
+
+	return false;
+}
