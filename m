Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab3D2OEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 10:04:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54449 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690Ab3D2OEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 10:04:33 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 3/3] x86, FPU: Do not use static_cpu_has before alternatives
Date: Mon, 29 Apr 2013 16:04:22 +0200
Message-Id: <1367244262-29511-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3.rc0
In-Reply-To: <1367244262-29511-1-git-send-email-bp@alien8.de>
References: <1367244262-29511-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

The call stack below shows how this happens: basically eager_fpu_init()
calls __thread_fpu_begin(current) which then does if (!use_eager_fpu()),
which, in turn, uses static_cpu_has.

And we're executing before alternatives so static_cpu_has doesn't work
there yet.

However, I don't want to cause the penalty of not using static_cpu_has
to all callers of use_eager_fpu() which are a bunch spread around the
tree so let's add the change only to __thread_fpu_begin() - it is still
on the context switch path but we can at least keep the static_cpu_has
call in the rest of the use_eager_fpu() callsites.

WARNING: at arch/x86/kernel/cpu/common.c:1368 warn_pre_alternatives+0x1e/0x20()
Hardware name: 2320CTO
You're using static_cpu_has before alternatives have run!
Modules linked in:
Pid: 0, comm: swapper Not tainted 3.9.0-rc8+ #1
Call Trace:
 warn_slowpath_common
 warn_slowpath_fmt
 ? fpu_finit
 warn_pre_alternatives
 eager_fpu_init
 fpu_init
 cpu_init
 trap_init
 start_kernel
 ? repair_env_string
 x86_64_start_reservations
 x86_64_start_kernel

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/fpu-internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index fb808d71cd70..0e34793aafd4 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -343,7 +343,7 @@ static inline void __thread_fpu_end(struct task_struct *tsk)
 
 static inline void __thread_fpu_begin(struct task_struct *tsk)
 {
-	if (!use_eager_fpu())
+	if (!cpu_has_eager_fpu)
 		clts();
 	__thread_set_has_fpu(tsk);
 }
-- 
1.8.3.rc0

