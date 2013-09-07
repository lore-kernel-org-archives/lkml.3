Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab3IGOJv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 10:09:51 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:33459 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3IGOI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 10:08:56 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        stefan.bader@canonical.com, stefano.stabellini@eu.citrix.com,
        jeremy@goop.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/5] xen/smp: Update pv_lock_ops functions before alternative code starts under PVHVM
Date: Sat,  7 Sep 2013 09:46:43 -0400
Message-Id: <1378561605-18998-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1378561605-18998-1-git-send-email-konrad.wilk@oracle.com>
References: <1378561605-18998-1-git-send-email-konrad.wilk@oracle.com>
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

The fix is to move the updating of the pv_lock_ops function
before the alternative code starts patching.

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
---
 arch/x86/xen/smp.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 4db779d..3404ee8 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -731,4 +731,12 @@ void __init xen_hvm_smp_init(void)
 	smp_ops.cpu_die = xen_hvm_cpu_die;
 	smp_ops.send_call_func_ipi = xen_smp_send_call_function_ipi;
 	smp_ops.send_call_func_single_ipi = xen_smp_send_call_function_single_ipi;
+
+	/*
+	 * The alternative logic (which patches the unlock/lock) runs before
+	 * the smp bootup up code is activated. That meant we would never patch
+	 * the core of the kernel with proper paravirt interfaces but would patch
+	 * modules.
+	 */
+	xen_init_spinlocks();
 }
-- 
1.7.7.6

