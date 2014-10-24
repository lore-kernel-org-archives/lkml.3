Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbaJXPII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:08:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756383AbaJXPIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:08:04 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Nadav Amit <namit@cs.technion.ac.il>, stable@vger.kernel.org
Subject: [PATCH 12/14] KVM: x86: PREFETCH and HINT_NOP should have SrcMem flag
Date: Fri, 24 Oct 2014 17:07:23 +0200
Message-Id: <1414163245-18555-13-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1414163245-18555-1-git-send-email-pbonzini@redhat.com>
References: <1414163245-18555-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nadav Amit <namit@cs.technion.ac.il>

The decode phase of the x86 emulator assumes that every instruction with the
ModRM flag, and which can be used with RIP-relative addressing, has either
SrcMem or DstMem.  This is not the case for several instructions - prefetch,
hint-nop and clflush.

Adding SrcMem|NoAccess for prefetch and hint-nop and SrcMem for clflush.

This fixes CVE-2014-8480.

Fixes: 41061cdb98a0bec464278b4db8e894a3121671f5
Cc: stable@vger.kernel.org
Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 97da5034d812..749f9fa38254 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3807,7 +3807,7 @@ static const struct opcode group11[] = {
 };
 
 static const struct gprefix pfx_0f_ae_7 = {
-	I(0, em_clflush), N, N, N,
+	I(SrcMem | ByteOp, em_clflush), N, N, N,
 };
 
 static const struct group_dual group15 = { {
@@ -4024,10 +4024,11 @@ static const struct opcode twobyte_table[256] = {
 	N, I(ImplicitOps | EmulateOnUD, em_syscall),
 	II(ImplicitOps | Priv, em_clts, clts), N,
 	DI(ImplicitOps | Priv, invd), DI(ImplicitOps | Priv, wbinvd), N, N,
-	N, D(ImplicitOps | ModRM), N, N,
+	N, D(ImplicitOps | ModRM | SrcMem | NoAccess), N, N,
 	/* 0x10 - 0x1F */
 	N, N, N, N, N, N, N, N,
-	D(ImplicitOps | ModRM), N, N, N, N, N, N, D(ImplicitOps | ModRM),
+	D(ImplicitOps | ModRM | SrcMem | NoAccess),
+	N, N, N, N, N, N, D(ImplicitOps | ModRM | SrcMem | NoAccess),
 	/* 0x20 - 0x2F */
 	DIP(ModRM | DstMem | Priv | Op3264 | NoMod, cr_read, check_cr_read),
 	DIP(ModRM | DstMem | Priv | Op3264 | NoMod, dr_read, check_dr_read),
-- 
1.8.3.1


