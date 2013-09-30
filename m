Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab3I3Kb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:31:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43504 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab3I3KMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 036/104] xen/events: mask events when changing their VCPU binding
Date: Mon, 30 Sep 2013 11:10:13 +0100
Message-Id: <1380535881-9239-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5:
  - removed the BM() cast (as per 3.2 backport) ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/xen/events.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 025e98b..8a8cd6e 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1431,8 +1431,10 @@ void rebind_evtchn_irq(int evtchn, int irq)
 /* Rebind an evtchn so that it gets delivered to a specific cpu */
 static int rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
 {
+	struct shared_info *s = HYPERVISOR_shared_info;
 	struct evtchn_bind_vcpu bind_vcpu;
 	int evtchn = evtchn_from_irq(irq);
+	int masked;
 
 	if (!VALID_EVTCHN(evtchn))
 		return -1;
@@ -1449,6 +1451,12 @@ static int rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
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
@@ -1456,6 +1464,9 @@ static int rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
 	if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_vcpu, &bind_vcpu) >= 0)
 		bind_evtchn_to_cpu(evtchn, tcpu);
 
+	if (!masked)
+		unmask_evtchn(evtchn);
+
 	return 0;
 }
 
-- 
1.8.3.2

