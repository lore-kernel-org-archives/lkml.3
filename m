Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaLOOb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:31:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39043 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaLOO3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:29:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 160/168] mips: bpf: Fix broken BPF_MOD
Date: Mon, 15 Dec 2014 14:26:54 +0000
Message-Id: <1418653622-21105-161-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Kirjanov <kda@linux-powerpc.org>

commit 2e46477a12f6fd273e31a220b155d66e8352198c upstream.

Remove optimize_div() from BPF_MOD | BPF_K case
since we don't know the dividend and fix the
emit_mod() by reading the mod operation result from HI register

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
Reviewed-by: Markos Chandras <markos.chandras@imgtec.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/mips/net/bpf_jit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/net/bpf_jit.c b/arch/mips/net/bpf_jit.c
index b87390a56a2f..965f1c116cc5 100644
--- a/arch/mips/net/bpf_jit.c
+++ b/arch/mips/net/bpf_jit.c
@@ -430,7 +430,7 @@ static inline void emit_mod(unsigned int dst, unsigned int src,
 		u32 *p = &ctx->target[ctx->idx];
 		uasm_i_divu(&p, dst, src);
 		p = &ctx->target[ctx->idx + 1];
-		uasm_i_mflo(&p, dst);
+		uasm_i_mfhi(&p, dst);
 	}
 	ctx->idx += 2; /* 2 insts */
 }
@@ -1005,7 +1005,7 @@ load_ind:
 			break;
 		case BPF_ALU | BPF_MOD | BPF_K:
 			/* A %= k */
-			if (k == 1 || optimize_div(&k)) {
+			if (k == 1) {
 				ctx->flags |= SEEN_A;
 				emit_jit_reg_move(r_A, r_zero, ctx);
 			} else {
-- 
2.1.3

