Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbaGBRPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:15:43 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:19168 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755560AbaGBROf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 13:14:35 -0400
Message-Id: <20140702171433.467774026@goodmis.org>
User-Agent: quilt/0.63-1
Date: Wed, 02 Jul 2014 13:14:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        stable-rt@vger.kernel.org
Subject: [PATCH RT 1/4] Revert "migrate_disable pushd down in atomic_dec_and_spin_lock"
References: <20140702171414.482562827@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-Revert-migrate_disable-pushd-down-in-atomic_dec_and_.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12.22-rt35-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

This reverts commit ff9c870c3e27d58c9512fad122e91436681fee5a.
Cc: stable-rt@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rtmutex.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 4057bc607923..d1b2ca08b160 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -952,12 +952,12 @@ int atomic_dec_and_spin_lock(atomic_t *atomic, spinlock_t *lock)
 	/* Subtract 1 from counter unless that drops it to 0 (ie. it was 1) */
 	if (atomic_add_unless(atomic, -1, 1))
 		return 0;
+	migrate_disable();
 	rt_spin_lock(lock);
-	if (atomic_dec_and_test(atomic)){
-		migrate_disable();
+	if (atomic_dec_and_test(atomic))
 		return 1;
-	}
 	rt_spin_unlock(lock);
+	migrate_enable();
 	return 0;
 }
 EXPORT_SYMBOL(atomic_dec_and_spin_lock);
-- 
2.0.0


