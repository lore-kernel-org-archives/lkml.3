Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbaK1F1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 00:27:48 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:33717 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaK1F1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 00:27:45 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: keescook@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com
Cc: dsaxena@linaro.org, arndb@arndb.de, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v10 5/6] arm64: add SIGSYS siginfo for compat task
Date: Fri, 28 Nov 2014 14:26:38 +0900
Message-Id: <1417152399-32717-6-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417152399-32717-1-git-send-email-takahiro.akashi@linaro.org>
References: <1417152399-32717-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SIGSYS is primarily used in secure computing to notify tracer of syscall
events. This patch allows signal handler on compat task to get correct
information with SA_SIGINFO specified when this signal is delivered.

Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/include/asm/compat.h |    7 +++++++
 arch/arm64/kernel/signal32.c    |    6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index 56de5aa..3fb053f 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -205,6 +205,13 @@ typedef struct compat_siginfo {
 			compat_long_t _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
 			int _fd;
 		} _sigpoll;
+
+		/* SIGSYS */
+		struct {
+			compat_uptr_t _call_addr; /* calling user insn */
+			int _syscall;	/* triggering system call number */
+			compat_uint_t _arch;	/* AUDIT_ARCH_* of syscall */
+		} _sigsys;
 	} _sifields;
 } compat_siginfo_t;
 
diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
index 1b9ad02..5a1ba6e 100644
--- a/arch/arm64/kernel/signal32.c
+++ b/arch/arm64/kernel/signal32.c
@@ -186,6 +186,12 @@ int copy_siginfo_to_user32(compat_siginfo_t __user *to, const siginfo_t *from)
 		err |= __put_user(from->si_uid, &to->si_uid);
 		err |= __put_user((compat_uptr_t)(unsigned long)from->si_ptr, &to->si_ptr);
 		break;
+	case __SI_SYS:
+		err |= __put_user((compat_uptr_t)(unsigned long)
+				from->si_call_addr, &to->si_call_addr);
+		err |= __put_user(from->si_syscall, &to->si_syscall);
+		err |= __put_user(from->si_arch, &to->si_arch);
+		break;
 	default: /* this is just in case for now ... */
 		err |= __put_user(from->si_pid, &to->si_pid);
 		err |= __put_user(from->si_uid, &to->si_uid);
-- 
1.7.9.5

