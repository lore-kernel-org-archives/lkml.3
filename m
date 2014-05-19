Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbaESVrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:47:41 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:1359 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaESVrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:47:40 -0400
Message-ID: <1400536056.6399.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [tip:locking/core] rwsem: Support optimistic spinning
From: Davidlohr Bueso <davidlohr@hp.com>
To: mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        peter@hurleysoftware.com, jason.low2@hp.com, alex.shi@linaro.org,
        riel@redhat.com, akpm@linux-foundation.org, aarcange@redhat.com,
        tglx@linutronix.de, scott.norton@hp.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, andi@firstfloor.org, tim.c.chen@linux.intel.com,
        paulmck@linux.vnet.ibm.com, walken@google.com, aswin@hp.com
Cc: linux-tip-commits@vger.kernel.org
Date: Mon, 19 May 2014 14:47:36 -0700
In-Reply-To: <tip-746c198007a8a5a155c4f74cb42f9a36f55272cf@git.kernel.org>
References: <1399055055.6275.15.camel@buesod1.americas.hpqcorp.net>
	 <tip-746c198007a8a5a155c4f74cb42f9a36f55272cf@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew had put this patch in -next for a while, and Stephen Rothwell was
able to trigger some warnings: https://lkml.org/lkml/2014/5/19/627

8<----------------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH] rwsem: Fix warnings for CONFIG_RWSEM_GENERIC_SPINLOCK

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
---
 include/linux/rwsem.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 3e108f1..091d993 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -64,7 +64,7 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 # define __RWSEM_DEP_MAP_INIT(lockname)
 #endif
 
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) && defined(CONFIG_RWSEM_XCHGADD_ALGORITHM)
 #define __RWSEM_INITIALIZER(name)			\
 	{ RWSEM_UNLOCKED_VALUE,				\
 	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
-- 
1.8.1.4



