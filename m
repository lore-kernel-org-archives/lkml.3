Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab3IBI7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:59:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37888 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758563Ab3IBIzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:49 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 54/58] powerpc: Don't Oops when accessing /proc/powerpc/lparcfg without hypervisor
Date: Mon,  2 Sep 2013 09:54:39 +0100
Message-Id: <1378112083-9475-55-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/lparcfg.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kernel/lparcfg.c b/arch/powerpc/kernel/lparcfg.c
index f5725bc..7ebbae0 100644
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
 
@@ -419,7 +425,8 @@ static void parse_em_data(struct seq_file *m)
 {
 	unsigned long retbuf[PLPAR_HCALL_BUFSIZE];
 
-	if (plpar_hcall(H_GET_EM_PARMS, retbuf) == H_SUCCESS)
+	if (firmware_has_feature(FW_FEATURE_LPAR) &&
+	    plpar_hcall(H_GET_EM_PARMS, retbuf) == H_SUCCESS)
 		seq_printf(m, "power_mode_data=%016lx\n", retbuf[0]);
 }
 
@@ -678,7 +685,6 @@ static int lparcfg_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations lparcfg_fops = {
-	.owner		= THIS_MODULE,
 	.read		= seq_read,
 	.write		= lparcfg_write,
 	.open		= lparcfg_open,
@@ -704,15 +710,4 @@ static int __init lparcfg_init(void)
 	proc_ppc64_lparcfg = ent;
 	return 0;
 }
-
-static void __exit lparcfg_cleanup(void)
-{
-	if (proc_ppc64_lparcfg)
-		remove_proc_entry("lparcfg", proc_ppc64_lparcfg->parent);
-}
-
-module_init(lparcfg_init);
-module_exit(lparcfg_cleanup);
-MODULE_DESCRIPTION("Interface for LPAR configuration data");
-MODULE_AUTHOR("Dave Engebretsen");
-MODULE_LICENSE("GPL");
+machine_device_initcall(pseries, lparcfg_init);
-- 
1.8.3.2

