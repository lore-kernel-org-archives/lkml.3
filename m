Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbaCOUCv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 16:02:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571AbaCOUCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 16:02:09 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@kernel.org, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86 emulator: emulate MOVAPS
Date: Sat, 15 Mar 2014 21:01:59 +0100
Message-Id: <1394913720-6466-2-git-send-email-imammedo@redhat.com>
In-Reply-To: <1394913720-6466-1-git-send-email-imammedo@redhat.com>
References: <1394913720-6466-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HCK memory driver test fails when testing 32-bit Windows 8.1
with baloon driver.

tracing KVM shows error:
reason EXIT_ERR rip 0x81c18326 info 0 0

x/10i 0x81c18326-20
0x0000000081c18312:  add    %al,(%eax)
0x0000000081c18314:  add    %cl,-0x7127711d(%esi)
0x0000000081c1831a:  rolb   $0x0,0x80ec(%ecx)
0x0000000081c18321:  and    $0xfffffff0,%esp
0x0000000081c18324:  mov    %esp,%esi
0x0000000081c18326:  movaps %xmm0,(%esi)
0x0000000081c18329:  movaps %xmm1,0x10(%esi)
0x0000000081c1832d:  movaps %xmm2,0x20(%esi)
0x0000000081c18331:  movaps %xmm3,0x30(%esi)
0x0000000081c18335:  movaps %xmm4,0x40(%esi)

which points to MOVAPS instruction currently no emulated by KVM.
Fix it by adding appropriate entries to opcode table in KVM's emulator.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/kvm/emulate.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 07ffca0..a26d075 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3668,6 +3668,10 @@ static const struct gprefix pfx_vmovntpx = {
 	I(0, em_mov), N, N, N,
 };
 
+static const struct gprefix pfx_0f_28_0f_29 = {
+	I(Aligned, em_mov), N, N, N,
+};
+
 static const struct escape escape_d9 = { {
 	N, N, N, N, N, N, N, I(DstMem, em_fnstcw),
 }, {
@@ -3870,7 +3874,9 @@ static const struct opcode twobyte_table[256] = {
 	IIP(ModRM | SrcMem | Priv | Op3264, em_cr_write, cr_write, check_cr_write),
 	IIP(ModRM | SrcMem | Priv | Op3264, em_dr_write, dr_write, check_dr_write),
 	N, N, N, N,
-	N, N, N, GP(ModRM | DstMem | SrcReg | Sse | Mov | Aligned, &pfx_vmovntpx),
+	GP(ModRM | DstReg | SrcMem | Mov | Sse, &pfx_0f_28_0f_29),
+	GP(ModRM | DstMem | SrcReg | Mov | Sse, &pfx_0f_28_0f_29),
+	N, GP(ModRM | DstMem | SrcReg | Sse | Mov | Aligned, &pfx_vmovntpx),
 	N, N, N, N,
 	/* 0x30 - 0x3F */
 	II(ImplicitOps | Priv, em_wrmsr, wrmsr),
-- 
1.8.5.3

