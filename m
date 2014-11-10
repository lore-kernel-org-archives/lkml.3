Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaKJKVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:21:54 -0500
Received: from mail-bn1bn0107.outbound.protection.outlook.com ([157.56.110.107]:54912
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751590AbaKJKVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:21:52 -0500
X-WSS-ID: 0NETJGC-07-W4H-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: Joerg Roedel <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        "Oded Gabbay" <oded.gabbay@amd.com>
Subject: [PATCH] iommu/amd: fix accounting of device_state
Date: Mon, 10 Nov 2014 12:21:39 +0200
Message-ID: <1415614899-12602-1-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(104166001)(97736003)(50986999)(46102003)(33646002)(93916002)(102836001)(87286001)(84676001)(89996001)(86362001)(88136002)(92566001)(120916001)(92726001)(87936001)(44976005)(19580395003)(31966008)(19580405001)(68736004)(21056001)(101416001)(99396003)(109900001)(229853001)(106466001)(99900001)(89900001)(48376002)(107046002)(47776003)(20776003)(110136001)(77096003)(77156002)(50466002)(95666004)(64706001)(36756003)(4396001)(50226001)(62966003)(105586002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB195;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Forefront-PRVS: 039178EF4A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug in the accounting of the device_state.
In the current code, the device_state was put (decremented) too many times,
which sometimes lead to the driver getting stuck permanently in
put_device_state_wait(). That happen because the device_state->count would go
below zero, which is never supposed to happen.

The root cause is that the device_state was decremented in put_pasid_state()
and put_pasid_state_wait() but also in all the functions that call those
functions. Therefore, the device_state was decremented twice in each of these
code paths.

The fix is to decouple the device_state accounting from the pasid_state
accounting - remove the call to put_device_state() from the
put_pasid_state() and the put_pasid_state_wait())

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/iommu/amd_iommu_v2.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 0d387db..7e0614b 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -272,10 +272,8 @@ static void free_pasid_state(struct pasid_state *pasid_state)
 
 static void put_pasid_state(struct pasid_state *pasid_state)
 {
-	if (atomic_dec_and_test(&pasid_state->count)) {
-		put_device_state(pasid_state->device_state);
+	if (atomic_dec_and_test(&pasid_state->count))
 		wake_up(&pasid_state->wq);
-	}
 }
 
 static void put_pasid_state_wait(struct pasid_state *pasid_state)
@@ -284,9 +282,7 @@ static void put_pasid_state_wait(struct pasid_state *pasid_state)
 
 	prepare_to_wait(&pasid_state->wq, &wait, TASK_UNINTERRUPTIBLE);
 
-	if (atomic_dec_and_test(&pasid_state->count))
-		put_device_state(pasid_state->device_state);
-	else
+	if (!atomic_dec_and_test(&pasid_state->count))
 		schedule();
 
 	finish_wait(&pasid_state->wq, &wait);
-- 
1.9.1

