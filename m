Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872AbaLLP01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:26:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:6440 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030570AbaLLP0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:26:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,564,1413270000"; 
   d="scan'208";a="622807526"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: eric.auger@linaro.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        Feng Wu <feng.wu@intel.com>
Subject: [v3 19/26] KVM: kvm-vfio: implement the VFIO skeleton for VT-d Posted-Interrupts
Date: Fri, 12 Dec 2014 23:14:53 +0800
Message-Id: <1418397300-10870-20-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the kvm-vfio interface for VT-d Posted-Interrrupts.
When guests update MSI/MSI-x information for an assigned-device,
QEMU will use KVM_DEV_VFIO_DEVICE_POST_IRQ attribute to setup
IRTE for VT-d PI. Userspace program can also use
KVM_DEV_VFIO_DEVICE_UNPOST_IRQ to change back to irq remapping mode.
This patch implements these IRQ attributes.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 include/linux/kvm_host.h |  20 +++++++++
 virt/kvm/vfio.c          | 107 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 127 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5cd4420..ca9a393 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1134,6 +1134,26 @@ static inline int kvm_arch_vfio_set_forward(struct kvm_fwd_irq *fwd_irq,
 }
 #endif
 
+#ifdef __KVM_HAVE_ARCH_KVM_VFIO_POST
+/*
+ * kvm_arch_vfio_update_pi_irte - set IRTE for Posted-Interrupts
+ *
+ * @kvm: kvm
+ * @host_irq: host irq of the interrupt
+ * @guest_irq: gsi of the interrupt
+ * @set: set or unset PI
+ * returns 0 on success, < 0 on failure
+ */
+int kvm_arch_vfio_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
+				 uint32_t guest_irq, bool set);
+#else
+static int kvm_arch_vfio_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
+					uint32_t guest_irq, bool set)
+{
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
 
 static inline void kvm_vcpu_set_in_spin_loop(struct kvm_vcpu *vcpu, bool val)
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 6bc7001..dbc6c3b 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -446,6 +446,99 @@ out:
 	return ret;
 }
 
+static int kvm_vfio_pci_get_irq_count(struct pci_dev *pdev, int irq_type)
+{
+	if (irq_type == VFIO_PCI_INTX_IRQ_INDEX) {
+		u8 pin;
+
+		pci_read_config_byte(pdev, PCI_INTERRUPT_PIN, &pin);
+		if (pin)
+			return 1;
+	} else if (irq_type == VFIO_PCI_MSI_IRQ_INDEX)
+		return pci_msi_vec_count(pdev);
+	else if (irq_type == VFIO_PCI_MSIX_IRQ_INDEX)
+		return pci_msix_vec_count(pdev);
+
+	return 0;
+}
+
+static int kvm_vfio_control_pi(struct kvm_device *kdev,
+			       int32_t __user *argp, bool set)
+{
+	struct kvm_vfio_dev_irq pi_info;
+	uint32_t *gsi;
+	unsigned long minsz;
+	struct vfio_device *vdev;
+	struct msi_desc *entry;
+	struct device *dev;
+	struct pci_dev *pdev;
+	int i, max, ret;
+
+	minsz = offsetofend(struct kvm_vfio_dev_irq, count);
+
+	if (copy_from_user(&pi_info, (void __user *)argp, minsz))
+		return -EFAULT;
+
+	if (pi_info.argsz < minsz || pi_info.index >= VFIO_PCI_NUM_IRQS)
+		return -EINVAL;
+
+	vdev = kvm_vfio_get_vfio_device(pi_info.fd);
+	if (IS_ERR(vdev))
+		return PTR_ERR(vdev);
+
+	dev = kvm_vfio_external_base_device(vdev);
+	if (!dev || !dev_is_pci(dev)) {
+		ret = -EFAULT;
+		goto put_vfio_device;
+	}
+
+	pdev = to_pci_dev(dev);
+
+	max = kvm_vfio_pci_get_irq_count(pdev, pi_info.index);
+	if (max <= 0) {
+		ret = -EFAULT;
+		goto put_vfio_device;
+	}
+
+	if (pi_info.argsz - minsz < pi_info.count * sizeof(u32) ||
+	    pi_info.start >= max || pi_info.start + pi_info.count > max) {
+		ret = -EINVAL;
+		goto put_vfio_device;
+	}
+
+	gsi = memdup_user((void __user *)((unsigned long)argp + minsz),
+			   pi_info.count * sizeof(u32));
+	if (IS_ERR(gsi)) {
+		ret = PTR_ERR(gsi);
+		goto put_vfio_device;
+	}
+
+#ifdef CONFIG_PCI_MSI
+	for (i = 0; i < pi_info.count; i++) {
+		list_for_each_entry(entry, &pdev->msi_list, list) {
+			if (entry->msi_attrib.entry_nr != pi_info.start+i)
+				continue;
+
+			ret = kvm_arch_vfio_update_pi_irte(kdev->kvm,
+							   entry->irq,
+							   gsi[i],
+							   set);
+			if (ret)
+				goto free_gsi;
+		}
+	}
+#endif
+
+	ret = 0;
+
+free_gsi:
+	kfree(gsi);
+
+put_vfio_device:
+	kvm_vfio_put_vfio_device(vdev);
+	return ret;
+}
+
 static int kvm_vfio_set_device(struct kvm_device *kdev, long attr, u64 arg)
 {
 	int32_t __user *argp = (int32_t __user *)(unsigned long)arg;
@@ -456,6 +549,14 @@ static int kvm_vfio_set_device(struct kvm_device *kdev, long attr, u64 arg)
 	case KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ:
 		ret = kvm_vfio_control_irq_forward(kdev, attr, argp);
 		break;
+#ifdef __KVM_HAVE_ARCH_KVM_VFIO_POST
+	case KVM_DEV_VFIO_DEVICE_POST_IRQ:
+		ret = kvm_vfio_control_pi(kdev, argp, 1);
+		break;
+	case KVM_DEV_VFIO_DEVICE_UNPOST_IRQ:
+		ret = kvm_vfio_control_pi(kdev, argp, 0);
+		break;
+#endif
 	default:
 		ret = -ENXIO;
 	}
@@ -511,6 +612,12 @@ static int kvm_vfio_has_attr(struct kvm_device *dev,
 		case KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ:
 			return 0;
 #endif
+#ifdef __KVM_HAVE_ARCH_KVM_VFIO_POST
+		case KVM_DEV_VFIO_DEVICE_POST_IRQ:
+		case KVM_DEV_VFIO_DEVICE_UNPOST_IRQ:
+			return 0;
+#endif
+
 		}
 		break;
 	}
-- 
1.9.1

