Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab3KAWas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:30:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606Ab3KAWFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:05:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.10 41/54] ARM: 7851/1: check for number of arguments in syscall_get/set_arguments()
Date: Fri,  1 Nov 2013 15:04:09 -0700
Message-Id: <20131101220215.957947330@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220211.311926234@linuxfoundation.org>
References: <20131101220211.311926234@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/syscall.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/arm/include/asm/syscall.h
+++ b/arch/arm/include/asm/syscall.h
@@ -57,6 +57,9 @@ static inline void syscall_get_arguments
 					 unsigned int i, unsigned int n,
 					 unsigned long *args)
 {
+	if (n == 0)
+		return;
+
 	if (i + n > SYSCALL_MAX_ARGS) {
 		unsigned long *args_bad = args + SYSCALL_MAX_ARGS - i;
 		unsigned int n_bad = n + i - SYSCALL_MAX_ARGS;
@@ -81,6 +84,9 @@ static inline void syscall_set_arguments
 					 unsigned int i, unsigned int n,
 					 const unsigned long *args)
 {
+	if (n == 0)
+		return;
+
 	if (i + n > SYSCALL_MAX_ARGS) {
 		pr_warning("%s called with max args %d, handling only %d\n",
 			   __func__, i + n, SYSCALL_MAX_ARGS);


