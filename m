Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab3GKHjC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 03:39:02 -0400
Received: from www.linutronix.de ([62.245.132.108]:36658 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab3GKHjA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 03:39:00 -0400
Date: Thu, 11 Jul 2013 09:38:58 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.8.13-rt14
Message-ID: <20130711073858.GA3695@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.8.13-rt14 release.

changes since v3.8.13-rt13:
- added a patch from Uwe Kleine-König to fix the UP breakage introduced by
  the recent s/sbin spinlocks/raw_spin_lock/ change.
- added a fix for a livelock of workqueue vs ata-piix. Found by Carsten
  Emde, patch proposed by Thomas Gleixner.

The delta patch against v3.8.13-rt13 is appended below and can be found here:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/incr/patch-3.8.13-rt13-rt14.patch.xz

The RT patch against 3.8.13 can be found here:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.8.13-rt14.patch.xz

The split quilt queue is available at:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patches-3.8.13-rt14.tar.xz

Sebastian

diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index ddfd46a..becd7a6 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -131,8 +131,10 @@ static inline void hlist_bl_lock(struct hlist_bl_head *b)
 	bit_spin_lock(0, (unsigned long *)b);
 #else
 	raw_spin_lock(&b->lock);
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
 	__set_bit(0, (unsigned long *)b);
 #endif
+#endif
 }
 
 static inline void hlist_bl_unlock(struct hlist_bl_head *b)
@@ -140,7 +142,9 @@ static inline void hlist_bl_unlock(struct hlist_bl_head *b)
 #ifndef CONFIG_PREEMPT_RT_BASE
 	__bit_spin_unlock(0, (unsigned long *)b);
 #else
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
 	__clear_bit(0, (unsigned long *)b);
+#endif
 	raw_spin_unlock(&b->lock);
 #endif
 }
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0d49ddf..99855b3 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -42,6 +42,7 @@
 #include <linux/lockdep.h>
 #include <linux/idr.h>
 #include <linux/locallock.h>
+#include <linux/delay.h>
 
 #include "workqueue_sched.h"
 
@@ -1157,7 +1158,7 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 	local_unlock_irqrestore(pendingb_lock, *flags);
 	if (work_is_canceling(work))
 		return -ENOENT;
-	cpu_relax();
+	cpu_chill();
 	return -EAGAIN;
 }
 
diff --git a/localversion-rt b/localversion-rt
index 9f7d0bd..08b3e75 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt13
+-rt14
