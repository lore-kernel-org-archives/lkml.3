Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaFPLsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:48:40 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:44627 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaFPLsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:48:39 -0400
Message-ID: <539ED993.80807@acm.org>
Date: Mon, 16 Jun 2014 13:48:35 +0200
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] spin_lock_*(): Always evaluate second argument
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evaluating a macro argument only if certain configuration options
have been selected is confusing and error-prone. Hence always
evaluate the second argument of spin_lock_nested() and
spin_lock_nest_lock().

This patch has the intentional side effect that it avoids that the
following warning is reported for netif_addr_lock_nested() when
building with CONFIG_DEBUG_LOCK_ALLOC=n and with W=1:

include/linux/netdevice.h: In function 'netif_addr_lock_nested':
include/linux/netdevice.h:2865:6: warning: variable 'subclass' set but not used [-Wunused-but-set-variable]
  int subclass = SINGLE_DEPTH_NESTING;
      ^

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David S. Miller <davem@davemloft.net>
---
 include/linux/spinlock.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 3f2867f..32b16cc 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -197,8 +197,10 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
 		 _raw_spin_lock_nest_lock(lock, &(nest_lock)->dep_map);	\
 	 } while (0)
 #else
-# define raw_spin_lock_nested(lock, subclass)		_raw_spin_lock(lock)
-# define raw_spin_lock_nest_lock(lock, nest_lock)	_raw_spin_lock(lock)
+# define raw_spin_lock_nested(lock, subclass)		\
+	((void)(subclass), _raw_spin_lock(lock))
+# define raw_spin_lock_nest_lock(lock, nest_lock)	\
+	((void)(nest_lock), _raw_spin_lock(lock))
 #endif
 
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-- 
1.8.4.5

