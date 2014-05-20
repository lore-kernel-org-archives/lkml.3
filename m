Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaETA4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 20:56:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40151 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaETA4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 20:56:11 -0400
Date: Mon, 19 May 2014 17:54:35 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-eb705905b713837d2cc26dfa019df16aeb8813be@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        jason.low2@hp.com, peter@hurleysoftware.com, riel@redhat.com,
        alex.shi@linaro.org, aarcange@redhat.com, tglx@linutronix.de,
        scott.norton@hp.com, davidlohr@hp.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, andi@firstfloor.org, tim.c.chen@linux.intel.com,
        paulmck@linux.vnet.ibm.com, walken@google.com, aswin@hp.com
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, peter@hurleysoftware.com, jason.low2@hp.com,
        riel@redhat.com, alex.shi@linaro.org, aarcange@redhat.com,
        tglx@linutronix.de, davidlohr@hp.com, scott.norton@hp.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, andi@firstfloor.org,
        tim.c.chen@linux.intel.com, paulmck@linux.vnet.ibm.com,
        walken@google.com, aswin@hp.com
In-Reply-To: <1400545677.6399.10.camel@buesod1.americas.hpqcorp.net>
References: <1400545677.6399.10.camel@buesod1.americas.hpqcorp.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] rwsem:
  Fix warnings for CONFIG_RWSEM_GENERIC_SPINLOCK
Git-Commit-ID: eb705905b713837d2cc26dfa019df16aeb8813be
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

Commit-ID:  eb705905b713837d2cc26dfa019df16aeb8813be
Gitweb:     http://git.kernel.org/tip/eb705905b713837d2cc26dfa019df16aeb8813be
Author:     Davidlohr Bueso <davidlohr@hp.com>
AuthorDate: Mon, 19 May 2014 17:27:57 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 20 May 2014 09:53:11 +0900

rwsem: Fix warnings for CONFIG_RWSEM_GENERIC_SPINLOCK

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
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Alex Shi <alex.shi@linaro.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Norton Scott J <scott.norton@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Chandramouleeswaran Aswin <aswin@hp.com>
Cc: Jason Low <jason.low2@hp.com>
Link: http://lkml.kernel.org/r/1400545677.6399.10.camel@buesod1.americas.hpqcorp.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
