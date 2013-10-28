Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab3J1OtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:49:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51114 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150Ab3J1OtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:49:07 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 23/64] ARM: 7851/1: check for number of arguments in syscall_get/set_arguments()
Date: Mon, 28 Oct 2013 14:47:42 +0000
Message-Id: <1382971703-17393-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: AKASHI Takahiro <takahiro.akashi@linaro.org>

commit 3c1532df5c1b54b5f6246cdef94eeb73a39fe43a upstream.

In ftrace_syscall_enter(),
    syscall_get_arguments(..., 0, n, ...)
        if (i == 0) { <handle ORIG_r0> ...; n--;}
        memcpy(..., n * sizeof(args[0]));
If 'number of arguments(n)' is zero and 'argument index(i)' is also zero in
syscall_get_arguments(), none of arguments should be copied by memcpy().
Otherwise 'n--' can be a big positive number and unexpected amount of data
will be copied. Tracing system calls which take no argument, say sync(void),
may hit this case and eventually make the system corrupted.
This patch fixes the issue both in syscall_get_arguments() and
syscall_set_arguments().

Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/include/asm/syscall.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/include/asm/syscall.h b/arch/arm/include/asm/syscall.h
index fce38a6..36b69df 100644
--- a/arch/arm/include/asm/syscall.h
+++ b/arch/arm/include/asm/syscall.h
@@ -51,6 +51,9 @@ static inline void syscall_get_arguments(struct task_struct *task,
 					 unsigned int i, unsigned int n,
 					 unsigned long *args)
 {
+	if (n == 0)
+		return;
+
 	if (i + n > SYSCALL_MAX_ARGS) {
 		unsigned long *args_bad = args + SYSCALL_MAX_ARGS - i;
 		unsigned int n_bad = n + i - SYSCALL_MAX_ARGS;
@@ -75,6 +78,9 @@ static inline void syscall_set_arguments(struct task_struct *task,
 					 unsigned int i, unsigned int n,
 					 const unsigned long *args)
 {
+	if (n == 0)
+		return;
+
 	if (i + n > SYSCALL_MAX_ARGS) {
 		pr_warning("%s called with max args %d, handling only %d\n",
 			   __func__, i + n, SYSCALL_MAX_ARGS);
-- 
1.8.3.2

