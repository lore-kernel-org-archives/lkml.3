Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbaAAEhO (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 31 Dec 2013 23:37:14 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18503 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaAAEhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 23:37:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v12 07/18] xen/pvh: Setup up shared_info.
Date: Tue, 31 Dec 2013 23:35:34 -0500
Message-Id: <1388550945-25499-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mukesh Rathor <mukesh.rathor@oracle.com>

For PVHVM the shared_info structure is provided via the same way
as for normal PV guests (see include/xen/interface/xen.h).

That is during bootup we get 'xen_start_info' via the %esi register
in startup_xen. Then later we extract the 'shared_info' from said
structure (in xen_setup_shared_info) and start using it.

The 'xen_setup_shared_info' is all setup to work with auto-xlat
guests, but there are two functions which it calls that are not:
xen_setup_mfn_list_list and xen_setup_vcpu_info_placement.
This patch modifies those to work in auto-xlat mode.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c | 5 +++--
 arch/x86/xen/p2m.c       | 3 +++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index ab4dd70..4cdc483 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1147,8 +1147,9 @@ void xen_setup_vcpu_info_placement(void)
 		xen_vcpu_setup(cpu);
 
 	/* xen_vcpu_setup managed to place the vcpu_info within the
-	   percpu area for all cpus, so make use of it */
-	if (have_vcpu_info_placement) {
+	 * percpu area for all cpus, so make use of it. Note that for
+	 * PVH we want to use native IRQ mechanism. */
+	if (have_vcpu_info_placement && !xen_pvh_domain()) {
 		pv_irq_ops.save_fl = __PV_IS_CALLEE_SAVE(xen_save_fl_direct);
 		pv_irq_ops.restore_fl = __PV_IS_CALLEE_SAVE(xen_restore_fl_direct);
 		pv_irq_ops.irq_disable = __PV_IS_CALLEE_SAVE(xen_irq_disable_direct);
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index fb7ee0a..696c694 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -339,6 +339,9 @@ void __ref xen_build_mfn_list_list(void)
 
 void xen_setup_mfn_list_list(void)
 {
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return;
+
 	BUG_ON(HYPERVISOR_shared_info == &xen_dummy_shared_info);
 
 	HYPERVISOR_shared_info->arch.pfn_to_mfn_frame_list_list =
-- 
1.8.3.1

