Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968228Ab3E3LWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 07:22:54 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:42273 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968083Ab3E3LWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 07:22:48 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gnatapov@redhat.com, <stable@vger.kernel.org>
Subject: [PATCH] KVM: Emulate multibyte NOP
Date: Thu, 30 May 2013 13:22:39 +0200
Message-Id: <1369912959-18715-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is encountered when booting RHEL5.9 64-bit.  There is another bug
after this one that is not a simple emulation failure, but this one lets
the boot proceed a bit.

Cc: <stable@vger.kernel.org> # 3.9
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 48e6abd..aa68106 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3987,7 +3987,8 @@ static const struct opcode twobyte_table[256] = {
 	DI(ImplicitOps | Priv, invd), DI(ImplicitOps | Priv, wbinvd), N, N,
 	N, D(ImplicitOps | ModRM), N, N,
 	/* 0x10 - 0x1F */
-	N, N, N, N, N, N, N, N, D(ImplicitOps | ModRM), N, N, N, N, N, N, N,
+	N, N, N, N, N, N, N, N,
+	D(ImplicitOps | ModRM), N, N, N, N, N, N, D(ImplicitOps | ModRM),
 	/* 0x20 - 0x2F */
 	DIP(ModRM | DstMem | Priv | Op3264, cr_read, check_cr_read),
 	DIP(ModRM | DstMem | Priv | Op3264, dr_read, check_dr_read),
@@ -4822,6 +4823,7 @@ twobyte_insn:
 	case 0x08:		/* invd */
 	case 0x0d:		/* GrpP (prefetch) */
 	case 0x18:		/* Grp16 (prefetch/nop) */
+	case 0x1f:		/* nop */
 		break;
 	case 0x20: /* mov cr, reg */
 		ctxt->dst.val = ops->get_cr(ctxt, ctxt->modrm_reg);
-- 
1.8.1.4

