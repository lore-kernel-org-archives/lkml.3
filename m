Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab3IKE5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:57:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab3IKE4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:49 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Jv6gWtmcx54A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=JE6IXamR_lwA:10 a=wMNdZWldAAAA:8 a=VwQbUJbxAAAA:8 a=asx95DYW1urs9zGrBYEA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042932.774765385@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:31:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [241/251] powerpc: Dont Oops when accessing /proc/powerpc/lparcfg without
 hypervisor
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0241-powerpc-Don-t-Oops-when-accessing-proc-powerpc-lparc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

[ Upstream commit f5f6cbb61610b7bf9d9d96db9c3979d62a424bab ]

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

CC: <stable@vger.kernel.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/kernel/lparcfg.c |   23 +++++++++--------------
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
1.7.10.4


