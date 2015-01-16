Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbbAPLKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:10:23 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55114 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbbAPLKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:10:22 -0500
Date: Fri, 16 Jan 2015 12:10:19 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 04/23] x86/ioapic: Check x2apic really
Message-ID: <20150116111019.GD18880@pd.tnic>
References: <20150115210458.625399149@linutronix.de>
 <20150115211702.541280622@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150115211702.541280622@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 09:22:14PM -0000, Thomas Gleixner wrote:
> The x2apic_preenabled flag is just a horrible hack and if X2APIC
> support is disabled it does not reflect the actual hardware
> state. Check the hardware instead.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/include/asm/apic.h    |    2 --
>  arch/x86/kernel/apic/apic.c    |    4 +++-
>  arch/x86/kernel/apic/io_apic.c |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> Index: tip/arch/x86/include/asm/apic.h
> ===================================================================
> --- tip.orig/arch/x86/include/asm/apic.h
> +++ tip/arch/x86/include/asm/apic.h
> @@ -177,7 +177,6 @@ static inline u64 native_x2apic_icr_read
>  
>  extern int x2apic_mode;
>  extern int x2apic_phys;
> -extern int x2apic_preenabled;
>  extern void check_x2apic(void);
>  extern void enable_x2apic(void);
>  static inline int x2apic_enabled(void)
> @@ -209,7 +208,6 @@ static inline void x2apic_force_phys(voi
>  }
>  
>  #define x2apic_mode		(0)
> -#define	x2apic_preenabled	(0)
>  #define	x2apic_supported()	(0)
>  #endif
>  
> Index: tip/arch/x86/kernel/apic/apic.c
> ===================================================================
> --- tip.orig/arch/x86/kernel/apic/apic.c
> +++ tip/arch/x86/kernel/apic/apic.c
> @@ -1480,7 +1480,7 @@ static bool nox2apic __initdata;
>  #ifdef CONFIG_X86_X2APIC
>  int x2apic_mode;
>  /* x2apic enabled before OS handover */
> -int x2apic_preenabled;
> +static int x2apic_preenabled;

Bah, let's get rid of this knob completely (ontop of your patch):

---
Index: b/arch/x86/kernel/apic/apic.c
===================================================================
--- a/arch/x86/kernel/apic/apic.c	2015-01-16 12:09:08.116801555 +0100
+++ b/arch/x86/kernel/apic/apic.c	2015-01-16 12:08:41.004802076 +0100
@@ -1480,7 +1480,6 @@ static bool nox2apic __initdata;
 #ifdef CONFIG_X86_X2APIC
 int x2apic_mode;
 /* x2apic enabled before OS handover */
-static int x2apic_preenabled;
 static int x2apic_disabled;
 static int __init setup_nox2apic(char *str)
 {
@@ -1546,7 +1545,7 @@ void check_x2apic(void)
 {
 	if (x2apic_enabled()) {
 		pr_info("x2apic enabled by BIOS, switching to x2apic ops\n");
-		x2apic_preenabled = x2apic_mode = 1;
+		x2apic_mode = 1;
 	}
 }
 
@@ -1570,7 +1569,6 @@ void enable_x2apic(void)
 	}
 }
 #else
-#define x2apic_preenabled	(0)
 #endif /* CONFIG_X86_X2APIC */
 
 static int __init try_to_enable_IR(void)
@@ -1599,7 +1597,7 @@ static __init void try_to_enable_x2apic(
 		    (IS_ENABLED(CONFIG_HYPERVISOR_GUEST) &&
 		     !hypervisor_x2apic_available())) {
 			pr_info("IRQ remapping doesn't support X2APIC mode, disable x2apic.\n");
-			if (x2apic_preenabled)
+			if (x2apic_enabled())
 				disable_x2apic();
 			return;
 		}
@@ -1643,7 +1641,7 @@ void __init enable_IR_x2apic(void)
 	legacy_pic->mask_all();
 	mask_ioapic_entries();
 
-	if (x2apic_preenabled && nox2apic)
+	if (x2apic_enabled() && nox2apic)
 		disable_x2apic();
 	/* If irq_remapping_prepare() succeded, try to enable it */
 	if (ir_stat >= 0)
--

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
