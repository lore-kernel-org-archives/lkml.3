Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601Ab3BNNgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 08:36:10 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39102 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757663Ab3BNNgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 08:36:08 -0500
Date: Thu, 14 Feb 2013 13:35:52 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arm64: fix invocation of restore_altstack
Message-ID: <20130214133552.GB25537@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
user-agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I noticed the following issue while attempting to build an arm64 kernel from
next-20130214, and it still seems to be present in signal/for-next and
signal/arch-arm64.

It looks to be a trivial typo.

Thanks,
Mark.

---->8---
Since e6d056c7c0: "arm64: switch to generic sigaltstack", arm64 won't
build:

arch/arm64/kernel/signal.c: In function ‘sys_rt_sigreturn’:
arch/arm64/kernel/signal.c:152:2: error: incompatible type for argument 1 of ‘restore_altstack’
In file included from arch/arm64/kernel/signal.c:21:0:
include/linux/signal.h:434:5: note: expected ‘const struct stack_t *’ but argument is of type ‘stack_t’
make[1]: *** [arch/arm64/kernel/signal.o] Error 1
make: *** [arch/arm64/kernel] Error 2

This patch fixes up the call to restore_altstack to pass the correct
type.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/kernel/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index d60ad23..890a591 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -149,7 +149,7 @@ asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
 	if (restore_sigframe(regs, frame))
 		goto badframe;
 
-	if (restore_altstack(frame->uc.uc_stack))
+	if (restore_altstack(&frame->uc.uc_stack))
 		goto badframe;
 
 	return regs->regs[0];
-- 
1.8.1.1


