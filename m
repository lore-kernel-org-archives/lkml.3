Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935189Ab3GWW6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:58:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41471 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934449Ab3GWW1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 008/103] powerpc/tm: Fix return of 32bit rt signals to active transactions
Date: Tue, 23 Jul 2013 15:25:19 -0700
Message-Id: <20130723220419.493369153@linuxfoundation.org>
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

commit 55e4341850ac56e63a3eefe9583a9000042164fa upstream.

Currently we only restore signals which are transactionally suspended but it's
possible that the transaction can be restored even when it's active.  Most
likely this will result in a transactional rollback by the hardware as the
transaction will have been doomed by an earlier treclaim.

The current code is a legacy of earlier kernel implementations which did
software rollback of active transactions in the kernel.  That code has now gone
but we didn't correctly fix up this part of the signals code which still makes
assumptions based on having software rollback.

This changes the signal return code to always restore both contexts on 32 bit
rt signal return.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/signal_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -1245,7 +1245,7 @@ long sys_rt_sigreturn(int r3, int r4, in
 		if (__get_user(msr_hi, &mcp->mc_gregs[PT_MSR]))
 			goto bad;
 
-		if (MSR_TM_SUSPENDED(msr_hi<<32)) {
+		if (MSR_TM_ACTIVE(msr_hi<<32)) {
 			/* We only recheckpoint on return if we're
 			 * transaction.
 			 */


