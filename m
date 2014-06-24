Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbaFXSbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 14:31:05 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:25531
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753296AbaFXSbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 14:31:03 -0400
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alex.williamson@redhat.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 3/3] iommu/fsl: Fix the error condition during iommu group
Date: Tue, 24 Jun 2014 19:27:17 +0530
Message-ID: <1403618237-26248-4-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403618237-26248-1-git-send-email-Varun.Sethi@freescale.com>
References: <1403618237-26248-1-git-send-email-Varun.Sethi@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(104016002)(95666004)(85306003)(76176999)(26826002)(50986999)(102836001)(105606002)(106466001)(97736001)(84676001)(77156001)(50226001)(81342001)(44976005)(89996001)(19580395003)(83322001)(19580405001)(79102001)(6806004)(68736004)(21056001)(85852003)(83072002)(77982001)(4396001)(86362001)(99396002)(2201001)(92726001)(92566001)(93916002)(20776003)(87936001)(87286001)(47776003)(88136002)(46102001)(50466002)(74502001)(36756003)(64706001)(80022001)(104166001)(74662001)(48376002)(81542001)(76482001)(62966002)(31966008)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR03MB086;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02524402D6
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Varun.Sethi@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earlier PTR_ERR was being returned even if group was set to null.
Now, we explicitly set an ERR_PTR value in case the group  pointer is
NULL.

Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
---
 drivers/iommu/fsl_pamu_domain.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index 54060d1..af47648 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -1037,12 +1037,15 @@ root_bus:
 			group = get_shared_pci_device_group(pdev);
 	}
 
+	if (!group)
+		group = ERR_PTR(-ENODEV);
+
 	return group;
 }
 
 static int fsl_pamu_add_device(struct device *dev)
 {
-	struct iommu_group *group = NULL;
+	struct iommu_group *group = ERR_PTR(-ENODEV);
 	struct pci_dev *pdev;
 	const u32 *prop;
 	int ret, len;
@@ -1065,7 +1068,7 @@ static int fsl_pamu_add_device(struct device *dev)
 			group = get_device_iommu_group(dev);
 	}
 
-	if (!group || IS_ERR(group))
+	if (IS_ERR(group))
 		return PTR_ERR(group);
 
 	ret = iommu_group_add_device(group, dev);
-- 
1.7.9.5

