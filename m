Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760315Ab3BMRbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:31:00 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:41738 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759980Ab3BMRa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:30:59 -0500
X-Greylist: delayed 503 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2013 12:30:58 EST
From: Nicolas Schichan <nschichan@freebox.fr>
To: Mircea Gherzan <mgherzan@gmail.com>, Russell King <linux@arm.linux.org.uk>
Cc: Nicolas Schichan <nschichan@freebox.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: net: bpf_jit: fix emit_swap16() for non ARMv6+.
Date: Wed, 13 Feb 2013 18:30:39 +0100
Message-Id: <1360776645-14726-1-git-send-email-nschichan@freebox.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360776125-14542-1-git-send-email-nschichan@freebox.fr>
References: <1360776125-14542-1-git-send-email-nschichan@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original code was generating an lsl instructions using the value
of ARM_R8 (skb_headlen, possibly uninitialized if no skb_headlen
access was required) as a shift amount.

Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
---
Resent due to missing Signed-off-by

 arch/arm/net/bpf_jit_32.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index a34f1e2..6828ef6 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -341,10 +341,17 @@ static void emit_load_be16(u8 cond, u8 r_res, u8 r_addr, struct jit_ctx *ctx)
 
 static inline void emit_swap16(u8 r_dst, u8 r_src, struct jit_ctx *ctx)
 {
-	emit(ARM_LSL_R(ARM_R1, r_src, 8), ctx);
-	emit(ARM_ORR_S(r_dst, ARM_R1, r_src, SRTYPE_LSL, 8), ctx);
-	emit(ARM_LSL_I(r_dst, r_dst, 8), ctx);
-	emit(ARM_LSL_R(r_dst, r_dst, 8), ctx);
+	/* r_dst = (r_src << 8) | (r_src >> 8) */
+	emit(ARM_LSL_I(ARM_R1, r_src, 8), ctx);
+	emit(ARM_ORR_S(r_dst, ARM_R1, r_src, SRTYPE_LSR, 8), ctx);
+
+	/*
+	 * we need to mask out the bits set in r_dst[23:16] due to
+	 * the first shift instruction.
+	 *
+	 * note that 0x8ff is the encoded immediate 0x00ff0000.
+	 */
+	emit(ARM_BIC_I(r_dst, r_dst, 0x8ff), ctx);
 }
 
 #else  /* ARMv6+ */
-- 
1.7.10.4

