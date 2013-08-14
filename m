Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab3HNKzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:55:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34466 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341Ab3HNKhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jonghwan Choi <jhbird.choi@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 21/75] xen/evtchn: avoid a deadlock when unbinding an event channel
Date: Wed, 14 Aug 2013 11:36:10 +0100
Message-Id: <1376476624-10011-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit 179fbd5a45f0d4034cc6fd37b8d367a3b79663c4 upstream.

Unbinding an event channel (either with the ioctl or when the evtchn
device is closed) may deadlock because disable_irq() is called with
port_user_lock held which is also locked by the interrupt handler.

Think of the IOCTL_EVTCHN_UNBIND is being serviced, the routine has
just taken the lock, and an interrupt happens. The evtchn_interrupt
is invoked, tries to take the lock and spins forever.

A quick glance at the code shows that the spinlock is a local IRQ
variant. Unfortunately that does not help as "disable_irq() waits for
the interrupt handler on all CPUs to stop running.  If the irq occurs
on another VCPU, it tries to take port_user_lock and can't because
the unbind ioctl is holding it." (from David). Hence we cannot
depend on the said spinlock to protect us. We could make it a system
wide IRQ disable spinlock but there is a better way.

We can piggyback on the fact that the existence of the spinlock is
to make get_port_user() checks be up-to-date. And we can alter those
checks to not depend on the spin lock (as it's protected by u->bind_mutex
in the ioctl) and can remove the unnecessary locking (this is
IOCTL_EVTCHN_UNBIND) path.

In the interrupt handler we cannot use the mutex, but we do not
need it.

"The unbind disables the irq before making the port user stale, so when
you clear it you are guaranteed that the interrupt handler that might
use that port cannot be running." (from David).

Hence this patch removes the spinlock usage on the teardown path
and piggybacks on disable_irq happening before we muck with the
get_port_user() data. This ensures that the interrupt handler will
never run on stale data.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
[v1: Expanded the commit description a bit]
Cc: Jonghwan Choi <jhbird.choi@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/xen/evtchn.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
index b2db77e..82b27d4 100644
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -377,18 +377,12 @@ static long evtchn_ioctl(struct file *file,
 		if (unbind.port >= NR_EVENT_CHANNELS)
 			break;
 
-		spin_lock_irq(&port_user_lock);
-
 		rc = -ENOTCONN;
-		if (get_port_user(unbind.port) != u) {
-			spin_unlock_irq(&port_user_lock);
+		if (get_port_user(unbind.port) != u)
 			break;
-		}
 
 		disable_irq(irq_from_evtchn(unbind.port));
 
-		spin_unlock_irq(&port_user_lock);
-
 		evtchn_unbind_from_user(u, unbind.port);
 
 		rc = 0;
@@ -488,26 +482,15 @@ static int evtchn_release(struct inode *inode, struct file *filp)
 	int i;
 	struct per_user_data *u = filp->private_data;
 
-	spin_lock_irq(&port_user_lock);
-
-	free_page((unsigned long)u->ring);
-
 	for (i = 0; i < NR_EVENT_CHANNELS; i++) {
 		if (get_port_user(i) != u)
 			continue;
 
 		disable_irq(irq_from_evtchn(i));
-	}
-
-	spin_unlock_irq(&port_user_lock);
-
-	for (i = 0; i < NR_EVENT_CHANNELS; i++) {
-		if (get_port_user(i) != u)
-			continue;
-
 		evtchn_unbind_from_user(get_port_user(i), i);
 	}
 
+	free_page((unsigned long)u->ring);
 	kfree(u->name);
 	kfree(u);
 
-- 
1.8.3.2

