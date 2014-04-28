Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbaD1W2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 18:28:55 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:12019
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751233AbaD1W2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 18:28:54 -0400
X-WSS-ID: 0N4RIFY-08-9WW-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>
CC: <linux-kernel@vger.kernel.org>, <kim.naru@amd.com>, <jay.cornwall@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH] iommu/amd: Take mmap_sem when calling get_user_pages
Date: Mon, 28 Apr 2014 17:27:46 -0500
Message-ID: <1398724066-3730-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(50986999)(89996001)(62966002)(92726001)(86362001)(92566001)(76482001)(81542001)(81342001)(85852003)(93916002)(48376002)(4396001)(46102001)(86152002)(88136002)(77982001)(33646001)(101416001)(36756003)(20776003)(50226001)(77156001)(19580395003)(83322001)(87936001)(19580405001)(2009001)(80976001)(99396002)(44976005)(47776003)(31966008)(53416003)(87286001)(50466002)(80022001)(79102001)(97736001)(84676001)(74662001)(74502001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR02MB118;H:atltwp02.amd.com;FPR:B55CA75C.B627CEE8.2E45BFB.81B6DA22.20124;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 01952C6E96
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cornwall <jay.cornwall@amd.com>

get_user_pages requires caller to hold a read lock on mmap_sem.

Signed-off-by: Jay Cornwall <jay.cornwall@amd.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd_iommu_v2.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 5208828..203b2e6 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -504,8 +504,10 @@ static void do_fault(struct work_struct *work)
 
 	write = !!(fault->flags & PPR_FAULT_WRITE);
 
+	down_read(&fault->state->mm->mmap_sem);
 	npages = get_user_pages(fault->state->task, fault->state->mm,
 				fault->address, 1, write, 0, &page, NULL);
+	up_read(&fault->state->mm->mmap_sem);
 
 	if (npages == 1) {
 		put_page(page);
-- 
1.7.10.4

