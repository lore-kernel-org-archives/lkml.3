Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab3IEUpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:45:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499Ab3IEU2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 07/36] powerpc: Dont Oops when accessing /proc/powerpc/lparcfg without hypervisor
Date: Thu,  5 Sep 2013 13:27:36 -0700
Message-Id: <20130905202703.177972601@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202702.289738686@linuxfoundation.org>
References: <20130905202702.289738686@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/lparcfg.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

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
 
@@ -418,7 +424,8 @@ static void parse_em_data(struct seq_fil
 {
 	unsigned long retbuf[PLPAR_HCALL_BUFSIZE];
 
-	if (plpar_hcall(H_GET_EM_PARMS, retbuf) == H_SUCCESS)
+	if (firmware_has_feature(FW_FEATURE_LPAR) &&
+	    plpar_hcall(H_GET_EM_PARMS, retbuf) == H_SUCCESS)
 		seq_printf(m, "power_mode_data=%016lx\n", retbuf[0]);
 }
 
@@ -677,7 +684,6 @@ static int lparcfg_open(struct inode *in
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


