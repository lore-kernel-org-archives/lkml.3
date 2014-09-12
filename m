Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaILHMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 03:12:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbaILHML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 03:12:11 -0400
From: Daniel Borkmann <dborkman@redhat.com>
To: will.deacon@arm.com
Cc: catalin.marinas@arm.com, davem@davemloft.net, zlim.lnx@gmail.com,
        ast@plumgrid.com, dborkman@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH arm64-next] net: bpf: arm64: address randomize and write protect JIT code
Date: Fri, 12 Sep 2014 09:11:37 +0200
Message-Id: <1410505897-20122-1-git-send-email-dborkman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the ARM64 variant for 314beb9bcab ("x86: bpf_jit_comp: secure bpf
jit against spraying attacks").

Thanks to commit 11d91a770f1f ("arm64: Add CONFIG_DEBUG_SET_MODULE_RONX
support") which added necessary infrastructure, we can now implement
RO marking of eBPF generated JIT image pages and randomize start offset
for the JIT code, so that it does not reside directly on a page boundary
anymore. Likewise, the holes are filled with illegal instructions.

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
Reviewed-by: Zi Shen Lim <zlim.lnx@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Alexei Starovoitov <ast@plumgrid.com>
---
 README:

 Will, Catalin, Dave, this is more or less a heads-up: when net-next and
 arm64-next tree will get both merged into Linus' tree, we will run into
 a 'silent' merge conflict until someone actually runs eBPF JIT on ARM64
 and might notice (I presume) an oops when JIT is freeing bpf_prog. I'd
 assume nobody actually _runs_ linux-next, but not sure about that though.

 The reason is that in net-next tree we did some BPF-wide (incl. JIT)
 changes regarding the allocator which are currently _not_ present here
 while eBPF JIT currently is _only_ available here.

 Zi offered to alternatively only have this one-liner replacement and
 would rebase this one on top of it. Both is fine by me, I think this one
 would be important to have as well since we have already migrated all
 other archs that support DEBUG_SET_MODULE_RONX to this (ARM32 with
 Mircea's consent pending in net-next).

 This patch here is on top of the module memory leak patch from yesterday
 but requires some of the dependencies from net-next below.

 If you want to look it up, on the top of my head, revelant commits from
 Dave's net-next tree are:

  60a3b2253c413cf601783b070507d7dd6620c954
  738cbe72adc5c8f2016c4c68aa5162631d4f27e1
  55309dd3d4cd7420376a3de0526d6ed24ff8fa76
  b954d83421d51d822c42e5ab7b65069b25ad3005

 How do we handle this? Would I need to resend this patch when the time
 comes or would you ARM64 guys take care of it automagically? ;)

 Thanks a lot!

 arch/arm64/net/bpf_jit_comp.c | 38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 7ae3354..4b71779 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -19,7 +19,6 @@
 #define pr_fmt(fmt) "bpf_jit: " fmt
 
 #include <linux/filter.h>
-#include <linux/moduleloader.h>
 #include <linux/printk.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
@@ -119,6 +118,15 @@ static inline int bpf2a64_offset(int bpf_to, int bpf_from,
 	return to - from;
 }
 
+static void jit_fill_hole(void *area, unsigned int size)
+{
+	/* Insert illegal UND instructions. */
+	u32 *ptr, fill_ins = 0xe7ffffff;
+	/* We are guaranteed to have aligned memory. */
+	for (ptr = area; size >= sizeof(u32); size -= sizeof(u32))
+		*ptr++ = fill_ins;
+}
+
 static inline int epilogue_offset(const struct jit_ctx *ctx)
 {
 	int to = ctx->offset[ctx->prog->len - 1];
@@ -613,8 +621,10 @@ void bpf_jit_compile(struct bpf_prog *prog)
 
 void bpf_int_jit_compile(struct bpf_prog *prog)
 {
+	struct bpf_binary_header *header;
 	struct jit_ctx ctx;
 	int image_size;
+	u8 *image_ptr;
 
 	if (!bpf_jit_enable)
 		return;
@@ -636,23 +646,25 @@ void bpf_int_jit_compile(struct bpf_prog *prog)
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
 
@@ -663,17 +675,25 @@ void bpf_int_jit_compile(struct bpf_prog *prog)
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

