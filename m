Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab3H1Iuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 04:50:44 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60548 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab3H1Iue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:50:34 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Alexander Graf <agraf@suse.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v9 11/13] KVM: PPC: add trampolines for VFIO external API
Date: Wed, 28 Aug 2013 18:50:23 +1000
Message-Id: <1377679823-3780-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.8.4.rc4
In-Reply-To: <1377679070-3515-1-git-send-email-aik@ozlabs.ru>
References: <1377679070-3515-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM is going to use VFIO's external API. However KVM can operate even VFIO
is not compiled or loaded so KVM is linked to VFIO dynamically.

This adds proxy functions for VFIO external API.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/kvm/book3s_64_vio.c | 49 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index cae1099..047b94c 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -27,6 +27,8 @@
 #include <linux/hugetlb.h>
 #include <linux/list.h>
 #include <linux/anon_inodes.h>
+#include <linux/module.h>
+#include <linux/vfio.h>
 
 #include <asm/tlbflush.h>
 #include <asm/kvm_ppc.h>
@@ -42,6 +44,53 @@
 
 #define ERROR_ADDR      ((void *)~(unsigned long)0x0)
 
+/*
+ * Dynamically linked version of the external user VFIO API.
+ *
+ * As a IOMMU group access control is implemented by VFIO,
+ * there is some API to vefiry that specific process can own
+ * a group. As KVM may run when VFIO is not loaded, KVM is not
+ * linked statically to VFIO, instead wrappers are used.
+ */
+struct vfio_group *kvmppc_vfio_group_get_external_user(struct file *filep)
+{
+	struct vfio_group *ret;
+	struct vfio_group * (*proc)(struct file *) =
+			symbol_get(vfio_group_get_external_user);
+	if (!proc)
+		return NULL;
+
+	ret = proc(filep);
+	symbol_put(vfio_group_get_external_user);
+
+	return ret;
+}
+
+void kvmppc_vfio_group_put_external_user(struct vfio_group *group)
+{
+	void (*proc)(struct vfio_group *) =
+			symbol_get(vfio_group_put_external_user);
+	if (!proc)
+		return;
+
+	proc(group);
+	symbol_put(vfio_group_put_external_user);
+}
+
+int kvmppc_vfio_external_user_iommu_id(struct vfio_group *group)
+{
+	int ret;
+	int (*proc)(struct vfio_group *) =
+			symbol_get(vfio_external_user_iommu_id);
+	if (!proc)
+		return -EINVAL;
+
+	ret = proc(group);
+	symbol_put(vfio_external_user_iommu_id);
+
+	return ret;
+}
+
 static long kvmppc_stt_npages(unsigned long window_size)
 {
 	return ALIGN((window_size >> SPAPR_TCE_SHIFT)
-- 
1.8.4.rc4

