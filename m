Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab3EFHWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 03:22:31 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:36389 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab3EFHW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 03:22:28 -0400
From: aik@ozlabs.ru
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 1/5] iommu: Move initialization earlier
Date: Mon,  6 May 2013 17:21:57 +1000
Message-Id: <51875a31.25ac440a.50d9.ffffe8fd@mx.google.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367824921-27151-1-git-send-email-y>
References: <1367824921-27151-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

The iommu_init() call initializes IOMMU internal structures and data
required for the API to function such as iommu_group_alloc().
It is registered as a subsys_initcall.

One of the IOMMU users is a PCI subsystem on POWER which discovers new
IOMMU tables during the PCI scan so the most logical place to call
iommu_group_alloc() is when a new group is just discovered. However
PCI scan is done from subsys_initcall hook as well, which makes
use of the IOMMU API impossible.

This moves IOMMU subsystem initialization one step earlier.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 drivers/iommu/iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 5514dfa..0de83eb 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -890,7 +890,7 @@ static int __init iommu_init(void)
 
 	return 0;
 }
-subsys_initcall(iommu_init);
+arch_initcall(iommu_init);
 
 int iommu_domain_get_attr(struct iommu_domain *domain,
 			  enum iommu_attr attr, void *data)
-- 
1.7.10.4

