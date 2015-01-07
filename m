Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbbAGDEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 22:04:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842AbbAGBv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:51:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexei Starovoitov <ast@plumgrid.com>,
        Zi Shen Lim <zlim.lnx@gmail.com>, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 3.18 32/84] arm64: bpf: lift restriction on last instruction
Date: Tue,  6 Jan 2015 17:49:35 -0800
Message-Id: <20150107014030.078041536@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014029.012974975@linuxfoundation.org>
References: <20150107014029.012974975@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zi Shen Lim <zlim.lnx@gmail.com>

commit 51c9fbb1b146f3336a93d398c439b6fbfe5ab489 upstream.

Earlier implementation assumed last instruction is BPF_EXIT.
Since this is no longer a restriction in eBPF, we remove this
limitation.

Per Alexei Starovoitov [1]:
> classic BPF has a restriction that last insn is always BPF_RET.
> eBPF doesn't have BPF_RET instruction and this restriction.
> It has BPF_EXIT insn which can appear anywhere in the program
> one or more times and it doesn't have to be last insn.

[1] https://lkml.org/lkml/2014/11/27/2

Fixes: e54bcde3d69d ("arm64: eBPF JIT compiler")
Acked-by: Alexei Starovoitov <ast@plumgrid.com>
Signed-off-by: Zi Shen Lim <zlim.lnx@gmail.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/net/bpf_jit_comp.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -60,7 +60,7 @@ struct jit_ctx {
 	const struct bpf_prog *prog;
 	int idx;
 	int tmp_used;
-	int body_offset;
+	int epilogue_offset;
 	int *offset;
 	u32 *image;
 };
@@ -130,8 +130,8 @@ static void jit_fill_hole(void *area, un
 
 static inline int epilogue_offset(const struct jit_ctx *ctx)
 {
-	int to = ctx->offset[ctx->prog->len - 1];
-	int from = ctx->idx - ctx->body_offset;
+	int to = ctx->epilogue_offset;
+	int from = ctx->idx;
 
 	return to - from;
 }
@@ -463,6 +463,8 @@ emit_cond_jmp:
 	}
 	/* function return */
 	case BPF_JMP | BPF_EXIT:
+		/* Optimization: when last instruction is EXIT,
+		   simply fallthrough to epilogue. */
 		if (i == ctx->prog->len - 1)
 			break;
 		jmp_offset = epilogue_offset(ctx);
@@ -685,11 +687,13 @@ void bpf_int_jit_compile(struct bpf_prog
 
 	/* 1. Initial fake pass to compute ctx->idx. */
 
-	/* Fake pass to fill in ctx->offset. */
+	/* Fake pass to fill in ctx->offset and ctx->tmp_used. */
 	if (build_body(&ctx))
 		goto out;
 
 	build_prologue(&ctx);
+
+	ctx.epilogue_offset = ctx.idx;
 	build_epilogue(&ctx);
 
 	/* Now we know the actual image size. */
@@ -706,7 +710,6 @@ void bpf_int_jit_compile(struct bpf_prog
 
 	build_prologue(&ctx);
 
-	ctx.body_offset = ctx.idx;
 	if (build_body(&ctx)) {
 		bpf_jit_binary_free(header);
 		goto out;


