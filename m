Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679AbaBUMvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:51:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47305 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932660AbaBUMvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:47 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Frediano Ziglio <frediano.ziglio@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 113/121] xen: Fix possible user space selector corruption
Date: Fri, 21 Feb 2014 12:48:57 +0000
Message-Id: <1392986945-9693-114-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frediano Ziglio <frediano.ziglio@citrix.com>

commit 7cde9b27e7b3a2e09d647bb4f6d94e842698d2d5 upstream.

Due to the way kernel is initialized under Xen is possible that the
ring1 selector used by the kernel for the boot cpu end up to be copied
to userspace leading to segmentation fault in the userspace.

Xen code in the kernel initialize no-boot cpus with correct selectors (ds
and es set to __USER_DS) but the boot one keep the ring1 (passed by Xen).
On task context switch (switch_to) we assume that ds, es and cs already
point to __USER_DS and __KERNEL_CSso these selector are not changed.

If processor is an Intel that support sysenter instruction sysenter/sysexit
is used so ds and es are not restored switching back from kernel to
userspace. In the case the selectors point to a ring1 instead of __USER_DS
the userspace code will crash on first memory access attempt (to be
precise Xen on the emulated iret used to do sysexit will detect and set ds
and es to zero which lead to GPF anyway).

Now if an userspace process call kernel using sysenter and get rescheduled
(for me it happen on a specific init calling wait4) could happen that the
ring1 selector is set to ds and es.

This is quite hard to detect cause after a while these selectors are fixed
(__USER_DS seems sticky).

Bisecting the code commit 7076aada1040de4ed79a5977dbabdb5e5ea5e249 appears
to be the first one that have this issue.

Signed-off-by: Frediano Ziglio <frediano.ziglio@citrix.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: David Vrabel <david.vrabel@citrix.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/xen/smp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index b81c88e..0cc3d8c 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -277,6 +277,15 @@ static void __init xen_smp_prepare_boot_cpu(void)
 	   old memory can be recycled */
 	make_lowmem_page_readwrite(xen_initial_gdt);
 
+#ifdef CONFIG_X86_32
+	/*
+	 * Xen starts us with XEN_FLAT_RING1_DS, but linux code
+	 * expects __USER_DS
+	 */
+	loadsegment(ds, __USER_DS);
+	loadsegment(es, __USER_DS);
+#endif
+
 	xen_filter_cpu_maps();
 	xen_setup_vcpu_info_placement();
 }
-- 
1.9.0

