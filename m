Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaGVBtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 21:49:53 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:41177 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaGVBto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 21:49:44 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org,
        Alexei Starovoitov <ast@plumgrid.com>, hpa@zytor.com,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 3/8] seccomp: Allow arch code to provide seccomp_data
Date: Mon, 21 Jul 2014 18:49:16 -0700
Message-Id: <ce65e0e8be18ae8fab437899db44ca41c912b506.1405992946.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1405992946.git.luto@amacapital.net>
References: <cover.1405992946.git.luto@amacapital.net>
In-Reply-To: <cover.1405992946.git.luto@amacapital.net>
References: <cover.1405992946.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

populate_seccomp_data is expensive: it works by inspecting
task_pt_regs and various other bits to piece together all the
information, and it's does so in multiple partially redundant steps.

Arch-specific code in the syscall entry path can do much better.

Admittedly this adds a bit of additional room for error, but the
speedup should be worth it.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 include/linux/seccomp.h |  2 +-
 kernel/seccomp.c        | 32 +++++++++++++++++++-------------
 2 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 3885108..a19ddac 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -39,7 +39,7 @@ static inline int secure_computing(void)
 #define SECCOMP_PHASE1_OK	0
 #define SECCOMP_PHASE1_SKIP	1
 
-extern u32 seccomp_phase1(void);
+extern u32 seccomp_phase1(struct seccomp_data *sd);
 int seccomp_phase2(u32 phase1_result);
 #else
 extern void secure_computing_strict(int this_syscall);
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 0088d29..80115b0 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -173,10 +173,10 @@ static int seccomp_check_filter(struct sock_filter *filter, unsigned int flen)
  *
  * Returns valid seccomp BPF response codes.
  */
-static u32 seccomp_run_filters(void)
+static u32 seccomp_run_filters(struct seccomp_data *sd)
 {
 	struct seccomp_filter *f = ACCESS_ONCE(current->seccomp.filter);
-	struct seccomp_data sd;
+	struct seccomp_data sd_local;
 	u32 ret = SECCOMP_RET_ALLOW;
 
 	/* Ensure unexpected behavior doesn't result in failing open. */
@@ -186,14 +186,17 @@ static u32 seccomp_run_filters(void)
 	/* Make sure cross-thread synced filter points somewhere sane. */
 	smp_read_barrier_depends();
 
-	populate_seccomp_data(&sd);
+	if (!sd) {
+		populate_seccomp_data(&sd_local);
+		sd = &sd_local;
+	}
 
 	/*
 	 * All filters in the list are evaluated and the lowest BPF return
 	 * value always takes priority (ignoring the DATA).
 	 */
 	for (; f; f = f->prev) {
-		u32 cur_ret = SK_RUN_FILTER(f->prog, (void *)&sd);
+		u32 cur_ret = SK_RUN_FILTER(f->prog, (void *)sd);
 
 		if ((cur_ret & SECCOMP_RET_ACTION) < (ret & SECCOMP_RET_ACTION))
 			ret = cur_ret;
@@ -599,7 +602,7 @@ void secure_computing_strict(int this_syscall)
 #else
 int __secure_computing(void)
 {
-	u32 phase1_result = seccomp_phase1();
+	u32 phase1_result = seccomp_phase1(NULL);
 
 	if (likely(phase1_result == SECCOMP_PHASE1_OK))
 		return 0;
@@ -610,7 +613,7 @@ int __secure_computing(void)
 }
 
 #ifdef CONFIG_SECCOMP_FILTER
-static u32 __seccomp_phase1_filter(int this_syscall, struct pt_regs *regs)
+static u32 __seccomp_phase1_filter(int this_syscall, struct seccomp_data *sd)
 {
 	u32 filter_ret, action;
 	int data;
@@ -621,20 +624,20 @@ static u32 __seccomp_phase1_filter(int this_syscall, struct pt_regs *regs)
 	 */
 	rmb();
 
-	filter_ret = seccomp_run_filters();
+	filter_ret = seccomp_run_filters(sd);
 	data = filter_ret & SECCOMP_RET_DATA;
 	action = filter_ret & SECCOMP_RET_ACTION;
 
 	switch (action) {
 	case SECCOMP_RET_ERRNO:
 		/* Set the low-order 16-bits as a errno. */
-		syscall_set_return_value(current, regs,
+		syscall_set_return_value(current, task_pt_regs(current),
 					 -data, 0);
 		goto skip;
 
 	case SECCOMP_RET_TRAP:
 		/* Show the handler the original registers. */
-		syscall_rollback(current, regs);
+		syscall_rollback(current, task_pt_regs(current));
 		/* Let the filter pass back 16 bits of data. */
 		seccomp_send_sigsys(this_syscall, data);
 		goto skip;
@@ -661,11 +664,14 @@ skip:
 
 /**
  * seccomp_phase1() - run fast path seccomp checks on the current syscall
+ * @arg sd: The seccomp_data or NULL
  *
  * This only reads pt_regs via the syscall_xyz helpers.  The only change
  * it will make to pt_regs is via syscall_set_return_value, and it will
  * only do that if it returns SECCOMP_PHASE1_SKIP.
  *
+ * If sd is provided, it will not read pt_regs at all.
+ *
  * It may also call do_exit or force a signal; these actions must be
  * safe.
  *
@@ -679,11 +685,11 @@ skip:
  * If it returns anything else, then the return value should be passed
  * to seccomp_phase2 from a context in which ptrace hooks are safe.
  */
-u32 seccomp_phase1(void)
+u32 seccomp_phase1(struct seccomp_data *sd)
 {
 	int mode = current->seccomp.mode;
-	struct pt_regs *regs = task_pt_regs(current);
-	int this_syscall = syscall_get_nr(current, regs);
+	int this_syscall = sd ? sd->nr :
+		syscall_get_nr(current, task_pt_regs(current));
 
 	switch (mode) {
 	case SECCOMP_MODE_STRICT:
@@ -691,7 +697,7 @@ u32 seccomp_phase1(void)
 		return SECCOMP_PHASE1_OK;
 #ifdef CONFIG_SECCOMP_FILTER
 	case SECCOMP_MODE_FILTER:
-		return __seccomp_phase1_filter(this_syscall, regs);
+		return __seccomp_phase1_filter(this_syscall, sd);
 #endif
 	default:
 		BUG();
-- 
1.9.3

