Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaLQKnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:43:49 -0500
Received: from 8bytes.org ([81.169.241.247]:60033 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbaLQKnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:43:46 -0500
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jerry Hoemann <jerry.hoemann@hp.com>, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>, <stable@vger.kernel.org>
Subject: [PATCH 1/2] iommu/vt-d: Fix dmar_domain leak in iommu_attach_device
Date: Wed, 17 Dec 2014 11:43:36 +0100
Message-Id: <1418813017-24888-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Since commit 1196c2f a domain is only destroyed in the
notifier path if it is hot-unplugged. This caused a
domain leakage in iommu_attach_device when a driver was
unbound from the device and bound to VFIO. In this case the
device is attached to a new domain and unlinked from the old
domain. At this point nothing points to the old domain
anymore and its memory is leaked.
Fix this by explicitly freeing the old domain in
iommu_attach_domain.

Fixes: 1196c2f (iommu/vt-d: Fix dmar_domain leak in iommu_attach_device)
Cc: <stable@vger.kernel.org> # v3.18
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/intel-iommu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 1232336..7610121 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4428,6 +4428,10 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 				domain_remove_one_dev_info(old_domain, dev);
 			else
 				domain_remove_dev_info(old_domain);
+
+			if (!domain_type_is_vm_or_si(old_domain) &&
+			     list_empty(&old_domain->devices))
+				domain_exit(old_domain);
 		}
 	}
 
-- 
1.9.1

