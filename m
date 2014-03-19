Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965467AbaCSPN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 11:13:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965095AbaCSPNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 11:13:53 -0400
Message-ID: <1395241998.2967.52.camel@deneb.redhat.com>
Subject: Re: [PATCH v2 11/15] arm64: add EFI stub
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 19 Mar 2014 11:13:18 -0400
In-Reply-To: <20140319105706.GE2214@arm.com>
References: <1394750828-16351-1-git-send-email-leif.lindholm@linaro.org>
	 <1394750828-16351-12-git-send-email-leif.lindholm@linaro.org>
	 <20140318120919.GG13200@arm.com>
	 <1395153629.2967.10.camel@deneb.redhat.com>
	 <20140318182826.GC20497@arm.com>
	 <1395178831.2967.29.camel@deneb.redhat.com> <20140319105706.GE2214@arm.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-19 at 10:57 +0000, Catalin Marinas wrote:
> On Tue, Mar 18, 2014 at 09:40:31PM +0000, Mark Salter wrote:
> > On Tue, 2014-03-18 at 18:28 +0000, Catalin Marinas wrote:
> > > If UEFI doesn't handle the caches, the only thing left to EFI_STUB is to
> > > flush by MVA. We don't need to flush the whole DRAM (and I would even
> > > recommend it) but at least the relevant kernel code/data touched with
> > > the MMU disabled.
> > 
> > So, it goes like this:
> > 
> >   1) UEFI calls stub with MMU/Caches on. Stub/kernel can be anywhere.
> >   2) Stub runs and relocates kernel to the desired runtime location
> >      but continues to execute from wherever UEFI loaded it until just
> >      after ExitBootServices().
> >   3) After ExitBootServices, efi_entry() returns relocated entry point
> >      for kernel to efi_stub_entry() in efi-entry.S where the Dcache and
> >      MMU are turned off, the __flush_dcache_all is called, then the
> >      code jumps to the kernel proper entry point.
> > 
> > It isn't clear to me if UEFI does cache flushing at ExitBootServices
> > time, but even so, at least stack use will get cached between then and
> > the kernel entry point. The stub could conceivably get its hands on the
> > EFI memmap and invalidate dcache using address ranges from UEFI memory
> > descriptors so maybe that is the way we should do it.
> 
> I think the stub just needs to flush the relocated kernel image, ensure
> it is sync with the memory. Additional flushing can be done by the
> kernel for bits it writes (like page tables, code patching etc). We can
> enter the kernel with the SCTLR.I bit set, so it can allocate in an
> unified cache already and D-cache maintenance would be needed anyway.

How about this?

diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
index 83bfb72..ed480b2 100644
--- a/arch/arm64/kernel/efi-entry.S
+++ b/arch/arm64/kernel/efi-entry.S
@@ -52,11 +52,19 @@ ENTRY(efi_stub_entry)
 	 * efi_entry() will have relocated the kernel image if necessary
 	 * and we return here with device tree address in x0 and the kernel
 	 * entry point stored at *image_addr. Save those values in registers
-	 * which are preserved by __flush_dcache_all.
+	 * which are callee preserved.
 	 */
-	ldr	x1, [sp, #16]
 	mov	x20, x0
-	mov	x21, x1
+	ldr	x0, [sp, #16]
+	mov	x21, x0
+
+	adrp	x1, _text
+	add	x1, x1, #:lo12:_text
+	adrp	x2, _edata
+	add	x2, x2, #:lo12:_edata
+	sub	x1, x2, x1
+
+	bl	__flush_dcache_area
 
 	/* Turn off Dcache and MMU */
 	mrs	x0, CurrentEL
@@ -76,8 +84,6 @@ ENTRY(efi_stub_entry)
 	msr	sctlr_el1, x0
 	isb
 2:
-	bl	__flush_dcache_all
-
 	/* Jump to real entry point */
 	mov	x0, x20
 	mov	x1, xzr



