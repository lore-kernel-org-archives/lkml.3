Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbaIKJhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:37:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbaIKJhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:37:22 -0400
From: Daniel Borkmann <dborkman@redhat.com>
To: catalin.marinas@arm.com
Cc: will.deacon@arm.com, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>
Subject: [PATCH arm64-next] net: bpf: arm64: fix module memory leak when JIT image build fails
Date: Thu, 11 Sep 2014 11:36:48 +0200
Message-Id: <1410428208-2446-1-git-send-email-dborkman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ARM64, when the BPF JIT compiler fills the JIT image body with
opcodes during translation of eBPF into ARM64 opcodes, we may fail
for several reasons during that phase: one being that we jump to
the notyet label for not yet supported eBPF instructions such as
BPF_ST. In that case we only free offsets, but not the actual
allocated target image where opcodes are being stored. Fix it by
calling module_free() on dismantle time in case of errors.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Zi Shen Lim <zlim.lnx@gmail.com>
Cc: Alexei Starovoitov <ast@plumgrid.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 [ Compile-tested only. ]

 arch/arm64/net/bpf_jit_comp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 38c4296..7ae3354 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -651,8 +651,10 @@ void bpf_int_jit_compile(struct bpf_prog *prog)
 	build_prologue(&ctx);
 
 	ctx.body_offset = ctx.idx;
-	if (build_body(&ctx))
+	if (build_body(&ctx)) {
+		module_free(NULL, ctx.image);
 		goto out;
+	}
 
 	build_epilogue(&ctx);
 
-- 
1.9.3

