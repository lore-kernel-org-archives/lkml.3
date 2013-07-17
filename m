Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab3GQW4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:56:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56802 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934588Ab3GQW4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:56:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 036/145] powerpc/hw_brk: Fix setting of length for exact mode breakpoints
Date: Wed, 17 Jul 2013 15:46:08 -0700
Message-Id: <1374101277-7915-37-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit b0b0aa9c7faf94e92320eabd8a1786c7747e40a8 upstream.

The smallest match region for both the DABR and DAWR is 8 bytes, so the
kernel needs to filter matches when users want to look at regions smaller than
this.

Currently we set the length of PPC_BREAKPOINT_MODE_EXACT breakpoints to 8.
This is wrong as in exact mode we should only match on 1 address, hence the
length should be 1.

This ensures that the kernel will filter out any exact mode hardware breakpoint
matches on any addresses other than the requested one.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Reported-by: Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/ptrace.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index c497000..33ff9be 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -1413,7 +1413,9 @@ static long ppc_set_hwdebug(struct task_struct *child,
 	 */
 	if (bp_info->addr_mode == PPC_BREAKPOINT_MODE_RANGE_INCLUSIVE) {
 		len = bp_info->addr2 - bp_info->addr;
-	} else if (bp_info->addr_mode != PPC_BREAKPOINT_MODE_EXACT) {
+	} else if (bp_info->addr_mode == PPC_BREAKPOINT_MODE_EXACT)
+		len = 1;
+	else {
 		ptrace_put_breakpoints(child);
 		return -EINVAL;
 	}
-- 
1.8.1.2

