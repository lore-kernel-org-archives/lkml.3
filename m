Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965863Ab3FUAwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:52:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52110 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422893Ab3FUAwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:52:15 -0400
Date: Thu, 20 Jun 2013 17:52:02 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-5f8c4218148822fde6eebbeefc34bd0a6061e031@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de, hpa@linux.intel.com
In-Reply-To: <1370772454-6106-6-git-send-email-bp@alien8.de>
References: <1370772454-6106-6-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu:
  Use static_cpu_has_safe before alternatives
Git-Commit-ID: 5f8c4218148822fde6eebbeefc34bd0a6061e031
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Jun 2013 17:52:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5f8c4218148822fde6eebbeefc34bd0a6061e031
Gitweb:     http://git.kernel.org/tip/5f8c4218148822fde6eebbeefc34bd0a6061e031
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Sun, 9 Jun 2013 12:07:34 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 20 Jun 2013 17:38:22 -0700

x86, fpu: Use static_cpu_has_safe before alternatives

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
Link: http://lkml.kernel.org/r/1370772454-6106-6-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/fpu-internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index fb808d7..4d0bda7 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -343,7 +343,7 @@ static inline void __thread_fpu_end(struct task_struct *tsk)
 
 static inline void __thread_fpu_begin(struct task_struct *tsk)
 {
-	if (!use_eager_fpu())
+	if (!static_cpu_has_safe(X86_FEATURE_EAGER_FPU))
 		clts();
 	__thread_set_has_fpu(tsk);
 }
