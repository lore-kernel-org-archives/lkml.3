Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbaFQKQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 06:16:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbaFQKQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 06:16:41 -0400
Message-ID: <53A01572.5090603@redhat.com>
Date: Tue, 17 Jun 2014 12:16:18 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Markos Chandras <markos.chandras@imgtec.com>
Subject: Re: mips:allmodconfig build failure in 3.16-rc1 due to bpf_jit code
References: <539FA6CB.5050703@roeck-us.net> <539FFA6B.9030004@redhat.com>
In-Reply-To: <539FFA6B.9030004@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------000900030008080307080608"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000900030008080307080608
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 06/17/2014 10:20 AM, Daniel Borkmann wrote:
> On 06/17/2014 04:24 AM, Guenter Roeck wrote:
>> mips:allmodconfig fails in 3.16-rc1 with lots of undefined symbols.
>>
>> arch/mips/net/bpf_jit.c: In function 'is_load_to_a':
>> arch/mips/net/bpf_jit.c:559:7: error: 'BPF_S_LD_W_LEN' undeclared (first use in this function)
>> arch/mips/net/bpf_jit.c:559:7: note: each undeclared identifier is reported only once for each function it appears in
>> arch/mips/net/bpf_jit.c:560:7: error: 'BPF_S_LD_W_ABS' undeclared (first use in this function)
>> arch/mips/net/bpf_jit.c:561:7: error: 'BPF_S_LD_H_ABS' undeclared (first use in this function)
>> arch/mips/net/bpf_jit.c:562:7: error: 'BPF_S_LD_B_ABS' undeclared (first use in this function)
>> arch/mips/net/bpf_jit.c:563:7: error: 'BPF_S_ANC_CPU' undeclared (first use in this function)
>> arch/mips/net/bpf_jit.c:564:7: error: 'BPF_S_ANC_IFINDEX' undeclared (first use in this function)
>> arch/mips/net/bpf_jit.c:565:7: error: 'BPF_S_ANC_MARK' undeclared (first use in this function)
>>
>> and so on.
>>
>> Those symbols are not defined anywhere.
>>
>> The problem is due to a conflict with commit 348059313 (net: filter: get rid of BPF_S_*
>> enum), which removed those definitions.
>
> Yep, it seems both got in this merge window from different trees. Don't have mips, but
> I'll have a look, and send you a patch.

Could you give the attached patch a try?

Thanks,

Daniel

--------------000900030008080307080608
Content-Type: text/x-patch;
 name="0001-mips-filter-fix-build-error-in-BPF-JIT.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-mips-filter-fix-build-error-in-BPF-JIT.patch"

>From 12b5040eebd51f5efd6ffe04b1bec8ebbe5a9caf Mon Sep 17 00:00:00 2001
From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 17 Jun 2014 11:48:28 +0200
Subject: [PATCH] mips: filter: fix build error in BPF JIT

Guenter reported that on MIPS, the following build error occurs when
BPF JIT is enabled:

  mips: allmodconfig fails in 3.16-rc1 with lots of undefined symbols.

  arch/mips/net/bpf_jit.c: In function 'is_load_to_a':
  arch/mips/net/bpf_jit.c:559:7: error: 'BPF_S_LD_W_LEN' undeclared (first use in this function)
  arch/mips/net/bpf_jit.c:559:7: note: each undeclared identifier is reported only once for each function it appears in
  arch/mips/net/bpf_jit.c:560:7: error: 'BPF_S_LD_W_ABS' undeclared (first use in this function)
  [...]

