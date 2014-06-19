Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664AbaFSO1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 10:27:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59169 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756754AbaFSO1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 10:27:41 -0400
Date: Thu, 19 Jun 2014 16:27:35 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com,
        m.chehab@samsung.com, bp@suse.de, linux-edac@vger.kernel.org,
        x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        rric@kernel.org
Subject: Re: [PATCH v3 2/5] acpi, apei, ghes: Introduce
 ARCH_HAS_ACPI_APEI_NMI to make NMI error notification a GHES feature.
Message-ID: <20140619142734.GE22025@pd.tnic>
References: <1402657380-18539-1-git-send-email-tomasz.nowicki@linaro.org>
 <1402657380-18539-3-git-send-email-tomasz.nowicki@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1402657380-18539-3-git-send-email-tomasz.nowicki@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 01:02:57PM +0200, Tomasz Nowicki wrote:
> Currently APEI depends on x86 architecture. It is because of NMI hardware
> error notification of GHES which is currently supported by x86 only.
> However, many other APEI features can be still used perfectly by other
> architectures.
> 
> This commit adds ARCH_HAS_ACPI_APEI_NMI which will be used in next patches
> for NMI related code isolation in ghes.c file. Only NMI error notification
> feature depends on x86 so let it be hard selected for x86 arch.
> 
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> ---
>  arch/x86/Kconfig          |    1 +
>  drivers/acpi/apei/Kconfig |    8 +++++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 3fc9b12..e1dc819 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -24,6 +24,7 @@ config X86
>  	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
>  	select ARCH_MIGHT_HAVE_PC_PARPORT
>  	select ARCH_MIGHT_HAVE_PC_SERIO
> +	select ARCH_HAS_ACPI_APEI_NMI
>  	select HAVE_AOUT if X86_32
>  	select HAVE_UNSTABLE_SCHED_CLOCK
>  	select ARCH_SUPPORTS_NUMA_BALANCING if X86_64
> diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
> index c4dac71..9f6c3ec 100644
> --- a/drivers/acpi/apei/Kconfig
> +++ b/drivers/acpi/apei/Kconfig
> @@ -3,7 +3,6 @@ config ACPI_APEI
>  	select MISC_FILESYSTEMS
>  	select PSTORE
>  	select UEFI_CPER
> -	depends on X86

Now this can practically be enabled on any architecture, AFAICT. Which
is wrong.

I think a better solution would be to have another HAVE_ symbol which
each arch which sports APEI selects. Like in the diff below ontop of
this patch, also incorporating Robert's comments.

You'll have to do select HAVE_ACPI_APEI on arm too.

Hmm?

--
Index: b/arch/x86/Kconfig
===================================================================
--- a/arch/x86/Kconfig	2014-06-19 16:25:48.118452980 +0200
+++ b/arch/x86/Kconfig	2014-06-19 16:24:57.270453451 +0200
@@ -24,7 +24,6 @@ config X86
 	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
-	select ARCH_HAS_ACPI_APEI_NMI
 	select HAVE_AOUT if X86_32
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select ARCH_SUPPORTS_NUMA_BALANCING if X86_64
@@ -132,6 +131,8 @@ config X86
 	select HAVE_CC_STACKPROTECTOR
 	select GENERIC_CPU_AUTOPROBE
 	select HAVE_ARCH_AUDITSYSCALL
+	select HAVE_ACPI_APEI
+	select HAVE_ACPI_APEI_NMI
 
 config INSTRUCTION_DECODER
 	def_bool y
Index: b/drivers/acpi/apei/Kconfig
===================================================================
--- a/drivers/acpi/apei/Kconfig	2014-06-19 16:25:48.118452980 +0200
+++ b/drivers/acpi/apei/Kconfig	2014-06-19 16:24:32.710453679 +0200
@@ -1,8 +1,15 @@
+config HAVE_ACPI_APEI
+	bool
+
+config HAVE_ACPI_APEI_NMI
+	bool
+
 config ACPI_APEI
 	bool "ACPI Platform Error Interface (APEI)"
 	select MISC_FILESYSTEMS
 	select PSTORE
 	select UEFI_CPER
+	depends on HAVE_ACPI_APEI
 	help
 	  APEI allows to report errors (for example from the chipset)
 	  to the operating system. This improves NMI handling
@@ -25,12 +32,6 @@ config ACPI_APEI_GHES
 	  by firmware to produce more valuable hardware error
 	  information for Linux.
 
-config ARCH_HAS_ACPI_APEI_NMI
-	bool
-	help
-	  Firmware first mode can use NMI notification mechanism to report errors
-	  to operating system. This feature is currently supported by X86
-	  architecture only.
 
 config ACPI_APEI_PCIEAER
 	bool "APEI PCIe AER logging/recovering support"


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
