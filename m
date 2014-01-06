Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbaAFXBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:01:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933217AbaAFWmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:42:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.10 123/129] arm64: check for number of arguments in syscall_get/set_arguments()
Date: Mon,  6 Jan 2014 14:39:12 -0800
Message-Id: <20140106223903.117022216@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AKASHI Takahiro <takahiro.akashi@linaro.org>

commit 7b22c03536a539142f931815528d55df455ffe2d upstream.

In ftrace_syscall_enter(),
    syscall_get_arguments(..., 0, n, ...)
        if (i == 0) { <handle orig_x0> ...; n--;}
        memcpy(..., n * sizeof(args[0]));
If 'number of arguments(n)' is zero and 'argument index(i)' is also zero in
syscall_get_arguments(), none of arguments should be copied by memcpy().
Otherwise 'n--' can be a big positive number and unexpected amount of data
will be copied. Tracing system calls which take no argument, say sync(void),
may hit this case and eventually make the system corrupted.
This patch fixes the issue both in syscall_get_arguments() and
syscall_set_arguments().

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/syscall.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/arm64/include/asm/syscall.h
+++ b/arch/arm64/include/asm/syscall.h
@@ -59,6 +59,9 @@ static inline void syscall_get_arguments
 					 unsigned int i, unsigned int n,
 					 unsigned long *args)
 {
+	if (n == 0)
+		return;
+
 	if (i + n > SYSCALL_MAX_ARGS) {
 		unsigned long *args_bad = args + SYSCALL_MAX_ARGS - i;
 		unsigned int n_bad = n + i - SYSCALL_MAX_ARGS;
@@ -82,6 +85,9 @@ static inline void syscall_set_arguments
 					 unsigned int i, unsigned int n,
 					 const unsigned long *args)
 {
+	if (n == 0)
+		return;
+
 	if (i + n > SYSCALL_MAX_ARGS) {
 		pr_warning("%s called with max args %d, handling only %d\n",
 			   __func__, i + n, SYSCALL_MAX_ARGS);


