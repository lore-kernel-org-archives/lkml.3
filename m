Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbaLNUk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:40:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53359 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbaLNUbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:31:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Markos Chandras <markos.chandras@imgtec.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.18 04/19] mips: bpf: Fix broken BPF_MOD
Date: Sun, 14 Dec 2014 12:21:15 -0800
Message-Id: <20141214201823.669493351@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201823.543296369@linuxfoundation.org>
References: <20141214201823.543296369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Kirjanov <kda@linux-powerpc.org>

[ Upstream commit 2e46477a12f6fd273e31a220b155d66e8352198c ]

Remove optimize_div() from BPF_MOD | BPF_K case
since we don't know the dividend and fix the
emit_mod() by reading the mod operation result from HI register

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
Reviewed-by: Markos Chandras <markos.chandras@imgtec.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/net/bpf_jit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/mips/net/bpf_jit.c
+++ b/arch/mips/net/bpf_jit.c
@@ -426,7 +426,7 @@ static inline void emit_mod(unsigned int
 		u32 *p = &ctx->target[ctx->idx];
 		uasm_i_divu(&p, dst, src);
 		p = &ctx->target[ctx->idx + 1];
-		uasm_i_mflo(&p, dst);
+		uasm_i_mfhi(&p, dst);
 	}
 	ctx->idx += 2; /* 2 insts */
 }
@@ -971,7 +971,7 @@ load_ind:
 			break;
 		case BPF_ALU | BPF_MOD | BPF_K:
 			/* A %= k */
-			if (k == 1 || optimize_div(&k)) {
+			if (k == 1) {
 				ctx->flags |= SEEN_A;
 				emit_jit_reg_move(r_A, r_zero, ctx);
 			} else {


