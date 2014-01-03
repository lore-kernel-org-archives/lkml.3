Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaACUcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:32:45 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21982 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbaACUaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:30:00 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        david.vrabel@citrix.com
Cc: hpa@zytor.com, Mukesh Rathor <mukesh.rathor@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v13 08/19] xen/pvh/mmu: Use PV TLB instead of native.
Date: Fri,  3 Jan 2014 14:38:25 -0500
Message-Id: <1388777916-1328-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
References: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mukesh Rathor <mukesh.rathor@oracle.com>

We also optimize one - the TLB flush. The native operation would
needlessly IPI offline VCPUs causing extra wakeups. Using the
Xen one avoids that and lets the hypervisor determine which
VCPU needs the TLB flush.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 490ddb3..c1d406f 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2222,6 +2222,15 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
 void __init xen_init_mmu_ops(void)
 {
 	x86_init.paging.pagetable_init = xen_pagetable_init;
+
+	/* Optimization - we can use the HVM one but it has no idea which
+	 * VCPUs are descheduled - which means that it will needlessly IPI
+	 * them. Xen knows so let it do the job.
+	 */
+	if (xen_feature(XENFEAT_auto_translated_physmap)) {
+		pv_mmu_ops.flush_tlb_others = xen_flush_tlb_others;
+		return;
+	}
 	pv_mmu_ops = xen_mmu_ops;
 
 	memset(dummy_mapping, 0xff, PAGE_SIZE);
-- 
1.8.3.1

