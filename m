Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab3GEQ37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 12:29:59 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:42371 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757369Ab3GEQ3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 12:29:55 -0400
Subject: [PATCH 3/3] smp/ipi:Remove check around csd lock in handler for
 smp_call_function variants
To: xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: npiggin@suse.de, deepthi@linux.vnet.ibm.com, peterz@infradead.org,
        rusty@rustcorp.com.au, heiko.carstens@de.ibm.com, udknight@gmail.com,
        rostedt@goodmis.org, miltonm@bga.com, srivatsa.bhat@linux.vnet.ibm.com,
        jens.axboe@oracle.com, tj@kernel.org, akpm@linux-foundation.org,
        svaidy@linux.vnet.ibm.com, shli@kernel.org, tglx@linutronix.de,
        lig.fnst@cn.fujitsu.com, anton@samba.org
Date: Fri, 05 Jul 2013 21:57:21 +0530
Message-ID: <20130705162720.16888.81958.stgit@preeti.in.ibm.com>
In-Reply-To: <20130705162548.16888.18957.stgit@preeti.in.ibm.com>
References: <20130705162548.16888.18957.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070516-1618-0000-0000-00000436A866
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

call_single_data is always locked by all callers of
arch_send_call_function_single_ipi() or
arch_send_call_function_ipi_mask() which results in execution of
generic_call_function_interrupt() handler.

Hence remove the check for lock on csd in generic_call_function_interrupt()
handler, before unlocking it.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: srivatsa.bhat@linux.vnet.ibm.com
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au
---

 kernel/smp.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index b6981ae..d37581a 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -181,25 +181,13 @@ void generic_smp_call_function_single_interrupt(void)
 
 	while (!list_empty(&list)) {
 		struct call_single_data *csd;
-		unsigned int csd_flags;
 
 		csd = list_entry(list.next, struct call_single_data, list);
 		list_del(&csd->list);
 
-		/*
-		 * 'csd' can be invalid after this call if flags == 0
-		 * (when called through generic_exec_single()),
-		 * so save them away before making the call:
-		 */
-		csd_flags = csd->flags;
-
 		csd->func(csd->info);
 
-		/*
-		 * Unlocked CSDs are valid through generic_exec_single():
-		 */
-		if (csd_flags & CSD_FLAG_LOCK)
-			csd_unlock(csd);
+		csd_unlock(csd);
 	}
 }
 

