Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab3L3SlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 13:41:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:46372 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756208Ab3L3SlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 13:41:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,575,1384329600"; 
   d="scan'208";a="457777599"
Subject: [PATCH 11/12] x86 Kconfig: move paravirt under virtualization
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 30 Dec 2013 10:41:00 -0800
References: <20131230184046.F5E42919@viggo.jf.intel.com>
In-Reply-To: <20131230184046.F5E42919@viggo.jf.intel.com>
Message-Id: <20131230184100.D99DCA7E@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

Right now, there is a "Enable paravirtualization code" option in
the "Processor Features" menu, which means Xen.  There is also a
group of paravirtualization options specific to KVM under the
top-level "Virtualization" menu.

This creates a new hypervisor-indemendent arch/x86/Kconfig.virt
file, and moves the "Virtualization" menu to be defined in there.
This also removes the very counterintuitive references to
lguest/vhost code *from* kvm-specific code.

This also removes the silly:

	depends on HAVE_KVM || X86

dependency.  It makes zero sense to have entried defined in
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
 linux.git-davehans/arch/x86/Kconfig.virt |   18 ++++++++++++++++++
 linux.git-davehans/arch/x86/kvm/Kconfig  |   19 -------------------
 3 files changed, 19 insertions(+), 20 deletions(-)

diff -puN arch/x86/Kconfig~x86-Kconfig-move-paravirt-under-virtualization arch/x86/Kconfig
--- linux.git/arch/x86/Kconfig~x86-Kconfig-move-paravirt-under-virtualization	2013-12-30 10:37:46.554293648 -0800
+++ linux.git-davehans/arch/x86/Kconfig	2013-12-30 10:37:46.560293918 -0800
@@ -2417,6 +2417,6 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
-source "arch/x86/kvm/Kconfig"
+source "arch/x86/Kconfig.virt"
 
 source "lib/Kconfig"
diff -puN /dev/null arch/x86/Kconfig.virt
--- /dev/null	2013-11-27 17:20:18.337162396 -0800
+++ linux.git-davehans/arch/x86/Kconfig.virt	2013-12-30 10:37:46.561293963 -0800
@@ -0,0 +1,18 @@
+
+menuconfig VIRTUALIZATION
+	bool "Virtualization"
+	default y
+	---help---
+	  Say Y here to get to see options for using your Linux host to run other
+	  operating systems inside virtual machines (guests).
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
+
+if VIRTUALIZATION
+
+source arch/x86/kvm/Kconfig
+source drivers/vhost/Kconfig
+source drivers/lguest/Kconfig
+
+endif # VIRTUALIZATION
diff -puN arch/x86/kvm/Kconfig~x86-Kconfig-move-paravirt-under-virtualization arch/x86/kvm/Kconfig
--- linux.git/arch/x86/kvm/Kconfig~x86-Kconfig-move-paravirt-under-virtualization	2013-12-30 10:37:46.556293738 -0800
+++ linux.git-davehans/arch/x86/kvm/Kconfig	2013-12-30 10:37:46.561293963 -0800
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
