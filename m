Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaGLBdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 21:33:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20532 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaGLBdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 21:33:43 -0400
Date: Fri, 11 Jul 2014 21:33:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: x86@kernel.org, Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        tglx@linutronix.de, andrew.cooper3@citrix.com,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>, david.vrabel@citrix.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, matt.fleming@intel.com,
        jbeulich@suse.com, xen-devel@lists.xenproject.org, mingo@redhat.com,
        jeremy@goop.org, ian.campbell@citrix.com
Subject: Re: [PATCH 2/2] arch/x86/xen: Silence compiler warnings
Message-ID: <20140712013311.GA7437@konrad-lan.dumpdata.com>
References: <20140712004751.GN13620@olila.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140712004751.GN13620@olila.local.net-space.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. snip ..
> > > Please loot at arch/x86/xen/enlighten.c:xen_check_mwait() and
> > > arch/x86/xen/enlighten.c:xen_boot_params_init_edd() (probably
> > > there are more stuff like that around). As I can see this is fairly
> > > common solution and probably compiler cope with it quite well.
> > >
> >
> > Those are some examples of some rather bad examples.
> 
> What is wrong with them?

#ifdef should not be in C files. It is making the code a bit of a mess.
> 
> > The way that is preferred in the Linux code is to have the ifdef in headers.
> >
> > See
> > http://lxr.free-electrons.com/source/arch/x86/include/asm/xen/swiotlb-xen.h
> > Or
> > http://lxr.free-electrons.com/source/arch/x86/include/asm/xen/pci.h
> >
> > You can create a similar file there and for the 32 bit implementation just make an empty static function.
> >
> > The 64 bit implementation has to be somewhere. Can it be in the Xen EFI file which is only compiled on 64 bit platforms?
> 
> OK, this (putting declaration/definition in *.h file) makes sens if you
> declare/define functions which must be called from different places.

Right.
> However, xen_efi_init() is called only once in arch/x86/xen/enlighten.c.

And the vga (see arch/x86/xen/vga.c) is also called only once.

> Of course, I could define this function here in similar way like it is done
> in above headers but it take a bit more place. However, if you wish why not.

I was thinking something along this (not compile tested):

>From 436461a33cf93eed2cd96774bfca78fb08930de1 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 11 Jul 2014 22:30:33 -0400
Subject: [PATCH] Like this.

---
 arch/x86/xen/Makefile    |    1 +
 arch/x86/xen/efi.c       |   22 ++++++++++++++++++++++
 arch/x86/xen/enlighten.c |   23 +----------------------
 arch/x86/xen/xen-ops.h   |    8 ++++++++
 4 files changed, 32 insertions(+), 22 deletions(-)
 create mode 100644 arch/x86/xen/efi.c

diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index b187df5..aa045ad 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -22,3 +22,4 @@ obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
 obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
 obj-$(CONFIG_XEN_DOM0)		+= apic.o vga.o
 obj-$(CONFIG_SWIOTLB_XEN)	+= pci-swiotlb-xen.o
+obj-$(CONFIG_XEN_EFI)		+= efi.c
diff --git a/arch/x86/xen/efi.c b/arch/x86/xen/efi.c
new file mode 100644
index 0000000..0b751d9
--- /dev/null
+++ b/arch/x86/xen/efi.c
@@ -0,0 +1,22 @@
+/* Need some headers. */
+
+extern efi_system_table_t __init *xen_efi_probe(void);
+
+void __init xen_efi_init(void)
+{
+	efi_system_table_t *efi_systab_xen;
+
+	efi_systab_xen = xen_efi_probe();
+
+	if (!efi_systab_xen)
+		return;
+
+	strncpy((char *)&boot_params.efi_info.efi_loader_signature, "Xen",
+			sizeof(boot_params.efi_info.efi_loader_signature));
+	boot_params.efi_info.efi_systab = (__u32)__pa(efi_systab_xen);
+	boot_params.efi_info.efi_systab_hi = (__u32)(__pa(efi_systab_xen) >> 32);
+
+	set_bit(EFI_BOOT, &efi.flags);
+	set_bit(EFI_NO_DIRECT, &efi.flags);
+	set_bit(EFI_64BIT, &efi.flags);
+}
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index abd8013..2d71db3 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -152,15 +152,6 @@ struct shared_info *HYPERVISOR_shared_info = &xen_dummy_shared_info;
  */
 static int have_vcpu_info_placement = 1;
 
-#ifdef CONFIG_XEN_EFI
-extern efi_system_table_t __init *xen_efi_probe(void);
-#else
-static efi_system_table_t __init *xen_efi_probe(void)
-{
-	return NULL;
-}
-#endif
-
 struct tls_descs {
 	struct desc_struct desc[3];
 };
@@ -1581,7 +1572,6 @@ asmlinkage __visible void __init xen_start_kernel(void)
 {
 	struct physdev_set_iopl set_iopl;
 	int rc;
-	efi_system_table_t *efi_systab_xen;
 
 	if (!xen_start_info)
 		return;
@@ -1777,18 +1767,7 @@ asmlinkage __visible void __init xen_start_kernel(void)
 
 	xen_setup_runstate_info(0);
 
-	efi_systab_xen = xen_efi_probe();
-
-	if (efi_systab_xen) {
-		strncpy((char *)&boot_params.efi_info.efi_loader_signature, "Xen",
-				sizeof(boot_params.efi_info.efi_loader_signature));
-		boot_params.efi_info.efi_systab = (__u32)__pa(efi_systab_xen);
-		boot_params.efi_info.efi_systab_hi = (__u32)(__pa(efi_systab_xen) >> 32);
-
-		set_bit(EFI_BOOT, &efi.flags);
-		set_bit(EFI_NO_DIRECT, &efi.flags);
-		set_bit(EFI_64BIT, &efi.flags);
-	}
+	xen_efi_init();
 
 	/* Start the world */
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 12a884d..0908dec 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -127,4 +127,12 @@ __visible void xen_adjust_exception_frame(void);
 extern int xen_panic_handler_init(void);
 
 void xen_pvh_secondary_vcpu_init(int cpu);
+
+#ifdef CONFIG_X86_64
+void __init xen_efi_init(void);
+#else
+static inline void __init xen_efi_init(void)
+{
+}
+#endif
 #endif /* XEN_OPS_H */
-- 
1.7.7.6

