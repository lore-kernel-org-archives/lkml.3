Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965029AbaKLD6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:58:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178AbaKLB0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:26:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.17 128/319] KVM: x86: PREFETCH and HINT_NOP should have SrcMem flag
Date: Wed, 12 Nov 2014 10:14:26 +0900
Message-Id: <20141112011013.800171034@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nadav Amit <namit@cs.technion.ac.il>

commit 3f6f1480d86bf9fc16c160d803ab1d006e3058d5 upstream.

The decode phase of the x86 emulator assumes that every instruction with the
ModRM flag, and which can be used with RIP-relative addressing, has either
SrcMem or DstMem.  This is not the case for several instructions - prefetch,
hint-nop and clflush.

Adding SrcMem|NoAccess for prefetch and hint-nop and SrcMem for clflush.

This fixes CVE-2014-8480.

Fixes: 41061cdb98a0bec464278b4db8e894a3121671f5
Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3715,7 +3715,7 @@ static const struct opcode group11[] = {
 };
 
 static const struct gprefix pfx_0f_ae_7 = {
-	I(0, em_clflush), N, N, N,
+	I(SrcMem | ByteOp, em_clflush), N, N, N,
 };
 
 static const struct group_dual group15 = { {
@@ -3928,10 +3928,11 @@ static const struct opcode twobyte_table
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


