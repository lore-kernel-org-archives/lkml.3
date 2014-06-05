Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbaFEOet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:34:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48295 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaFEOeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:34:46 -0400
Date: Thu, 5 Jun 2014 07:32:58 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-dbb5eafa23fdb7a00d64b04e23a3efc59d6474cb@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        jason.low2@hp.com, peter@hurleysoftware.com, clm@fb.com,
        riel@redhat.com, alex.shi@linaro.org, akpm@linux-foundation.org,
        aarcange@redhat.com, tglx@linutronix.de, davidlohr@hp.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, andi@firstfloor.org,
        tim.c.chen@linux.intel.com, paulmck@linux.vnet.ibm.com,
        jbacik@fusionio.com, walken@google.com
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, peter@hurleysoftware.com, jason.low2@hp.com,
        clm@fb.com, riel@redhat.com, alex.shi@linaro.org,
        akpm@linux-foundation.org, aarcange@redhat.com, tglx@linutronix.de,
        davidlohr@hp.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        andi@firstfloor.org, tim.c.chen@linux.intel.com,
        paulmck@linux.vnet.ibm.com, jbacik@fusionio.com, walken@google.com
In-Reply-To: <1400545677.6399.10.camel@buesod1.americas.hpqcorp.net>
References: <1400545677.6399.10.camel@buesod1.americas.hpqcorp.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/rwsem:
  Fix warnings for CONFIG_RWSEM_GENERIC_SPINLOCK
Git-Commit-ID: dbb5eafa23fdb7a00d64b04e23a3efc59d6474cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dbb5eafa23fdb7a00d64b04e23a3efc59d6474cb
Gitweb:     http://git.kernel.org/tip/dbb5eafa23fdb7a00d64b04e23a3efc59d6474cb
Author:     Davidlohr Bueso <davidlohr@hp.com>
AuthorDate: Mon, 19 May 2014 17:27:57 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 10:38:45 +0200

locking/rwsem: Fix warnings for CONFIG_RWSEM_GENERIC_SPINLOCK

Optimistic spinning is only used by the xadd variant
of rw-semaphores. Make sure that we use the old version
of the __RWSEM_INITIALIZER macro for systems that rely
on the spinlock one, otherwise warnings can be triggered,
such as the following reported on an arm box:

  ipc/ipcns_notifier.c:22:8: warning: excess elements in struct initializer [enabled by default]
  ipc/ipcns_notifier.c:22:8: warning: (near initialization for 'ipcns_chain.rwsem') [enabled by default]
  ipc/ipcns_notifier.c:22:8: warning: excess elements in struct initializer [enabled by default]
  ipc/ipcns_notifier.c:22:8: warning: (near initialization for 'ipcns_chain.rwsem') [enabled by default]

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Alex Shi <alex.shi@linaro.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason Low <jason.low2@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fusionio.com>
Link: http://lkml.kernel.org/r/1400545677.6399.10.camel@buesod1.americas.hpqcorp.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/rwsem.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 3e108f1..8d79708 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -64,7 +64,7 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 # define __RWSEM_DEP_MAP_INIT(lockname)
 #endif
 
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) && !defined(CONFIG_RWSEM_GENERIC_SPINLOCK)
 #define __RWSEM_INITIALIZER(name)			\
 	{ RWSEM_UNLOCKED_VALUE,				\
 	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
