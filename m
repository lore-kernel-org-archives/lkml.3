Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab3HKCyp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 22:54:45 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25819 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab3HKCtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 22:49:05 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Donald Dutile <ddutile@redhat.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        stable@vger.kernel.org
Subject: [PATCH v4 10/28] iommu, irq: Allocate irq_desc for dmar_msi with local node
Date: Sat, 10 Aug 2013 19:47:56 -0700
Message-Id: <1376189294-32022-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
References: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iommu irq's irq_desc should be on local node ram.

Fix the return value checking problem.
  create_irq() will return -1 when fail to allocate.
  create_irq_nr() will return 0 when fail to allocate.
here only check !irq, so need to change it to use create_irq_nr instead.

-v2: According to Sebastian, add cc to stable.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Donald Dutile <ddutile@redhat.com>
Acked-by: Donald Dutile <ddutile@redhat.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: stable@vger.kernel.org
---
 drivers/iommu/dmar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 785675a..db41e36 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1277,7 +1277,7 @@ int dmar_set_interrupt(struct intel_iommu *iommu)
 	if (iommu->irq)
 		return 0;
 
-	irq = create_irq();
+	irq = create_irq_nr(0, iommu->node);
 	if (!irq) {
 		pr_err("IOMMU: no free vectors\n");
 		return -EINVAL;
-- 
1.8.1.4

