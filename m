Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab3DBWny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:43:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760573Ab3DBWMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Lingzhu Xiang <lxiang@redhat.com>, CAI Qian <caiqian@redhat.com>
Subject: [ 092/124] xen/events: avoid race with raising an event in unmask_evtchn()
Date: Tue,  2 Apr 2013 15:11:14 -0700
Message-Id: <20130402221114.806326162@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit c26377e62f4e6bfb4d99ef88526047209701a83f upstream.

In unmask_evtchn(), when the mask bit is cleared after testing for
pending and the event becomes pending between the test and clear, then
the upcall will not become pending and the event may be lost or
delayed.

Avoid this by always clearing the mask bit before checking for
pending.  If a hypercall is needed, remask the event as
EVTCHNOP_unmask will only retrigger pending events if they were
masked.

This fixes a regression introduced in 3.7 by
b5e579232d635b79a3da052964cb357ccda8d9ea (xen/events: fix
unmask_evtchn for PV on HVM guests) which reordered the clear mask and
check pending operations.

Changes in v2:
- set mask before hypercall.

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
Reviewed-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/events.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -388,11 +388,23 @@ static void unmask_evtchn(int port)
 
 	if (unlikely((cpu != cpu_from_evtchn(port))))
 		do_hypercall = 1;
-	else
+	else {
+		/*
+		 * Need to clear the mask before checking pending to
+		 * avoid a race with an event becoming pending.
+		 *
+		 * EVTCHNOP_unmask will only trigger an upcall if the
+		 * mask bit was set, so if a hypercall is needed
+		 * remask the event.
+		 */
+		sync_clear_bit(port, &s->evtchn_mask[0]);
 		evtchn_pending = sync_test_bit(port, &s->evtchn_pending[0]);
 
-	if (unlikely(evtchn_pending && xen_hvm_domain()))
-		do_hypercall = 1;
+		if (unlikely(evtchn_pending && xen_hvm_domain())) {
+			sync_set_bit(port, &s->evtchn_mask[0]);
+			do_hypercall = 1;
+		}
+	}
 
 	/* Slow path (hypercall) if this is a non-local port or if this is
 	 * an hvm domain and an event is pending (hvm domains don't have
@@ -403,8 +415,6 @@ static void unmask_evtchn(int port)
 	} else {
 		struct vcpu_info *vcpu_info = __this_cpu_read(xen_vcpu);
 
-		sync_clear_bit(port, &s->evtchn_mask[0]);
-
 		/*
 		 * The following is basically the equivalent of
 		 * 'hw_resend_irq'. Just like a real IO-APIC we 'lose


