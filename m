Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbaAVOMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 09:12:20 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41426 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbaAVOLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:11:42 -0500
From: Jean Pihet <jean.pihet@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo <acme@ghostprotocols.net>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Will Deacon <will.deacon@arm.com>
Cc: patches@linaro.org, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 4/4] ARM64: perf: support dwarf unwinding in compat mode
Date: Wed, 22 Jan 2014 15:11:19 +0100
Message-Id: <1390399879-5109-5-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1390399879-5109-1-git-send-email-jean.pihet@linaro.org>
References: <1390399879-5109-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for unwinding using the dwarf information in compat
mode. Using the correct user stack pointer allows perf to record
the frames correctly in the native and compat modes.

Note that although the dwarf frame unwinding works ok using
libunwind in native mode (on ARMv7 & ARMv8), some changes are
required to the libunwind code for the compat mode. Those changes
are posted separately on the libunwind mailing list.

Tested on ARMv8 platform with v8 and compat v7 binaries, the latter
are statically built.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
---
 arch/arm64/include/asm/compat.h | 2 +-
 arch/arm64/include/asm/ptrace.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index fda2704..e71f81f 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -228,7 +228,7 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
 	return (u32)(unsigned long)uptr;
 }
 
-#define compat_user_stack_pointer() (current_pt_regs()->compat_sp)
+#define compat_user_stack_pointer() (user_stack_pointer(current_pt_regs()))
 
 static inline void __user *arch_compat_alloc_user_space(long len)
 {
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index fbb0020..86d5b54 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -133,7 +133,7 @@ struct pt_regs {
 	(!((regs)->pstate & PSR_F_BIT))
 
 #define user_stack_pointer(regs) \
-	((regs)->sp)
+	(!compat_user_mode(regs)) ? ((regs)->sp) : ((regs)->compat_sp)
 
 /*
  * Are the current registers suitable for user mode? (used to maintain
-- 
1.7.11.7

