Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab3GUNoz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 09:44:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34087 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab3GUNo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 09:44:27 -0400
Date: Sun, 21 Jul 2013 06:43:52 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-ea8596bb2d8d37957f3e92db9511c50801689180@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jkosina@suse.cz, jbaron@akamai.com, masami.hiramatsu.pt@hitachi.com,
        bpetkov@suse.de, rostedt@goodmis.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jkosina@suse.cz, jbaron@akamai.com, masami.hiramatsu.pt@hitachi.com,
        bpetkov@suse.de, rostedt@goodmis.org, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20130718114753.26675.18714.stgit@mhiramat-M0-7522>
References: <20130718114753.26675.18714.stgit@mhiramat-M0-7522>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes/x86: Remove unused text_poke_smp()
  and text_poke_smp_batch() functions
Git-Commit-ID: ea8596bb2d8d37957f3e92db9511c50801689180
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 21 Jul 2013 06:44:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea8596bb2d8d37957f3e92db9511c50801689180
Gitweb:     http://git.kernel.org/tip/ea8596bb2d8d37957f3e92db9511c50801689180
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 18 Jul 2013 20:47:53 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Jul 2013 09:57:04 +0200

kprobes/x86: Remove unused text_poke_smp() and text_poke_smp_batch() functions

Since introducing the text_poke_bp() for all text_poke_smp*()
callers, text_poke_smp*() are now unused. This patch basically
reverts:

  3d55cc8a058e ("x86: Add text_poke_smp for SMP cross modifying code")
  7deb18dcf047 ("x86: Introduce text_poke_smp_batch() for batch-code modifying")

and related commits.

This patch also fixes a Kconfig dependency issue on STOP_MACHINE
in the case of CONFIG_SMP && !CONFIG_MODULE_UNLOAD.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@akamai.com>
Cc: yrl.pp-manager.tt@hitachi.com
Cc: Borislav Petkov <bpetkov@suse.de>
Link: http://lkml.kernel.org/r/20130718114753.26675.18714.stgit@mhiramat-M0-7522
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig                   |  5 --
 arch/x86/include/asm/alternative.h | 11 -----
 arch/x86/kernel/alternative.c      | 98 +-------------------------------------
 3 files changed, 2 insertions(+), 112 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b32ebf9..3106e0e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -81,7 +81,6 @@ config X86
 	select HAVE_USER_RETURN_NOTIFIER
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select HAVE_ARCH_JUMP_LABEL
-	select HAVE_TEXT_POKE_SMP
 	select HAVE_GENERIC_HARDIRQS
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select SPARSE_IRQ
@@ -2332,10 +2331,6 @@ config HAVE_ATOMIC_IOMAP
 	def_bool y
 	depends on X86_32
 
-config HAVE_TEXT_POKE_SMP
-	bool
-	select STOP_MACHINE if SMP
-
 config X86_DEV_DMA_OPS
 	bool
 	depends on X86_64 || STA2X11
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 3abf8dd..4daf8c5 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -220,21 +220,10 @@ extern void *text_poke_early(void *addr, const void *opcode, size_t len);
  * no thread can be preempted in the instructions being modified (no iret to an
  * invalid instruction possible) or if the instructions are changed from a
  * consistent state to another consistent state atomically.
- * More care must be taken when modifying code in the SMP case because of
- * Intel's errata. text_poke_smp() takes care that errata, but still
- * doesn't support NMI/MCE handler code modifying.
  * On the local CPU you need to be protected again NMI or MCE handlers seeing an
  * inconsistent instruction while you patch.
  */
-struct text_poke_param {
-	void *addr;
-	const void *opcode;
-	size_t len;
-};
-
 extern void *text_poke(void *addr, const void *opcode, size_t len);
 extern void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler);
