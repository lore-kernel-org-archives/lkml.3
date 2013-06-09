Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab3FIKIH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 06:08:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47463 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab3FIKHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 06:07:38 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5/5] x86, FPU: Use static_cpu_has_safe before alternatives
Date: Sun,  9 Jun 2013 12:07:34 +0200
Message-Id: <1370772454-6106-6-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1370772454-6106-1-git-send-email-bp@alien8.de>
References: <1370772454-6106-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

The call stack below shows how this happens: basically eager_fpu_init()
calls __thread_fpu_begin(current) which then does if (!use_eager_fpu()),
which, in turn, uses static_cpu_has.

And we're executing before alternatives so static_cpu_has doesn't work
there yet.

Use the safe variant in this path which becomes optimal after
alternatives have run.

WARNING: at arch/x86/kernel/cpu/common.c:1368 warn_pre_alternatives+0x1e/0x20()
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
index e25cc33ec54d..b36f31b18664 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -345,7 +345,7 @@ static inline void __thread_fpu_end(struct task_struct *tsk)
 
 static inline void __thread_fpu_begin(struct task_struct *tsk)
 {
-	if (!use_eager_fpu())
+	if (!static_cpu_has_safe(X86_FEATURE_EAGER_FPU))
 		clts();
 	__thread_set_has_fpu(tsk);
 }
-- 
1.8.3

