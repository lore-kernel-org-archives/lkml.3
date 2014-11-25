Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbaKYWSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 17:18:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55206 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbaKYWSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 17:18:06 -0500
Date: Tue, 25 Nov 2014 23:18:00 +0100
From: Borislav Petkov <bp@suse.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Richard Hendershot <rshendershot@mchsi.com>,
        David Vrabel <david.vrabel@citrix.com>, x86-ml <x86@kernel.org>
Subject: Re: [PATCH 3.17 100/141] x86, microcode: Fix accessing dis_ucode_ldr
 on 32-bit
Message-ID: <20141125221800.GI4128@pd.tnic>
References: <20141125182410.GB4128@pd.tnic>
 <5474CDCE.6040000@oracle.com>
 <20141125184351.GC4128@pd.tnic>
 <5474D0A1.2020600@oracle.com>
 <20141125190849.GF4128@pd.tnic>
 <5474D86E.6020608@oracle.com>
 <20141125202628.GG4128@pd.tnic>
 <20141125203634.GA6433@laptop.dumpdata.com>
 <20141125211708.GH4128@pd.tnic>
 <5474FBC6.7090603@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5474FBC6.7090603@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding x86 people.

On Tue, Nov 25, 2014 at 04:59:34PM -0500, Boris Ostrovsky wrote:
> This should be cpuid(0x1, &eax, &ebx, &ecx, &edx). Otherwise we are not
> getting bits that the hypervisor wants the guest to see (on Xen cpuid()
> turns into hypercall, on baremetal it's native).
> 
> With that change it works and
> 
> Tested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

Thanks for testing.

> (May be worth adding a comment as to what is_guest() is checking for since
> 31 is a magic number).

See below.

> BTW, the crash had nothing to do with accessing dis_ucode_ldr, we are
> crashing much later, in load_ucode_intel_ap(), trying to access
> *initrd_start_p. And the reason we didn't crash before was because compiler
> optimized out whole load_ucode_ap() since check_loader_disabled_ap() was
> always true.

Right, and my fix actually uncovered the original issue :-\

Ok, here's a v2 which adds the check to the late loader too, for
completeness. I'll write a proper commit message tomorrow.

---
diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 64dc362506b7..654907db5f09 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -87,4 +87,9 @@ static inline int __init save_microcode_in_initrd(void)
 }
 #endif
 
+/* Check whether we're running as a guest on a hypervisor. */
+static inline bool x86_guest(void)
+{
+	return !!(cpuid_ecx(1) & BIT(31));
+}
 #endif /* _ASM_X86_MICROCODE_H */
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 2ce9051174e6..0b6db2a97f61 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -557,6 +557,9 @@ static int __init microcode_init(void)
 	struct cpuinfo_x86 *c = &cpu_data(0);
 	int error;
 
+	if (x86_guest())
+		return 0;
+
 	if (dis_ucode_ldr)
 		return 0;
 
diff --git a/arch/x86/kernel/cpu/microcode/core_early.c b/arch/x86/kernel/cpu/microcode/core_early.c
index 2c017f242a78..dfa93e74c370 100644
--- a/arch/x86/kernel/cpu/microcode/core_early.c
+++ b/arch/x86/kernel/cpu/microcode/core_early.c
@@ -98,6 +98,9 @@ void __init load_ucode_bsp(void)
 {
 	int vendor, x86;
 
+	if (x86_guest())
+		return;
+
 	if (check_loader_disabled_bsp())
 		return;
 
@@ -134,6 +137,9 @@ void load_ucode_ap(void)
 {
 	int vendor, x86;
 
+	if (x86_guest())
+		return;
+
 	if (check_loader_disabled_ap())
 		return;
 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
