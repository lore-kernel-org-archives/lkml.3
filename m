Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaEAAuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:50:08 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:57673 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751060AbaEAAuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:50:06 -0400
Message-Id: <20140501005004.241785945@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 30 Apr 2014 20:47:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Nicholas Mc Guire <der.herr@hofr.at>,
        Clark Williams <williams@redhat.com>
Subject: [PATCH RT 1/3] rt: Move migrate_disable up in trylocks
References: <20140501004757.583708392@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-rt-Move-migrate_disable-up-in-trylocks.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12.15-rt26-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

The changes to move the migrate_disable() down in the trylocks()
caused race conditions to appear in the cpu hotplug code. The
migrate disables must be done before any of the rtmutexes are
taken, otherwise a lock may be held that prevents hotplug from
moving forward.

Link: http://lkml.kernel.org/r/20140429201308.63292691@gandalf.local.home

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
Cc: Clark Williams <williams@redhat.com>
---
 kernel/rt.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/kernel/rt.c b/kernel/rt.c
index 5d17727..5f44def 100644
--- a/kernel/rt.c
+++ b/kernel/rt.c
@@ -180,12 +180,15 @@ EXPORT_SYMBOL(_mutex_unlock);
  */
 int __lockfunc rt_write_trylock(rwlock_t *rwlock)
 {
-	int ret = rt_mutex_trylock(&rwlock->lock);
+	int ret;
+
+	migrate_disable();
+	ret = rt_mutex_trylock(&rwlock->lock);
 
-	if (ret) {
+	if (ret)
 		rwlock_acquire(&rwlock->dep_map, 0, 1, _RET_IP_);
-		migrate_disable();
-	}
+	else
+		migrate_enable();
 
 	return ret;
 }
@@ -212,11 +215,12 @@ int __lockfunc rt_read_trylock(rwlock_t *rwlock)
 	 * write locked.
 	 */
 	if (rt_mutex_owner(lock) != current) {
+		migrate_disable();
 		ret = rt_mutex_trylock(lock);
-		if (ret) {
+		if (ret)
 			rwlock_acquire(&rwlock->dep_map, 0, 1, _RET_IP_);
-			migrate_disable();
-		}
+		else
+			migrate_enable();
 	} else if (!rwlock->read_depth) {
 		ret = 0;
 	}
@@ -245,8 +249,8 @@ void __lockfunc rt_read_lock(rwlock_t *rwlock)
 	 */
 	if (rt_mutex_owner(lock) != current) {
 		rwlock_acquire(&rwlock->dep_map, 0, 0, _RET_IP_);
-		__rt_spin_lock(lock);
 		migrate_disable();
+		__rt_spin_lock(lock);
 	}
 	rwlock->read_depth++;
 }
-- 
1.8.5.3


