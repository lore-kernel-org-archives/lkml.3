Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab3FEVuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:50:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37949 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932970Ab3FEVfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Priyanka Jain <Priyanka.Jain@freescale.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 082/127] powerpc/32bit:Store temporary result in r0 instead of r8
Date: Wed,  5 Jun 2013 14:34:09 -0700
Message-Id: <20130605213227.250102346@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/entry_32.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


