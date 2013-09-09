Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab3IIPMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:12:13 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37659 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3IIPMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:12:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        stefan.bader@canonical.com, stefano.stabellini@eu.citrix.com,
        jeremy@goop.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5/5] Revert "xen/spinlock: Disable IRQ spinlock (PV) allocation on PVHVM"
Date: Mon,  9 Sep 2013 11:11:36 -0400
Message-Id: <1378739496-17468-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378739496-17468-1-git-send-email-konrad.wilk@oracle.com>
References: <1378739496-17468-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 70dd4998cb85f0ecd6ac892cc7232abefa432efb.

Now that the bugs have been resolved we can re-enable the
PV ticketlock implementation under PVHVM Xen guests.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/spinlock.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index e1bff87..b3c1ee8 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -230,13 +230,6 @@ void xen_init_lock_cpu(int cpu)
 	WARN(per_cpu(lock_kicker_irq, cpu) >= 0, "spinlock on CPU%d exists on IRQ%d!\n",
 	     cpu, per_cpu(lock_kicker_irq, cpu));
 
-	/*
-	 * See git commit f10cd522c5fbfec9ae3cc01967868c9c2401ed23
-	 * (xen: disable PV spinlocks on HVM)
-	 */
-	if (xen_hvm_domain())
-		return;
-
 	name = kasprintf(GFP_KERNEL, "spinlock%d", cpu);
 	irq = bind_ipi_to_irqhandler(XEN_SPIN_UNLOCK_VECTOR,
 				     cpu,
@@ -256,13 +249,6 @@ void xen_init_lock_cpu(int cpu)
 
 void xen_uninit_lock_cpu(int cpu)
 {
-	/*
-	 * See git commit f10cd522c5fbfec9ae3cc01967868c9c2401ed23
-	 * (xen: disable PV spinlocks on HVM)
-	 */
-	if (xen_hvm_domain())
-		return;
-
 	if (!xen_pvspin)
 		return;
 
@@ -275,12 +261,6 @@ void xen_uninit_lock_cpu(int cpu)
 
 void __init xen_init_spinlocks(void)
 {
-	/*
-	 * See git commit f10cd522c5fbfec9ae3cc01967868c9c2401ed23
-	 * (xen: disable PV spinlocks on HVM)
-	 */
-	if (xen_hvm_domain())
-		return;
 
 	if (!xen_pvspin) {
 		printk(KERN_DEBUG "xen: PV spinlocks disabled\n");
-- 
1.8.3.1

