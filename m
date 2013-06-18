Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933356Ab3FRQST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:18:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271Ab3FRQSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:18:07 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 42/48] powerpc: Fix missing/delayed calls to irq_work
Date: Tue, 18 Jun 2013 09:18:08 -0700
Message-Id: <20130618161732.041320108@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
References: <20130618161725.912524266@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 230b3034793247f61e6a0b08c44cf415f6d92981 upstream.

When replaying interrupts (as a result of the interrupt occurring
while soft-disabled), in the case of the decrementer, we are exclusively
testing for a pending timer target. However we also use decrementer
interrupts to trigger the new "irq_work", which in this case would
be missed.

This change the logic to force a replay in both cases of a timer
boundary reached and a decrementer interrupt having actually occurred
while disabled. The former test is still useful to catch cases where
a CPU having been hard-disabled for a long time completely misses the
interrupt due to a decrementer rollover.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -162,7 +162,7 @@ notrace unsigned int __check_irq_replay(
 	 * in case we also had a rollover while hard disabled
 	 */
 	local_paca->irq_happened &= ~PACA_IRQ_DEC;
-	if (decrementer_check_overflow())
+	if ((happened & PACA_IRQ_DEC) || decrementer_check_overflow())
 		return 0x900;
 
 	/* Finally check if an external interrupt happened */


