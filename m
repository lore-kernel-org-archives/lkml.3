Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab3L2CZl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:25:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55555 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753277Ab3L2CLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:11:02 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Michael Neuling" <mikey@neuling.org>,
        "Haren Myneni" <haren@linux.vnet.ibm.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.585624167@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 081/185] powerpc/signals: Mark VSX not saved with
 small contexts
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/signal_32.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -457,7 +457,15 @@ static int save_user_regs(struct pt_regs
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

