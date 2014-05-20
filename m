Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaETA2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 20:28:04 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:59733 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaETA2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 20:28:01 -0400
Message-ID: <1400545677.6399.10.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [tip:locking/core] rwsem: Support optimistic spinning
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jason Low <jason.low2@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Alex Shi <alex.shi@linaro.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        linux-tip-commits@vger.kernel.org
Date: Mon, 19 May 2014 17:27:57 -0700
In-Reply-To: <CAGQ1y=6KSQaSfv4yHp4S1vbDHR2Osa+XpCyk7w9-SbPMpnae6Q@mail.gmail.com>
References: <1399055055.6275.15.camel@buesod1.americas.hpqcorp.net>
	 <tip-746c198007a8a5a155c4f74cb42f9a36f55272cf@git.kernel.org>
	 <1400536056.6399.3.camel@buesod1.americas.hpqcorp.net>
	 <1400539179.6399.7.camel@buesod1.americas.hpqcorp.net>
	 <CAGQ1y=6KSQaSfv4yHp4S1vbDHR2Osa+XpCyk7w9-SbPMpnae6Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So if given the choice between the 2, I think checking
> !CONFIG_RWSEM_GENERIC_SPINLOCK is better just because we use that to
> decide the implementation/structure layout.

Yeah, I suspect this is more suitable as well. Thanks.

8<---------------------------------------------
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
-- 
1.8.1.4



