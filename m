Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab3IIPLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:11:55 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37493 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3IIPLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:11:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        stefan.bader@canonical.com, stefano.stabellini@eu.citrix.com,
        jeremy@goop.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/5] xen/smp: Update pv_lock_ops functions before alternative code starts under PVHVM
Date: Mon,  9 Sep 2013 11:11:34 -0400
Message-Id: <1378739496-17468-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378739496-17468-1-git-send-email-konrad.wilk@oracle.com>
References: <1378739496-17468-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this patch we would patch all of the pv_lock_ops sites
using alternative assembler. Then later in the bootup cycle
change the unlock_kick and lock_spinning to the Xen specific -
without re patching.

That meant that for the core of the kernel we would be running
with the baremetal version of unlock_kick and lock_spinning while
for modules we would have the proper Xen specific slowpaths.

As most of the module uses some API from the core kernel that ended
up with slowpath lockers waiting forever to be kicked (b/c they
would be using the Xen specific slowpath logic). And the
kick never came b/c the unlock path that was taken was the
baremetal one.

On PV we do not have the problem as we initialise before the
alternative code kicks in.

The fix is to make the updating of the pv_lock_ops function
be done before the alternative code starts patching.

Note that this patch fixes issues discovered by commit
f10cd522c5fbfec9ae3cc01967868c9c2401ed23.
("xen: disable PV spinlocks on HVM") wherein it mentioned

   PV spinlocks cannot possibly work with the current code because they are
   enabled after pvops patching has already been done, and because PV
   spinlocks use a different data structure than native spinlocks so we
   cannot switch between them dynamically.

The first problem is solved by this patch.

The second problem has been solved by commit
816434ec4a674fcdb3c2221a6dffdc8f34020550
(Merge branch 'x86-spinlocks-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)

P.S.
There is still the commit 70dd4998cb85f0ecd6ac892cc7232abefa432efb
(xen/spinlock: Disable IRQ spinlock (PV) allocation on PVHVM) to
revert but that can be done later after all other bugs have been
fixed.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/smp.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index c21b825..d1e4777 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -273,12 +273,20 @@ static void __init xen_smp_prepare_boot_cpu(void)
 	BUG_ON(smp_processor_id() != 0);
 	native_smp_prepare_boot_cpu();
 
-	/* We've switched to the "real" per-cpu gdt, so make sure the
-	   old memory can be recycled */
-	make_lowmem_page_readwrite(xen_initial_gdt);
+	if (xen_pv_domain()) {
+		/* We've switched to the "real" per-cpu gdt, so make sure the
+		   old memory can be recycled */
+		make_lowmem_page_readwrite(xen_initial_gdt);
 
-	xen_filter_cpu_maps();
-	xen_setup_vcpu_info_placement();
+		xen_filter_cpu_maps();
+		xen_setup_vcpu_info_placement();
+	}
+	/*
+	 * The alternative logic (which patches the unlock/lock) runs before
+	 * the smp bootup up code is activated. Hence we need to set this up
+	 * the core kernel is being patched. Otherwise we will have only
+	 * modules patched but not core code.
+	 */
 	xen_init_spinlocks();
 }
 
@@ -737,4 +745,5 @@ void __init xen_hvm_smp_init(void)
 	smp_ops.cpu_die = xen_hvm_cpu_die;
 	smp_ops.send_call_func_ipi = xen_smp_send_call_function_ipi;
 	smp_ops.send_call_func_single_ipi = xen_smp_send_call_function_single_ipi;
+	smp_ops.smp_prepare_boot_cpu = xen_smp_prepare_boot_cpu;
 }
-- 
1.8.3.1

