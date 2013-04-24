Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab3DXR3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 13:29:01 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:53831 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab3DXR3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 13:29:00 -0400
From: Nicolas Schichan <nschichan@freebox.fr>
To: Will Drewry <wad@chromium.org>, Mircea Gherzan <mgherzan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Nicolas Schichan <nschichan@freebox.fr>,
        Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>
Subject: [PATCH V3 3/3] ARM: net: bpf_jit: add support for jitted seccomp filters.
Date: Wed, 24 Apr 2013 19:27:09 +0200
Message-Id: <1366824429-26652-4-git-send-email-nschichan@freebox.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366824429-26652-1-git-send-email-nschichan@freebox.fr>
References: <1366824429-26652-1-git-send-email-nschichan@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch selects HAVE_SECCOMP_FILTER_JIT in the ARM Kconfig file,
implements seccomp_jit_compile() and seccomp_jit_free(), and adds
support for BPF_S_ANC_SECCOMP_LD_W instruction.

BPF_S_ANC_SECCOMP_LD_W instructions trigger the generation of a call
to C function seccomp_bpf_load().

Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
---
 arch/arm/Kconfig          |    1 +
 arch/arm/net/bpf_jit_32.c |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 60b9876..d2e5d39 100644
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
index bb66a2b..4b89f50 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -548,6 +548,15 @@ load_common:
 			emit_err_ret(ARM_COND_NE, ctx);
 			emit(ARM_MOV_R(r_A, ARM_R0), ctx);
 			break;
+#ifdef CONFIG_SECCOMP_FILTER_JIT
+		case BPF_S_ANC_SECCOMP_LD_W:
+			ctx->seen |= SEEN_CALL;
+			emit_mov_i(ARM_R3, (u32)seccomp_bpf_load, ctx);
+			emit_mov_i(ARM_R0, k, ctx);
+			emit_blx_r(ARM_R3, ctx);
+			emit(ARM_MOV_R(r_A, ARM_R0), ctx);
+			break;
+#endif
 		case BPF_S_LD_W_IND:
 			load_order = 2;
 			goto load_ind;
@@ -956,3 +965,31 @@ void bpf_jit_free(struct sk_filter *fp)
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
+	ctx.prog_len = seccomp_filter_get_len(fp);
+	ctx.prog_insns = seccomp_filter_get_insns(fp);
+
+	__bpf_jit_compile(&ctx);
+	if (ctx.target)
+		seccomp_filter_set_bpf_func(fp, (void *)ctx.target);
+}
+
+void seccomp_jit_free(struct seccomp_filter *fp)
+{
+	struct work_struct *work;
+	void *bpf_func = seccomp_filter_get_bpf_func(fp);
+
+	if (bpf_func != sk_run_filter) {
+		work = (struct work_struct *)bpf_func;
+
+		INIT_WORK(work, bpf_jit_free_worker);
+		schedule_work(work);
+	}
+}
+#endif
-- 
1.7.10.4

