Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab3IISuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:50:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57095 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab3IISpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:45:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 12/24] powerpc: Don't Oops when accessing /proc/powerpc/lparcfg without hypervisor
Date: Mon,  9 Sep 2013 11:45:02 -0700
Message-Id: <1378752314-2416-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378752314-2416-1-git-send-email-kamal@canonical.com>
References: <1378752314-2416-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit f5f6cbb61610b7bf9d9d96db9c3979d62a424bab upstream.

/proc/powerpc/lparcfg is an ancient facility (though still actively used)
which allows access to some informations relative to the partition when
running underneath a PAPR compliant hypervisor.

It makes no sense on non-pseries machines. However, currently, not only
can it be created on these if the kernel has pseries support, but accessing
it on such a machine will crash due to trying to do hypervisor calls.

In fact, it should also not do HV calls on older pseries that didn't have
an hypervisor either.

Finally, it has the plumbing to be a module but is a "bool" Kconfig option.

This fixes the whole lot by turning it into a machine_device_initcall
that is only created on pseries, and adding the necessary hypervisor
check before calling the H_GET_EM_PARMS hypercall

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/kernel/lparcfg.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/kernel/lparcfg.c b/arch/powerpc/kernel/lparcfg.c
index d92f387..e2a0a16 100644
--- a/arch/powerpc/kernel/lparcfg.c
+++ b/arch/powerpc/kernel/lparcfg.c
@@ -35,7 +35,13 @@
 #include <asm/vdso_datapage.h>
 #include <asm/vio.h>
 #include <asm/mmu.h>
+#include <asm/machdep.h>
 
+
+/*
+ * This isn't a module but we expose that to userspace
+ * via /proc so leave the definitions here
+ */
 #define MODULE_VERS "1.9"
 #define MODULE_NAME "lparcfg"
 
@@ -418,7 +424,8 @@ static void parse_em_data(struct seq_file *m)
 {
 	unsigned long retbuf[PLPAR_HCALL_BUFSIZE];
 
-	if (plpar_hcall(H_GET_EM_PARMS, retbuf) == H_SUCCESS)
+	if (firmware_has_feature(FW_FEATURE_LPAR) &&
+	    plpar_hcall(H_GET_EM_PARMS, retbuf) == H_SUCCESS)
 		seq_printf(m, "power_mode_data=%016lx\n", retbuf[0]);
 }
 
@@ -677,7 +684,6 @@ static int lparcfg_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations lparcfg_fops = {
-	.owner		= THIS_MODULE,
 	.read		= seq_read,
 	.write		= lparcfg_write,
 	.open		= lparcfg_open,
@@ -699,14 +705,4 @@ static int __init lparcfg_init(void)
 	}
 	return 0;
 }
-
-static void __exit lparcfg_cleanup(void)
-{
-	remove_proc_subtree("powerpc/lparcfg", NULL);
-}
-
-module_init(lparcfg_init);
-module_exit(lparcfg_cleanup);
-MODULE_DESCRIPTION("Interface for LPAR configuration data");
-MODULE_AUTHOR("Dave Engebretsen");
-MODULE_LICENSE("GPL");
+machine_device_initcall(pseries, lparcfg_init);
-- 
1.8.1.2

