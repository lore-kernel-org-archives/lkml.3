Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaIXL4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:56:31 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:54201 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbaIXL41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:56:27 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>, Gleb Natapov <gleb@kernel.org>,
        Alex Williamson <Alex.Williamson@redhat.com>
Subject: [PATCH v2] kvm-vfio: do not use module_init
Date: Wed, 24 Sep 2014 13:56:20 +0200
Message-Id: <1411559780-12676-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/me got confused between the kernel and QEMU.  In the kernel, you can
only have one module_init function, and it will prevent unloading the
module unless you also have the corresponding module_exit function.

So, commit 80ce1639727e (KVM: VFIO: register kvm_device_ops dynamically,
2014-09-02) broke unloading of the kvm module, by adding a module_init
function and no module_exit.

Repair it by making kvm_vfio_ops_init weak, and checking it in
kvm_init.

Cc: Will Deacon <will.deacon@arm.com>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: Alex Williamson <Alex.Williamson@redhat.com>
Fixes: 80ce1639727e9d38729c34f162378508c307ca25
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 9 +++++++++
 virt/kvm/vfio.c     | 4 ++--
 virt/kvm/vfio.h     | 6 ++++++
 3 files changed, 17 insertions(+), 2 deletions(-)
 create mode 100644 virt/kvm/vfio.h

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index db57363cc287..ad3439835adb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -58,6 +58,10 @@
 #include "coalesced_mmio.h"
 #include "async_pf.h"
 
+#ifdef CONFIG_KVM_VFIO
+#include "vfio.h"
+#endif
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/kvm.h>
 
@@ -3226,6 +3230,11 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		goto out_undebugfs;
 	}
 
+#ifdef CONFIG_KVM_VFIO
+	r = kvm_vfio_ops_init();
+	WARN_ON(r);
+#endif
+
 	return 0;
 
 out_undebugfs:
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index bb11b36ee8a2..281e7cf2b8e5 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
+#include "vfio.h"
 
 struct kvm_vfio_group {
 	struct list_head node;
@@ -278,8 +279,7 @@ static int kvm_vfio_create(struct kvm_device *dev, u32 type)
 	return 0;
 }
 
-static int __init kvm_vfio_ops_init(void)
+int kvm_vfio_ops_init(void)
 {
 	return kvm_register_device_ops(&kvm_vfio_ops, KVM_DEV_TYPE_VFIO);
 }
-module_init(kvm_vfio_ops_init);
diff --git a/virt/kvm/vfio.h b/virt/kvm/vfio.h
new file mode 100644
index 000000000000..f705288f5547
--- /dev/null
+++ b/virt/kvm/vfio.h
@@ -0,0 +1,6 @@
+#ifndef __KVM_VFIO_H
+#define __KVM_VFIO_H
+
+int kvm_vfio_ops_init(void);
+
+#endif
-- 
1.8.3.1

