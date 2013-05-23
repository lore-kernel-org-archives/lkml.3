Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab3EWHyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 03:54:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33518 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757140Ab3EWHya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 03:54:30 -0400
Date: Thu, 23 May 2013 09:54:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/microcode: vendor abstract out
 save_microcode_in_initrd()
Message-ID: <20130523075423.GA3977@pd.tnic>
References: <1369271734-3231-1-git-send-email-jacob.shin@amd.com>
 <1369271734-3231-2-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1369271734-3231-2-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 08:15:33PM -0500, Jacob Shin wrote:
> Currently save_microcode_in_initrd() is declared in vendor neutural
> microcode.h file, but defined in vendor specific
> microcode_intel_early.c file. Vendor abstract it out to
> microcode_core_early.c with a wrapper function.
> 
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> ---
>  arch/x86/include/asm/microcode_intel.h  |    2 ++
>  arch/x86/kernel/microcode_core_early.c  |   10 ++++++++++
>  arch/x86/kernel/microcode_intel_early.c |    2 +-
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
> index 5356f92..cf729eb 100644
> --- a/arch/x86/include/asm/microcode_intel.h
> +++ b/arch/x86/include/asm/microcode_intel.h
> @@ -67,10 +67,12 @@ update_match_revision(struct microcode_header_intel *mc_header, int rev);
>  extern void __init load_ucode_intel_bsp(void);
>  extern void __cpuinit load_ucode_intel_ap(void);
>  extern void show_ucode_info_early(void);
> +extern int __init save_microcode_in_initrd_intel(void);
>  #else
>  static inline __init void load_ucode_intel_bsp(void) {}
>  static inline __cpuinit void load_ucode_intel_ap(void) {}
>  static inline void show_ucode_info_early(void) {}
> +static inline int __init save_microcode_in_initrd_intel(void) {}

In file included from arch/x86/kernel/cpu/common.c:41:0:
/w/kernel/linux-2.6/arch/x86/include/asm/microcode_intel.h: In function ‘save_microcode_in_initrd_intel’:
/w/kernel/linux-2.6/arch/x86/include/asm/microcode_intel.h:75:1: warning: no return statement in function returning non-void [-Wreturn-type]
In file included from arch/x86/kernel/microcode_intel_lib.c:30:0:
/w/kernel/linux-2.6/arch/x86/include/asm/microcode_intel.h: In function ‘save_microcode_in_initrd_intel’:
/w/kernel/linux-2.6/arch/x86/include/asm/microcode_intel.h:75:1: warning: no return statement in function returning non-void [-Wreturn-type]
In file included from arch/x86/kernel/microcode_intel.c:82:0:
/w/kernel/linux-2.6/arch/x86/include/asm/microcode_intel.h: In function ‘save_microcode_in_initrd_intel’:
/w/kernel/linux-2.6/arch/x86/include/asm/microcode_intel.h:75:1: warning: no return statement in function returning non-void [-Wreturn-type]
Setup is 15436 bytes (padded to 15872 bytes).
System is 4268 kB
CRC a330a73f

You need:

diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
index cf729eb3beee..87a085333cbf 100644
--- a/arch/x86/include/asm/microcode_intel.h
+++ b/arch/x86/include/asm/microcode_intel.h
@@ -72,7 +72,7 @@ extern int __init save_microcode_in_initrd_intel(void);
 static inline __init void load_ucode_intel_bsp(void) {}
 static inline __cpuinit void load_ucode_intel_ap(void) {}
 static inline void show_ucode_info_early(void) {}
-static inline int __init save_microcode_in_initrd_intel(void) {}
+static inline int __init save_microcode_in_initrd_intel(void) { return -EINVAL; }
 #endif
 
 #if defined(CONFIG_MICROCODE_INTEL_EARLY) && defined(CONFIG_HOTPLUG_CPU)

Btw,

could you pick up this trivial fix and add it to your set - I can't help
myself when I see typos, especially in user-visible printks :)

Thanks.

--
>From fefc8dec3fb301f217909f04a1805563fcd65329 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bp@suse.de>
Date: Thu, 23 May 2013 09:51:06 +0200
Subject: [PATCH] x86, microcode, intel: Correct typo in printk

User-visible so correct it.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/microcode_intel_early.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/microcode_intel_early.c
index 88f0edc8bb25..317aea99f130 100644
--- a/arch/x86/kernel/microcode_intel_early.c
+++ b/arch/x86/kernel/microcode_intel_early.c
@@ -711,7 +711,7 @@ int __init save_microcode_in_initrd_intel(void)
 	microcode_pointer(mc_saved, mc_saved_in_initrd, initrd_start, count);
 	ret = save_microcode(&mc_saved_data, mc_saved, count);
 	if (ret)
-		pr_err("Can not save microcod patches from initrd");
+		pr_err("Cannot save microcode patches from initrd.\n");
 
 	show_saved_mc();
 
-- 
1.8.3.rc0


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
