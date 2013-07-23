Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935241Ab3GWW7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:59:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934151Ab3GWW04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:26:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>,
        Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 002/103] powerpc/hw_brk: Fix clearing of extraneous IRQ
Date: Tue, 23 Jul 2013 15:25:13 -0700
Message-Id: <20130723220418.839450369@linuxfoundation.org>
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

commit 540e07c67efe42ef6b6be4f1956931e676d58a15 upstream.

In 9422de3 "powerpc: Hardware breakpoints rewrite to handle non DABR breakpoint
registers" we changed the way we mark extraneous irqs with this:

-	info->extraneous_interrupt = !((bp->attr.bp_addr <= dar) &&
-			(dar - bp->attr.bp_addr < bp->attr.bp_len));
+	if (!((bp->attr.bp_addr <= dar) &&
+	      (dar - bp->attr.bp_addr < bp->attr.bp_len)))
+		info->type |= HW_BRK_TYPE_EXTRANEOUS_IRQ;

Unfortunately this is bogus as it never clears extraneous IRQ if it's already
set.

This correctly clears extraneous IRQ before possibly setting it.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Reported-by: Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/hw_breakpoint.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/kernel/hw_breakpoint.c
+++ b/arch/powerpc/kernel/hw_breakpoint.c
@@ -250,6 +250,7 @@ int __kprobes hw_breakpoint_handler(stru
 	 * we still need to single-step the instruction, but we don't
 	 * generate an event.
 	 */
+	info->type &= ~HW_BRK_TYPE_EXTRANEOUS_IRQ;
 	if (!((bp->attr.bp_addr <= dar) &&
 	      (dar - bp->attr.bp_addr < bp->attr.bp_len)))
 		info->type |= HW_BRK_TYPE_EXTRANEOUS_IRQ;


