Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab3FDQ7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:59:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48320 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207Ab3FDQ7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:59:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Priyanka Jain <Priyanka.Jain@freescale.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 74/75] powerpc/32bit:Store temporary result in r0 instead of r8
Date: Tue,  4 Jun 2013 09:55:58 -0700
Message-Id: <1370364959-9475-75-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Priyanka Jain <Priyanka.Jain@freescale.com>

commit f7b3367774f92a688d39ed767f0ae9b93af7873a upstream.

Commit a9c4e541ea9b22944da356f2a9258b4eddcc953b
"powerpc/kprobe: Complete kprobe and migrate exception frame"
introduced a regression:

While returning from exception handling in case of PREEMPT enabled,
_TIF_NEED_RESCHED bit is checked in TI_FLAGS (thread_info flag) of current
task. Only if this bit is set, it should continue with the process of
calling preempt_schedule_irq() to schedule highest priority task if
available.

Current code assumes that r8 contains TI_FLAGS and check this for
_TIF_NEED_RESCHED, but as r8 is modified in the code which executes before
this check, r8 no longer contains the expected TI_FLAGS information.

As a result check for comparison with _TIF_NEED_RESCHED was failing even if
NEED_RESCHED bit is set in the current thread_info flag. Due to this,
preempt_schedule_irq() and in turn scheduler was not getting called even if
highest priority task is ready for execution.

So, store temporary results in r0 instead of r8 to prevent r8 from getting
modified as subsequent code is dependent on its value.

Signed-off-by: Priyanka Jain <Priyanka.Jain@freescale.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/kernel/entry_32.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index e514de5..4498467 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -851,7 +851,7 @@ resume_kernel:
 	/* check current_thread_info, _TIF_EMULATE_STACK_STORE */
 	CURRENT_THREAD_INFO(r9, r1)
 	lwz	r8,TI_FLAGS(r9)
-	andis.	r8,r8,_TIF_EMULATE_STACK_STORE@h
+	andis.	r0,r8,_TIF_EMULATE_STACK_STORE@h
 	beq+	1f
 
 	addi	r8,r1,INT_FRAME_SIZE	/* Get the kprobed function entry */
-- 
1.8.1.2

