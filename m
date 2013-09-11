Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab3IKF0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:26:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab3IKE5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:25 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=OsewsQGiCFYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=-ZcwYOwyC2cA:10 a=tHz9FfFoAAAA:8 a=yPCof4ZbAAAA:8 a=g7qgrIXzKTmI0eey5JUA:9 a=6O0IECtVFhoA:10 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042911.588592632@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [116/251] xen/evtchn: avoid a deadlock when unbinding an event channel
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0116-xen-evtchn-avoid-a-deadlock-when-unbinding-an-event-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

[ Upstream commit 179fbd5a45f0d4034cc6fd37b8d367a3b79663c4 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[v1: Expanded the commit description a bit]
---
 drivers/xen/evtchn.c |   21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
index b1f60a0..8eb68c9 100644
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -367,18 +367,12 @@ static long evtchn_ioctl(struct file *file,
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
@@ -478,26 +472,15 @@ static int evtchn_release(struct inode *inode, struct file *filp)
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
1.7.10.4


