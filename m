Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbaGKR4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 13:56:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370AbaGKR4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 13:56:32 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] KVM: x86 emulator: emulate MOVNTDQ
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 11 Jul 2014 11:56:31 -0600
Message-ID: <20140711175345.19079.28143.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Windows 8.1 guest with NVIDIA driver and GPU fails to boot with an
emulation failure.  The KVM spew suggests the fault is with lack of
movntdq emulation (courtesy of Paolo):

Code=02 00 00 b8 08 00 00 00 f3 0f 6f 44 0a f0 f3 0f 6f 4c 0a e0 <66> 0f e7 41 f0 66 0f e7 49 e0 48 83 e9 40 f3 0f 6f 44 0a 10 f3 0f 6f 0c 0a 66 0f e7 41 10

$ as -o a.out
        .section .text
        .byte 0x66, 0x0f, 0xe7, 0x41, 0xf0
        .byte 0x66, 0x0f, 0xe7, 0x49, 0xe0
$ objdump -d a.out
    0:  66 0f e7 41 f0          movntdq %xmm0,-0x10(%rcx)
    5:  66 0f e7 49 e0          movntdq %xmm1,-0x20(%rcx)

Add the necessary emulation.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
---

Hope I got all the flags correct from copying similar MOV ops, but it
allows the guest to boot, so I suspect it's ok.

 arch/x86/kvm/emulate.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index e4e833d..ae39f08 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3681,6 +3681,10 @@ static const struct gprefix pfx_0f_28_0f_29 = {
 	I(Aligned, em_mov), I(Aligned, em_mov), N, N,
 };
 
+static const struct gprefix pfx_0f_e7 = {
+	N, I(Sse, em_mov), N, N,
+};
+
 static const struct escape escape_d9 = { {
 	N, N, N, N, N, N, N, I(DstMem, em_fnstcw),
 }, {
@@ -3951,7 +3955,8 @@ static const struct opcode twobyte_table[256] = {
 	/* 0xD0 - 0xDF */
 	N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N,
 	/* 0xE0 - 0xEF */
-	N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N,
+	N, N, N, N, N, N, N, GP(SrcReg | DstMem | ModRM | Mov, &pfx_0f_e7),
+	N, N, N, N, N, N, N, N,
 	/* 0xF0 - 0xFF */
 	N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N
 };