The reason behind this is that 3480593131e0 ("net: filter: get rid of
BPF_S_* enum") was routed via net-next tree, that takes all BPF-related
changes, at a time where MIPS BPF JIT was not part of net-next, while
c6610de353da ("MIPS: net: Add BPF JIT") was routed via mips arch tree
and went into mainline within the same merge window. Thus, fix it up by
converting BPF_S_* in a similar fashion as in 3480593131e0 for MIPS.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Alexei Starovoitov <ast@plumgrid.com>
Cc: Markos Chandras <markos.chandras@imgtec.com>
---
 arch/mips/net/bpf_jit.c | 143 +++++++++++++++++++++++-------------------------
 1 file changed, 69 insertions(+), 74 deletions(-)

diff --git a/arch/mips/net/bpf_jit.c b/arch/mips/net/bpf_jit.c
index a67b975..f7c2064 100644
--- a/arch/mips/net/bpf_jit.c
+++ b/arch/mips/net/bpf_jit.c
@@ -556,18 +556,10 @@ static inline void update_on_xread(struct jit_ctx *ctx)
 static bool is_load_to_a(u16 inst)
 {
 	switch (inst) {
-	case BPF_S_LD_W_LEN:
-	case BPF_S_LD_W_ABS:
-	case BPF_S_LD_H_ABS:
-	case BPF_S_LD_B_ABS:
-	case BPF_S_ANC_CPU:
-	case BPF_S_ANC_IFINDEX:
-	case BPF_S_ANC_MARK:
-	case BPF_S_ANC_PROTOCOL:
-	case BPF_S_ANC_RXHASH:
-	case BPF_S_ANC_VLAN_TAG:
-	case BPF_S_ANC_VLAN_TAG_PRESENT:
-	case BPF_S_ANC_QUEUE:
+	case BPF_LD | BPF_W | BPF_LEN:
+	case BPF_LD | BPF_W | BPF_ABS:
+	case BPF_LD | BPF_H | BPF_ABS:
+	case BPF_LD | BPF_B | BPF_ABS:
 		return true;
 	default:
 		return false;
@@ -709,7 +701,7 @@ static void build_prologue(struct jit_ctx *ctx)
 		emit_jit_reg_move(r_X, r_zero, ctx);
 
 	/* Do not leak kernel data to userspace */
-	if ((first_inst != BPF_S_RET_K) && !(is_load_to_a(first_inst)))
+	if ((first_inst != (BPF_RET | BPF_K)) && !(is_load_to_a(first_inst)))
 		emit_jit_reg_move(r_A, r_zero, ctx);
 }
 
@@ -783,41 +775,44 @@ static int build_body(struct jit_ctx *ctx)
 	u32 k, b_off __maybe_unused;
 
 	for (i = 0; i < prog->len; i++) {
+		u16 code;
+
 		inst = &(prog->insns[i]);
 		pr_debug("%s: code->0x%02x, jt->0x%x, jf->0x%x, k->0x%x\n",
 			 __func__, inst->code, inst->jt, inst->jf, inst->k);
 		k = inst->k;
+		code = bpf_anc_helper(inst);
 
 		if (ctx->target == NULL)
 			ctx->offsets[i] = ctx->idx * 4;
 
-		switch (inst->code) {
-		case BPF_S_LD_IMM:
+		switch (code) {
+		case BPF_LD | BPF_IMM:
 			/* A <- k ==> li r_A, k */
 			ctx->flags |= SEEN_A;
 			emit_load_imm(r_A, k, ctx);
 			break;
-		case BPF_S_LD_W_LEN:
+		case BPF_LD | BPF_W | BPF_LEN:
 			BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff, len) != 4);
 			/* A <- len ==> lw r_A, offset(skb) */
 			ctx->flags |= SEEN_SKB | SEEN_A;
 			off = offsetof(struct sk_buff, len);
 			emit_load(r_A, r_skb, off, ctx);
 			break;
-		case BPF_S_LD_MEM:
+		case BPF_LD | BPF_MEM:
 			/* A <- M[k] ==> lw r_A, offset(M) */
 			ctx->flags |= SEEN_MEM | SEEN_A;
 			emit_load(r_A, r_M, SCRATCH_OFF(k), ctx);
 			break;
-		case BPF_S_LD_W_ABS:
+		case BPF_LD | BPF_W | BPF_ABS:
 			/* A <- P[k:4] */
 			load_order = 2;
 			goto load;
-		case BPF_S_LD_H_ABS:
+		case BPF_LD | BPF_H | BPF_ABS:
 			/* A <- P[k:2] */
 			load_order = 1;
 			goto load;
-		case BPF_S_LD_B_ABS:
+		case BPF_LD | BPF_B | BPF_ABS:
 			/* A <- P[k:1] */
 			load_order = 0;
 load:
@@ -852,15 +847,15 @@ load_common:
 			emit_b(b_imm(prog->len, ctx), ctx);
 			emit_reg_move(r_ret, r_zero, ctx);
 			break;
-		case BPF_S_LD_W_IND:
+		case BPF_LD | BPF_W | BPF_IND:
 			/* A <- P[X + k:4] */
 			load_order = 2;
 			goto load_ind;
-		case BPF_S_LD_H_IND:
+		case BPF_LD | BPF_H | BPF_IND:
 			/* A <- P[X + k:2] */
 			load_order = 1;
 			goto load_ind;
-		case BPF_S_LD_B_IND:
+		case BPF_LD | BPF_B | BPF_IND:
 			/* A <- P[X + k:1] */
 			load_order = 0;
 load_ind:
@@ -868,23 +863,23 @@ load_ind:
 			ctx->flags |= SEEN_OFF | SEEN_X;
 			emit_addiu(r_off, r_X, k, ctx);
 			goto load_common;
-		case BPF_S_LDX_IMM:
+		case BPF_LDX | BPF_IMM:
 			/* X <- k */
 			ctx->flags |= SEEN_X;
 			emit_load_imm(r_X, k, ctx);
 			break;
-		case BPF_S_LDX_MEM:
+		case BPF_LDX | BPF_MEM:
 			/* X <- M[k] */
 			ctx->flags |= SEEN_X | SEEN_MEM;
 			emit_load(r_X, r_M, SCRATCH_OFF(k), ctx);
 			break;
-		case BPF_S_LDX_W_LEN:
+		case BPF_LDX | BPF_W | BPF_LEN:
 			/* X <- len */
 			ctx->flags |= SEEN_X | SEEN_SKB;
 			off = offsetof(struct sk_buff, len);
 			emit_load(r_X, r_skb, off, ctx);
 			break;
-		case BPF_S_LDX_B_MSH:
+		case BPF_LDX | BPF_B | BPF_MSH:
 			/* X <- 4 * (P[k:1] & 0xf) */
 			ctx->flags |= SEEN_X | SEEN_CALL | SEEN_S0 | SEEN_SKB;
 			/* Load offset to a1 */
@@ -917,50 +912,50 @@ load_ind:
 			emit_b(b_imm(prog->len, ctx), ctx);
 			emit_load_imm(r_ret, 0, ctx); /* delay slot */
 			break;
-		case BPF_S_ST:
+		case BPF_ST:
 			/* M[k] <- A */
 			ctx->flags |= SEEN_MEM | SEEN_A;
 			emit_store(r_A, r_M, SCRATCH_OFF(k), ctx);
 			break;
-		case BPF_S_STX:
+		case BPF_STX:
 			/* M[k] <- X */
 			ctx->flags |= SEEN_MEM | SEEN_X;
 			emit_store(r_X, r_M, SCRATCH_OFF(k), ctx);
 			break;
-		case BPF_S_ALU_ADD_K:
+		case BPF_ALU | BPF_ADD | BPF_K:
 			/* A += K */
 			ctx->flags |= SEEN_A;
 			emit_addiu(r_A, r_A, k, ctx);
 			break;
-		case BPF_S_ALU_ADD_X:
+		case BPF_ALU | BPF_ADD | BPF_X:
 			/* A += X */
 			ctx->flags |= SEEN_A | SEEN_X;
 			emit_addu(r_A, r_A, r_X, ctx);
 			break;
-		case BPF_S_ALU_SUB_K:
+		case BPF_ALU | BPF_SUB | BPF_K:
 			/* A -= K */
 			ctx->flags |= SEEN_A;
 			emit_addiu(r_A, r_A, -k, ctx);
 			break;
-		case BPF_S_ALU_SUB_X:
+		case BPF_ALU | BPF_SUB | BPF_X:
 			/* A -= X */
 			ctx->flags |= SEEN_A | SEEN_X;
 			emit_subu(r_A, r_A, r_X, ctx);
 			break;
-		case BPF_S_ALU_MUL_K:
+		case BPF_ALU | BPF_MUL | BPF_K:
 			/* A *= K */
 			/* Load K to scratch register before MUL */
 			ctx->flags |= SEEN_A | SEEN_S0;
 			emit_load_imm(r_s0, k, ctx);
 			emit_mul(r_A, r_A, r_s0, ctx);
 			break;
-		case BPF_S_ALU_MUL_X:
+		case BPF_ALU | BPF_MUL | BPF_X:
 			/* A *= X */
 			update_on_xread(ctx);
 			ctx->flags |= SEEN_A | SEEN_X;
 			emit_mul(r_A, r_A, r_X, ctx);
 			break;
-		case BPF_S_ALU_DIV_K:
+		case BPF_ALU | BPF_DIV | BPF_K:
 			/* A /= k */
 			if (k == 1)
 				break;
@@ -973,7 +968,7 @@ load_ind:
 			emit_load_imm(r_s0, k, ctx);
 			emit_div(r_A, r_s0, ctx);
 			break;
-		case BPF_S_ALU_MOD_K:
+		case BPF_ALU | BPF_MOD | BPF_K:
 			/* A %= k */
 			if (k == 1 || optimize_div(&k)) {
 				ctx->flags |= SEEN_A;
@@ -984,7 +979,7 @@ load_ind:
 				emit_mod(r_A, r_s0, ctx);
 			}
 			break;
-		case BPF_S_ALU_DIV_X:
+		case BPF_ALU | BPF_DIV | BPF_X:
 			/* A /= X */
 			update_on_xread(ctx);
 			ctx->flags |= SEEN_X | SEEN_A;
@@ -994,7 +989,7 @@ load_ind:
 			emit_load_imm(r_val, 0, ctx); /* delay slot */
 			emit_div(r_A, r_X, ctx);
 			break;
-		case BPF_S_ALU_MOD_X:
+		case BPF_ALU | BPF_MOD | BPF_X:
 			/* A %= X */
 			update_on_xread(ctx);
 			ctx->flags |= SEEN_X | SEEN_A;
@@ -1004,94 +999,94 @@ load_ind:
 			emit_load_imm(r_val, 0, ctx); /* delay slot */
 			emit_mod(r_A, r_X, ctx);
 			break;
-		case BPF_S_ALU_OR_K:
+		case BPF_ALU | BPF_OR | BPF_K:
 			/* A |= K */
 			ctx->flags |= SEEN_A;
 			emit_ori(r_A, r_A, k, ctx);
 			break;
-		case BPF_S_ALU_OR_X:
+		case BPF_ALU | BPF_OR | BPF_X:
 			/* A |= X */
 			update_on_xread(ctx);
 			ctx->flags |= SEEN_A;
 			emit_ori(r_A, r_A, r_X, ctx);
 			break;
-		case BPF_S_ALU_XOR_K:
+		case BPF_ALU | BPF_XOR | BPF_K:
 			/* A ^= k */
 			ctx->flags |= SEEN_A;
 			emit_xori(r_A, r_A, k, ctx);
 			break;
-		case BPF_S_ANC_ALU_XOR_X:
-		case BPF_S_ALU_XOR_X:
+		case BPF_ANC | SKF_AD_ALU_XOR_X:
+		case BPF_ALU | BPF_XOR | BPF_X:
 			/* A ^= X */
 			update_on_xread(ctx);
 			ctx->flags |= SEEN_A;
 			emit_xor(r_A, r_A, r_X, ctx);
 			break;
-		case BPF_S_ALU_AND_K:
+		case BPF_ALU | BPF_AND | BPF_K:
 			/* A &= K */
 			ctx->flags |= SEEN_A;
 			emit_andi(r_A, r_A, k, ctx);
 			break;
-		case BPF_S_ALU_AND_X:
+		case BPF_ALU | BPF_AND | BPF_X:
 			/* A &= X */
 			update_on_xread(ctx);
 			ctx->flags |= SEEN_A | SEEN_X;
 			emit_and(r_A, r_A, r_X, ctx);
 			break;
-		case BPF_S_ALU_LSH_K:
+		case BPF_ALU | BPF_LSH | BPF_K:
 			/* A <<= K */
 			ctx->flags |= SEEN_A;
 			emit_sll(r_A, r_A, k, ctx);
 			break;
-		case BPF_S_ALU_LSH_X:
+		case BPF_ALU | BPF_LSH | BPF_X:
 			/* A <<= X */
 			ctx->flags |= SEEN_A | SEEN_X;
 			update_on_xread(ctx);
 			emit_sllv(r_A, r_A, r_X, ctx);
 			break;
-		case BPF_S_ALU_RSH_K:
+		case BPF_ALU | BPF_RSH | BPF_K:
 			/* A >>= K */
 			ctx->flags |= SEEN_A;
 			emit_srl(r_A, r_A, k, ctx);
 			break;
-		case BPF_S_ALU_RSH_X:
+		case BPF_ALU | BPF_RSH | BPF_X:
 			ctx->flags |= SEEN_A | SEEN_X;
 			update_on_xread(ctx);
 			emit_srlv(r_A, r_A, r_X, ctx);
 			break;
-		case BPF_S_ALU_NEG:
+		case BPF_ALU | BPF_NEG:
 			/* A = -A */
 			ctx->flags |= SEEN_A;
 			emit_neg(r_A, ctx);
 			break;
-		case BPF_S_JMP_JA:
+		case BPF_JMP | BPF_JA:
 			/* pc += K */
 			emit_b(b_imm(i + k + 1, ctx), ctx);
 			emit_nop(ctx);
 			break;
-		case BPF_S_JMP_JEQ_K:
+		case BPF_JMP | BPF_JEQ | BPF_K:
 			/* pc += ( A == K ) ? pc->jt : pc->jf */
 			condt = MIPS_COND_EQ | MIPS_COND_K;
 			goto jmp_cmp;
-		case BPF_S_JMP_JEQ_X:
+		case BPF_JMP | BPF_JEQ | BPF_X:
 			ctx->flags |= SEEN_X;
 			/* pc += ( A == X ) ? pc->jt : pc->jf */
 			condt = MIPS_COND_EQ | MIPS_COND_X;
 			goto jmp_cmp;
-		case BPF_S_JMP_JGE_K:
+		case BPF_JMP | BPF_JGE | BPF_K:
 			/* pc += ( A >= K ) ? pc->jt : pc->jf */
 			condt = MIPS_COND_GE | MIPS_COND_K;
 			goto jmp_cmp;
-		case BPF_S_JMP_JGE_X:
+		case BPF_JMP | BPF_JGE | BPF_X:
 			ctx->flags |= SEEN_X;
 			/* pc += ( A >= X ) ? pc->jt : pc->jf */
 			condt = MIPS_COND_GE | MIPS_COND_X;
 			goto jmp_cmp;
-		case BPF_S_JMP_JGT_K:
+		case BPF_JMP | BPF_JGT | BPF_K:
 			/* pc += ( A > K ) ? pc->jt : pc->jf */
 			condt = MIPS_COND_GT | MIPS_COND_K;
 			goto jmp_cmp;
-		case BPF_S_JMP_JGT_X:
+		case BPF_JMP | BPF_JGT | BPF_X:
 			ctx->flags |= SEEN_X;
 			/* pc += ( A > X ) ? pc->jt : pc->jf */
 			condt = MIPS_COND_GT | MIPS_COND_X;
@@ -1167,7 +1162,7 @@ jmp_cmp:
 				}
 			}
 			break;
-		case BPF_S_JMP_JSET_K:
+		case BPF_JMP | BPF_JSET | BPF_K:
 			ctx->flags |= SEEN_S0 | SEEN_S1 | SEEN_A;
 			/* pc += (A & K) ? pc -> jt : pc -> jf */
 			emit_load_imm(r_s1, k, ctx);
@@ -1181,7 +1176,7 @@ jmp_cmp:
 			emit_b(b_off, ctx);
 			emit_nop(ctx);
 			break;
-		case BPF_S_JMP_JSET_X:
+		case BPF_JMP | BPF_JSET | BPF_X:
 			ctx->flags |= SEEN_S0 | SEEN_X | SEEN_A;
 			/* pc += (A & X) ? pc -> jt : pc -> jf */
 			emit_and(r_s0, r_A, r_X, ctx);
@@ -1194,7 +1189,7 @@ jmp_cmp:
 			emit_b(b_off, ctx);
 			emit_nop(ctx);
 			break;
-		case BPF_S_RET_A:
+		case BPF_RET | BPF_A:
 			ctx->flags |= SEEN_A;
 			if (i != prog->len - 1)
 				/*
@@ -1204,7 +1199,7 @@ jmp_cmp:
 				emit_b(b_imm(prog->len, ctx), ctx);
 			emit_reg_move(r_ret, r_A, ctx); /* delay slot */
 			break;
-		case BPF_S_RET_K:
+		case BPF_RET | BPF_K:
 			/*
 			 * It can emit two instructions so it does not fit on
 			 * the delay slot.
@@ -1219,19 +1214,19 @@ jmp_cmp:
 				emit_nop(ctx);
 			}
 			break;
-		case BPF_S_MISC_TAX:
+		case BPF_MISC | BPF_TAX:
 			/* X = A */
 			ctx->flags |= SEEN_X | SEEN_A;
 			emit_jit_reg_move(r_X, r_A, ctx);
 			break;
-		case BPF_S_MISC_TXA:
+		case BPF_MISC | BPF_TXA:
 			/* A = X */
 			ctx->flags |= SEEN_A | SEEN_X;
 			update_on_xread(ctx);
 			emit_jit_reg_move(r_A, r_X, ctx);
 			break;
 		/* AUX */
-		case BPF_S_ANC_PROTOCOL:
+		case BPF_ANC | SKF_AD_PROTOCOL:
 			/* A = ntohs(skb->protocol */
 			ctx->flags |= SEEN_SKB | SEEN_OFF | SEEN_A;
 			BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff,
@@ -1256,7 +1251,7 @@ jmp_cmp:
 			}
 #endif
 			break;
