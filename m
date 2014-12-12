Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935016AbaLLP3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:29:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:47791 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030543AbaLLP0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:26:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,564,1413270000"; 
   d="scan'208";a="622807503"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: eric.auger@linaro.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        Feng Wu <feng.wu@intel.com>
Subject: [v3 18/26] KVM: kvm-vfio: User API for VT-d Posted-Interrupts
Date: Fri, 12 Dec 2014 23:14:52 +0800
Message-Id: <1418397300-10870-19-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds and documents two new attributes
KVM_DEV_VFIO_DEVICE_POST_IRQ and KVM_DEV_VFIO_DEVICE_UNPOST_IRQ
in KVM_DEV_VFIO_DEVICE group. The new attributes are used for
VT-d Posted-Interrupts.

When guest OS changes the interrupt configuration for an
assigned device, such as, MSI/MSIx data/address fields,
QEMU will use this IRQ attribute to tell KVM to update the
related IRTE according the VT-d Posted-Interrrupts Specification,
such as, the guest vector should be updated in the related IRTE.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 Documentation/virtual/kvm/devices/vfio.txt |  9 +++++++++
 include/uapi/linux/kvm.h                   | 11 +++++++++++
 2 files changed, 20 insertions(+)

diff --git a/Documentation/virtual/kvm/devices/vfio.txt b/Documentation/virtual/kvm/devices/vfio.txt
index f7aff29..ecfbf61 100644
--- a/Documentation/virtual/kvm/devices/vfio.txt
+++ b/Documentation/virtual/kvm/devices/vfio.txt
@@ -42,3 +42,12 @@ activated before VFIO_DEVICE_SET_IRQS has been called to trigger the IRQ
 or associate an eventfd to it. Unforwarding can only be called while the
 signaling has been disabled with VFIO_DEVICE_SET_IRQS. If this condition is
 not satisfied, the command returns an -EBUSY.
+
+  KVM_DEV_VFIO_DEVICE_POST_IRQ: set a VFIO device IRQ as posted
+  KVM_DEV_VFIO_DEVICE_UNPOST_IRQ: set a VFIO device IRQ as remapped
+For this attribute, kvm_device_attr.addr points to a kvm_vfio_dev_irq struct.
+
+When guest OS changes the interrupt configuration for an assigned device,
+such as, MSI/MSIx data/address fields, QEMU will use this IRQ attribute
+to tell KVM to update the related IRTE according the VT-d Posted-Interrrupts
+Specification, such as, the guest vector should be updated in the related IRTE.
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a269a42..8f51487 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -949,6 +949,8 @@ struct kvm_device_attr {
 #define  KVM_DEV_VFIO_DEVICE			2
 #define   KVM_DEV_VFIO_DEVICE_FORWARD_IRQ			1
 #define   KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ			2
+#define   KVM_DEV_VFIO_DEVICE_POST_IRQ				3
+#define   KVM_DEV_VFIO_DEVICE_UNPOST_IRQ			4
 
 enum kvm_device_type {
 	KVM_DEV_TYPE_FSL_MPIC_20	= 1,
@@ -973,6 +975,15 @@ struct kvm_arch_forwarded_irq {
 	__u32 gsi; /* gsi, ie. virtual IRQ number */
 };
 
+struct kvm_vfio_dev_irq {
+	__u32	argsz;
+	__u32	fd;		/* file descriptor of the VFIO device */
+	__u32	index;		/* VFIO device IRQ index */
+	__u32	start;
+	__u32	count;
+	__u32	gsi[];		/* gsi, ie. virtual IRQ number */
+};
+
 /*
  * ioctls for VM fds
  */
-- 
1.9.1

