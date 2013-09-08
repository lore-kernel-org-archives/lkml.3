Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab3IHDqA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:46:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56075 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755760Ab3IHDTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Jan Beulich" <jbeulich@suse.com>,
        "David Vrabel" <david.vrabel@citrix.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.533180772@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [081/121] xen/events: mask events when changing their VCPU binding
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit 4704fe4f03a5ab27e3c36184af85d5000e0f8a48 upstream.

When a event is being bound to a VCPU there is a window between the
EVTCHNOP_bind_vpcu call and the adjustment of the local per-cpu masks
where an event may be lost.  The hypervisor upcalls the new VCPU but
the kernel thinks that event is still bound to the old VCPU and
ignores it.

There is even a problem when the event is being bound to the same VCPU
as there is a small window beween the clear_bit() and set_bit() calls
in bind_evtchn_to_cpu().  When scanning for pending events, the kernel
may read the bit when it is momentarily clear and ignore the event.

Avoid this by masking the event during the whole bind operation.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
[bwh: Backported to 3.2: remove the BM() cast]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/xen/events.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1340,8 +1340,10 @@ void rebind_evtchn_irq(int evtchn, int i
 /* Rebind an evtchn so that it gets delivered to a specific cpu */
 static int rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
 {
+	struct shared_info *s = HYPERVISOR_shared_info;
 	struct evtchn_bind_vcpu bind_vcpu;
 	int evtchn = evtchn_from_irq(irq);
+	int masked;
 
 	if (!VALID_EVTCHN(evtchn))
 		return -1;
@@ -1358,6 +1360,12 @@ static int rebind_irq_to_cpu(unsigned ir
 	bind_vcpu.vcpu = tcpu;
 
 	/*
+	 * Mask the event while changing the VCPU binding to prevent
+	 * it being delivered on an unexpected VCPU.
+	 */
+	masked = sync_test_and_set_bit(evtchn, s->evtchn_mask);
+
+	/*
 	 * If this fails, it usually just indicates that we're dealing with a
 	 * virq or IPI channel, which don't actually need to be rebound. Ignore
 	 * it, but don't do the xenlinux-level rebind in that case.
@@ -1365,6 +1373,9 @@ static int rebind_irq_to_cpu(unsigned ir
 	if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_vcpu, &bind_vcpu) >= 0)
 		bind_evtchn_to_cpu(evtchn, tcpu);
 
+	if (!masked)
+		unmask_evtchn(evtchn);
+
 	return 0;
 }
 