-		case BPF_S_ANC_CPU:
+		case BPF_ANC | SKF_AD_CPU:
 			ctx->flags |= SEEN_A | SEEN_OFF;
 			/* A = current_thread_info()->cpu */
 			BUILD_BUG_ON(FIELD_SIZEOF(struct thread_info,
@@ -1265,7 +1260,7 @@ jmp_cmp:
 			/* $28/gp points to the thread_info struct */
 			emit_load(r_A, 28, off, ctx);
 			break;
-		case BPF_S_ANC_IFINDEX:
+		case BPF_ANC | SKF_AD_IFINDEX:
 			/* A = skb->dev->ifindex */
 			ctx->flags |= SEEN_SKB | SEEN_A | SEEN_S0;
 			off = offsetof(struct sk_buff, dev);
@@ -1279,31 +1274,31 @@ jmp_cmp:
 			off = offsetof(struct net_device, ifindex);
 			emit_load(r_A, r_s0, off, ctx);
 			break;
-		case BPF_S_ANC_MARK:
+		case BPF_ANC | SKF_AD_MARK:
 			ctx->flags |= SEEN_SKB | SEEN_A;
 			BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff, mark) != 4);
 			off = offsetof(struct sk_buff, mark);
 			emit_load(r_A, r_skb, off, ctx);
 			break;