-extern void *text_poke_smp(void *addr, const void *opcode, size_t len);
-extern void text_poke_smp_batch(struct text_poke_param *params, int n);
 
 #endif /* _ASM_X86_ALTERNATIVE_H */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 0ab4936..5d8782e 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -633,8 +633,8 @@ static int int3_notify(struct notifier_block *self, unsigned long val, void *dat
  * @handler:	address to jump to when the temporary breakpoint is hit
  *
  * Modify multi-byte instruction by using int3 breakpoint on SMP.
- * In contrary to text_poke_smp(), we completely avoid stop_machine() here,
- * and achieve the synchronization using int3 breakpoint.
+ * We completely avoid stop_machine() here, and achieve the
+ * synchronization using int3 breakpoint.
  *
  * The way it is done:
  *	- add a int3 trap to the address that will be patched
@@ -702,97 +702,3 @@ static int __init int3_init(void)
 }
 
 arch_initcall(int3_init);
-/*
- * Cross-modifying kernel text with stop_machine().
- * This code originally comes from immediate value.
- */
-static atomic_t stop_machine_first;
-static int wrote_text;
-
-struct text_poke_params {
-	struct text_poke_param *params;
-	int nparams;
-};
-
-static int __kprobes stop_machine_text_poke(void *data)
-{
-	struct text_poke_params *tpp = data;
-	struct text_poke_param *p;
-	int i;
-
-	if (atomic_xchg(&stop_machine_first, 0)) {
-		for (i = 0; i < tpp->nparams; i++) {
-			p = &tpp->params[i];
-			text_poke(p->addr, p->opcode, p->len);
-		}
-		smp_wmb();	/* Make sure other cpus see that this has run */
-		wrote_text = 1;
-	} else {
-		while (!wrote_text)
-			cpu_relax();
-		smp_mb();	/* Load wrote_text before following execution */
-	}
-
-	for (i = 0; i < tpp->nparams; i++) {
-		p = &tpp->params[i];
-		flush_icache_range((unsigned long)p->addr,
-				   (unsigned long)p->addr + p->len);
-	}
-	/*
-	 * Intel Archiecture Software Developer's Manual section 7.1.3 specifies
-	 * that a core serializing instruction such as "cpuid" should be
-	 * executed on _each_ core before the new instruction is made visible.
-	 */
-	sync_core();
-	return 0;
-}
-
-/**
- * text_poke_smp - Update instructions on a live kernel on SMP
- * @addr: address to modify
- * @opcode: source of the copy
- * @len: length to copy
- *
- * Modify multi-byte instruction by using stop_machine() on SMP. This allows
- * user to poke/set multi-byte text on SMP. Only non-NMI/MCE code modifying
- * should be allowed, since stop_machine() does _not_ protect code against
- * NMI and MCE.
- *
- * Note: Must be called under get_online_cpus() and text_mutex.
- */
-void *__kprobes text_poke_smp(void *addr, const void *opcode, size_t len)
-{
-	struct text_poke_params tpp;
-	struct text_poke_param p;
-
-	p.addr = addr;
-	p.opcode = opcode;
-	p.len = len;
-	tpp.params = &p;
-	tpp.nparams = 1;
-	atomic_set(&stop_machine_first, 1);
-	wrote_text = 0;
-	/* Use __stop_machine() because the caller already got online_cpus. */
-	__stop_machine(stop_machine_text_poke, (void *)&tpp, cpu_online_mask);
-	return addr;
-}
-
-/**
- * text_poke_smp_batch - Update instructions on a live kernel on SMP
- * @params: an array of text_poke parameters
- * @n: the number of elements in params.
- *
- * Modify multi-byte instruction by using stop_machine() on SMP. Since the
- * stop_machine() is heavy task, it is better to aggregate text_poke requests
- * and do it once if possible.
- *
- * Note: Must be called under get_online_cpus() and text_mutex.
- */
-void __kprobes text_poke_smp_batch(struct text_poke_param *params, int n)
-{
-	struct text_poke_params tpp = {.params = params, .nparams = n};
-
-	atomic_set(&stop_machine_first, 1);
-	wrote_text = 0;
-	__stop_machine(stop_machine_text_poke, (void *)&tpp, cpu_online_mask);
-}
