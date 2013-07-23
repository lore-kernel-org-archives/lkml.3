Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935201Ab3GWW6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:58:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934437Ab3GWW1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>,
        Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 001/103] powerpc/hw_brk: Fix setting of length for exact mode breakpoints
Date: Tue, 23 Jul 2013 15:25:12 -0700
Message-Id: <20130723220418.740673542@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/ptrace.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -1449,7 +1449,9 @@ static long ppc_set_hwdebug(struct task_
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