-		case BPF_S_ANC_RXHASH:
+		case BPF_ANC | SKF_AD_RXHASH:
 			ctx->flags |= SEEN_SKB | SEEN_A;
 			BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff, hash) != 4);
 			off = offsetof(struct sk_buff, hash);
 			emit_load(r_A, r_skb, off, ctx);
 			break;
-		case BPF_S_ANC_VLAN_TAG:
-		case BPF_S_ANC_VLAN_TAG_PRESENT:
+		case BPF_ANC | SKF_AD_VLAN_TAG:
+		case BPF_ANC | SKF_AD_VLAN_TAG_PRESENT:
 			ctx->flags |= SEEN_SKB | SEEN_S0 | SEEN_A;
 			BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff,
 						  vlan_tci) != 2);
 			off = offsetof(struct sk_buff, vlan_tci);
 			emit_half_load(r_s0, r_skb, off, ctx);
-			if (inst->code == BPF_S_ANC_VLAN_TAG)
+			if (code == (BPF_ANC | SKF_AD_VLAN_TAG))
 				emit_and(r_A, r_s0, VLAN_VID_MASK, ctx);
 			else
 				emit_and(r_A, r_s0, VLAN_TAG_PRESENT, ctx);
 			break;
-		case BPF_S_ANC_PKTTYPE:
+		case BPF_ANC | SKF_AD_PKTTYPE:
 			off = pkt_type_offset();
 
 			if (off < 0)
@@ -1312,7 +1307,7 @@ jmp_cmp:
 			/* Keep only the last 3 bits */
 			emit_andi(r_A, r_tmp, PKT_TYPE_MAX, ctx);
 			break;
-		case BPF_S_ANC_QUEUE:
+		case BPF_ANC | SKF_AD_QUEUE:
 			ctx->flags |= SEEN_SKB | SEEN_A;
 			BUILD_BUG_ON(FIELD_SIZEOF(struct sk_buff,
 						  queue_mapping) != 2);
-- 
1.7.11.7


--------------000900030008080307080608--
