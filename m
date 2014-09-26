Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbaIZJqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:46:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070AbaIZJqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:37 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Huacai Chen <chenhc@lemote.com>,
        Jie Chen <chenj@lemote.com>, Rui Wang <wangr@lemote.com>,
        John Crispin <john@phrozen.org>,
        "Steven J. Hill" <Steven.Hill@imgtec.com>, linux-mips@linux-mips.org,
        Fuxin Zhang <zhangfx@lemote.com>, Zhangjin Wu <wuzhangjin@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 071/142] MIPS: Remove BUG_ON(!is_fpu_owner()) in do_ade()
Date: Fri, 26 Sep 2014 11:44:42 +0200
Message-Id: <6540a038754f78f73075f906ce42c04f84297e3e.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2e5767a27337812f6850b3fa362419e2f085e5c3 upstream.

In do_ade(), is_fpu_owner() isn't preempt-safe. For example, when an
unaligned ldc1 is executed, do_cpu() is called and then FPU will be
enabled (and TIF_USEDFPU will be set for the current process). Then,
do_ade() is called because the access is unaligned.  If the current
process is preempted at this time, TIF_USEDFPU will be cleard.  So when
the process is scheduled again, BUG_ON(!is_fpu_owner()) is triggered.

This small program can trigger this BUG in a preemptible kernel:

int main (int argc, char *argv[])
{
        double u64[2];

        while (1) {
                asm volatile (
                        ".set push \n\t"
                        ".set noreorder \n\t"
                        "ldc1 $f3, 4(%0) \n\t"
                        ".set pop \n\t"
                        ::"r"(u64):
                );
        }

        return 0;
}

V2: Remove the BUG_ON() unconditionally due to Paul's suggestion.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Jie Chen <chenj@lemote.com>
Signed-off-by: Rui Wang <wangr@lemote.com>
Cc: John Crispin <john@phrozen.org>
Cc: Steven J. Hill <Steven.Hill@imgtec.com>
Cc: linux-mips@linux-mips.org
Cc: Fuxin Zhang <zhangfx@lemote.com>
Cc: Zhangjin Wu <wuzhangjin@gmail.com>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/mips/kernel/unaligned.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/mips/kernel/unaligned.c b/arch/mips/kernel/unaligned.c
index c369a5d35527..b897dde93e7a 100644
--- a/arch/mips/kernel/unaligned.c
+++ b/arch/mips/kernel/unaligned.c
@@ -605,7 +605,6 @@ static void emulate_load_store_insn(struct pt_regs *regs,
 	case sdc1_op:
 		die_if_kernel("Unaligned FP access in kernel code", regs);
 		BUG_ON(!used_math());
-		BUG_ON(!is_fpu_owner());
 
 		lose_fpu(1);	/* Save FPU state for the emulator. */
 		res = fpu_emulator_cop1Handler(regs, &current->thread.fpu, 1,
-- 
2.1.0

