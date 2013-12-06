Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab3LFOQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:16:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43688 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161185Ab3LFNAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:00:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 036/272] powerpc/signals: Mark VSX not saved with small contexts
Date: Fri,  6 Dec 2013 12:55:25 +0000
Message-Id: <1386334761-25517-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit c13f20ac48328b05cd3b8c19e31ed6c132b44b42 upstream.

The VSX MSR bit in the user context indicates if the context contains VSX
state.  Currently we set this when the process has touched VSX at any stage.

Unfortunately, if the user has not provided enough space to save the VSX state,
we can't save it but we currently still set the MSR VSX bit.

This patch changes this to clear the MSR VSX bit when the user doesn't provide
enough space.  This indicates that there is no valid VSX state in the user
context.

This is needed to support get/set/make/swapcontext for applications that use
VSX but only provide a small context.  For example, getcontext in glibc
provides a smaller context since the VSX registers don't need to be saved over
the glibc function call.  But since the program calling getcontext may have
used VSX, the kernel currently says the VSX state is valid when it's not.  If
the returned context is then used in setcontext (ie. a small context without
VSX but with MSR VSX set), the kernel will refuse the context.  This situation
has been reported by the glibc community.

Based on patch from Carlos O'Donell.

Tested-by: Haren Myneni <haren@linux.vnet.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/signal_32.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index 0f83122..3233099 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -454,7 +454,15 @@ static int save_user_regs(struct pt_regs *regs, struct mcontext __user *frame,
 		if (copy_vsx_to_user(&frame->mc_vsregs, current))
 			return 1;
 		msr |= MSR_VSX;
-	}
+	} else if (!ctx_has_vsx_region)
+		/*
+		 * With a small context structure we can't hold the VSX
+		 * registers, hence clear the MSR value to indicate the state
+		 * was not saved.
+		 */
+		msr &= ~MSR_VSX;
+
+
 #endif /* CONFIG_VSX */
 #ifdef CONFIG_SPE
 	/* save spe registers */
-- 
1.8.3.2

