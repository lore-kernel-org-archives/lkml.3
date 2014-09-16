Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaIPHtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 03:49:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaIPHtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 03:49:21 -0400
From: Daniel Borkmann <dborkman@redhat.com>
To: catalin.marinas@arm.com
Cc: will.deacon@arm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Zi Shen Lim <zlim.lnx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@plumgrid.com>
Subject: [PATCH arm64-next v4] net: bpf: arm64: address randomize and write protect JIT code
Date: Tue, 16 Sep 2014 09:48:50 +0200
Message-Id: <1410853730-16470-1-git-send-email-dborkman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the ARM64 variant for 314beb9bcab ("x86: bpf_jit_comp: secure bpf
jit against spraying attacks").

Thanks to commit 11d91a770f1f ("arm64: Add CONFIG_DEBUG_SET_MODULE_RONX
support") which added necessary infrastructure, we can now implement
RO marking of eBPF generated JIT image pages and randomize start offset
for the JIT code, so that it does not reside directly on a page boundary
anymore. Likewise, the holes are filled with illegal instructions: here
we use BRK #0x100 (opcode 0xd4202000) to trigger a fault in the kernel
(unallocated BRKs would trigger a fault through do_debug_exception). This
seems more reliable as we don't have a guaranteed undefined instruction
space on ARM64.

This is basically the ARM64 variant of what we already have in ARM via
commit 55309dd3d4cd ("net: bpf: arm: address randomize and write protect
JIT code"). Moreover, this commit also presents a merge resolution due to
conflicts with commit 60a3b2253c41 ("net: bpf: make eBPF interpreter images
read-only") as we don't use kfree() in bpf_jit_free() anymore to release
the locked bpf_prog structure, but instead bpf_prog_unlock_free() through
a different allocator.

JIT tested on aarch64 with BPF test suite.

Reference: http://mainisusuallyafunction.blogspot.com/2012/11/attacking-hardened-linux-systems-with.html
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Zi Shen Lim <zlim.lnx@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Alexei Starovoitov <ast@plumgrid.com>
---
 v3->v4:
  - Inclusion into debug-monitors.h as suggested by Will
 v2->v3:
  - Use cpu_to_le32() as suggested by Zi/Will
 v1->v2:
  - Use brk insn as suggested by Catalin
 Note:
  - This patch depends on net-next being merged to mainline due
    to the mentioned merge conflict.

 arch/arm64/include/asm/debug-monitors.h |  8 +++++++
 arch/arm64/net/bpf_jit_comp.c           | 39 +++++++++++++++++++++++++--------
 2 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/debug-monitors.h b/arch/arm64/include/asm/debug-monitors.h
index 7fb3437..230132f 100644
--- a/arch/arm64/include/asm/debug-monitors.h
+++ b/arch/arm64/include/asm/debug-monitors.h
@@ -48,9 +48,11 @@
 /*
  * #imm16 values used for BRK instruction generation
  * Allowed values for kgbd are 0x400 - 0x7ff
+ * 0x100: for triggering a fault on purpose (reserved)
  * 0x400: for dynamic BRK instruction
  * 0x401: for compile time BRK instruction
  */
+#define FAULT_BRK_IMM			0x100
 #define KGDB_DYN_DGB_BRK_IMM		0x400
 #define KDBG_COMPILED_DBG_BRK_IMM	0x401
 
@@ -61,6 +63,12 @@
 #define AARCH64_BREAK_MON	0xd4200000
 
 /*
+ * BRK instruction for provoking a fault on purpose
+ * Unlike kgdb, #imm16 value with unallocated handler is used for faulting.
+ */
+#define AARCH64_BREAK_FAULT	(AARCH64_BREAK_MON | (FAULT_BRK_IMM << 5))
+
+/*
  * Extract byte from BRK instruction
  */
 #define KGDB_DYN_DGB_BRK_INS_BYTE(x) \
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 7ae3354..7108895 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -19,12 +19,13 @@
 #define pr_fmt(fmt) "bpf_jit: " fmt
 
 #include <linux/filter.h>
-#include <linux/moduleloader.h>
 #include <linux/printk.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
+
 #include <asm/byteorder.h>
 #include <asm/cacheflush.h>
+#include <asm/debug-monitors.h>
 
 #include "bpf_jit.h"
 
@@ -119,6 +120,14 @@ static inline int bpf2a64_offset(int bpf_to, int bpf_from,
 	return to - from;
 }
 
+static void jit_fill_hole(void *area, unsigned int size)
+{
+	u32 *ptr;
+	/* We are guaranteed to have aligned memory. */
+	for (ptr = area; size >= sizeof(u32); size -= sizeof(u32))
+		*ptr++ = cpu_to_le32(AARCH64_BREAK_FAULT);
+}
+
 static inline int epilogue_offset(const struct jit_ctx *ctx)
 {
 	int to = ctx->offset[ctx->prog->len - 1];
@@ -613,8 +622,10 @@ void bpf_jit_compile(struct bpf_prog *prog)
 
 void bpf_int_jit_compile(struct bpf_prog *prog)
 {
+	struct bpf_binary_header *header;
 	struct jit_ctx ctx;
 	int image_size;
+	u8 *image_ptr;
 
 	if (!bpf_jit_enable)
 		return;
@@ -636,23 +647,25 @@ void bpf_int_jit_compile(struct bpf_prog *prog)
 		goto out;
 
 	build_prologue(&ctx);
-
 	build_epilogue(&ctx);
 
 	/* Now we know the actual image size. */
 	image_size = sizeof(u32) * ctx.idx;
-	ctx.image = module_alloc(image_size);
-	if (unlikely(ctx.image == NULL))
+	header = bpf_jit_binary_alloc(image_size, &image_ptr,
+				      sizeof(u32), jit_fill_hole);
+	if (header == NULL)
 		goto out;
 
 	/* 2. Now, the actual pass. */
 
+	ctx.image = (u32 *)image_ptr;
 	ctx.idx = 0;
+
 	build_prologue(&ctx);
 
 	ctx.body_offset = ctx.idx;
 	if (build_body(&ctx)) {
-		module_free(NULL, ctx.image);
+		bpf_jit_binary_free(header);
 		goto out;
 	}
 
@@ -663,17 +676,25 @@ void bpf_int_jit_compile(struct bpf_prog *prog)
 		bpf_jit_dump(prog->len, image_size, 2, ctx.image);
 
 	bpf_flush_icache(ctx.image, ctx.image + ctx.idx);
+
+	set_memory_ro((unsigned long)header, header->pages);
 	prog->bpf_func = (void *)ctx.image;
 	prog->jited = 1;
-
 out:
 	kfree(ctx.offset);
 }
 
 void bpf_jit_free(struct bpf_prog *prog)
 {
-	if (prog->jited)
-		module_free(NULL, prog->bpf_func);
+	unsigned long addr = (unsigned long)prog->bpf_func & PAGE_MASK;
+	struct bpf_binary_header *header = (void *)addr;
+
+	if (!prog->jited)
+		goto free_filter;
+
+	set_memory_rw(addr, header->pages);
+	bpf_jit_binary_free(header);
 
-	kfree(prog);
+free_filter:
+	bpf_prog_unlock_free(prog);
 }
-- 
1.9.3

