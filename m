Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354Ab3GaJAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:00:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41751 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759229Ab3GaI4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:56:51 -0400
Date: Wed, 31 Jul 2013 01:55:48 -0700
From: tip-bot for Xie XiuQi <tipbot@zytor.com>
Message-ID: <tip-46591962cb5bfd2bfb0baf42497119c816503598@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, jens.axboe@oracle.com,
        paulmck@linux.vnet.ibm.com, npiggin@suse.de, xiexiuqi@huawei.com,
        tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, jens.axboe@oracle.com, npiggin@suse.de,
        paulmck@linux.vnet.ibm.com, xiexiuqi@huawei.com, oleg@redhat.com,
        tglx@linutronix.de
In-Reply-To: <51F72DA1.7010401@huawei.com>
References: <51F72DA1.7010401@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] generic-ipi:
  Kill unnecessary variable - csd_flags
Git-Commit-ID: 46591962cb5bfd2bfb0baf42497119c816503598
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 31 Jul 2013 01:55:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46591962cb5bfd2bfb0baf42497119c816503598
Gitweb:     http://git.kernel.org/tip/46591962cb5bfd2bfb0baf42497119c816503598
Author:     Xie XiuQi <xiexiuqi@huawei.com>
AuthorDate: Tue, 30 Jul 2013 11:06:09 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Jul 2013 22:19:05 +0200

generic-ipi: Kill unnecessary variable - csd_flags

After commit 8969a5ede0f9e17da4b943712429aef2c9bcd82b
("generic-ipi: remove kmalloc()"), wait = 0 can be guaranteed,
and all callsites of generic_exec_single() do an unconditional
csd_lock() now.

So csd_flags is unnecessary now. Remove it.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Link: http://lkml.kernel.org/r/51F72DA1.7010401@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/smp.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index fe9f773..7332697 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -186,25 +186,13 @@ void generic_smp_call_function_single_interrupt(void)
 
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
 
