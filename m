Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaJPUD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:03:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:13002 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbaJPUDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:03:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,734,1406617200"; 
   d="scan'208";a="615720764"
Date: Thu, 16 Oct 2014 22:03:38 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/x86/realmode: make trampoline code conditional for
 x86-32
Message-ID: <20141016200338.GA4337@intel.com>
References: <1413450350-20672-1-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413450350-20672-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 11:05:50AM +0200, Jarkko Sakkinen wrote:
> Trampoline code is only needed for SMP and in x86-64 for wakeup
> code. Make it conditional in order to minimize the kernel size.
> Added a new hidden config option CONFIG_X86_TRAMPOLINE as
> suggested by H. Peter Anvin.
> 
> The justification for this patch is tinyfication effort run by
> Josh Triplett. In embedded world a 32-bit processor without SMP
> is not uncommon phenomenon.
> 
> I think the trampoline code could be completely ripped off if
> ACPI_SLEEP and INTEL_TXT are not enabled but did not want to
> include that yet into this patch.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/Kconfig              |  4 ++++
>  arch/x86/realmode/rm/Makefile | 10 +++++-----
>  2 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index f2327e8..9603ca3 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2488,6 +2488,10 @@ config PMC_ATOM
>  	def_bool y
>          depends on PCI
>  
> +config X86_TRAMPOLINE
> +	def_bool y
> +	depends on X86_64 || SMP

I think this could be just as well

  depends on (X86_64 && (INTEL_TXT || ACPI_SLEEP)) || SMP

Should I send an updated patch?

> +
>  source "net/Kconfig"
>  
>  source "drivers/Kconfig"
> diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
> index 7c0d7be..299e450 100644
> --- a/arch/x86/realmode/rm/Makefile
> +++ b/arch/x86/realmode/rm/Makefile
> @@ -19,11 +19,11 @@ wakeup-objs	+= video-vga.o
>  wakeup-objs	+= video-vesa.o
>  wakeup-objs	+= video-bios.o
>  
> -realmode-y			+= header.o
> -realmode-y			+= trampoline_$(BITS).o
> -realmode-y			+= stack.o
> -realmode-y			+= reboot.o
> -realmode-$(CONFIG_ACPI_SLEEP)	+= $(wakeup-objs)
> +realmode-y				+= header.o
> +realmode-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
> +realmode-y				+= stack.o
> +realmode-y				+= reboot.o
> +realmode-$(CONFIG_ACPI_SLEEP)		+= $(wakeup-objs)
>  
>  targets	+= $(realmode-y)
>  
> -- 
> 2.1.0
> 

/Jarkko
