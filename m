Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934332Ab3ECViW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 17:38:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2527 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932913Ab3ECViT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 17:38:19 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=JeoFf_2MvkQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=HVw-rlg3GMUA:10 a=6ohNodAXAAAA:8 a=VwQbUJbxAAAA:8 a=yyfDmEu5Vw8DcnoQlo0A:9 a=gDjHQkheYgsA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130503213818.087747521@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 03 May 2013 17:37:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>,
        Priyanka Jain <Priyanka.Jain@freescale.com>
Subject: [PATCH RT 3/5] powerpc/64bit,PREEMPT_RT: Check preempt_count before preempting
References: <20130503213703.521223574@goodmis.org>
Content-Disposition: inline; filename=0003-powerpc-64bit-PREEMPT_RT-Check-preempt_count-before-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Priyanka Jain <Priyanka.Jain@freescale.com>

In ret_from_except_lite() with CONFIG_PREEMPT enabled,
add the missing check to compare value of preempt_count
with zero before continuing with preemption process of
the current task.
If preempt_count is non-zero, restore reg and return,
else continue the preemption process.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Priyanka Jain <Priyanka.Jain@freescale.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/kernel/entry_64.S |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index a9b98cc..7af1ea7 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -596,6 +596,8 @@ resume_kernel:
 #ifdef CONFIG_PREEMPT
 	/* Check if we need to preempt */
 	lwz	r8,TI_PREEMPT(r9)
+	cmpwi	0,r8,0		/* if non-zero, just restore regs and return */
+	bne	restore
 	andi.	r0,r4,_TIF_NEED_RESCHED
 	bne+	1f
 
-- 
1.7.10.4


