Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab3CAT62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:58:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab3CATqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Seiji Aguchi <seiji.aguchi@hds.com>, Don Zickus <dzickus@redhat.com>,
        Tony Luck <tony.luck@intel.com>, CAI Qian <caiqian@redhat.com>
Subject: [ 34/46] pstore: Avoid deadlock in panic and emergency-restart path
Date: Fri,  1 Mar 2013 11:45:22 -0800
Message-Id: <20130301194435.868452642@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194432.263409302@linuxfoundation.org>
References: <20130301194432.263409302@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seiji Aguchi <seiji.aguchi@hds.com>

commit 9f244e9cfd70c7c0f82d3c92ce772ab2a92d9f64 upstream.

[Issue]

When pstore is in panic and emergency-restart paths, it may be blocked
in those paths because it simply takes spin_lock.

This is an example scenario which pstore may hang up in a panic path:

 - cpuA grabs psinfo->buf_lock
 - cpuB panics and calls smp_send_stop
 - smp_send_stop sends IRQ to cpuA
 - after 1 second, cpuB gives up on cpuA and sends an NMI instead
 - cpuA is now in an NMI handler while still holding buf_lock
 - cpuB is deadlocked

This case may happen if a firmware has a bug and
cpuA is stuck talking with it more than one second.

Also, this is a similar scenario in an emergency-restart path:

 - cpuA grabs psinfo->buf_lock and stucks in a firmware
 - cpuB kicks emergency-restart via either sysrq-b or hangcheck timer.
   And then, cpuB is deadlocked by taking psinfo->buf_lock again.

[Solution]

This patch avoids the deadlocking issues in both panic and emergency_restart
paths by introducing a function, is_non_blocking_path(), to check if a cpu
can be blocked in current path.

With this patch, pstore is not blocked even if another cpu has
taken a spin_lock, in those paths by changing from spin_lock_irqsave
to spin_trylock_irqsave.

In addition, according to a comment of emergency_restart() in kernel/sys.c,
spin_lock shouldn't be taken in an emergency_restart path to avoid
deadlock. This patch fits the comment below.

<snip>
/**
 *      emergency_restart - reboot the system
 *
 *      Without shutting down any hardware or taking any locks
 *      reboot the system.  This is called when we know we are in
 *      trouble so this is our best effort to reboot.  This is
 *      safe to call in interrupt context.
 */
void emergency_restart(void)
<snip>

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/pstore/platform.c   |   35 +++++++++++++++++++++++++++++------
 include/linux/pstore.h |    6 ++++++
 2 files changed, 35 insertions(+), 6 deletions(-)

--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -88,6 +88,27 @@ static const char *get_reason_str(enum k
 	}
 }
 
+bool pstore_cannot_block_path(enum kmsg_dump_reason reason)
+{
+	/*
+	 * In case of NMI path, pstore shouldn't be blocked
+	 * regardless of reason.
+	 */
+	if (in_nmi())
+		return true;
+
+	switch (reason) {
+	/* In panic case, other cpus are stopped by smp_send_stop(). */
+	case KMSG_DUMP_PANIC:
+	/* Emergency restart shouldn't be blocked by spin lock. */
+	case KMSG_DUMP_EMERG:
+		return true;
+	default:
+		return false;
+	}
+}
+EXPORT_SYMBOL_GPL(pstore_cannot_block_path);
+
 /*
  * callback from kmsg_dump. (s2,l2) has the most recently
  * written bytes, older bytes are in (s1,l1). Save as much
@@ -111,10 +132,12 @@ static void pstore_dump(struct kmsg_dump
 
 	why = get_reason_str(reason);
 
-	if (in_nmi()) {
-		is_locked = spin_trylock(&psinfo->buf_lock);
-		if (!is_locked)
-			pr_err("pstore dump routine blocked in NMI, may corrupt error record\n");
+	if (pstore_cannot_block_path(reason)) {
+		is_locked = spin_trylock_irqsave(&psinfo->buf_lock, flags);
+		if (!is_locked) {
+			pr_err("pstore dump routine blocked in %s path, may corrupt error record\n"
+				       , in_nmi() ? "NMI" : why);
+		}
 	} else
 		spin_lock_irqsave(&psinfo->buf_lock, flags);
 	oopscount++;
@@ -145,9 +168,9 @@ static void pstore_dump(struct kmsg_dump
 		total += l1_cpy + l2_cpy;
 		part++;
 	}
-	if (in_nmi()) {
+	if (pstore_cannot_block_path(reason)) {
 		if (is_locked)
-			spin_unlock(&psinfo->buf_lock);
+			spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 	} else
 		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 }
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -54,12 +54,18 @@ struct pstore_info {
 
 #ifdef CONFIG_PSTORE
 extern int pstore_register(struct pstore_info *);
+extern bool pstore_cannot_block_path(enum kmsg_dump_reason reason);
 #else
 static inline int
 pstore_register(struct pstore_info *psi)
 {
 	return -ENODEV;
 }
+static inline bool
+pstore_cannot_block_path(enum kmsg_dump_reason reason)
+{
+	return false;
+}
 #endif
 
 #endif /*_LINUX_PSTORE_H*/


