Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaKGTsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 14:48:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59997 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930AbaKGTsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 14:48:16 -0500
Date: Fri, 7 Nov 2014 20:48:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 6/8] x86, microcode, intel: use cpuid explicitly instead
 of sync_core
Message-ID: <20141107194811.GD5180@pd.tnic>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-7-git-send-email-hmh@hmh.eng.br>
 <20141107175645.GC5180@pd.tnic>
 <20141107184000.GB18128@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141107184000.GB18128@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 04:40:00PM -0200, Henrique de Moraes Holschuh wrote:
> No real problem, other than the fact that the microcode drivers call
> sync_core() for what might as well be considered an internal implementation
> detail of sync_core().

I think the comment there is enough.

But if you really want to be pedantic and make code more clear for
people who stare at it, this is what you should do:

---
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index c6826d1e8082..59b98a4417ed 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -159,7 +159,7 @@ static int apply_microcode_intel(int cpu)
 	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
 
 	/* As documented in the SDM: Do a CPUID 1 here */
-	sync_core();
+	cpuid_eax(1);
 
 	/* get the current revision from MSR 0x8B */
 	rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
index b88343f7a3b3..6cb747113714 100644
--- a/arch/x86/kernel/cpu/microcode/intel_early.c
+++ b/arch/x86/kernel/cpu/microcode/intel_early.c
@@ -667,7 +667,7 @@ static int apply_microcode_early(struct mc_saved_data *mc_saved_data,
 	native_wrmsr(MSR_IA32_UCODE_REV, 0, 0);
 
 	/* As documented in the SDM: Do a CPUID 1 here */
-	sync_core();
+	cpuid_eax(1);
 
 	/* get the current revision from MSR 0x8B */
 	native_rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
--

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
