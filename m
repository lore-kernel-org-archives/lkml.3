Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194Ab3GSKFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 06:05:41 -0400
Received: from 19.mo1.mail-out.ovh.net ([178.32.97.206]:40546 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752088Ab3GSKFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 06:05:40 -0400
Date: Fri, 19 Jul 2013 11:56:28 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Robin Holt <holt@sgi.com>,
        Pawel Moll <pawel.moll@arm.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH] arm64: use common reboot infrastructure
Message-ID: <20130719095628.GG16015@ns203013.ovh.net>
References: <1373541180-7452-1-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373541180-7452-1-git-send-email-marc.zyngier@arm.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 991354868903816039
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:13 Thu 11 Jul     , Marc Zyngier wrote:
> Commit 7b6d864b48d9 (reboot: arm: change reboot_mode to use enum
> reboot_mode) changed the way reboot is handled on arm, which has a
> direct impact on arm64 as we share the reset driver on the VE platform.
> 
> The obvious fix is to move arm64 to use the same infrastructure.
> 
> Cc: Robin Holt <holt@sgi.com>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/system_misc.h | 3 ++-
>  arch/arm64/kernel/process.c          | 2 +-
>  kernel/reboot.c                      | 2 +-
>  3 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/system_misc.h b/arch/arm64/include/asm/system_misc.h
> index a6e1750..7a18fab 100644
> --- a/arch/arm64/include/asm/system_misc.h
> +++ b/arch/arm64/include/asm/system_misc.h
> @@ -23,6 +23,7 @@
>  #include <linux/compiler.h>
>  #include <linux/linkage.h>
>  #include <linux/irqflags.h>
> +#include <linux/reboot.h>
>  
>  struct pt_regs;
>  
> @@ -41,7 +42,7 @@ extern void show_pte(struct mm_struct *mm, unsigned long addr);
>  extern void __show_regs(struct pt_regs *);
>  
>  void soft_restart(unsigned long);
> -extern void (*arm_pm_restart)(char str, const char *cmd);
> +extern void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
>  
>  #define UDBG_UNDEFINED	(1 << 0)
>  #define UDBG_SYSCALL	(1 << 1)
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index 46f02c3..1788bf6 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -132,7 +132,7 @@ void machine_restart(char *cmd)
>  
>  	/* Now call the architecture specific reboot code. */
>  	if (arm_pm_restart)
> -		arm_pm_restart('h', cmd);
> +		arm_pm_restart(reboot_mode, cmd);
>  
>  	/*
>  	 * Whoops - the architecture was unable to reboot.
> diff --git a/kernel/reboot.c b/kernel/reboot.c
> index 269ed93..9aaeb58 100644
> --- a/kernel/reboot.c
> +++ b/kernel/reboot.c
> @@ -25,7 +25,7 @@ int C_A_D = 1;
>  struct pid *cad_pid;
>  EXPORT_SYMBOL(cad_pid);
>  
> -#if defined(CONFIG_ARM) || defined(CONFIG_UNICORE32)
> +#if defined(CONFIG_ARM) || defined(CONFIG_ARM64) || defined(CONFIG_UNICORE32)
how aboud have a specific Kconfig for this instead of a list of defined(xx)

Best Regards,
J.
>  #define DEFAULT_REBOOT_MODE		= REBOOT_HARD
>  #else
>  #define DEFAULT_REBOOT_MODE
> -- 
> 1.8.1.5
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
