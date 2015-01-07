Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbbAGQRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 11:17:52 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:45557 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbbAGQRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:17:50 -0500
From: Imre Palik <imrep.amz@gmail.com>
To: xen-devel@lists.xenproject.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, "Palik, Imre" <imrep@amazon.de>,
        Anthony Liguori <aliguori@amazon.com>
Subject: [PATCH RFC] xen-time: decreasing the rating of the xen clocksource below that of the tsc clocksource for dom0's
Date: Wed,  7 Jan 2015 17:16:38 +0100
Message-Id: <1420647398-20207-1-git-send-email-imrep.amz@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Palik, Imre" <imrep@amazon.de>

In Dom0's the use of the TSC clocksource (whenever it is stable enough to
be used) instead of the Xen clocksource should not cause any issues, as
Dom0 VMs never live-migrated.  The TSC clocksource is somewhat more
efficient than the Xen paravirtualised clocksource, thus it should have
higher rating.

Cc: Anthony Liguori <aliguori@amazon.com>
Signed-off-by: Imre Palik <imrep@amazon.de>
---
 arch/x86/xen/time.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index f473d26..c768726 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -487,6 +487,10 @@ static void __init xen_time_init(void)
 	int cpu = smp_processor_id();
 	struct timespec tp;
 
+	/* As Dom0 is never moved, no penalty on using TSC there */
+	if (xen_initial_domain())
+		xen_clocksource.rating = 275;
+
 	clocksource_register_hz(&xen_clocksource, NSEC_PER_SEC);
 
 	if (HYPERVISOR_vcpu_op(VCPUOP_stop_periodic_timer, cpu, NULL) == 0) {
-- 
1.7.9.5

