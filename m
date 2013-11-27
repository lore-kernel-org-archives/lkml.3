Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261Ab3K0BIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:08:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758750Ab3K0A76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Haren Myneni <haren@linux.vnet.ibm.com>,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.12 091/116] powerpc/signals: Mark VSX not saved with small contexts
Date: Tue, 26 Nov 2013 16:57:44 -0800
Message-Id: <20131127005743.199255331@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/signal_32.c |   10 +++++++++-
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


