Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaFFRxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:53:06 -0400
Received: from mxip5-inbound.gatech.edu ([130.207.182.47]:15936 "EHLO
	mxip5-inbound.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaFFRxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:53:03 -0400
X-RemoteIP: 130.207.185.167
X-Group: ZimbraSenderGroup
X-Policy: $ZIMBRA
X-MID: 92091733
X-SBRS: None
X-IronPort-AV: E=Sophos;i="4.98,990,1392181200"; 
   d="scan'208";a="92091733"
X-GT-Spam-Rating: (0%)
Message-ID: <5391FFFD.1060901@gatech.edu>
Date: Fri, 06 Jun 2014 13:53:01 -0400
From: Pranith Kumar <pranith@gatech.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: peterz@infradead.org
CC: linux-kernel@vger.kernel.org, tim.c.chen@linux.intel.com, davidlohr@hp.com,
        mingo@redhat.com
Subject: Re: [RFC PATCH 1/1] cleanup: use bool as return type for rwsem_is_locked
References: <5390D7E1.7060606@gatech.edu>
In-Reply-To: <5390D7E1.7060606@gatech.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 3:35 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> Now in general, I don't particularly like such superfluous changes, so
> unless you can show that GCC actually generates better code, I'd prefer
> to keep things as they are.

Fixed and checked the assembly. It saves us 2 bytes of code, not much. I am not sure if that is worth it :(

use bool as the return type for rwsem_is_locked() instead of int

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 include/linux/rwsem-spinlock.h  |    2 +-
 include/linux/rwsem.h           |    2 +-
 kernel/locking/rwsem-spinlock.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/rwsem-spinlock.h b/include/linux/rwsem-spinlock.h
index d5b13bc..9026d2a 100644
--- a/include/linux/rwsem-spinlock.h
+++ b/include/linux/rwsem-spinlock.h
@@ -39,7 +39,7 @@ extern int __down_write_trylock(struct rw_semaphore *sem);
 extern void __up_read(struct rw_semaphore *sem);
 extern void __up_write(struct rw_semaphore *sem);
 extern void __downgrade_write(struct rw_semaphore *sem);
-extern int rwsem_is_locked(struct rw_semaphore *sem);
+extern bool rwsem_is_locked(struct rw_semaphore *sem);
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_RWSEM_SPINLOCK_H */
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 03f3b05..b056780 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -40,7 +40,7 @@ extern struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem);
 #include <asm/rwsem.h>
 
 /* In all implementations count != 0 means locked */
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
+static inline bool rwsem_is_locked(struct rw_semaphore *sem)
 {
 	return sem->count != 0;
 }
diff --git a/kernel/locking/rwsem-spinlock.c b/kernel/locking/rwsem-spinlock.c
index 9be8a91..3f8adf8 100644
--- a/kernel/locking/rwsem-spinlock.c
+++ b/kernel/locking/rwsem-spinlock.c
@@ -20,9 +20,9 @@ struct rwsem_waiter {
 	enum rwsem_waiter_type type;
 };
 
-int rwsem_is_locked(struct rw_semaphore *sem)
+bool rwsem_is_locked(struct rw_semaphore *sem)
 {
-	int ret = 1;
+	bool ret = true;
 	unsigned long flags;
 
 	if (raw_spin_trylock_irqsave(&sem->wait_lock, flags)) {
-- 
1.7.9.5
