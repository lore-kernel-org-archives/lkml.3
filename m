Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417Ab3E1INP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:13:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55603 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933328Ab3E1INM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:13:12 -0400
Date: Tue, 28 May 2013 10:13:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 3/3] x86/microcode: early microcode patch loading
 support on AMD
Message-ID: <20130528081309.GA29233@pd.tnic>
References: <1369323618-5820-1-git-send-email-jacob.shin@amd.com>
 <1369323618-5820-4-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1369323618-5820-4-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 10:40:18AM -0500, Jacob Shin wrote:
> Add support for early microcode patch loading on AMD.
> 
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> ---
>  arch/x86/Kconfig                       |   16 +-
>  arch/x86/include/asm/microcode.h       |    1 -
>  arch/x86/include/asm/microcode_amd.h   |   17 ++
>  arch/x86/include/asm/microcode_intel.h |    1 +
>  arch/x86/kernel/microcode_amd.c        |  338 ++++++++++++++++++++++++++++----
>  arch/x86/kernel/microcode_core_early.c |    7 +
>  6 files changed, 333 insertions(+), 47 deletions(-)
>  create mode 100644 arch/x86/include/asm/microcode_amd.h
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 3a5bced..fab72e7 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1090,8 +1090,18 @@ config MICROCODE_INTEL_LIB
>  	depends on MICROCODE_INTEL
>  
>  config MICROCODE_INTEL_EARLY
> -	bool "Early load microcode"
> +	def_bool n
>  	depends on MICROCODE_INTEL && BLK_DEV_INITRD
> +
> +config MICROCODE_AMD_EARLY
> +	def_bool n
> +	depends on MICROCODE_AMD && BLK_DEV_INITRD
> +
> +config MICROCODE_EARLY
> +	bool "Early load microcode"
> +	depends on (MICROCODE_INTEL || MICROCODE_AMD) && BLK_DEV_INITRD
> +	select MICROCODE_INTEL_EARLY if MICROCODE_INTEL
> +	select MICROCODE_AMD_EARLY if MICROCODE_AMD
>  	default y
>  	help
>  	  This option provides functionality to read additional microcode data

This whole microcode Kconfig game seems kinda too granulary to me.
I mean, distros will enable all of them anyway (both AMD and Intel
microcode loading) and since we can safely enable early loading even if
there's no microcode in the initrd, we can add in the early code too.

So how about simplifying this a lot by having only:

config MICROCODE
        tristate "CPU microcode loading support"
        select FW_LOADER

config MICROCODE_EARLY
	depends on BLK_DEV_INITRD && MICROCODE

and drop all this vendor differentiation. Microcode core code checks
vendors so it won't be loaded on anything unsupported, etc.

hpa, Ingo, what do you guys think?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
