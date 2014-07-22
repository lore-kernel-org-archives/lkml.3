Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbaGVQUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:20:48 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24521 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741AbaGVQUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:20:08 -0400
From: Ethan Zhao <ethan.zhao@oracle.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com,
        kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org
Cc: alex.williamson@redhat.com, alexander.h.duyck@intel.com,
        ethan.kernel@gmail.com
Subject: [PATCH 2/4] KVM: use pci device flag operation helper functions
Date: Wed, 23 Jul 2014 00:19:02 +0800
Message-Id: <1406045944-1587-3-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1406045944-1587-1-git-send-email-ethan.zhao@oracle.com>
References: <1406045944-1587-1-git-send-email-ethan.zhao@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use helper function instead of direct operation to pci device
flag when set device to assigned or deassigned.

Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
---
 virt/kvm/assigned-dev.c |    2 +-
 virt/kvm/iommu.c        |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index bf06577..d122bda 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -302,7 +302,7 @@ static void kvm_free_assigned_device(struct kvm *kvm,
 	else
 		pci_restore_state(assigned_dev->dev);
 
-	assigned_dev->dev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
+	pci_set_dev_deassigned(assigned_dev->dev);
 
 	pci_release_regions(assigned_dev->dev);
 	pci_disable_device(assigned_dev->dev);
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 0df7d4b..8cfe021 100644
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
+	pci_set_dev_deassigned(pdev);
 
 	dev_info(&pdev->dev, "kvm deassign device\n");
 
-- 
1.7.1

