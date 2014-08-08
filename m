Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbaHHFhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 01:37:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19209 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623AbaHHFhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 01:37:12 -0400
From: Ethan Zhao <ethan.zhao@oracle.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com,
        kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org
Cc: alex.williamson@redhat.com, alexander.h.duyck@intel.com,
        ethan.kernel@gmail.com
Subject: [PATCH 2/4] KVM: use pci device flag operation helper functions
Date: Fri,  8 Aug 2014 13:36:05 +0800
Message-Id: <1407476167-18935-3-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1407476167-18935-1-git-send-email-ethan.zhao@oracle.com>
References: <1407476167-18935-1-git-send-email-ethan.zhao@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use helper function instead of direct operation to pci device
flag when set device to assigned or deassigned.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
---
 virt/kvm/assigned-dev.c |    2 +-
 virt/kvm/iommu.c        |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index bf06577..38581ee 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -302,7 +302,7 @@ static void kvm_free_assigned_device(struct kvm *kvm,
 	else
 		pci_restore_state(assigned_dev->dev);
 
-	assigned_dev->dev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
+	pci_clear_dev_assigned(assigned_dev->dev);
 
 	pci_release_regions(assigned_dev->dev);
 	pci_disable_device(assigned_dev->dev);
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 0df7d4b..34a8b02 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -194,7 +194,7 @@ int kvm_assign_device(struct kvm *kvm,
 			goto out_unmap;
 	}
 
-	pdev->dev_flags |= PCI_DEV_FLAGS_ASSIGNED;
+	pci_set_dev_assigned(pdev);
 
 	dev_info(&pdev->dev, "kvm assign device\n");
 
@@ -220,7 +220,7 @@ int kvm_deassign_device(struct kvm *kvm,
 
 	iommu_detach_device(domain, &pdev->dev);
 
-	pdev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
+	pci_clear_dev_assigned(pdev);
 
 	dev_info(&pdev->dev, "kvm deassign device\n");
 
-- 
1.7.1

