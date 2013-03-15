Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab3COSaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:30:06 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:47754 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755045Ab3COSaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:30:03 -0400
From: Nicolas Schichan <nschichan@freebox.fr>
To: Will Drewry <wad@chromium.org>, Mircea Gherzan <mgherzan@gmail.com>
Cc: Nicolas Schichan <nschichan@freebox.fr>,
        Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC 3/3] ARM: net: bpf_jit: add support for jitted seccomp filters.
Date: Fri, 15 Mar 2013 19:28:43 +0100
Message-Id: <1363372123-8861-4-git-send-email-nschichan@freebox.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363372123-8861-1-git-send-email-nschichan@freebox.fr>
References: <1363372123-8861-1-git-send-email-nschichan@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch selects HAVE_SECCOMP_FILTER_JIT in the ARM Kconfig file,
implements and seccomp_jit_compile() and seccomp_jit_free(), and adds
support for BPF_S_ANC_SECCOMP_LD_W instruction.

BPF_S_ANC_SECCOMP_LD_W instructions trigger the generation of a call
to C function jit_get_seccomp_w(). which is a wrapper around
seccomp_bpf_load().

Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
---
 arch/arm/Kconfig          |    1 +
 arch/arm/net/bpf_jit_32.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index dedf02b..b3dce17 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -24,6 +24,7 @@ config ARM
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_BPF_JIT
+	select HAVE_SECCOMP_FILTER_JIT
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_API_DEBUG
diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index 0ea29e0..5af21be 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -103,6 +103,13 @@ static u64 jit_get_skb_w(struct sk_buff *skb, unsigned offset)
 	return (u64)err << 32 | ntohl(ret);
 }
 
+#ifdef CONFIG_SECCOMP_FILTER_JIT
+static u64 jit_get_seccomp_w(struct sk_buff *skb, unsigned int offset)
+{
+	return seccomp_bpf_load(offset);
+}
+#endif
+
 /*
  * Wrapper that handles both OABI and EABI and assures Thumb2 interworking
  * (where the assembly routines like __aeabi_uidiv could cause problems).
@@ -548,6 +555,16 @@ load_common:
 			emit_err_ret(ARM_COND_NE, ctx);
 			emit(ARM_MOV_R(r_A, ARM_R0), ctx);
 			break;
+#ifdef CONFIG_SECCOMP_FILTER_JIT
+		case BPF_S_ANC_SECCOMP_LD_W:
+			ctx->seen |= SEEN_CALL;
+			emit_mov_i(ARM_R3, (u32)jit_get_seccomp_w, ctx);
+			emit_mov_i(ARM_R0, 0, ctx);
+			emit_mov_i(ARM_R1, k, ctx);
+			emit_blx_r(ARM_R3, ctx);
+			emit(ARM_MOV_R(r_A, ARM_R0), ctx);
+			break;
+#endif
 		case BPF_S_LD_W_IND:
 			load_order = 2;
 			goto load_ind;
@@ -956,3 +973,30 @@ void bpf_jit_free(struct sk_filter *fp)
 		schedule_work(work);
 	}
 }
+
+#ifdef CONFIG_SECCOMP_FILTER_JIT
+void seccomp_jit_compile(struct seccomp_filter *fp)
+{
+	struct jit_ctx ctx;
+
+	memset(&ctx, 0, sizeof(ctx));
+	ctx.prog_len = fp->len;
+	ctx.prog_insns = fp->insns;
+
+	__bpf_jit_compile(&ctx);
+	if (ctx.target)
+		fp->bpf_func = (void*)ctx.target;
+}
+
+void seccomp_jit_free(struct seccomp_filter *fp)
+{
+	struct work_struct *work;
+
+	if (fp->bpf_func != sk_run_filter) {
+		work = (struct work_struct *)fp->bpf_func;
+
+		INIT_WORK(work, bpf_jit_free_worker);
+		schedule_work(work);
+	}
+}
+#endif
-- 
1.7.10.4

