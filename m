Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab3BSN7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 08:59:23 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:17887 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828Ab3BSN7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 08:59:22 -0500
X-IronPort-AV: E=Sophos;i="4.84,695,1355097600"; 
   d="scan'208";a="7757429"
Date: Tue, 19 Feb 2013 13:59:19 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <xen-devel@lists.xensource.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] xen: introduce xen_remap, use it instead of ioremap
Message-ID: <alpine.DEB.2.02.1302191332340.4654@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioremap can't be used to map ring pages on ARM because it uses device
memory caching attributes (MT_DEVICE*).

Introduce a Xen specific abstraction to map ring pages, called
xen_remap, that is defined as ioremap on x86 (no behavioral changes).
On ARM it explicitly calls __arm_ioremap with the right caching
attributes: MT_MEMORY.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
index c6b9096..30cdacb 100644
--- a/arch/arm/include/asm/xen/page.h
+++ b/arch/arm/include/asm/xen/page.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_ARM_XEN_PAGE_H
 #define _ASM_ARM_XEN_PAGE_H
 
+#include <asm/mach/map.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 
@@ -86,4 +87,7 @@ static inline bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 {
 	return __set_phys_to_machine(pfn, mfn);
 }
+
+#define xen_remap(cookie, size) __arm_ioremap((cookie), (size), MT_MEMORY);
+
 #endif /* _ASM_ARM_XEN_PAGE_H */
diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 472b9b7..6aef9fb 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -212,4 +212,6 @@ unsigned long arbitrary_virt_to_mfn(void *vaddr);
 void make_lowmem_page_readonly(void *vaddr);
 void make_lowmem_page_readwrite(void *vaddr);
 
+#define xen_remap(cookie, size) ioremap((cookie), (size));
+
 #endif /* _ASM_X86_XEN_PAGE_H */
diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 19843ec..682210d7 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -230,7 +230,7 @@ static int xen_hvm_console_init(void)
 	if (r < 0 || v == 0)
 		goto err;
 	mfn = v;
-	info->intf = ioremap(mfn << PAGE_SHIFT, PAGE_SIZE);
+	info->intf = xen_remap(mfn << PAGE_SHIFT, PAGE_SIZE);
 	if (info->intf == NULL)
 		goto err;
 	info->vtermno = HVC_COOKIE;
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 7038de5..1c2a1e5 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -1146,7 +1146,7 @@ int gnttab_resume(void)
 		return gnttab_map(0, nr_grant_frames - 1);
 
 	if (gnttab_shared.addr == NULL) {
-		gnttab_shared.addr = ioremap(xen_hvm_resume_frames,
+		gnttab_shared.addr = xen_remap(xen_hvm_resume_frames,
 						PAGE_SIZE * max_nr_gframes);
 		if (gnttab_shared.addr == NULL) {
 			printk(KERN_WARNING
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 038b71d..3325884 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -769,7 +769,7 @@ static int __init xenbus_init(void)
 			goto out_error;
 		xen_store_mfn = (unsigned long)v;
 		xen_store_interface =
-			ioremap(xen_store_mfn << PAGE_SHIFT, PAGE_SIZE);
+			xen_remap(xen_store_mfn << PAGE_SHIFT, PAGE_SIZE);
 		break;
 	default:
 		pr_warn("Xenstore state unknown\n");
