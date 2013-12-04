Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3LDF4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 00:56:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:14304 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab3LDF4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 00:56:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,822,1378882800"; 
   d="scan'208";a="444270640"
Subject: [PATCH] locking: Giving mutex warning more precisely in case of
 !lock->owner
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: peterz@infradead.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Dec 2013 13:58:13 +0800
Message-ID: <1386136693.3650.48.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When enabling mutex debugging, in case the imbalanced mutex_unlock()
is called, we still get the warning like below:
[  364.208284] DEBUG_LOCKS_WARN_ON(lock->owner != current)

But in that case, it is due to imbalanced mutex_unlock calling, and
the lock->owner is NULL.

Here we can enhance the case to give the warning as below:
 DEBUG_LOCKS_WARN_ON(lock->owner == NULL)

Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
---
 kernel/locking/mutex-debug.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/locking/mutex-debug.c b/kernel/locking/mutex-debug.c
index 7e3443f..b2a1b96 100644
--- a/kernel/locking/mutex-debug.c
+++ b/kernel/locking/mutex-debug.c
@@ -75,7 +75,12 @@ void debug_mutex_unlock(struct mutex *lock)
 		return;
 
 	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
-	DEBUG_LOCKS_WARN_ON(lock->owner != current);
+
+	if (!lock->owner)
+		DEBUG_LOCKS_WARN_ON(lock->owner == NULL);
+	else
+		DEBUG_LOCKS_WARN_ON(lock->owner != current);
+
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
 	mutex_clear_owner(lock);
 }
-- 
1.7.9.5



