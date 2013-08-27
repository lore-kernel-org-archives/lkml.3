Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab3H0BQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:16:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59532 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3H0BHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [ 42/74] xen/events: mask events when changing their VCPU binding
Date: Mon, 26 Aug 2013 18:08:40 -0700
Message-Id: <20130827010433.238225232@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/events.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1492,8 +1492,10 @@ void rebind_evtchn_irq(int evtchn, int i
 /* Rebind an evtchn so that it gets delivered to a specific cpu */
 static int rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
 {
+	struct shared_info *s = HYPERVISOR_shared_info;
 	struct evtchn_bind_vcpu bind_vcpu;
 	int evtchn = evtchn_from_irq(irq);
+	int masked;
 
 	if (!VALID_EVTCHN(evtchn))
 		return -1;
@@ -1510,6 +1512,12 @@ static int rebind_irq_to_cpu(unsigned ir
 	bind_vcpu.vcpu = tcpu;
 
 	/*
+	 * Mask the event while changing the VCPU binding to prevent
+	 * it being delivered on an unexpected VCPU.
+	 */
+	masked = sync_test_and_set_bit(evtchn, BM(s->evtchn_mask));
+
+	/*
 	 * If this fails, it usually just indicates that we're dealing with a
 	 * virq or IPI channel, which don't actually need to be rebound. Ignore
 	 * it, but don't do the xenlinux-level rebind in that case.
@@ -1517,6 +1525,9 @@ static int rebind_irq_to_cpu(unsigned ir
 	if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_vcpu, &bind_vcpu) >= 0)
 		bind_evtchn_to_cpu(evtchn, tcpu);
 
+	if (!masked)
+		unmask_evtchn(evtchn);
+
 	return 0;
 }
 


