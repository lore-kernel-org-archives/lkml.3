Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbaKYK7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:59:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59020 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbaKYKnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Ian Campbell <ijc@hellion.org.uk>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Mark Salter <msalter@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 202/254] arm64: efi: Fix stub cache maintenance
Date: Tue, 25 Nov 2014 10:39:12 +0000
Message-Id: <1416912004-5928-203-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit 9b0b26580a753d4d6bdd2b8b4ca9a8f3f2d39065 upstream.

While efi-entry.S mentions that efi_entry() will have relocated the
kernel image, it actually means that efi_entry will have placed a copy
of the kernel in the appropriate location, and until this is branched to
at the end of efi_entry.S, all instructions are executed from the
original image.

Thus while the flush in efi_entry.S does ensure that the copy is visible
to noncacheable accesses, it does not guarantee that this is true for
the image instructions are being executed from. This could have
disasterous effects when the MMU and caches are disabled if the image
has not been naturally evicted to the PoC.

Additionally, due to a missing dsb following the ic ialluis, the new
kernel image is not necessarily clean in the I-cache when it is branched
to, with similar potentially disasterous effects.

This patch adds additional flushing to ensure that the currently
executing stub text is flushed to the PoC and is thus visible to
noncacheable accesses. As it is placed after the instructions cache
maintenance for the new image and __flush_dcache_area already contains a
dsb, we do not need to add a separate barrier to ensure completion of
the icache maintenance.

Comments are updated to clarify the situation with regard to the two
images and the maintenance required for both.

Fixes: 3c7f255039a2ad6ee1e3890505caf0d029b22e29
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Joel Schopp <joel.schopp@amd.com>
Reviewed-by: Roy Franz <roy.franz@linaro.org>
Tested-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ian Campbell <ijc@hellion.org.uk>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Mark Salter <msalter@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm64/kernel/efi-entry.S | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
index 619b1dd7bcde..d18a44940968 100644
--- a/arch/arm64/kernel/efi-entry.S
+++ b/arch/arm64/kernel/efi-entry.S
@@ -54,18 +54,17 @@ ENTRY(efi_stub_entry)
 	b.eq	efi_load_fail
 
 	/*
-	 * efi_entry() will have relocated the kernel image if necessary
-	 * and we return here with device tree address in x0 and the kernel
-	 * entry point stored at *image_addr. Save those values in registers
-	 * which are callee preserved.
+	 * efi_entry() will have copied the kernel image if necessary and we
+	 * return here with device tree address in x0 and the kernel entry
+	 * point stored at *image_addr. Save those values in registers which
+	 * are callee preserved.
 	 */
 	mov	x20, x0		// DTB address
 	ldr	x0, [sp, #16]	// relocated _text address
 	mov	x21, x0
 
 	/*
-	 * Flush dcache covering current runtime addresses
-	 * of kernel text/data. Then flush all of icache.
+	 * Calculate size of the kernel Image (same for original and copy).
 	 */
 	adrp	x1, _text
 	add	x1, x1, #:lo12:_text
@@ -73,9 +72,24 @@ ENTRY(efi_stub_entry)
 	add	x2, x2, #:lo12:_edata
 	sub	x1, x2, x1
 
+	/*
+	 * Flush the copied Image to the PoC, and ensure it is not shadowed by
+	 * stale icache entries from before relocation.
+	 */
 	bl	__flush_dcache_area
 	ic	ialluis
 
+	/*
+	 * Ensure that the rest of this function (in the original Image) is
+	 * visible when the caches are disabled. The I-cache can't have stale
+	 * entries for the VA range of the current image, so no maintenance is
+	 * necessary.
+	 */
+	adr	x0, efi_stub_entry
+	adr	x1, efi_stub_entry_end
+	sub	x1, x1, x0
+	bl	__flush_dcache_area
+
 	/* Turn off Dcache and MMU */
 	mrs	x0, CurrentEL
 	cmp	x0, #CurrentEL_EL2
@@ -105,4 +119,5 @@ efi_load_fail:
 	ldp	x29, x30, [sp], #32
 	ret
 
+efi_stub_entry_end:
 ENDPROC(efi_stub_entry)
-- 
2.1.0

