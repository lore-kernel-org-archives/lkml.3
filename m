Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbaIPU3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:29:38 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:56206 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbaIPU3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:29:35 -0400
From: Zi Shen Lim <zlim.lnx@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: Zi Shen Lim <zlim.lnx@gmail.com>, "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arm64: bpf: add 'load 64-bit immediate' instruction
Date: Tue, 16 Sep 2014 13:29:23 -0700
Message-Id: <1410899363-27635-1-git-send-email-zlim.lnx@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410892655-17818-1-git-send-email-zlim.lnx@gmail.com>
References: <1410892655-17818-1-git-send-email-zlim.lnx@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin, Will,

Please consider applying this after -rc1 as well. [1]

Let me know how you prefer to handle these patches and I can repost
as necessary.

Thanks,
z

[1] https://lkml.org/lkml/2014/9/16/418
>8------------------------------------------------------8<

Commit 02ab695bb37e (net: filter: add "load 64-bit immediate" eBPF
instruction) introduced a new eBPF instruction. Let's add support
for this for arm64 as well.

Our arm64 eBPF JIT compiler now passes the new "load 64-bit
immediate" test case introduced in the same commit 02ab695bb37e.

Signed-off-by: Zi Shen Lim <zlim.lnx@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Alexei Starovoitov <ast@plumgrid.com>
---
 arch/arm64/net/bpf_jit_comp.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 80cc769..618d2cd 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -205,6 +205,12 @@ static void build_epilogue(struct jit_ctx *ctx)
 	emit(A64_RET(A64_LR), ctx);
 }
 
+/* JITs an eBPF instruction.
+ * Returns:
+ * 0  - successfully JITed an 8-byte eBPF instruction.
+ * >0 - successfully JITed a 16-byte eBPF instruction.
+ * <0 - failed to JIT.
+ */
 static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 {
 	const u8 code = insn->code;
@@ -464,6 +470,27 @@ emit_cond_jmp:
 		emit(A64_B(jmp_offset), ctx);
 		break;
 
+	/* dst = imm64 */
+	case BPF_LD | BPF_IMM | BPF_DW:
+	{
+		const struct bpf_insn insn1 = insn[1];
+		u64 imm64;
+
+		if (insn1.code != 0 || insn1.src_reg != 0 ||
+		    insn1.dst_reg != 0 || insn1.off != 0) {
+			/* Note: verifier in BPF core must catch invalid
+			 * instructions.
+			 */
+			pr_err_once("Invalid BPF_LD_IMM64 instruction\n");
+			return -EINVAL;
+		}
+
+		imm64 = (u64)insn1.imm << 32 | imm;
+		emit_a64_mov_i64(dst, imm64, ctx);
+
+		return 1;
+	}
+
 	/* LDX: dst = *(size *)(src + off) */
 	case BPF_LDX | BPF_MEM | BPF_W:
 	case BPF_LDX | BPF_MEM | BPF_H:
@@ -615,6 +642,10 @@ static int build_body(struct jit_ctx *ctx)
 			ctx->offset[i] = ctx->idx;
 
 		ret = build_insn(insn, ctx);
+		if (ret > 0) {
+			i++;
+			continue;
+		}
 		if (ret)
 			return ret;
 	}
-- 
1.9.1

