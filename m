Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760333Ab3BHT25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:28:57 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26010 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946826Ab3BHT2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:28:51 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Donald Dutile <ddutile@redhat.com>
Subject: [PATCH v2 08/26] iommu, irq: Allocate irq_desc for dmar_msi with local node
Date: Fri,  8 Feb 2013 11:28:05 -0800
Message-Id: <1360351703-20571-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iommu irq's irq_desc should be on local node ram.

Fix the return value checking problem.

create_irq() will return -1 when fail to allocate.
create_irq_nr() will return 0 when fail to allocate.

here only check !irq, so need to change it to use create_irq_nr instead.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Donald Dutile <ddutile@redhat.com>
---
 drivers/iommu/dmar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 174bb65..316b5a2 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1263,7 +1263,7 @@ int dmar_set_interrupt(struct intel_iommu *iommu)
 	if (iommu->irq)
 		return 0;
 
-	irq = create_irq();
+	irq = create_irq_nr(0, iommu->node);
 	if (!irq) {
 		pr_err("IOMMU: no free vectors\n");
 		return -EINVAL;
-- 
1.7.10.4

