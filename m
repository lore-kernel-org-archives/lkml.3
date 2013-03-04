Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab3CDDnL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:43:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60931 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755849Ab3CDDnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:02 -0500
Message-Id: <20130304033720.273770642@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:16 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Seiji Aguchi <seiji.aguchi@hds.com>,
        Don Zickus <dzickus@redhat.com>, Tony Luck <tony.luck@intel.com>
Subject: [ 129/153] pstore: Avoid deadlock in panic and emergency-restart path
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context
 - Add #include <linux/kmsg_dump.h>]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -72,6 +72,27 @@ static char *reason_str[] = {
 	"Oops", "Panic", "Kexec", "Restart", "Halt", "Poweroff", "Emergency"
 };
 
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
@@ -97,10 +118,12 @@ static void pstore_dump(struct kmsg_dump
 	else
 		why = "Unknown";
 
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
@@ -131,9 +154,9 @@ static void pstore_dump(struct kmsg_dump
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
@@ -22,6 +22,8 @@
 #ifndef _LINUX_PSTORE_H
 #define _LINUX_PSTORE_H
 
+#include <linux/kmsg_dump.h>
+
 /* types */
 enum pstore_type_id {
 	PSTORE_TYPE_DMESG	= 0,
@@ -50,6 +52,7 @@ struct pstore_info {
 
 #ifdef CONFIG_PSTORE
 extern int pstore_register(struct pstore_info *);
+extern bool pstore_cannot_block_path(enum kmsg_dump_reason reason);
 extern int pstore_write(enum pstore_type_id type, char *buf, size_t size);
 #else
 static inline int
@@ -57,6 +60,11 @@ pstore_register(struct pstore_info *psi)
 {
 	return -ENODEV;
 }
+static inline bool
+pstore_cannot_block_path(enum kmsg_dump_reason reason)
+{
+	return false;
+}
 static inline int
 pstore_write(enum pstore_type_id type, char *buf, size_t size)
 {


