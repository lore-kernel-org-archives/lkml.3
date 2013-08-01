Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab3HAUXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 16:23:06 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:56925 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab3HAUWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 16:22:47 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 2/3] mips/kvm: Cleanup .push/.pop directives in kvm_locore.S
Date: Thu,  1 Aug 2013 13:22:34 -0700
Message-Id: <1375388555-4045-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375388555-4045-1-git-send-email-ddaney.cavm@gmail.com>
References: <1375388555-4045-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

There are:
	.set	push
	.set	noreorder
	.set	noat
	 .
	 .
	 .
	.set	pop

Sequences all over the place in this file, but in some places the
final ".set pop" is erroneously converted to ".set push", so none of
these really do what they appear to.

Clean up the whole mess by moving ".set noreorder", ".set noat" to the
top, and get rid of everything else.

Generated object code is unchanged.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/kvm/kvm_locore.S | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/arch/mips/kvm/kvm_locore.S b/arch/mips/kvm/kvm_locore.S
index 2b4fdd1..fdc169d 100644
--- a/arch/mips/kvm/kvm_locore.S
+++ b/arch/mips/kvm/kvm_locore.S
@@ -55,12 +55,10 @@
  * a0: run
  * a1: vcpu
  */
-
-FEXPORT(__kvm_mips_vcpu_run)
-	.set	push
 	.set	noreorder
 	.set	noat
 
+FEXPORT(__kvm_mips_vcpu_run)
 	/* k0/k1 not being used in host kernel context */
 	addiu	k1, sp, -PT_SIZE
 	LONG_S	$0, PT_R0(k1)
@@ -229,15 +227,11 @@ FEXPORT(__kvm_mips_load_k0k1)
 
 	/* Jump to guest */
 	eret
-	.set	pop
 
 VECTOR(MIPSX(exception), unknown)
 /*
  * Find out what mode we came from and jump to the proper handler.
  */
-	.set	push
-	.set	noat
-	.set	noreorder
 	mtc0	k0, CP0_ERROREPC	#01: Save guest k0
 	ehb				#02:
 
@@ -248,7 +242,6 @@ VECTOR(MIPSX(exception), unknown)
 	addiu	k0, k0, 0x2000		#06: Exception handler is installed @ offset 0x2000
 	j	k0			#07: jump to the function
 	 nop				#08: branch delay slot
-	.set	push
 VECTOR_END(MIPSX(exceptionEnd))
 .end MIPSX(exception)
 
@@ -258,10 +251,6 @@ VECTOR_END(MIPSX(exceptionEnd))
  *
  */
 NESTED (MIPSX(GuestException), CALLFRAME_SIZ, ra)
-	.set	push
-	.set	noat
-	.set	noreorder
-
 	/* Get the VCPU pointer from DDTATA_LO */
 	mfc0	k1, CP0_DDATA_LO
 	addiu	k1, k1, VCPU_HOST_ARCH
@@ -583,7 +572,6 @@ __kvm_mips_return_to_host:
 	j       ra
 	 nop
 
-	.set    pop
 VECTOR_END(MIPSX(GuestExceptionEnd))
 .end MIPSX(GuestException)
 
-- 
1.7.11.7

