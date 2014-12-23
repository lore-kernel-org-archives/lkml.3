Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbaLWPPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 10:15:15 -0500
Received: from mail-oi0-f54.google.com ([209.85.218.54]:55366 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310AbaLWPPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 10:15:11 -0500
MIME-Version: 1.0
Date: Tue, 23 Dec 2014 23:15:10 +0800
Message-ID: <CAHkaATRdNgcZnAvgKFRmiMEhLOPxFEPpjTu+XNkDk9DxG+4Fpg@mail.gmail.com>
Subject: [PATCH] arm64: setup return path for el1_undef
From: Min-Hua Chen <orca.chen@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Larry Bassel <larry.bassel@linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>, Neil Zhang <zhangwm@marvell.com>
Cc: linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setup return path for el1_undef since el1_undef may
be handled by handlers.

asmlinkage void __exception do_undefinstr(struct pt_regs *regs)
{
    siginfo_t info;
    void __user *pc = (void __user *)instruction_pointer(regs);

    /* check for AArch32 breakpoint instructions */
    if (!aarch32_break_handler(regs))
        return;

    if (call_undef_hook(regs) == 0)
        return;

    ...
}

Signed-off-by: Min-Hua Chen <orca.chen@gmail.com>
---
 arch/arm64/kernel/entry.S |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index fd4fa37..86ebec5 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -313,7 +313,8 @@ el1_undef:
      */
     enable_dbg
     mov    x0, sp
-    b    do_undefinstr
+    bl    do_undefinstr
+    kernel_exit 1
 el1_dbg:
     /*
      * Debug exception handling
-- 
1.7.10.4
