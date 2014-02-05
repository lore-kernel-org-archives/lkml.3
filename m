Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496AbaBEVRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:17:48 -0500
Received: from mail1.windriver.com ([147.11.146.13]:47857 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbaBEUD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:03:26 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Alex Williamson <alex.williamson@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 008/213] KVM: lock slots_lock around device assignment
Date: Wed, 5 Feb 2014 14:59:23 -0500
Message-ID: <1391630568-49251-9-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 21a1416a1c945c5aeaeaf791b63c64926018eb77 upstream.

As pointed out by Jason Baron, when assigning a device to a guest
we first set the iommu domain pointer, which enables mapping
and unmapping of memory slots to the iommu.  This leaves a window
where this path is enabled, but we haven't synchronized the iommu
mappings to the existing memory slots.  Thus a slot being removed
at that point could send us down unexpected code paths removing
non-existent pinnings and iommu mappings.  Take the slots_lock
around creating the iommu domain and initial mappings as well as
around iommu teardown to avoid this race.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
[PG: drop goto for EPERM check, 2.6.34 doesn't have that code]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 virt/kvm/iommu.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index ac765f648218..8c510edca9c9 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -174,18 +174,20 @@ int kvm_iommu_map_guest(struct kvm *kvm)
 		return -ENODEV;
 	}
 
+	mutex_lock(&kvm->slots_lock);
+
 	kvm->arch.iommu_domain = iommu_domain_alloc();
-	if (!kvm->arch.iommu_domain)
-		return -ENOMEM;
+	if (!kvm->arch.iommu_domain) {
+		r = -ENOMEM;
+		goto out_unlock;
+	}
 
 	r = kvm_iommu_map_memslots(kvm);
 	if (r)
-		goto out_unmap;
-
-	return 0;
+		kvm_iommu_unmap_memslots(kvm);
 
-out_unmap:
-	kvm_iommu_unmap_memslots(kvm);
+out_unlock:
+	mutex_unlock(&kvm->slots_lock);
 	return r;
 }
 
@@ -239,7 +241,11 @@ int kvm_iommu_unmap_guest(struct kvm *kvm)
 	if (!domain)
 		return 0;
 
+	mutex_lock(&kvm->slots_lock);
 	kvm_iommu_unmap_memslots(kvm);
+	kvm->arch.iommu_domain = NULL;
+	mutex_unlock(&kvm->slots_lock);
+
 	iommu_domain_free(domain);
 	return 0;
 }
-- 
1.8.5.2

