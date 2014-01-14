Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaANALl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:11:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:40306 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbaANALk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:11:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,656,1384329600"; 
   d="scan'208";a="466126316"
Subject: [PATCH 1/2] x86 Kconfig: create x86/Kconfig.virt
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave@sr71.net>, bp@suse.de, dtor@vmware.com,
        kys@microsoft.com, haiyangz@microsoft.com, agraf@suse.de,
        gleb@redhat.com, pbonzini@redhat.com
From: Dave Hansen <dave@sr71.net>
Date: Mon, 13 Jan 2014 16:11:38 -0800
Message-Id: <20140114001138.57304DD0@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

Right now, there is a "Enable paravirtualization code" option in
the "Processor Features" menu, which means Xen.  There is also a
group of host-side paravirtualization options specific to KVM
under the top-level "Virtualization" menu.

I think it makes a lot of sense to group the host and guest side
things together, especially since the top-level "Virtualization"
menu is so sparsely populated.

This creates a new hypervisor-independent arch/x86/Kconfig.virt
file, and moves the "Virtualization" menu to be defined in there.
Currently CONFIG_VIRTUALIZATION really means "host-side", so
create a new config option which matches the guest-side one, and
default its value to be what CONFIG_VIRTUALIZATION was set to.

This also removes the very counterintuitive references to
lguest/vhost code *from* kvm-specific code and removes the silly:

	depends on HAVE_KVM || X86

dependency.  It makes zero sense to have entries defined in
arch/x86 depend on x86.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Dmitry Torokhov <dtor@vmware.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Alexander Graf <agraf@suse.de>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
---

 linux.git-davehans/arch/x86/Kconfig      |    2 +-
 linux.git-davehans/arch/x86/Kconfig.virt |   25 +++++++++++++++++++++++++
 linux.git-davehans/arch/x86/kvm/Kconfig  |   19 -------------------
 3 files changed, 26 insertions(+), 20 deletions(-)

diff -puN arch/x86/Kconfig~x86-Kconfig-move-paravirt-under-virtualization arch/x86/Kconfig
--- linux.git/arch/x86/Kconfig~x86-Kconfig-move-paravirt-under-virtualization	2014-01-13 16:09:29.785875796 -0800
+++ linux.git-davehans/arch/x86/Kconfig	2014-01-13 16:09:29.793876157 -0800
@@ -2416,6 +2416,6 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
-source "arch/x86/kvm/Kconfig"
+source "arch/x86/Kconfig.virt"
 
 source "lib/Kconfig"
diff -puN /dev/null arch/x86/Kconfig.virt
--- /dev/null	2013-11-27 17:20:18.337162396 -0800
+++ linux.git-davehans/arch/x86/Kconfig.virt	2014-01-13 16:09:29.793876157 -0800
@@ -0,0 +1,25 @@
+
+menu "Virtualization"
+
+config VIRTUALIZATION
+	bool
+
+config HYPERVISOR_HOST
+	bool "Host-Side Features (Linux as the Hypervisor)"
+	default y if VIRTUALIZATION
+	---help---
+	  Say Y here to get to see options for using your Linux host to run other
+	  operating systems inside virtual machines (guests).
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
+
+if HYPERVISOR_HOST
+
+source arch/x86/kvm/Kconfig
+source drivers/vhost/Kconfig
+source drivers/lguest/Kconfig
+
+endif # HYPERVISOR_HOST
+
+endmenu # "Virtualization"
diff -puN arch/x86/kvm/Kconfig~x86-Kconfig-move-paravirt-under-virtualization arch/x86/kvm/Kconfig
--- linux.git/arch/x86/kvm/Kconfig~x86-Kconfig-move-paravirt-under-virtualization	2014-01-13 16:09:29.787875886 -0800
+++ linux.git-davehans/arch/x86/kvm/Kconfig	2014-01-13 16:09:29.793876157 -0800
@@ -4,19 +4,6 @@
 
 source "virt/kvm/Kconfig"
 
-menuconfig VIRTUALIZATION
-	bool "Virtualization"
-	depends on HAVE_KVM || X86
-	default y
-	---help---
-	  Say Y here to get to see options for using your Linux host to run other
-	  operating systems inside virtual machines (guests).
-	  This option alone does not add any kernel code.
-
-	  If you say N, all options in this submenu will be skipped and disabled.
-
-if VIRTUALIZATION
-
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on HAVE_KVM
@@ -93,9 +80,3 @@ config KVM_DEVICE_ASSIGNMENT
 
 	  If unsure, say Y.
 
-# OK, it's a little counter-intuitive to do this, but it puts it neatly under
-# the virtualization menu.
-source drivers/vhost/Kconfig
-source drivers/lguest/Kconfig
-
-endif # VIRTUALIZATION
_
